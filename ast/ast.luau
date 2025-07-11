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
export type BreakTokenType = "BreakTokenType"
export type ContinueTokenType = "ContinueTokenType"
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
export type TypeTokenType = "TypeTokenType"
export type TypeofTokenType = "TypeofTokenType"
export type PublicTokenType = "PublicTokenType"
export type ImportTokenType = "ImportTokenType"
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
    | BreakTokenType
    | ContinueTokenType
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
    | TypeTokenType
    | TypeofTokenType
    | PublicTokenType
    | ImportTokenType
    | EofTokenType

export type LiteralTokenTypes = 
    | NumberAstType
    | StringAstType
    | BooleanAstType

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
local BreakTokenType: BreakTokenType = "BreakTokenType"
local ContinueTokenType: ContinueTokenType = "ContinueTokenType"
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
local TypeTokenType: TypeTokenType = "TypeTokenType"
local TypeofTokenType: TypeofTokenType = "TypeofTokenType"
local PublicTokenType: PublicTokenType = "PublicTokenType"
local ImportTokenType: ImportTokenType = "ImportTokenType"
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
local BreakToken = createToken(BreakTokenType)
local ContinueTokenType = createToken(ContinueTokenType)
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
local TypeToken = createToken(TypeTokenType)
local TypeofToken = createToken(TypeofTokenType)
local PublicToken = createToken(PublicTokenType)
local ImportToken = createToken(ImportTokenType)
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
    BreakToken = BreakToken,
    ContinueTokenType = ContinueTokenType,
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
    TypeToken = TypeToken,
    TypeofToken = TypeofToken,
    PublicToken = PublicToken,
    ImportToken = ImportToken,
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
    TypeTokenType = TypeTokenType,
    TypeofTokenType = TypeofTokenType,
    PublicTokenType = PublicTokenType,
    EofTokenType = EofTokenType,
}

local operator_precedence: { [OperatorTokenTypes]: number } = {
    [AddTokenType] = 1,
    [SubTokenType] = 1,

    [MulTokenType] = 2,
    [DivTokenType] = 2,

    [GreaterTokenType] = 0,
    [GreaterEqualTokenType] = 0,
    [LessTokenType] = 0,
    [LessEqualTokenType] = 0,
    
    [EqualTwoTokenType] = 0,
    [NotEqualTokenType] = 0,

    [AndTokenType] = 0,
    [OrTokenType] = 0,
}

export type StringAstType = { 
    type: "StringAstType",
}
export type NumberAstType = { 
    type: "NumberAstType",
}
export type BooleanAstType = { 
    type: "BooleanAstType",
}
export type AnyAstType = { 
    type: "AnyAstType",
}

export type FunctionAstType = {
    parameters: { ParameterAstType },
    return_type: AstType,
    generics: { GenericAstType },
    type: "FunctionAstType",
}

export type GenericAstType = {
    name: string,
    type: "GenericAstType",
}

export type TypeofAstType = {
    expression: Expression,
    type: "TypeofAstType",
}

export type CustomAstType = {
    name: string,
    generics: { GenericAstType },
    type: "CustomAstType",
}

export type AstType = 
    | StringAstType
    | NumberAstType
    | BooleanAstType
    | AnyAstType
    | FunctionAstType
    | GenericAstType
    | TypeofAstType
    | CustomAstType

local ast_type = {}

ast_type.StringAstType = { 
    type = "StringAstType", 
} :: StringAstType

ast_type.NumberAstType = { 
    type = "NumberAstType", 
} :: NumberAstType

ast_type.BooleanAstType = { 
    type = "BooleanAstType", 
} :: BooleanAstType

ast_type.AnyAstType = { 
    type = "AnyAstType", 
} :: AnyAstType

local ast_node = {}

function ast_type.FunctionAstType(parameters: { ParameterAstType }, return_type: AstType, generics: { GenericAstType }): FunctionAstType
    return {
        parameters = parameters,
        return_type = return_type,
        generics = generics,
        type = "FunctionAstType",
    }
end

function ast_type.GenericAstType(name: string): GenericAstType
    return {
        name = name,
        type = "GenericAstType",
    }
end

function ast_type.TypeofAstType(expression: Expression): TypeofAstType
    return {
        expression = expression,
        type = "TypeofAstType",
    }
end

function ast_type.CustomAstType(name: string, generics: { GenericAstType }): CustomAstType
    return {
        name = name,
        generics = generics,
        type = "CustomAstType",
    }
end

export type LiteralExpression = {
    data_type: LiteralTokenTypes?,
    value: string,
    annotated_type: AstType?,
    type: "LiteralExpression",
}

export type GroupedExpression = {
    expression: Expression,
    annotated_type: AstType?,
    type: "GroupedExpression",
}

export type UnaryExpression = {
    expression: Expression,
    type: "UnaryExpression",
}

export type NotExpression = {
    expression: Expression,
    type: "NotExpression",
}

export type FunctionCallExpression = {
    expression: Expression,
    parameters: { Expression },
    annotated_type: AstType?,
    type: "FunctionCallExpression",
}

export type VariableExpression = {
    name: string,
    annotated_type: AstType?,
    type: "VariableExpression",
}

export type BinaryExpression = {
    left: Expression,
    right: Expression,
    operator: OperatorTokenTypes,
    annotated_type: AstType?,
    type: "BinaryExpression",
}

export type FunctionExpression = {
    parameters: { ParameterAstType },
    return_annotated_type: AstType?,
    generics: { GenericAstType },
    body: Block,
    type: "FunctionExpression",
}

