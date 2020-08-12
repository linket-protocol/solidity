lexer grammar SolidityLexer;

Abstract: 'abstract';
ContractKind: ( 'contract' | 'interface' | 'library' );
Pragma: 'pragma' -> pushMode(PragmaMode);
Import: 'import';

LParen: '(';
RParen: ')';
LBrack: '[';
RBrack: ']';
LBrace: '{';
RBrace: '}';
Colon: ':';
Semicolon: ';';
Period: '.';
Conditional: '?';
Arrow: '=>';
Assign: '=';
AssignBitOr: '|=';
AssignBitXor: '^=';
AssignBitAnd: '&=';
AssignShl: '<<=';
AssignSar: '>>=';
AssignShr: '>>>=';
AssignAdd: '+=';
AssignSub: '-=';
AssignMul: '*=';
AssignDiv: '/=';
AssignMod: '%=';

Comma: ',';
Or: '||';
And: '&&';
BitOr: '|';
BitXor: '^';
BitAnd: '&';
Shl: '<<';
Sar: '>>';
Shr: '>>>';
Add: '+';
Sub: '-';
Mul: '*';
Div: '/';
Mod: '%';
Exp: '**';
Equal: '==';
NotEqual: '!=';
LessThan: '<';
GreaterThan: '>';
LessThanOrEqual: '<=';
GreaterThanOrEqual: '>=';
Not: '!';
BitNot: '~';
Inc: '++';
Dec: '--';
Delete: 'delete';
As: 'as';
Struct: 'struct';
Enum: 'enum';
Is: 'is';
Memory: 'memory';
Storage: 'storage';
Calldata: 'calldata';
If: 'if';
Else: 'else';
Try: 'try';
While: 'while';
Do: 'do';
For: 'for';
Catch: 'catch';
New: 'new';

Virtual: 'virtual';
Pure: 'pure';
View: 'view';
Internal: 'internal';
External: 'external';
Private: 'private';
Public: 'public';
Override: 'override';
Returns: 'returns';
Constant: 'constant';
Return: 'return';
Anonymous: 'anonymous';
Indexed: 'indexed';
Type: 'type';
Constructor: 'constructor';
Fallback: 'fallback';
Receive: 'receive';
Continue: 'continue';
Break: 'break';
Hex: 'hex';
True: 'true';
False: 'false';
Emit: 'emit';
Immutable: 'immutable';

StringLiteralFragment: '"' DoubleQuotedStringCharacter* '"' | '\'' SingleQuotedStringCharacter* '\'';
UnicodeStringLiteralFragment: 'unicode"' DoubleQuotedStringCharacter* '"' | 'unicode\'' SingleQuotedStringCharacter* '\'';
HexLiteralFragment: 'hex' (('"' HexDigits? '"') | ('\'' HexDigits? '\''));
DecimalNumber: (DecimalDigits | (DecimalDigits? '.' DecimalDigits)) ([eE] '-'? DecimalDigits)?;
fragment DecimalDigits: [0-9] ('_'? [0-9])* ;
HexNumber: '0' [xX] HexDigits;
fragment HexDigits: HexCharacter ('_'? HexCharacter)*;
fragment HexCharacter: [0-9A-Fa-f];
NumberUnit: 'wei' | 'gwei' | 'ether' | 'seconds' | 'minutes' | 'hours' | 'days' | 'weeks' | 'years';

