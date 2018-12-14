{$R+}
Program HelloWorld;
    type
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
      index := inLexer.index;
      LexerCur := inLexer.inp[index];
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
      if (ioLexer.index > ioLexer.len) then
        exit();
      
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
        if (cur = ' ') then
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
        Token := TokenNew('Minux','-')
      else if (cur ='*') then
        Token := TokenNew('Asterisk', '*')
      else if (cur = '/') then
        Token := TokenNew('Slash', '/')
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

begin

  while true do
  begin
    readln(inputString);
    Lexer := LexerInit(inputString, Lexer);
    Parser := ParserNew(Lexer);

    writeLn(Parser.cur.literal);
    writeLn(Parser.peek.literal);
  end;
end.