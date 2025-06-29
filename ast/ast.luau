export type TokenType = 
    | "IdentifierLexerToken"
    | "NumberLexerToken"
    | "StringLexerToken"
    | "FunctionLexerToken"
    | "BooleanLexerToken"
    | "NilLexerToken"
    | "ClassLexerToken"
    | "VarLexerToken"
    | "IfLexerToken"
    | "ElseLexerToken"
    | "WhileLexerToken"
    | "ForLexerToken"
    | "ReturnLexerToken"
    | "AddLexerToken"
    | "SubLexerToken"
    | "MulLexerToken"
    | "DivLexerToken"
    | "RemainderLexerToken"
    | "AndLexerToken"
    | "OrLexerToken"
    | "NotLexerToken"
    | "DotLexerToken"
    | "DotTwoLexerToken"
    | "CommaLexerToken"
    | "SemiColonLexerToken"
    | "ColonLexerToken"
    | "ColonTwoLexerToken"
    | "EqualLexerToken"
    | "EqualTwoLexerToken"
    | "NotEqualLexerToken"
    | "LessLexerToken"
    | "LessEqualLexerToken"
    | "GreaterLexerToken"
    | "GreaterEqualLexerToken"
    | "EqualAddLexerToken"
    | "EqualSubLexerToken"
    | "EqualMulLexerToken"
    | "EqualDivLexerToken"
    | "LeftParenLexerToken"
    | "RightParenLexerToken"
    | "LeftBraceLexerToken"
    | "RightBraceLexerToken"
    | "LeftBrackLexerToken"
    | "RightBrackLexerToken"
    | "ArrowLexerToken"
    | "ExtendsLexerToken"
    | "TypeLexerToken"
    | "PublicLexerToken"
    | "EofLexerToken"

export type Token<T> = { 
    type: T,
    lexeme: string, 
    line: number, 
    column: number,
}

local function createToken(token_type: TokenType): (lexme: string, line: number, column: number) -> Token<TokenType>
    return function(lexeme, line, column) 
        return {
            lexeme = lexeme,
            type = token_type,
            line = line,
            column = column,
        }
    end
end

local IdentifierToken = createToken "IdentifierLexerToken"
local NumberToken = createToken "NumberLexerToken"
local StringToken = createToken "StringLexerToken"
local FunctionToken = createToken "FunctionLexerToken"
local BooleanToken = createToken "BooleanLexerToken"
local NilToken = createToken "NilLexerToken"
local ClassToken = createToken "ClassLexerToken"
local VarToken = createToken "VarLexerToken"
local IfToken = createToken "IfLexerToken"
local ElseToken = createToken "ElseLexerToken"
local WhileToken = createToken "WhileLexerToken"
local ForToken = createToken "ForLexerToken"
local ReturnToken = createToken "ReturnLexerToken"
local AddToken = createToken "AddLexerToken"
local SubToken = createToken "SubLexerToken"
local MulToken = createToken "MulLexerToken"
local DivToken = createToken "DivLexerToken"
local RemainderToken = createToken "RemainderLexerToken"
local AndToken = createToken "AndLexerToken"
local OrToken = createToken "OrLexerToken"
local NotToken = createToken "NotLexerToken"
local DotToken = createToken "DotLexerToken"
local DotTwoToken = createToken "DotTwoLexerToken"
local CommaToken = createToken "CommaLexerToken"
local SemiColonToken = createToken "SemiColonLexerToken"
local ColonToken = createToken "ColonLexerToken"
local ColonTwoToken = createToken "ColonTwoLexerToken"
local EqualToken = createToken "EqualLexerToken"
local EqualTwoToken = createToken "EqualTwoLexerToken"
local NotEqualToken = createToken "NotEqualLexerToken"
local LessToken = createToken "LessLexerToken"
local LessEqualToken = createToken "LessEqualLexerToken"
local GreaterToken = createToken "GreaterLexerToken"
local GreaterEqualToken = createToken "GreaterEqualLexerToken"
local EqualAddToken = createToken "EqualAddLexerToken"
local EqualSubToken = createToken "EqualSubLexerToken"
local EqualMulToken = createToken "EqualMulLexerToken"
local EqualDivToken = createToken "EqualDivLexerToken"
local LeftParenToken = createToken "LeftParenLexerToken"
local RightParenToken = createToken "RightParenLexerToken"
local LeftBraceToken = createToken "LeftBraceLexerToken"
local RightBraceToken = createToken "RightBraceLexerToken"
local LeftBrackToken = createToken "LeftBrackLexerToken"
local RightBrackToken = createToken "RightBrackLexerToken"
local ArrowToken = createToken "ArrowLexerToken"
local ExtendsToken = createToken "ExtendsLexerToken"
local TypeToken = createToken "TypeLexerToken"
local PublicToken = createToken "PublicLexerToken"
local EofToken = createToken "EofLexerToken"

