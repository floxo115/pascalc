{$R+}
Program HelloWorld;
  type
  tPrecedence = (LOWEST, SUM, PRODUCT, PREFIX);
  tToken = record
              tokenType: string;
              literal: string;
            end;
  tLexer = record
              index: integer;
              inp: string;
              len: integer;
          end;
  tParser = record
              Lexer: tLexer;
              cur: tToken;
              peek: tToken;
            end;
            
  var
  inputString: string;
  Lexer: tLexer;
  Token: tToken;
  Parser: tParser;

  function TokenNew(tokenType, literal: string): tToken;
    var
    Token: tToken;
  begin
    Token.tokenType := tokentype;
    Token.literal := literal;
    exit(Token);
  end;

  function TokenPrint(inToken: tToken): string;
    var
    s: string; 
  begin
    s := 'Token: ';
    s := s + inToken.tokenType + ' ';
    s := s + inToken.literal;
    exit(s);
  end;

  function LexerInit(inString: string; var ioLexer: tLexer): tLexer;
  begin
    ioLexer.index := 1;
    ioLexer.inp := inString;
    ioLexer.len := length(ioLexer.inp);

    LexerInit := ioLexer;
  end;

  function LexerCur(inLexer: tLexer): char;
    var
    index: integer;
  begin
    if (inLexer.index <= inLexer.len) then
    begin
      index := inLexer.index;
      exit(inLexer.inp[index]);
    end;

    exit(char(''));
  end;

  function LexerPeek(inLexer: tLexer): char;
    var
    index: integer;
  begin
    index := inLexer.index + 1;
    LexerPeek := inLexer.inp[index];
  end;

  procedure LexerNextChar(var ioLexer: tLexer);
  begin
    ioLexer.index := ioLexer.index + 1
  end;

  function LexerNextToken(var ioLexer: tLexer): tToken;
    var 
    cur: char;
    peek: char;
    token: tToken;
    literal: string;

    function WS(inLexer: tLexer): boolean;
      var
      cur: char;
    begin
      cur := LexerCur(inLexer);
      if (cur = ' ') or (cur = '\n') then
        exit(true);
      
      exit(false);
    end;

    function IsDigit(cur: char): boolean;
    begin
      case (cur) of
        '0': exit(true);
        '1': exit(true);
        '2': exit(true);
        '3': exit(true);
        '4': exit(true);
        '5': exit(true);
        '6': exit(true);
        '7': exit(true);
        '8': exit(true);
        '9': exit(true);
      end;

      exit(false);
    end;
  begin
    while (WS(ioLexer)) do
      LexerNextChar(ioLexer);


    cur := LexerCur(ioLexer);
    peek := LexerPeek(ioLexer);
    if (cur = '+') then
      Token := TokenNew('Plus','+')
    else if (cur = '-') then
      Token := TokenNew('Minus','-')
    else if (cur ='*') then
      Token := TokenNew('Asterisk', '*')
    else if (cur = '(') then
      Token := TokenNew('LParen', '(')
    else if (cur = ')') then
      Token := TokenNew('RParen', ')')
    else if (isDigit(cur)) then
    begin
      literal := '';
      repeat
        literal := literal + cur;
        LexerNextChar(ioLexer);
        cur := LexerCur(ioLexer);
      until (not isDigit(cur));

      Token := TokenNew('Integer', literal);
    end
    else if (ord(cur) = 0) then
      Token := TokenNew('EOF', 'EOF')
    else 
      Token := TokenNew('Unknown', '');

    LexerNextChar(ioLexer);
    exit(token);
  end;

  function ParserNew(var ioLexer: tLexer): tParser;
    var
    Parser: tParser;
    cur: tToken;
    peek: tToken;
  begin
    cur := LexerNextToken(ioLexer);
    peek := LexerNextToken(ioLexer);

    Parser.Lexer := ioLexer;
    Parser.cur := cur;
    Parser.peek := peek;

    exit(Parser);
  end;

  procedure ParserNextToken(var ioParser: tParser);
    var 
    Token: tToken;
  begin
    Token := LexerNextToken(ioParser.Lexer);
    ioParser.cur := ioParser.peek;
    ioParser.peek := Token;
  end;

  function ParseExpression(
    inValue: integer;
    inPredecence: tPrecedence;
    var ioParser: tParser
  ): integer;
    var
    left: integer;
    infix: integer;
    Token: tToken;
  
    function computePrefix(
      inValue: integer;
      inToken: tToken;
      var ioParser: tParser
    ): integer;
      var
      value: integer;
      code: integer;
    begin
      case (inToken.tokenType) of
        'Integer': 
          begin
            val(inToken.literal, value, code);
            exit(value);
          end;
        'Plus':
          begin
            value := ParseExpression(inValue, PREFIX, ioParser);
            exit(+value);
          end;
        'Minus':
          begin
            value := ParseExpression(inValue, PREFIX, ioParser);
            exit(-value);
          end;
      end;

      writeln('ERROR: unknown token');
    end;

    function peekPredecence(inParser: tParser): tPrecedence;
    begin
      case (inParser.peek.tokenType) of
        'Plus': exit(SUM);
        'Minus': exit(SUM);
        'Asterisk': exit(PRODUCT);
      end;

      exit(LOWEST);
    end;

    function InfixExists(inToken: tToken): boolean;
    begin
      case (inToken.tokenType) of
        'Plus': exit(true);
        'Minus': exit(true);
        'Asterisk': exit(true);
      end;

      exit(false);
    end;

    function computeInfix(inValue: integer; inToken: tToken; var ioParser: tParser): integer;
      var
      right: integer;
    begin
      ParserNextToken(ioParser);
      case (inToken.tokenType) of
        'Plus':
          begin
            right := ParseExpression(inValue, SUM, ioParser);
            exit(inValue + right);
          end;
        'Minus':
          begin
            right := ParseExpression(inValue, SUM, ioParser);
            exit(inValue - right);
          end;
        'Asterisk':
          begin
            right := ParseExpression(inValue, PRODUCT, ioParser);
            exit(inValue * right);
          end;
      end;
    end;

  begin
    left := computePrefix(inValue, ioParser.cur, ioParser);

    while (ioParser.cur.tokenType <> 'EOF') and (peekPredecence(ioParser) > inPredecence) do
    begin
      if (not InfixExists(ioParser.peek)) then
      begin
        exit(left);
      end;

      ParserNextToken(ioParser);
      left := computeInfix(left, ioParser.cur, ioParser);
    end;

    exit(left);
  end;

begin
  while true do
  begin
    writeln('bitte input geben: ');
    readln(inputString);

    Lexer := LexerInit(inputString, Lexer);
    Parser := ParserNew(Lexer);

    writeLn('result: ', ParseExpression(0, LOWEST, Parser));
  end;
end.