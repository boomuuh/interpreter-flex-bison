%{
#include "parser-defs.h"
#include "parser.tab.h"

/*
 * DECLARATION
 * You may want to use this string to assemble the lexeme
 * of string constants by adding the current matched character from yytext to it.
 * You can do this as buffer += yytext;
 */
string buffer;

/*
 * You may want to track the comment desting depth with this variable.
 */
int comment_depth = 0;


%}


%option noyywrap

DIGIT                     [[:digit:]]
LETTER                  [[:alpha:]]|_
ID                          {LETTER}({LETTER}|{DIGIT}+)*
WHITESPACE           [ \t\f\r\v]+
NEWLINE                 [\n]
COMMA                  [,]
LESS                        [<]
GREATER                 [>]
EQ                          [=]
STR                         ["]
PRINT                      (?i:print)
ISNIL                       (?i:isNil)
NIL                          (?i:Nil)
LET                          (?i:let)
WITH                       (?i:with)
IF                             (?i:if)
THEN                       (?i:then)
ELSE                        (?i:else)
LAMBDA                  (?i:lambda)
FUNCTION               (?i:fun)
IN                            (?i:in)
READSTR                  (?i:readstring)
READINT                   (?i:readInt)







%x STRING
%x COMMENT


%%

\. {
    return TOKEN_DOT;
}

\+ {
    return TOKEN_PLUS;
}

\- {
    return TOKEN_MINUS;
}

\/ {
    return TOKEN_DIVIDE;
}

\* {
    return TOKEN_TIMES;
}

[&] {
    return TOKEN_AND;
}

[|] {
    return TOKEN_OR;
}

[@] {
    return TOKEN_CONS;
}

[!] {
    return TOKEN_HD;
}

[#] {
    return TOKEN_TL;
}


{EQ} {
    return TOKEN_EQ;
}


{GREATER} {
    return TOKEN_GT;
}

({GREATER}{EQ}) {
    return TOKEN_GEQ;
}

{LESS} {
    return TOKEN_LT;
}

({LESS}{EQ}) {
    return TOKEN_LEQ;
}

({LESS}{GREATER}) {
    return TOKEN_NEQ;
}


\( {
    return TOKEN_LPAREN;
}

\) {
    return TOKEN_RPAREN;
}


{STR} {
    BEGIN(STRING);
    buffer = "";
}

<STRING>[^"\n]+ {
        buffer += yytext;
}


<STRING>{STR} {
      SET_LEXEME(buffer);
      BEGIN(INITIAL);
     return TOKEN_STRING;
}



<STRING><<EOF>> {
    SET_LEXEME("Unexpected EOF in string");
    return TOKEN_ERROR;
}



<INITIAL,COMMENT>"(*" {
     /* encountered (* so +1 to nested comment */
        if (comment_depth == 0) {
            comment_depth = 1;
            BEGIN(COMMENT);

        } else {
             ++comment_depth;
        }
}

<COMMENT>"*)" {
    --comment_depth;
    if (comment_depth == 0){
        BEGIN(INITIAL);
    }

}

<COMMENT,STRING>{NEWLINE} {
    ++curr_lineno;
    buffer += yytext;

}

<COMMENT>[^(*)\n]+ {

}

<COMMENT>"("|"*"|")" {

}


<COMMENT><<EOF>> {
    SET_LEXEME("Unexpected EOF in comment.");
    return TOKEN_ERROR;
}

"*)" {
    return TOKEN_ERROR;
}


{LET} {
    return TOKEN_LET;
}

{DIGIT}+ {
    SET_LEXEME(yytext);
    return TOKEN_INT;
}


{ISNIL} {
    return TOKEN_ISNIL;
}

{NIL} {
    return TOKEN_NIL;
}

{PRINT} {
    return TOKEN_PRINT;
}

{LAMBDA} {
    return TOKEN_LAMBDA;
}

{FUNCTION} {
    return TOKEN_FUN;
}

{WITH} {
    return TOKEN_WITH;
}
 {IN} {
    return TOKEN_IN;
}

{IF} {
    return TOKEN_IF;
}

{THEN} {
    return TOKEN_THEN;
}

{ELSE} {
    return TOKEN_ELSE;
}

{READSTR} {
    return TOKEN_READSTRING;
}

{READINT} {
    return TOKEN_READINT;
}

{ID} {
    SET_LEXEME(yytext);
    return TOKEN_IDENTIFIER;
}


{WHITESPACE} {
  /* Do nothing */
}

{NEWLINE} {
/* Do nothing, but increment line numbers */
 curr_lineno++;
}

{COMMA} {
  return TOKEN_COMMA;
}


. {
  /* Leave this rule at the end of our lexer to "eat up" all illegal strings */
  SET_LEXEME("Unexpected character in input");
  return TOKEN_ERROR;
}