local IdentifierTokenType = "IdentifierLexerToken"
local NumberTokenType = "NumberLexerToken"
local StringTokenType = "StringLexerToken"
local FunctionTokenType = "FunctionLexerToken"
local BooleanTokenType = "BooleanLexerToken"
local NilTokenType = "NilLexerToken"
local ClassTokenType = "ClassLexerToken"
local VarTokenType = "VarLexerToken"
local IfTokenType = "IfLexerToken"
local ElseTokenType = "ElseLexerToken"
local WhileTokenType = "WhileLexerToken"
local ForTokenType = "ForLexerToken"
local ReturnTokenType = "ReturnLexerToken"
local AddTokenType = "AddLexerToken"
local SubTokenType = "SubLexerToken"
local MulTokenType = "MulLexerToken"
local DivTokenType = "DivLexerToken"
local RemainderTokenType = "RemainderLexerToken"
local AndTokenType = "AndLexerToken"
local OrTokenType = "OrLexerToken"
local NotTokenType = "NotLexerToken"
local DotTokenType = "DotLexerToken"
local DotTwoTokenType = "DotTwoLexerToken"
local CommaTokenType = "CommaLexerToken"
local SemiColonTokenType = "SemiColonLexerToken"
local ColonTokenType = "ColonLexerToken"
local ColonTwoTokenType = "ColonTwoLexerToken"
local EqualTokenType = "EqualLexerToken"
local EqualTwoTokenType = "EqualTwoLexerToken"
local NotEqualTokenType = "NotEqualLexerToken"
local LessTokenType = "LessLexerToken"
local LessEqualTokenType = "LessEqualLexerToken"
local GreaterTokenType = "GreaterLexerToken"
local GreaterEqualTokenType = "GreaterEqualLexerToken"
local EqualAddTokenType = "EqualAddLexerToken"
local EqualSubTokenType = "EqualSubLexerToken"
local EqualMulTokenType = "EqualMulLexerToken"
local EqualDivTokenType = "EqualDivLexerToken"
local LeftParenTokenType = "LeftParenLexerToken"
local RightParenTokenType = "RightParenLexerToken"
local LeftBraceTokenType = "LeftBraceLexerToken"
local RightBraceTokenType = "RightBraceLexerToken"
local LeftBrackTokenType = "LeftBrackLexerToken"
local RightBrackTokenType = "RightBrackLexerToken"
local ArrowTokenType = "ArrowLexerToken"
local ExtendsTokenType = "ExtendsLexerToken"
local TypeTokenType = "TypeLexerToken"
local PublicTokenType = "PublicLexerToken"
local EofTokenType = "EofLexerToken"

export type IdentifierTokenType = "IdentifierTokenType"
export type NumberTokenType = "NumberTokenType"
export type StringTokenType = "StringTokenType"
export type FunctionTokenType = "FunctionTokenType"
export type BooleanTokenType = "BooleanTokenType"
export type NilTokenType = "NilTokenType"
export type ClassTokenType = "ClassTokenType"
export type VarTokenType = "VarTokenType"
export type IfTokenType = "IfTokenType"
export type ElseTokenType = "ElseTokenType"
export type WhileTokenType = "WhileTokenType"
export type ForTokenType = "ForTokenType"
export type ReturnTokenType = "ReturnTokenType"
export type AddTokenType = "AddTokenType"
export type SubTokenType = "SubTokenType"
export type MulTokenType = "MulTokenType"
export type DivTokenType = "DivTokenType"
export type RemainderTokenType = "RemainderTokenType"
export type AndTokenType = "AndTokenType"
export type OrTokenType = "OrTokenType"
export type NotTokenType = "NotTokenType"
export type DotTokenType = "DotTokenType"
export type DotTwoTokenType = "DotTwoTokenType"
export type CommaTokenType = "CommaTokenType"
export type SemiColonTokenType = "SemiColonTokenType"
export type ColonTokenType = "ColonTokenType"
export type ColonTwoTokenType = "ColonTwoTokenType"
export type EqualTokenType = "EqualTokenType"
export type EqualTwoTokenType = "EqualTwoTokenType"
export type NotEqualTokenType = "NotEqualTokenType"
export type LessTokenType = "LessTokenType"
export type LessEqualTokenType = "LessEqualTokenType"
export type GreaterTokenType = "GreaterTokenType"
export type GreaterEqualTokenType = "GreaterEqualTokenType"
export type EqualAddTokenType = "EqualAddTokenType"
export type EqualSubTokenType = "EqualSubTokenType"
export type EqualMulTokenType = "EqualMulTokenType"
export type EqualDivTokenType = "EqualDivTokenType"
export type LeftParenTokenType = "LeftParenTokenType"
export type RightParenTokenType = "RightParenTokenType"
export type LeftBraceTokenType = "LeftBraceTokenType"
export type RightBraceTokenType = "RightBraceTokenType"
export type LeftBrackTokenType = "LeftBrackTokenType"
export type RightBrackTokenType = "RightBrackTokenType"
export type ArrowTokenType = "ArrowTokenType"
export type ExtendsTokenType = "ExtendsTokenType"
export type TypeTokenType = "TypeTokenType"
export type PublicTokenType = "PublicTokenType"
export type EofTokenType = "EofTokenType"

