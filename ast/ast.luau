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
export type TypeofTokenType = "TypeofTokenType"
export type PublicTokenType = "PublicTokenType"
export type EofTokenType = "EofTokenType"

export type TokenType = 
    | IdentifierTokenType
    | NumberTokenType
    | StringTokenType
    | FunctionTokenType
    | BooleanTokenType
    | NilTokenType
    | ClassTokenType
    | VarTokenType
    | IfTokenType
    | ElseTokenType
    | WhileTokenType
    | ForTokenType
    | ReturnTokenType
    | AddTokenType
    | SubTokenType
    | MulTokenType
    | DivTokenType
    | RemainderTokenType
    | AndTokenType
    | OrTokenType
    | NotTokenType
    | DotTokenType
    | DotTwoTokenType
    | CommaTokenType
    | SemiColonTokenType
    | ColonTokenType
    | ColonTwoTokenType
    | EqualTokenType
    | EqualTwoTokenType
    | NotEqualTokenType
    | LessTokenType
    | LessEqualTokenType
    | GreaterTokenType
    | GreaterEqualTokenType
    | EqualAddTokenType
    | EqualSubTokenType
    | EqualMulTokenType
    | EqualDivTokenType
    | LeftParenTokenType
    | RightParenTokenType
    | LeftBraceTokenType
    | RightBraceTokenType
    | LeftBrackTokenType
    | RightBrackTokenType
    | ArrowTokenType
    | ExtendsTokenType
    | TypeTokenType
    | TypeofTokenType
    | PublicTokenType
    | EofTokenType

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

local IdentifierTokenType: IdentifierTokenType = "IdentifierTokenType"
local NumberTokenType: NumberTokenType = "NumberTokenType"
local StringTokenType: StringTokenType = "StringTokenType"
local FunctionTokenType: FunctionTokenType = "FunctionTokenType"
local BooleanTokenType: BooleanTokenType = "BooleanTokenType"
local NilTokenType: NilTokenType = "NilTokenType"
local ClassTokenType: ClassTokenType = "ClassTokenType"
local VarTokenType: VarTokenType = "VarTokenType"
local IfTokenType: IfTokenType = "IfTokenType"
local ElseTokenType: ElseTokenType = "ElseTokenType"
local WhileTokenType: WhileTokenType = "WhileTokenType"
local ForTokenType: ForTokenType = "ForTokenType"
local ReturnTokenType: ReturnTokenType = "ReturnTokenType"
local AddTokenType: AddTokenType = "AddTokenType"
local SubTokenType: SubTokenType = "SubTokenType"
local MulTokenType: MulTokenType = "MulTokenType"
local DivTokenType: DivTokenType = "DivTokenType"
local RemainderTokenType: RemainderTokenType = "RemainderTokenType"
local AndTokenType: AndTokenType = "AndTokenType"
local OrTokenType: OrTokenType = "OrTokenType"
local NotTokenType: NotTokenType = "NotTokenType"
local DotTokenType: DotTokenType = "DotTokenType"
local DotTwoTokenType: DotTwoTokenType = "DotTwoTokenType"
local CommaTokenType: CommaTokenType = "CommaTokenType"
local SemiColonTokenType: SemiColonTokenType = "SemiColonTokenType"
local ColonTokenType: ColonTokenType = "ColonTokenType"
local ColonTwoTokenType: ColonTwoTokenType = "ColonTwoTokenType"
local EqualTokenType: EqualTokenType = "EqualTokenType"
local EqualTwoTokenType: EqualTwoTokenType = "EqualTwoTokenType"
local NotEqualTokenType: NotEqualTokenType = "NotEqualTokenType"
local LessTokenType: LessTokenType = "LessTokenType"
local LessEqualTokenType: LessEqualTokenType = "LessEqualTokenType"
local GreaterTokenType: GreaterTokenType = "GreaterTokenType"
local GreaterEqualTokenType: GreaterEqualTokenType = "GreaterEqualTokenType"
local EqualAddTokenType: EqualAddTokenType = "EqualAddTokenType"
local EqualSubTokenType: EqualSubTokenType = "EqualSubTokenType"
local EqualMulTokenType: EqualMulTokenType = "EqualMulTokenType"
local EqualDivTokenType: EqualDivTokenType = "EqualDivTokenType"
local LeftParenTokenType: LeftParenTokenType = "LeftParenTokenType"
local RightParenTokenType: RightParenTokenType = "RightParenTokenType"
local LeftBraceTokenType: LeftBraceTokenType = "LeftBraceTokenType"
local RightBraceTokenType: RightBraceTokenType = "RightBraceTokenType"
local LeftBrackTokenType: LeftBrackTokenType = "LeftBrackTokenType"
local RightBrackTokenType: RightBrackTokenType = "RightBrackTokenType"
local ArrowTokenType: ArrowTokenType = "ArrowTokenType"
local ExtendsTokenType: ExtendsTokenType = "ExtendsTokenType"
local TypeTokenType: TypeTokenType = "TypeTokenType"
local TypeofTokenType: TypeofTokenType = "TypeofTokenType"
local PublicTokenType: PublicTokenType = "PublicTokenType"
local EofTokenType: EofTokenType = "EofTokenType"

