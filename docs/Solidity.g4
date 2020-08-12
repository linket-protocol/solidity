grammar Solidity;

options { tokenVocab=SolidityLexer; }

sourceUnit: (pragmaDirective | importDirective | contractDefinition | structDefinition | enumDefinition)* EOF;

pragmaDirective: Pragma PragmaToken+ PragmaSemicolon;

importDirective:
	Import (
		(stringLiteral (As Identifier?))
		| (LBrace symbolAliases+=symbolAlias (Comma symbolAliases+=symbolAlias)* RBrace)
		| (Mul As Identifier)
	) Semicolon;

symbolAlias: Identifier (As Identifier);

contractDefinition:
	Abstract? ContractKind Identifier (Is inheritanceSpecifierList)?
	LBrace contractElement*	RBrace;

inheritanceSpecifierList: inheritanceSpecifiers+=inheritanceSpecifier (Comma inheritanceSpecifiers+=inheritanceSpecifier)*?;
inheritanceSpecifier: userDefinedTypeName functionCallArgumentList?;
contractElement:
	constructorDefinition # Constructor
	| fallbackFunctionDefinition # Fallback
	| functionDefinition # Function
	| structDefinition # Struct
	| enumDefinition # Enum
	| stateVariableDeclaration # StateVariable
	| modifierDefinition # Modifier
	| eventDefinition # Event
	| usingDirective # Using
;

functionDefinition:
	Function (Identifier | Fallback | Receive) LParen (arguments=parameterList)? RParen
	(modifierInvocation | stateMutability | visibility | Virtual | overrideSpecifier)*
	(Returns LParen returnParameters=parameterList RParen)?
	(body=block | Semicolon);
modifierDefinition: Modifier Identifier (LParen (arguments=parameterList)? RParen)? (Virtual | overrideSpecifier)* (Semicolon | body=block);



constructorDefinition: Constructor LParen (arguments=parameterList)? RParen (modifierInvocation | Payable | visibility)* body=block;
fallbackFunctionDefinition:
	(Fallback | Receive) LParen RParen
	(visibility | stateMutability | modifierInvocation | Virtual | overrideSpecifier)*
	(Semicolon | body=block);

parameterDeclaration: type=typeName location=storageLocation? name=Identifier?;
parameterList: parameters+=parameterDeclaration (Comma parameters+=parameterDeclaration)*;

variableDeclaration: type=typeName location=storageLocation? name=Identifier;
storageLocation: Memory | Storage | Calldata;

modifierInvocation: Identifier functionCallArgumentList?;
stateMutability: Pure | View | Payable;
visibility: Internal | External | Private | Public;
overrideSpecifier: Override (LParen overrides+=userDefinedTypeName (Comma overrides+=userDefinedTypeName)* RParen)?;

variableDeclarationList: variableDeclarations+=variableDeclaration (Comma variableDeclarations+=variableDeclaration)*;

functionCallArgumentList: LParen ((expression (Comma expression)*)? | LBrace (callOption (Comma callOption)*)? RBrace) RParen;

expression:
	expression binaryOp expression # BinaryOperation
	| expression assignOp expression # Assignment
	| expression compareOp expression # Comparison
	| expression (Inc | Dec) # UnarySuffixOperation
	| (Inc | Dec | Not | BitNot | Delete | Sub) expression # UnaryPrefixOperation
	| expression LBrack index=expression? RBrack # IndexAccess
	| expression LBrack start=expression? Colon end=expression? RBrack # IndexRangeAccess
	| expression Period (Identifier | Address) # MemberAccess
	| expression LBrace (callOption (Comma callOption)*)? RBrace # FunctionCallOptions
	| expression functionCallArgumentList # FunctionCall
	| Payable functionCallArgumentList # PayableConversion
	| Type LParen typeName RParen # MetaType
	| expression Conditional expression Colon expression # Conditional
	| New typeName # NewExpression
	| (
		Identifier
		| literal
		| typeNameExpression
		| tupleExpression
		| inlineArrayExpression
	  ) # PrimaryExpression
;
callOption: Identifier Colon expression;


assignOp: Assign | AssignBitOr | AssignBitXor | AssignBitAnd | AssignShl | AssignSar | AssignShr | AssignAdd | AssignSub | AssignMul | AssignDiv | AssignMod;
binaryOp: Comma | Or | And | BitOr | BitXor | BitAnd | Shl | Sar | Shr | Add | Sub | Mul | Div | Mod | Exp;
compareOp: Equal | NotEqual | LessThan | GreaterThan | LessThanOrEqual | GreaterThanOrEqual;
typeNameExpression: elementaryTypeName | userDefinedTypeName;
tupleExpression: LParen (expression? ( Comma expression?)* ) RParen;
inlineArrayExpression: LBrack (expression? ( Comma expression?)* ) RBrack;