export type Expression = 
    | LiteralExpression
    | GroupedExpression
    | UnaryExpression
    | NotExpression
    | FunctionCallExpression
    | VariableExpression
    | BinaryExpression
    | FunctionExpression

local expression = {}

function expression.LiteralExpression(data_type: LiteralTokenTypes?, value: string): LiteralExpression
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

function expression.NotExpression(expression: Expression): NotExpression
    return {
        expression = expression,
        type = "NotExpression",
    }
end

function expression.FunctionCallExpression(expression: Expression, parameters: { Expression }): FunctionCallExpression
    return {
        expression = expression,
        parameters = parameters,
        type = "FunctionCallExpression",
    }
end

function expression.VariableExpression(name: string): VariableExpression
    return {
        name = name,
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

function expression.FunctionExpression(body: Block, parameters: { ParameterAstType }, return_annotated_type: AstType?, generics: { GenericAstType }): FunctionExpression
    return {
        parameters = parameters,
        return_annotated_type = return_annotated_type,
        body = body,
        generics = generics,
        type = "FunctionExpression",
    }
end

export type IfStatement = {
    condition: Expression,
    body: Block,
    else_if_blocks: { 
        [number]: {
            body: Block,
            condition: Expression,
            type: "ElseIfBlocks"
        },
    },
    else_block: {
        body: Block,
        type: "ElseBlock"
    },
    type: "IfStatement",
}

export type ForStatement = {
    initialization: VariableAstNode,
    condition: Expression,
    increment: Expression,
    body: Block,
    type: "ForStatement",
}

export type WhileStatement = {
    condition: Expression,
    body: Block,
    type: "WhileStatement",
}

export type ReturnStatement = {
    value: Expression,
    type: "ReturnStatement",
}

export type BreakStatement = {
    type: "BreakStatement",
}

export type ContinueStatement = {
    type: "ContinueStatement",
}

export type Statement = 
    | IfStatement
    | ForStatement
    | WhileStatement
    | ReturnStatement
    | BreakStatement
    | ContinueStatement

local statement = {}

function statement.IfStatement(
    condition: Expression, 
    body: Block, 
    else_if_blocks: { 
        [number]: {
            body: Block,
            condition: Expression,
            type: "ElseIfBlocks"
        },
    }, 
    else_block: {
        body: Block,
        type: "ElseBlock"
    }
): IfStatement
    return {
        condition = condition,
        body = body,
        else_if_blocks = else_if_blocks,
        else_block = else_block,
        type = "IfStatement",
    }
end

function statement.ForStatement(initialization: VariableAstNode, condition: Expression, increment: Expression, body: Block): ForStatement
    return {
        initialization = initialization,
        condition = condition,
        increment = increment,
        body = body,
        type = "ForStatement",
    }
end

function statement.WhileStatement(condition: Expression, body: Block): WhileStatement
    return {
        condition = condition,
        body = body,
        type = "WhileStatement",
    }
end

function statement.ReturnStatement(value: Expression): ReturnStatement
    return {
        value = value,
        type = "ReturnStatement",
    }
end

function statement.BreakStatement(): BreakStatement
    return { type = "BreakStatement" }
end

function statement.ContinueStatement(): ContinueStatement
    return { type = "ContinueStatement" }
end

export type VariableAstNode = {
    name: string,
    value: Expression,
    annotated_type: AstType?,
    type: "VariableAstNode",
}

export type FunctionAstNode = {
    name: string,
    parameters: { ParameterAstType },
    generics: { GenericAstType },
    return_annotated_type: AstType?,
    body: Block,
    type: "FunctionAstNode",
}

export type TypeAstNode = {
    name: string,
    value: AstType,
    generics: { GenericAstType },
    type: "TypeAstNode",
}

export type PublicAstNode = {
    ast_node: PublicAstNodes,
    type: "PublicAstNode",
}

export type ImportAstNode = {
    path: string,
    type: "ImportAstNode",
}

export type ParameterAstType = {
    name: string,
    ast_type: AstType,
}

export type PublicAstNodes = 
    | FunctionAstNode
    | TypeAstNode

export type AstNode =
    | VariableAstNode
    | FunctionAstNode
    | TypeAstNode
    | PublicAstNode
    | ImportAstNode
    | Statement
    | Expression

export type Block = { AstNode }

function ast_node.VariableAstNode(name: string, value: Expression, annotated_type: AstType?): VariableAstNode
    return {
        name = name,
        value = value,
        annotated_type = annotated_type,
        type = "VariableAstNode",
    }
end

function ast_node.FunctionAstNode(name: string, parameters: { ParameterAstType }, body: Block, return_annotated_type: AstType?, generics: { GenericAstType }): FunctionAstNode
    return {
        name = name,
        parameters = parameters,
        return_annotated_type = return_annotated_type,
        body = body,
        generics = generics,
        type = "FunctionAstNode",
    }
end

function ast_node.TypeAstNode(name: string, value: AstType, generics: { GenericAstType }): TypeAstNode
    return {
        name = name,
        value = value,
        generics = generics,
        type = "TypeAstNode",
    }
end

function ast_node.PublicAstNode(ast_node: PublicAstNodes): PublicAstNode
    return {
        ast_node = ast_node,
        type = "PublicAstNode",
    }
end

function ast_node.ImportAstNode(path: string): ImportAstNode
    return {
        path = path,
        type = "ImportAstNode",
    }
end

return {
    tokens = tokens,
    token_types = token_types,
    operator_precedence = operator_precedence,
    expression = expression,
    statement = statement,
    ast_node = ast_node,
    ast_type = ast_type,
}