local tokens = {
    IdentifierToken = IdentifierToken,
    NumberToken = NumberToken,
    StringToken = StringToken,
    FunctionToken = FunctionToken,
    BooleanToken = BooleanToken,
    NilToken = NilToken,
    ClassToken = ClassToken,
    VarToken = VarToken,
    IfToken = IfToken,
    ElseToken = ElseToken,
    WhileToken = WhileToken,
    ForToken = ForToken,
    ReturnToken = ReturnToken,
    AddToken = AddToken,
    SubToken = SubToken,
    MulToken = MulToken,
    DivToken = DivToken,
    RemainderToken = RemainderToken,
    AndToken = AndToken,
    OrToken = OrToken,
    NotToken = NotToken,
    DotToken = DotToken,
    DotTwoToken = DotTwoToken,
    CommaToken = CommaToken,
    SemiColonToken = SemiColonToken,
    ColonToken = ColonToken,
    ColonTwoToken = ColonTwoToken,
    EqualToken = EqualToken,
    EqualTwoToken = EqualTwoToken,
    NotEqualToken = NotEqualToken,
    LessToken = LessToken,
    LessEqualToken = LessEqualToken,
    GreaterToken = GreaterToken,
    GreaterEqualToken = GreaterEqualToken,
    EqualAddToken = EqualAddToken,
    EqualSubToken = EqualSubToken,
    EqualMulToken = EqualMulToken,
    EqualDivToken = EqualDivToken,
    LeftParenToken = LeftParenToken,
    RightParenToken = RightParenToken,
    LeftBraceToken = LeftBraceToken,
    RightBraceToken = RightBraceToken,
    LeftBrackToken = LeftBrackToken,
    RightBrackToken = RightBrackToken,
    ArrowToken = ArrowToken,
    ExtendsToken = ExtendsToken,
    TypeToken = TypeToken,
    PublicToken = PublicToken,
    EofToken = EofToken,
}

local token_types = {
    IdentifierTokenType = IdentifierTokenType,
    NumberTokenType = NumberTokenType,
    StringTokenType = StringTokenType,
    FunctionTokenType = FunctionTokenType,
    BooleanTokenType = BooleanTokenType,
    NilTokenType = NilTokenType,
    ClassTokenType = ClassTokenType,
    VarTokenType = VarTokenType,
    IfTokenType = IfTokenType,
    ElseTokenType = ElseTokenType,
    WhileTokenType = WhileTokenType,
    ForTokenType = ForTokenType,
    ReturnTokenType = ReturnTokenType,
    AddTokenType = AddTokenType,
    SubTokenType = SubTokenType,
    MulTokenType = MulTokenType,
    DivTokenType = DivTokenType,
    RemainderTokenType = RemainderTokenType,
    AndTokenType = AndTokenType,
    OrTokenType = OrTokenType,
    NotTokenType = NotTokenType,
    DotTokenType = DotTokenType,
    DotTwoTokenType = DotTwoTokenType,
    CommaTokenType = CommaTokenType,
    SemiColonTokenType = SemiColonTokenType,
    ColonTokenType = ColonTokenType,
    ColonTwoTokenType = ColonTwoTokenType,
    EqualTokenType = EqualTokenType,
    EqualTwoTokenType = EqualTwoTokenType,
    NotEqualTokenType = NotEqualTokenType,
    LessTokenType = LessTokenType,
    LessEqualTokenType = LessEqualTokenType,
    GreaterTokenType = GreaterTokenType,
    GreaterEqualTokenType = GreaterEqualTokenType,
    EqualAddTokenType = EqualAddTokenType,
    EqualSubTokenType = EqualSubTokenType,
    EqualMulTokenType = EqualMulTokenType,
    EqualDivTokenType = EqualDivTokenType,
    LeftParenTokenType = LeftParenTokenType,
    RightParenTokenType = RightParenTokenType,
    LeftBraceTokenType = LeftBraceTokenType,
    RightBraceTokenType = RightBraceTokenType,
    LeftBrackTokenType = LeftBrackTokenType,
    RightBrackTokenType = RightBrackTokenType,
    ArrowTokenType = ArrowTokenType,
    ExtendsTokenType = ExtendsTokenType,
    TypeTokenType = TypeTokenType,
    PublicTokenType = PublicTokenType,
    EofTokenType = EofTokenType,
}