literal: stringLiteral | numberLiteral | booleanLiteral | hexLiteral | unicodeStringLiteral;
booleanLiteral: True | False;
stringLiteral: StringLiteralFragment+;
hexLiteral: HexLiteralFragment+;
unicodeStringLiteral: UnicodeStringLiteralFragment+;

numberLiteral: (DecimalNumber | HexNumber) NumberUnit?;

userDefinedTypeName: Identifier (Period Identifier)*;

structDefinition: Struct Identifier LBrace structMemberDefinition+ RBrace;
structMemberDefinition: typeName Identifier Semicolon;

enumDefinition:	Enum Identifier LBrace enumValues+=Identifier (Comma enumValues+=Identifier)* RBrace;

stateVariableDeclaration:
	typeName
	(Public | Private | Internal | Constant | Virtual | overrideSpecifier | Immutable)*
	Identifier
	(Assign expression)?
	Semicolon;

typeName: elementaryTypeName | functionTypeName | mappingType | userDefinedTypeName | typeName LBrack expression? RBrack;

elementaryTypeName: Address Payable? | Bool | String | Bytes | Int | Uint | FixedBytes | Fixed | Ufixed;

functionTypeName: Function LParen (arguments=parameterList)? RParen (visibility | stateMutability)* (Returns LParen returnParameters=parameterList RParen)?;

block: LBrace statement* RBrace;

statement:
	assemblyStatement
	| simpleStatement
	| ifStatement
	| tryStatement
	| whileStatement
	| doWhileStatement
	| forStatement
	| returnStatement
	| block
	| continueStatement
	| breakStatement
	| emitStatement
;

simpleStatement: variableDeclarationStatement | expressionStatement;
assemblyStatement: Assembly AssemblyDialect? AssemblyLBrace yulStatement* YulRBrace;
variableDeclarationListMaybeEmpty: (Comma* variableDeclarations+=variableDeclaration) (Comma (variableDeclarations+=variableDeclaration)?)*;
variableDeclarationStatement: (variableDeclaration | LParen variableDeclarationListMaybeEmpty RParen) (Assign expression)? Semicolon;
expressionStatement: expression Semicolon;
ifStatement: If LParen expression RParen statement (Else statement)?;
tryStatement: Try expression (Returns LParen returnParameters=parameterList RParen)? block catchClause+;
whileStatement: While LParen expression RParen statement;
doWhileStatement: Do statement While LParen expression RParen Semicolon;
forStatement: For LParen (simpleStatement | Semicolon) (expressionStatement | Semicolon) expression? RParen statement;
continueStatement: Continue Semicolon;
breakStatement: Break Semicolon;
returnStatement: Return expression? Semicolon;
emitStatement: Emit expression functionCallArgumentList Semicolon;

catchClause: Catch (Identifier? LParen (arguments=parameterList)? RParen)? block;

eventDefinition: Event Identifier LParen eventParameterList? RParen Anonymous? Semicolon;

eventParameterList: parameters+=eventParameter (Comma parameters+=eventParameter)*;
eventParameter: typeName Indexed? Identifier?;

usingDirective: Using userDefinedTypeName For (Mul | typeName) Semicolon;

mappingType: Mapping LParen key=mappingKey Arrow value=typeName RParen;
mappingKey: elementaryTypeName | userDefinedTypeName;

yulStatement:
	yulSwitchStatement
	| yulForStatement
	| yulIfStatement
	| yulBlock
	| yulVarDecl
	| yulAssignment
	| yulFunctionCall
	| YulLeave
	| YulBreak
	| YulContinue
	| yulFunctionDefinition;
yulFunctionDefinition:
	YulFunction YulIdentifier
	YulLParen (arguments+=YulIdentifier (YulComma arguments+=YulIdentifier)*)? YulRParen
	((YulArrow | YulMinus YulGreater) returnParameters+=YulIdentifier (YulComma returnParameters+=YulIdentifier)*)?
	body=yulBlock;
yulSwitchStatement: YulSwitch yulExpression | yulSwitchCase+;
yulForStatement: YulFor init=yulBlock cond=yulExpression post=yulBlock body=yulBlock;
yulIfStatement: YulIf cond=yulExpression body=yulBlock;
yulSwitchCase: YulDefault yulBlock | YulCase yulLiteral yulBlock;
yulBlock: YulLBrace yulStatement* YulRBrace;
yulVarDecl: YulLet variables+=YulIdentifier (YulComma variables+=YulIdentifier)* (YulAssign value=yulExpression)?;
yulAssignment: yulPath YulAssign yulExpression | (yulPath (YulComma yulPath)+) YulAssign yulFunctionCall;
yulPath: YulIdentifier (YulPeriod YulIdentifier)*;
yulFunctionCall: YulIdentifier YulLParen (yulExpression (YulComma yulExpression)*)? YulRParen;
yulExpression: yulPath | yulFunctionCall | yulLiteral;
yulLiteral: YulDecimalNumber | YulStringLiteral | YulHexNumber | yulBoolean;
yulBoolean: YulTrue | YulFalse;