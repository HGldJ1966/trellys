{-# LANGUAGE PatternGuards, FlexibleInstances, FlexibleContexts, TupleSections, RankNTypes #-}
{-# OPTIONS_GHC -Wall -fno-warn-unused-matches #-}

-- | A parsec-based parser for the Trellys concrete syntax.
module Language.Trellys.Parser
  (
   parseModuleFile, 
   parseModuleImports,
   parseExpr
  )
  where

import Language.Trellys.Options
import Language.Trellys.Syntax hiding (moduleImports)
import Language.Trellys.GenericBind

import Text.Parsec hiding (State,Empty)
import Text.Parsec.Expr(Operator(..),Assoc(..),buildExpressionParser)
import qualified Language.Trellys.LayoutToken as Token

import Control.Monad.State.Lazy hiding (join)
import Control.Monad.Reader hiding (join)
import Control.Applicative ( (<$>), (<*>) )
import Control.Monad.Error hiding (join)

import Data.List
import qualified Data.Set as S

{- current concrete syntax for the annotated language:

  levels:
     l ::= natural numbers

  theta:
     th ::= prog | log

  terms:
    a,b,A,B ::=
      Type [l]                 Universes
    | x                        Variables   (start with lowercase)
    | C                        Term, Type constructors (start with 
                                      uppercase)
    | \ x . a                  Runtime lambda
    | \ [x] . a                Erased lambda
    | a b                      Runtime application
    | a [b]                    Erased application
    | let x [y] = a in b       Runtime let, default to log
    | let th x [y] = a in b    Runtime let, explicitly prog or log
    | let [x] [y] = a in b     Erased let, default to log
    | let th [x] [y] = a in b  Erased let, default to log
    | let th x = a in b        Let statement with the name 
                                  of the equation supressed.
    | (x : A) -> B             Runtime pi
    | [x : A] -> B             Erased pi
    | case a [y] of            Case expressions, roughly
        C1 [x] y z -> b1
        C2 x [y]   -> b2
    | a < b                    Order type
    | ord a                    Axiomatic ordering proof
    | ordtrans a1 a2           Proof of transitivity of ordering
    | a = b                    Equality type
    | join k                   Equality proof
    | contra a                  Contra
    | abort                    Abort
    | rec f x = a              Runtime rec
    | rec f [x] = a            Erased rec
    | ind f x = a              Runtime ind
    | ind f [x] = a            Erased ind
    | (a : A)                  Annotations
    | A @ th                   At
    
    | if a then b else c       Syntactic sugar for case


   equality contexts
     EqC ::= x. A

  telescopes:
    D ::=
                               Empty
     | (x : A) D               runtime cons
     | [x : A] D               erased cons

  declarations:

    For logical declarations:
      foo : A
      foo = a

      or

      log foo : A
      foo = a

    For programmatic declarations:

      prog foo : A
      foo = A

    For axiom declarations:
      axiom prog foo : A -- programmatic
      axiom log  foo : A -- logical
      axiom foo : A      -- also logical

    For logical datatype declarations (the level can be omitted):

       log data T D : Type [l] where
         C1 of Del1
         ...
         Cn of Deln

    For programmatic datatype declarations:

       prog data T D : Type [l] where
         C1 of Del1
         ...
         Cn of Deln

    Setting default thetas (used when a function type doesn't specify an @).
       usually prog
       usually log
       usually none

  Syntax sugar:

   - You can collapse lambdas, like:

         \ x [y] z . a

     This gets parsed as \ x . \ [y] . \ z . a

   - You can make a top level declaration a rec or ind:

     foo : (n : Nat) -> A
     ind foo x = ...

-}

liftError :: (MonadError e m) => Either e a -> m a
liftError (Left e) = throwError e
liftError (Right a) = return a

-- | Parse a module declaration from the given filepath.
parseModuleFile :: (MonadError ParseError m, MonadIO m) => [Flag] -> ConstructorNames -> String -> m Module
parseModuleFile flags cnames name = do
  contents <- liftIO $ readFile name
  liftError $ runFreshM $ flip runReaderT flags $ 
    flip evalStateT cnames $
     (runParserT (do { whiteSpace; v <- moduleDef;eof; return v}) [] name contents)

-- | Parse only the imports part of a module from the given filepath.
parseModuleImports :: (MonadError ParseError m, MonadIO m) => [Flag] -> String -> m Module
parseModuleImports flags name = do
  contents <- liftIO $ readFile name
  liftError $ runFreshM $ flip runReaderT flags $ 
    flip evalStateT emptyConstructorNames $
     (runParserT (do { whiteSpace; moduleImports }) [] name contents)

-- | Test an 'LParser' on a String.
--
-- E.g., do
--
-- > testParser decl "axiom fix : (aTy : Type 0) -> (f : ((a:aTy) -> aTy)) -> aTy"
--
-- to parse an axiom declaration of a logical fixpoint combinator.
testParser :: (LParser t) -> String -> Either ParseError t
testParser parser str = runFreshM $ flip runReaderT [] $ 
   flip evalStateT emptyConstructorNames $
     runParserT (do { whiteSpace; v <- parser; eof; return v}) [] "<interactive>" str

-- | Parse an expression.
parseExpr :: String -> Either ParseError Term
parseExpr = testParser expr

-- * Lexer definitions
type ParserState =    (StateT ConstructorNames
                       (ReaderT [Flag] FreshM)) -- The internal state for generating fresh names, for flags,
                                                -- and for remembering which names are constructors.
type LParser a = ParsecT
                    String                      -- The input is a sequence of Char
                    [Column]                    -- The internal state for Layout tabs
                    ParserState                 -- The other internal state
                    a                           -- the type of the object being parsed

instance Fresh (ParsecT s u (StateT ConstructorNames (ReaderT a FreshM)))  where
  fresh = lift . lift . lift . fresh

-- Based on Parsec's haskellStyle (which we can not use directly since
-- Parsec gives it a too specific type).
trellysStyle :: (Stream s m Char, Monad m) => Token.GenLanguageDef s u m
trellysStyle = Token.LanguageDef
                { Token.commentStart   = "{-"
                , Token.commentEnd     = "-}"
                , Token.commentLine    = "--"
                , Token.nestedComments = True
                , Token.identStart     = letter
                , Token.identLetter    = alphaNum <|> oneOf "_'"
                , Token.opStart	       = oneOf ":!#$%&*+.,/<=>?@\\^|-"
                , Token.opLetter       = oneOf ":!#$%&*+.,/<=>?@\\^|-"
                , Token.caseSensitive  = True
                , Token.reservedNames =
                  ["ord"
                  ,"ordtrans"
                  ,"join"
                  ,"pjoin"
                  ,"smartjoin"
                  ,"smartpjoin"
                  ,"unfold"
                  ,"punfold"
                  ,"rec"
                  ,"ind"
                  ,"Type"
                  ,"data"
                  ,"where"
                  ,"case"
                  ,"of"
                  ,"with"
                  ,"abort"
                  ,"contra"
                  ,"let", "in"
                  ,"prog", "log"
                  ,"axiom"
                  ,"erased"
                  ,"termcase"
                  ,"TRUSTME"
                  , "injectivity"
                  , "if", "then", "else"  
                  ]
               , Token.reservedOpNames =
                 ["!","?","\\",":",".",",","<", "=", "+", "-", "^", "()", "_", "@"]
                }

--tokenizer :: Token.GenTokenParser String [Column] m
--layout:: LParser item -> LParser stop -> LParser [item]
(tokenizer,Token.LayFun layout) = Token.makeTokenParser trellysStyle "{" ";" "}"

identifier :: (Rep a) => LParser (Name a)
identifier = string2Name <$> Token.identifier tokenizer

whiteSpace :: LParser ()
whiteSpace = Token.whiteSpace tokenizer

variable :: LParser TName
variable =
  do i <- identifier
     cnames <- get
     if (i `S.member` (tconNames cnames `S.union` dconNames cnames))
       then fail "Expected a variable, but a constructor was found"
       else return i

wildcard :: LParser TName
wildcard = reservedOp "_" >> fresh (string2Name "_")

variableOrWild :: LParser TName
variableOrWild = try wildcard <|> variable

constructor :: LParser ([(Term,Epsilon)] -> Term)
constructor = 
  do i <- identifier
     cnames <- get
     if (i `S.member` tconNames cnames)
       then return $ TCon i
       else if (i `S.member` dconNames cnames)
             then return $ DCon i
             else fail "Expected a constructor, but a variable was found"

dconstructor :: LParser TName
dconstructor =
  do i <- identifier
     cnames <- get
     if (i `S.member` dconNames cnames)
       then return i
       else if (i `S.member` tconNames cnames)
             then fail "Expected a data constructor, but a type constructor was found."
             else fail "Expected a constructor, but a variable was found"

-- variables or zero-argument constructors
varOrCon :: LParser Term
varOrCon = do i <- identifier
              cnames <- get
              if (i `S.member` (dconNames cnames))
                then return (DCon i [])
                else if (i `S.member` tconNames cnames)
                       then return (TCon i [])
                       else return (Var i)

colon, dot :: LParser ()
colon = Token.colon tokenizer >> return ()
dot = Token.dot tokenizer >> return ()

reserved,reservedOp :: String -> LParser ()
reserved = Token.reserved tokenizer
reservedOp = Token.reservedOp tokenizer

parens,brackets,braces :: LParser a -> LParser a
parens = Token.parens tokenizer
brackets = Token.brackets tokenizer
braces = Token.braces tokenizer

natural :: LParser Int
natural = fromInteger <$> Token.natural tokenizer

natenc :: LParser Term
natenc =
  do n <- natural
     return $ encode n 
   where encode 0 = DCon (string2Name "Zero") []
         encode n = DCon (string2Name "Succ") [(encode (n-1), Runtime)]

moduleImports :: LParser Module
moduleImports = do
  reserved "module"
  modName <- identifier
  reserved "where"
  imports <- layout importDef (return ())
  return $ Module modName imports [] emptyConstructorNames

moduleDef :: LParser Module
moduleDef = do
  reserved "module"
  modName <- identifier
  reserved "where"
  imports <- layout importDef (return ())
  decls <- layout decl (return ())
  cnames <- get
  return $ Module modName imports decls cnames

importDef :: LParser ModuleImport
importDef = do reserved "import" >>  (ModuleImport <$> importName)
  where importName = identifier

telescope :: LParser Telescope
telescope = many teleBinding
  where
    annot :: Epsilon -> LParser (TName, Term,Epsilon)
    annot ep = do
      (x,ty) <-    try ((,) <$> variableOrWild            <*> (colon >> expr))
                <|>    ((,) <$> (fresh (string2Name "_")) <*> expr)
      return (x,ty,ep)
    teleBinding :: LParser (TName, Term,Epsilon)
    teleBinding =
      (    parens (annot Runtime)
       <|> brackets (annot Erased)) <?> "binding"

theta :: LParser Theta
theta =      (reserved "prog" >> return Program)
        <|>  (reserved "log" >> return Logic)            

---
--- Top level declarations
---

decl,dataDef,sigDef,valDef,indDef,recDef,usuallyTheta :: LParser Decl
decl = (try dataDef) <|> sigDef <|> valDef <|> indDef <|> recDef <|> usuallyTheta

-- datatype declarations.
dataDef = do
  reserved "data"
  name <- identifier
  params <- telescope
  colon
  reserved "Type"
  level <- option 0 natural
  modify (\cnames -> cnames{ tconNames = S.insert name (tconNames cnames) })
  reserved "where"
  cs <- layout constructorDef (return ())
  forM_ cs
    (\(ConstructorDef _ cname _) ->
       modify (\cnames -> cnames{ dconNames = S.insert cname (dconNames cnames)}))
  return $ Data name params level cs
 where constructorDef = do
                         pos <- getPosition
                         cname <- identifier
                         args <- option [] (reserved "of" >> telescope)
                         return $ ConstructorDef pos cname args
                        <?> "Constructor"

sigDef = do
  axOrSig <- option Sig $ (reserved "axiom" >> return Axiom)
  th <- option Logic $ theta
  n <- try (variable >>= \v -> colon >> return v)
  ty <- expr
  return $ axOrSig n th ty 

valDef = do
  (n, binds) <- try (do {n <- variable; 
                      ps <- many impOrExpBind; 
                      reservedOp "="; return (n, ps)})
  body <- expr
  let val = foldr (\(x,ep) m -> Lam ep (bind x m)) body binds
  return $ Def n val

indDef = do
  r@(Ind b) <- ind
  let ((n,_),_) = unsafeUnbind b
  return $ Def n r

recDef = do
 r@(Rec b) <- rec
 let ((n,_),_) = unsafeUnbind b
 return $ Def n r

usuallyTheta = do
  _ <- string "usually" 
  whiteSpace
  try (return . UsuallyTheta . Just =<< theta) 
    <|> (string "none" >> return (UsuallyTheta Nothing))

------------------------
------------------------
-- Annotated Terms
------------------------
------------------------

termCase :: LParser Term
termCase = do
  reserved "termcase"
  scrutinee <- expr
  pf <- braces identifier
  reserved "of"
  (a,t) <- do
    -- Diverges case
    ae <- do reservedOp "|"
             reserved "abort"
             reservedOp "->"
             expr <?> "aborts branch"

    -- Terminates case
    te <- do reservedOp "|"
             reservedOp "!"
             v <- identifier
             reservedOp "->"
             e <- expr <?> "terminates branch"
             return (bind v e)
    return (ae,te)

  return $ TerminationCase scrutinee (bind pf (a,t))

trustme :: LParser Term
trustme = do reserved "TRUSTME"; return TrustMe

inferme :: LParser Term
inferme = do reservedOp "_" ; return InferMe

injectivity :: LParser Term
injectivity = do
  reserved "injectivity"
  InjDCon <$> factor <*> natural

ordax :: LParser Term
ordax = 
  do reserved "ord"
     OrdAx <$> factor

ordtrans :: LParser Term
ordtrans =
  do reserved "ordtrans"
     OrdTrans <$> factor <*> factor
      
join :: LParser Term
join =
  do style <-     try (reserved "join" >> return (Join CBV Dumb))  
                 <|> try (reserved "pjoin" >> return (Join PAR_CBV Dumb))
                 <|> try (reserved "smartjoin" >> return (Join CBV Smart))
                 <|> (reserved "smartpjoin" >> return (Join PAR_CBV Smart))
     s1 <- optionMaybe natural
     s2 <- optionMaybe natural
     case (s1,s2) of
       (Nothing,Nothing) -> return $ style 1000 1000
       (Just n,Nothing)  -> return $ style n n
       (Just n1,Just n2) -> return $ style n1 n2
       _                 -> error $ "Internal error: nat after no nat"


unfold :: LParser Term
unfold = 
  do strategy <-   try (reserved "unfold" >> return CBV)
                    <|> (reserved "punfold" >> return PAR_CBV)
     s <- optionMaybe natural
     e <- expr
     reserved "in"
     e' <- expr
     case s of
       Nothing -> return $ Unfold strategy 100 e e'
       Just n  -> return $ Unfold strategy n e e'

-- Expressions

expr,compound,term,factor :: LParser Term
 
-- expr is the toplevel expression grammar, the "a,b,A,B" from the ott file.
expr = do
    p <- getPosition
    Pos p <$> (buildExpressionParser table compound)
  where table = [[Postfix (do reservedOp "@" ; th <- theta; return (\ty -> At ty th))]]

-- A "compound" is an expression not involving @. We can't handle @s using 
-- this buildExpressionParser because they should bind less tightly than arrows,
--  and dependent arrows are built using a separate expProdOrAnnotOrParens production.
compound = do
    p <- getPosition
    Pos p <$> (buildExpressionParser table term)
  where table = [[ifix  AssocLeft "<" Smaller],
                 [ifix  AssocLeft "=" TyEq],
                 [ifixM AssocRight "->" (mkArrow Explicit), 
                  ifixM AssocRight "=>" (mkArrow Inferred)]
                ]
        ifix  assoc op f = Infix (reservedOp op >> return f) assoc
        ifixM assoc op f = Infix (reservedOp op >> f) assoc
        mkArrow ex  = do x <- fresh (string2Name "_")
                         return $ \tyA tyB -> Arrow ex Runtime (bind (x,embed tyA) tyB)

-- A "term" is either a function application or a constructor
-- application.  Breaking it out as a seperate category both
-- eliminates left-recursion in (<expr> := <expr> <expr>) and
-- allows us to keep constructors fully applied in the abstract syntax.
term = try conapp <|> funapp

conapp :: LParser Term
conapp = do 
  c <- constructor
  args <- many bfactor
  return $ c args
  where bfactor = ((,Erased)  <$> brackets expr) <|>
                  ((,Runtime) <$> factor)

funapp :: LParser Term
funapp = do 
  f <- factor
  foldl' app f <$> many bfactor
  where bfactor = ((,Erased)  <$> brackets expr) <|>
                  ((,Runtime) <$> factor)
        app e1 (e2,ep)  =  App ep e1 e2

factor = choice [ inferme   <?> "a placeholder (_)"
                , varOrCon <?> "a variable or zero-argument data constructor"
                , explicitize <?> "an atomic expression with !"
                , typen   <?> "Type n"
                , natenc <?> "a literal"
                , lambda <?> "a lambda"
                , ind <?> "ind"
                , rec    <?> "rec"
                , letExpr   <?> "a let"
                , unfold <?> "an unfold"
                , contra    <?> "a contra"
                , abort     <?> "abort"
                , caseExpr  <?> "a case"
                , ordax     <?> "ord"
                , ordtrans  <?> "ordtrans"
                , injectivity <?> "injectivity"
                , join      <?> "join"
                , termCase  <?> "a termcase"
                , trustme   <?> "TRUSTME"
                , impProd   <?> "an implicit function type"
                , ifExpr    <?> "an if expression"  
                , expProdOrAnnotOrParens
                    <?> "an explicit function type or annotated expression"
                ]

impBind,expBind :: LParser (TName,Epsilon)
impBind = brackets ((,Erased)  <$> variableOrWild)
expBind =           (,Runtime) <$> variableOrWild

impOrExpBind :: LParser (TName,Epsilon)
impOrExpBind = impBind <|> expBind

explicitize :: LParser Term
explicitize = do 
  reservedOp "!"
  Explicitize <$> factor

typen :: LParser Term
typen =
  do reserved "Type"
     Type <$> (option 0 $ natural)


-- Lambda abstractions have the syntax '\x . e' There is no type annotation
-- on the binder.
lambda :: LParser Term
lambda = do reservedOp "\\"
            binds <- many1 impOrExpBind
            dot
            body <- expr
            return $ foldr (\(x,ep) m -> Lam ep (bind x m))
                           body binds

-- recursive abstractions, with the syntax 'ind f x = e', no type annotation.
ind :: LParser Term
ind = do
  reserved "ind"
  f <- variable
  args <-  many1 impOrExpBind
  reservedOp "="
  body <- expr
  return $ (Ind (bind (f,args) body))

-- recursive abstractions, with the syntax 'rec f x = e', no type annotation.
rec :: LParser Term
rec = do
  reserved "rec"
  f <- variable
  args <- many1 impOrExpBind
  reservedOp "="
  body <- expr
  return $ (Rec (bind (f,args) body))

ifExpr :: LParser Term
ifExpr = 
  do reserved "if"
     a <- expr
     reserved "then"
     b <- expr
     reserved "else"
     c <- expr
     eqname <- fresh (string2Name "if_eq")
     let scrut = [ (embed a, eqname) ]
     let tm = ComplexMatch (bind [PatCon (embed (string2Name "True")) []] b)
     let fm = ComplexMatch (bind [PatCon (embed (string2Name "False")) []] c)
     return $ (ComplexCase (bind scrut [tm, fm]))

letExpr :: LParser Term
letExpr =
  do reserved "let"
     th <- option Logic $ theta
     (x,ep) <- impOrExpBind
     defaultName <- fresh (string2Name "_")
     y <- option defaultName (brackets variableOrWild)
     --y <- brackets variableOrWild
     reservedOp "="
     boundExp <- expr
     reserved "in"
     body <- expr
     return $ (Let th ep (bind (x,y, embed boundExp) body))

{- Many different things start with parentheses:

   Parethesised expressions, e.g.
     (42)
     (vec 42)
     (vec x)

   Type ascriptions, e.g.
     (42 : Int)
     (vec 42 : Type)
     (vec x : Type)

   Pi types and multiple-bindings Pi types, e.g.
     (x : Int) -> T
     (x : Int) => T
     (x y : Int) -> T
     (vec x : Type) -> T    --Oops.

   As the last example hints, there is an ambiguity: (x:A)->B and
   (x y:A)->B could could be parsed both as Pi types or a simple types where
   the domain is an expression involving type ascription. In these cases
   we parse it as a Pi type.

   Algorithmically, first parse everything as either (exp) or (exp:exp').
   If the latter, we check if the next token is a thin or fat 
   arrow, and whether exp is a bunch of variables.
-}
expProdOrAnnotOrParens :: LParser Term
expProdOrAnnotOrParens =
  let
    -- afterBinder picks up the return type of a pi
    afterBinder :: LParser (Explicitness, Term)
    afterBinder = do
                    ex <- (try (reservedOp "->" >> return Explicit))
                            <|> (reservedOp "=>" >> return Inferred)
                    rest <- compound
                    return (ex,rest)

    -- before binder parses an expression in parens
    -- If it doesn't involve a colon, you get (Right tm)
    -- If it does, you get (Left tms tm2).  Tms might be:
    --    
    --       a variable or a list of variables (this is a pi type)
   --       
    --    in which case you might be looking at an explicit pi type.
    beforeBinder :: LParser (Either (Term,Term) Term)
    beforeBinder = parens $
      choice [do e1 <- try (term >>= (\e1 -> colon >> return e1))
                 e2 <- expr
                 return $ Left (e1,e2)
             , Right <$> expr]
  in
    do bd <- beforeBinder
       case bd of
         Left (a,b) -> (do
                          xs <- looksLikeVariableList a
                          (ex, c) <- afterBinder
                          return $ arrows ex Runtime xs b c)
                        <|> (return (Ann a b))
         Right a    -> return $ Paren a


-- impProd - erased dependent products
-- These have the syntax [x:a]->b or [a]->b or [x:a]=>b or [a]=>b
impProd :: LParser Term
impProd =
  do (xs,tyA) <- brackets (try ((,) <$> many1 variableOrWild <*> (colon >> expr))
                           <|> ((,) <$> ((:[]) <$> fresh (string2Name "_")) <*> expr))
     ex <- (try (reservedOp "->" >> return Explicit) 
            <|> (reservedOp "=>" >> return Inferred))
     tyB <- compound
     return $ arrows ex Erased xs tyA tyB
--FIXME: add wildcard

-- Takes an expression, check if it is a left-associated series of
-- applications of variabls (x y z ...) and return as a list,
-- otherwise fail.
looksLikeVariableList :: Term -> LParser [TName]
looksLikeVariableList (Var x) = return [x]
looksLikeVariableList (App Runtime t (Var x)) = do
  xs <- looksLikeVariableList t
  return $ xs ++ [x]
looksLikeVariableList _ = fail "expected variable"

-- given a list of variable names [x,y,z] and types A, B,
-- build the arrow type (x:A)->(y:A)->(z:A)->B.
arrows :: Explicitness -> Epsilon -> [TName] -> Term -> Term -> Term
arrows _ _ [] _ s = s
arrows ex ep (x:xs) t s = Arrow ex ep (bind (x,embed t) (arrows ex ep xs t s))

pattern :: LParser Pattern 
-- Note that 'dconstrutor' and 'variable' overlaps, annoyingly.
pattern =      try (PatCon <$> (embed <$> dconstructor) <*> many arg_pattern)
           <|> atomic_pattern
  where arg_pattern    =    ((,Erased) <$> brackets pattern) 
                        <|> ((,Runtime) <$> atomic_pattern)
        atomic_pattern =    (parens pattern)
                        <|> (PatVar <$> wildcard)
                        <|> do t <- varOrCon
                               case t of
                                 (Var x) -> return $ PatVar x
                                 (DCon c []) -> return $ PatCon (embed c) []
                                 (TCon c []) -> fail "expected a data constructor but a type constructor was found"
                                 _ -> error "internal error in atomic_pattern"

complexMatch :: LParser ComplexMatch
complexMatch = 
  do pats <- sepBy1 pattern (reservedOp ",")
     reservedOp "->"
     body <- term
     return $ ComplexMatch (bind pats body)

eqName :: LParser TName
eqName = do 
  n <- fresh (string2Name "_")
  option n (brackets variableOrWild)
  

caseExpr :: LParser Term
caseExpr = do
    reserved "case"
    scruts <- sepBy1 ((,) <$> (embed <$> factor) <*> eqName)
                     (reservedOp ",")
    reserved "of"
    alts <- layout complexMatch (return ())
    return $ ComplexCase (bind scruts alts)

contra :: LParser Term
contra = do
  reserved "contra"
  witness <- expr
  return $ Contra witness


abort :: LParser Term 
abort = do 
  reserved "abort"
  return Abort