export type LiteralTokenTypes = 
    | NumberTokenType
    | StringTokenType
    | BooleanTokenType
    | NilTokenType

export type OperatorTokenTypes = 
    | AddTokenType
    | SubTokenType
    | MulTokenType
    | DivTokenType
    | RemainderTokenType

    | GreaterTokenType
    | LessTokenType
    | GreaterEqualTokenType
    | LessEqualTokenType

    | EqualTwoTokenType
    | NotEqualTokenType

    | AndTokenType
    | OrTokenType


export type LiteralExpression = {
    data_type: LiteralTokenTypes,
    value: string,
    type: "LiteralExpression",
}

export type GroupedExpression = {
    expression: Expression,
    type: "GroupedExpression",
}

export type UnaryExpression = {
    expression: Expression,
    type: "UnaryExpression",
}

export type FunctionCallExpression = {
    expression: Expression,
    args: { Expression },
    type: "FunctionCallExpression",
}

export type VariableExpression = {
    name: string,
    type: "VariableExpression",
}

export type BinaryExpression = {
    left: Expression,
    right: Expression,
    operator: OperatorTokenTypes,
    type: "BinaryExpression",
}

export type IndexAccessExpression = {
    expression: Expression,
    index: Expression,
    type: "IndexAccessExpression",
}

export type TableExpression = {
    args: {
        [number]: {
            key: Expression,
            value: Expression,
        }
    },
    type: "TableExpression",
}

export type FunctionExpression = {
    parameters: { string },
    return_expression: Expression,
    body: { AstNode },
    type: "FunctionExpression",
}

export type Expression = 
    | LiteralExpression
    | GroupedExpression
    | UnaryExpression
    | FunctionCallExpression
    | VariableExpression
    | BinaryExpression
    | IndexAccessExpression
    | TableExpression

local expression = {}

function expression.LiteralExpression(data_type: LiteralTokenTypes, value: string): LiteralExpression
    return {
        data_type = data_type,
        value = value,
        type = "LiteralExpression",
    }
end

function expression.GroupedExpression(expression: Expression): GroupedExpression
    return {
        expression = expression,
        type = "GroupedExpression",
    }
end

function expression.UnaryExpression(expression: Expression): UnaryExpression
    return {
        expression = expression,
        type = "UnaryExpression",
    }
end

function expression.FunctionCallExpression(expression: Expression, args: { Expression }): FunctionCallExpression
    return {
        expression = expression,
        args = args,
        type = "FunctionCallExpression",
    }
end

function expression.VariableExpression(name: string, value: Expression): VariableExpression
    return {
        name = name,
        value = value,
        type = "VariableExpression",
    }
end

function expression.BinaryExpression(left: Expression, operator: OperatorTokenTypes, right: Expression): BinaryExpression
    return {
        left = left,
        right = right,
        operator = operator,
        type = "BinaryExpression",
    }
end

function expression.IndexAccessExpression(expression: Expression, index: Expression): IndexAccessExpression
    return {
        expression = expression,
        index = index,
        type = "IndexAccessExpression",
    }
end

function expression.TableExpression(args: { { key: Expression, value: Expression } }): TableExpression
    return {
        args = args,
        type = "TableExpression",
    }
end

function expression.FunctionExpression(body: { AstNode }, parameters: { string }, return_expression: Expression): FunctionExpression
    return {
        parameters = parameters,
        return_expression = return_expression,
        body = body,
        type = "FunctionExpression",
    }
end

export type VariableAstNode = {
    name: string,
    value: Expression,
    type: "VariableAstNode",
}

export type FunctionAstNode = {
    name: string,
    parameters: { string },
    return_expression: Expression,
    body: { AstNode },
    type: "FunctionAstNode",
}

export type AstNode =
    | VariableAstNode
    | FunctionAstNode

local ast_node = {}

function ast_node.VariableAstNode(name: string, value: Expression): VariableAstNode
    return {
        name = name,
        value = value,
        type = "VariableAstNode",
    }
end

function ast_node.FunctionAstNode(name: string, parameters: { string }, return_expression: Expression, body: { AstNode }): FunctionAstNode
    return {
        name = name,
        parameters = parameters,
        return_expression = return_expression,
        body = body,
        type = "FunctionAstNode",
    }
end

--// TODO: add class, pub, import, type
-- function expression.ClassExpression()

-- end

-- function expression.TypeExpression()

-- end

-- function expression.ImportExpression()

-- end

return {
    tokens = tokens,
    token_types = token_types,
    expression = expression,
}