   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
   #include <stdio.h>
   #include <ctype.h>
   #include "miniL-parser.hpp"
   extern int num_lines = 1;
   int num_cols = 1;
%}

   /* some common rules */
DIGIT     [0-9]
ID        [A-Za-z][A-Za-z0-9_]*[A-Za-z0-9]*
STARTD_ID  [0-9]+[A-Za-z_]+[A-Za-z0-9]*
STARTU_ID  [_]+[A-Za-z0-9_]*[A-Za-z0-9]*
END_ID    [A-Za-z][A-Za-z0-9_]*[_]+
%%
   /* specific lexer rules in regex */
" "            {++num_cols; }
"\t"           {num_cols += 4; }
"##".*         { /* DO NOTHING */ }           
\n             {++num_lines; }
"function"     {return FUNCTION; }
"beginparams"  {return BEGINPARAMS; }
"endparams"    {return ENDPARAMS; }
"beginlocals"  {return BEGINLOCALS; }
"endlocals"    {return ENDLOCALS; }
"beginbody"    {return BEGINBODY; }
"endbody"      {return ENDBODY; }
"integer"      {return INTEGER; }
"array"        {return ARRAY; }
"of"           {return OF; }
"if"           {return IF; }
"then"         {return THEN; }
"endif"        {return ENDIF; }
"else"         {return ELSE; }
"while"        {return WHILE; }
"do"           {return DO; }
"beginloop"    {return BEGINLOOP; }
"endloop"      {return ENDLOOP; }
"continue"     {return CONTINUE; }
"break"        {return BREAK; }
"read"         {return READ; }
"write"        {return WRITE; }
"not"          {return NOT; }
"true"         {return TRUE; }
"false"        {return FALSE; }
"return"       {return RETURN; }

"-"            {return '-'; }
"+"            {return '+'; }
"*"            {return '*'; }
"/"            {return '/'; }
"%"            {return '%'; }

"=="           {return EQUALITY; }
"<>"           {return NOT_EQ; }
"<"            {return '<'; }
">"            {return '>'; }
"<="           {return LESS_EQ; }
">="           {return GTR_EQ; }

";"            {return ';'; }
":"            {return ':'; }
","            {return ','; }
"("            {return '('; }
")"            {return ')'; }
"["            {return '['; }
"]"            {return ']'; }
":="           {return ASSIGN; }

{STARTD_ID}    { return ERROR; exit(1); }
{STARTU_ID}    { return ERROR; exit(1); }
{END_ID}       { return ERROR; exit(1); }
{ID}           { yylval.sval = strdup(yytext); return IDENT; }    //printf("IDENT %s\n", yytext);
{DIGIT}+       { yylval.ival = atoi(yytext); return NUMBER; }     //printf("NUMBER %s\n", yytext)

.              {++num_cols; return ERROR; exit(1); }

%%