fragment DoubleQuotedStringCharacter: ~["\r\n\\] | ('\\' .);

fragment SingleQuotedStringCharacter: ~['\r\n\\] | ('\\' .);


Function: 'function';

Address: 'address';
Payable: 'payable';
Bool: 'bool';
String: 'string';
Bytes: 'bytes';
Int:
	'int' | 'int8' | 'int16' | 'int24' | 'int32' | 'int40' | 'int48' | 'int56' | 'int64' |
	'int72' | 'int80' | 'int88' | 'int96' | 'int104' | 'int112' | 'int120' | 'int128' |
	'int136' | 'int144' | 'int152' | 'int160' | 'int168' | 'int176' | 'int184' | 'int192' |
	'int200' | 'int208' | 'int216' | 'int224' | 'int232' | 'int240' | 'int248' | 'int256';
Uint:
	'uint' | 'uint8' | 'uint16' | 'uint24' | 'uint32' | 'uint40' | 'uint48' | 'uint56' | 'uint64' |
	'uint72' | 'uint80' | 'uint88' | 'uint96' | 'uint104' | 'uint112' | 'uint120' | 'uint128' |
	'uint136' | 'uint144' | 'uint152' | 'uint160' | 'uint168' | 'uint176' | 'uint184' | 'uint192' |
	'uint200' | 'uint208' | 'uint216' | 'uint224' | 'uint232' | 'uint240' | 'uint248' | 'uint256';
FixedBytes:
	'byte' | 'bytes1' | 'bytes2' | 'bytes3' | 'bytes4' | 'bytes5' | 'bytes6' | 'bytes7' | 'bytes8' |
	'bytes9' | 'bytes10' | 'bytes11' | 'bytes12' | 'bytes13' | 'bytes14' | 'bytes15' | 'bytes16' |
	'bytes17' | 'bytes18' | 'bytes19' | 'bytes20' | 'bytes21' | 'bytes22' | 'bytes23' | 'bytes24' |
	'bytes25' | 'bytes26' | 'bytes27' | 'bytes28' | 'bytes29' | 'bytes30' | 'bytes31' | 'bytes32';
Fixed: 'fixed' | ('fixed' [0-9]+ 'x' [0-9]+);
Ufixed: 'ufixed' | ('ufixed' [0-9]+ 'x' [0-9]+);


Modifier: 'modifier';
Event: 'event';
Using: 'using';
Mapping: 'mapping';

Assembly: 'assembly' -> pushMode(AssemblyBlockMode);

Identifier: IdentifierStart IdentifierPart*;
fragment IdentifierStart: [a-zA-Z$_];
fragment IdentifierPart: [a-zA-Z0-9$_];

WS: [ \t\r\n\u000C]+ -> skip ;
COMMENT: '/*' .*? '*/' -> channel(HIDDEN) ;
LINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN);

mode AssemblyBlockMode;

AssemblyDialect: '"' AssemblyDialectCharacter* '"';
fragment AssemblyDialectCharacter: ~["\r\n\\] | ('\\' .);
AssemblyLBrace: '{' -> popMode, pushMode(YulMode);

AssemblyBlockWS: [ \t\r\n\u000C]+ -> skip ;
AssemblyBlockCOMMENT: '/*' .*? '*/' -> channel(HIDDEN) ;
AssemblyBlockLINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN) ;

mode YulMode;

YulLBrace: '{' -> pushMode(YulMode);
YulRBrace: '}' -> popMode;
YulFor: 'for';
YulIf: 'if';
YulLeave: 'leave';
YulBreak: 'break';
YulContinue: 'continue';
YulSwitch: 'switch';
YulDefault: 'default';
YulCase: 'case';
YulLet: 'let';
YulFunction: 'function';
YulAssign: ':=';
YulPeriod: '.';
YulComma: ',';
YulArrow: '->';
YulMinus: '-';
YulGreater: '>';
YulLParen: '(';
YulRParen: ')';
YulTrue: 'true';
YulFalse: 'false';

YulIdentifier: YulIdentifierStart YulIdentifierPart*;
fragment YulIdentifierStart: [a-zA-Z$_];
fragment YulIdentifierPart: [a-zA-Z0-9$_];
YulHexNumber: '0' 'x' [0-9a-fA-F]+;
YulDecimalNumber: [0-9]+; // TODO
YulStringLiteral: '"' YulDoubleQuotedStringCharacter* '"';
fragment YulDoubleQuotedStringCharacter: ~["\r\n\\] | ('\\' .);

YulWS: [ \t\r\n\u000C]+ -> skip ;
YulCOMMENT: '/*' .*? '*/' -> channel(HIDDEN) ;
YulLINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN) ;

mode PragmaMode;

PragmaToken: ~[;]+;
PragmaSemicolon: ';' -> popMode;

PragmaWS: [ \t\r\n\u000C]+ -> skip ;
PragmaCOMMENT: '/*' .*? '*/' -> channel(HIDDEN) ;
PragmaLINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN) ;
