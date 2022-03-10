    /* cs152-miniL phase3 */
%{
extern int yylex();
extern int yyparse();
void yyerror(const char *msg);
#include <string>
#include <iostream>
std::string output;

struct CodeNode { 
  std::string name;
  std::string code;
};
%}

%union{
  /* put your types here */
  int ival;
  char *sval;
  struct CodeNode* code_node;
}

%error-verbose
%locations

/* Lower Precdence */

%left '+' '-'       /* (A op B) op C  */
%left '*' '/'       /* A op (B op C)   */
%right '='          /* A = (B = C)     */

/* Higher precedence */

%start prog_start

%token FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE BREAK READ WRITE
%token NOT TRUE FALSE RETURN EQUALITY NOT_EQ LESS_EQ GTR_EQ ASSIGN ERROR
%token <ival> NUMBER
%token <sval> IDENT

%type <code_node> var 
%type <code_node> term 
%type <code_node> statement 
%type <code_node> comp 
%type <code_node> functions 
%type <code_node> function 
%type <code_node> expression 
%type <code_node> mult-expr 
%type <code_node> bool-exp
%type <code_node> statements
%type <code_node> declaration
%type <code_node> Function
%type <code_node> prog_start
%type <code_node> declarations


/* %start program */

%% 

  /* write your rules here */
  prog_start: functions {
    CodeNode *node = new CodeNode;
    printf(($1->code).c_str());
   }
  ;

  functions: Function functions {
    CodeNode *node = new CodeNode;
    node->code = $1->code;
    node->name = $1->name;
    $$ = node;
   }
  |
  ;

  Function: FUNCTION IDENT ';' BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY {
    CodeNode *node = new CodeNode;
    node->name = "func 1";
    node->code = $11->code;
    $$ = node;
   }
  ;

  declarations: declaration ';' declarations {
    CodeNode *node = new CodeNode;
    node->code = $1->code + ";";
    node->name = "dec";
    $$ = node;
   }
  |
  ;

  declaration: IDENT ':' INTEGER                      {
    CodeNode *node = new CodeNode;
    node->name = "IDENT : INT";
    node->code = "IDENT : INT";
    $$ = node;
   }
  | IDENT ':' ARRAY '[' NUMBER ']' OF INTEGER         {
    CodeNode *node = new CodeNode;
    node->name = "IDENT : ARR";
    node->code = "IDENT : ARR";
    $$ = node;
   }
  ;

  expression : mult-expr                            {
              CodeNode *node = new CodeNode;
              node->code = $1->code;
              node->name = $1->name;
              $$ = node;
              }
             | mult-expr '+'  expression             {
             std::string temp = "";
             CodeNode *node = new CodeNode;
             node->code = $1->code + $3->code + temp;
             node->code += std::string("+, ") + temp + std::string(", ") + $1->name + std::string("\n");
             node->name = temp;
             $$ = node;
             }
             | mult-expr '-' expression             {
               std::string temp = "";
                CodeNode *node = new CodeNode;
                node->code = $1->code + $3->code + temp;
                node->code += std::string("-, ") + temp + std::string(", ") + $1->name + std::string("\n");
                node->name = temp;
                $$ = node;
              }
             ;

  statements: statement ';' statements                {
    CodeNode *node = new CodeNode;
    node->code = $1->code + $3->code;
    node->name = "";
    $$ = node;
   }
  |
  ;

  statement : var ASSIGN expression                                     {
              std::string var_name = $1->name;
              std::string error;
              //Error if statement went here

              CodeNode *node = new CodeNode;
              node->code = $3->code;
              node->code += std::string("= ") + var_name + std::string(", ") + $3->name + std::string("\n");
              node->name = var_name;
              $$ = node;
            }
            | IF bool-exp THEN statements ENDIF                         { }
            | IF bool-exp THEN statements ELSE statements ENDIF         { }
            | WHILE bool-exp BEGINLOOP statements ENDLOOP               { }
            | DO BEGINLOOP statements ENDLOOP WHILE bool-exp            { }
            | READ var                                                  {
              CodeNode *node = new CodeNode;
              node->code = $2->code;
              node->name = std::string("Read");
              std::string error;
              //Error if statement went here
              $$ = node;
             }
            | WRITE var                                                 {
              CodeNode *node = new CodeNode;
              node->code = $2->code;
              node->name = std::string("Write");
              std::string error;
              //Error if statement went here
              $$ = node;
             }
            | CONTINUE                                                  {
              CodeNode *node = new CodeNode;
              node->code = "";
              node->name = std::string("Continue");
              std::string error;
              //Error if statement went here
              $$ = node;
             }
            | BREAK                                                     {
              CodeNode *node = new CodeNode;
              node->code = "";
              node->name = std::string("Break");
              std::string error;
              //Error if statement went here
              $$ = node;
             }
            | RETURN expression                                         {
              CodeNode *node = new CodeNode;
              node->code = $2->code;
              node->name = std::string("Return");
              std::string error;
              //Error if statement went here
              $$ = node;
             }
  ;

  bool-exp : expression comp expression                             {
            CodeNode *node = new CodeNode;
            node->code = $1->code + $2->code + $3->code;
            node->name = $1->name + $2->name + $3->name;
            $$ = node;
            }
           | NOT expression comp expression                         {
             CodeNode *node = new CodeNode;
             node->code = "!" + $2->code + $3->code + $4->code;
             node->name = "!" + $2->name + $3->name  +$4->name;
             $$ = node;
            }
  ;

  comp : EQUALITY                                                       {
    CodeNode *node = new CodeNode;
    node->code = "";
    node->name = std::string("eq");
    std::string error;
    //Error if statement went here
    $$ = node;
   }
  |      NOT_EQ                                                         {
    CodeNode *node = new CodeNode;
    node->code = "";
    node->name = std::string("!eq");
    std::string error;
    //Error if statement went here
    $$ = node;
   }
  |       '<'                                                           {
    CodeNode *node = new CodeNode;
    node->code = "";
    node->name = std::string("<");
    std::string error;
    //Error if statement went here
    $$ = node;
   }
  |       '>'                                                           {
    CodeNode *node = new CodeNode;
    node->code = "";
    node->name = std::string(">");
    std::string error;
    //Error if statement went here
    $$ = node;
   }
  |       LESS_EQ                                                       {
    CodeNode *node = new CodeNode;
    node->code = "";
    node->name = std::string("<=");
    std::string error;
    //Error if statement went here
    $$ = node;
   }
  |       GTR_EQ                                                        {
    CodeNode *node = new CodeNode;
    node->code = "";
    node->name = std::string(">=");
    std::string error;
    //Error if statement went here
    $$ = node;
   }
  ;

  mult-expr : term                                                      {
    CodeNode *node = new CodeNode;
    node->code = $1->code;
    node->name = $1->name;
    $$ = node;
   }
            | term '*' mult-expr                                          {
              CodeNode *node = new CodeNode;
              node->code = $1->code + "*";
              node->name = $1->name + "*";
              $$ = node;
             }
            | term '/' mult-expr                                          {
              CodeNode *node = new CodeNode;
              node->code = $1->code + "/";
              node->name = $1->name + "/";
              $$ = node;
             }
            | term '%' mult-expr                                          {
              CodeNode *node = new CodeNode;
              node->code = $1->code + "%";
              node->name = $1->name + "%";
              $$ = node;
             }
            ;

  term : var                                                            {
    CodeNode *node = new CodeNode;
    node->code = "";
    node->name = $1->name;
    $$ = node;
   }
       | NUMBER                                                         {
         CodeNode *node = new CodeNode;
         //int temp = $1;
         //printf("%d", temp);
         node->code = $1;
         node->name = $1;
         $$ = node;
        }
       | '(' expression ')'                                             {
         CodeNode *node = new CodeNode;
         node->code = $2->code;
         node->name = $2->name;
         $$ = node;
        }
       | IDENT '(' expression ')'                                       {
         CodeNode *node = new CodeNode;
         node->name = $1;
         node->code = $3->code;
         $$ = node;
        }
       ;

  var : IDENT                                                           { 
      CodeNode *node = new CodeNode;
      node->code = "";
      node->name = $1;
      std::string error;
      //Error if statement went here
      $$ = node;
      }
      | IDENT '[' expression ']'                                        {
        CodeNode *node = new CodeNode;
        node->code += std::string("=[] _temp, ") + $1 + std::string(", ") + $3->code;
        node->name = std::string("temp");
        std::string error;
        //Error if statement went here
        $$ = node;
       }
      |
      ;


%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
    extern int num_lines;
    printf("Line %d: %s\n", num_lines, msg);
}