local IdentifierToken = createToken(IdentifierTokenType)
local NumberToken = createToken(NumberTokenType)
local StringToken = createToken(StringTokenType)
local FunctionToken = createToken(FunctionTokenType)
local BooleanToken = createToken(BooleanTokenType)
local NilToken = createToken(NilTokenType)
local ClassToken = createToken(ClassTokenType)
local VarToken = createToken(VarTokenType)
local IfToken = createToken(IfTokenType)
local ElseToken = createToken(ElseTokenType)
local WhileToken = createToken(WhileTokenType)
local ForToken = createToken(ForTokenType)
local ReturnToken = createToken(ReturnTokenType)
local AddToken = createToken(AddTokenType)
local SubToken = createToken(SubTokenType)
local MulToken = createToken(MulTokenType)
local DivToken = createToken(DivTokenType)
local RemainderToken = createToken(RemainderTokenType)
local AndToken = createToken(AndTokenType)
local OrToken = createToken(OrTokenType)
local NotToken = createToken(NotTokenType)
local DotToken = createToken(DotTokenType)
local DotTwoToken = createToken(DotTwoTokenType)
local CommaToken = createToken(CommaTokenType)
local SemiColonToken = createToken(SemiColonTokenType)
local ColonToken = createToken(ColonTokenType)
local ColonTwoToken = createToken(ColonTwoTokenType)
local EqualToken = createToken(EqualTokenType)
local EqualTwoToken = createToken(EqualTwoTokenType)
local NotEqualToken = createToken(NotEqualTokenType)
local LessToken = createToken(LessTokenType)
local LessEqualToken = createToken(LessEqualTokenType)
local GreaterToken = createToken(GreaterTokenType)
local GreaterEqualToken = createToken(GreaterEqualTokenType)
local EqualAddToken = createToken(EqualAddTokenType)
local EqualSubToken = createToken(EqualSubTokenType)
local EqualMulToken = createToken(EqualMulTokenType)
local EqualDivToken = createToken(EqualDivTokenType)
local LeftParenToken = createToken(LeftParenTokenType)
local RightParenToken = createToken(RightParenTokenType)
local LeftBraceToken = createToken(LeftBraceTokenType)
local RightBraceToken = createToken(RightBraceTokenType)
local LeftBrackToken = createToken(LeftBrackTokenType)
local RightBrackToken = createToken(RightBrackTokenType)
local ArrowToken = createToken(ArrowTokenType)
local ExtendsToken = createToken(ExtendsTokenType)
local TypeToken = createToken(TypeTokenType)
local TypeofToken = createToken(TypeofTokenType)
local PublicToken = createToken(PublicTokenType)
local EofToken = createToken(EofTokenType)

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
    TypeofToken = TypeofToken,
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
    TypeofTokenType = TypeofTokenType,
    PublicTokenType = PublicTokenType,
    EofTokenType = EofTokenType,
}

export type StringAstType = "StringAstType"
export type NumberAstType = "NumberAstType"
export type BooleanAstType = "NumberAstType"
export type NilAstType = "NilAstType"

export type FunctionAstType = {
    parameters: { AstType },
    return_type: AstType,
    type: "FunctionAstType",
}

export type AstType = 
    | StringAstType
    | NumberAstType
    | BooleanAstType
    | NilAstType
    | FunctionAstType

local ast_type = {}
ast_type.StringAstType = "StringAstType"
ast_type.NumberAstType = "NumberAstType"
ast_type.BooleanAstType = "NumberAstType"
ast_type.NilAstType = "NilAstType"

function ast_type.FunctionAstType(parameters: { AstType }, return_type: AstType): FunctionAstType
    return {
        parameters = parameters,
        return_type = return_type,
        type = "FunctionAstType",
    }
end

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

export type TypeAstNode = {
    name: string,
    value: AstType,
    type: "TypeAstNode",
}

export type AstNode =
    | VariableAstNode
    | FunctionAstNode
    | TypeAstNode

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

function ast_node.TypeAstNode(name: string, value: AstType): TypeAstNode
    return {
        name = name,
        value = value,
        type = "TypeAstNode",
    }
end

--// TODO: add class, pub, import, type
--// TODO: add type, statement
--// TODO: compiler -> typeof
--// 튜플, 어레이, 오브젝트 같은거는 std 에 넣기
-- function expression.ClassExpression()

-- end


-- function expression.ImportExpression()

-- end

return {
    tokens = tokens,
    token_types = token_types,
    expression = expression,
    ast_node = ast_node,
}