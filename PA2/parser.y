%{
#include "parser-defs.h"

int yylex();
extern int yy_scan_string(const char* c);
int yyerror(const char* p)
{ 
  if(parser_error_fn != NULL) {
    parser_error_fn("At line " + int_to_string(curr_lineno) + ": " + string(p));
  }
  return 1;
};

bool _DEBUG_ = false;
void debug(std::vector<Expression*> e) {
  if (_DEBUG_) {    
    std::cout << "************ DEBUG ******** " << std::endl;
     int count = 1;
     for (std::vector<Expression*>::const_iterator it= e.begin(); it != e.end(); ++it) {
          std::cout << count << ":  " << (*it)->to_string() << std::endl;
          ++count;
     }}
}



%}
/* BISON Declarations */
%token 
TOKEN_READSTRING 
TOKEN_READINT 
TOKEN_PRINT 
TOKEN_ISNIL
TOKEN_HD 
TOKEN_TL 
TOKEN_CONS 
TOKEN_NIL 
TOKEN_DOT 
TOKEN_WITH 
TOKEN_LET 
TOKEN_PLUS 
TOKEN_MINUS 
TOKEN_IDENTIFIER 
TOKEN_TIMES 
TOKEN_DIVIDE 
TOKEN_INT 
TOKEN_LPAREN 
TOKEN_RPAREN 
TOKEN_AND 
TOKEN_OR 
TOKEN_EQ 
TOKEN_NEQ 
TOKEN_GT 
TOKEN_GEQ 
TOKEN_LT 
TOKEN_LEQ 
TOKEN_IF 
TOKEN_THEN 
TOKEN_ELSE 
TOKEN_LAMBDA 
TOKEN_FUN 
TOKEN_COMMA 
TOKEN_STRING 
TOKEN_ERROR 
TOKEN_IN



%nonassoc EXPR

%left  TOKEN_LT TOKEN_GT TOKEN_EQ TOKEN_NEQ TOKEN_LEQ TOKEN_GEQ
%left  TOKEN_PLUS  TOKEN_MINUS
%left  TOKEN_TIMES TOKEN_DIVIDE



%%







program: expression
{
	res_expr = $$;
}



expression: 
           TOKEN_INT {
                        	string lexeme = GET_LEXEME($1);
                        	long int val = string_to_int(lexeme);
                        	Expression* e = AstInt::make(val);
                        	$$ = e; } 
          | TOKEN_STRING {
                        	string lexeme = GET_LEXEME($1);
                          Expression* e = AstString::make(lexeme);
                          $$ = e; }
                      
          | TOKEN_IDENTIFIER {
                      	  string lexeme = GET_LEXEME($1);
                        	$$ =  AstIdentifier::make(lexeme); }
          | TOKEN_READINT  { $$ = AstRead::make(true); }   

          | TOKEN_READSTRING { $$ = AstRead::make(false); }   
          
          | conditional 
            
          | expression TOKEN_PLUS expression {
            	            $$ = AstBinOp::make(PLUS, $1, $3); }

          | expression TOKEN_MINUS expression {
                          $$ = AstBinOp::make(MINUS, $1, $3); }  
          
          | expression TOKEN_TIMES expression {
                          $$ = AstBinOp::make(TIMES, $1, $3); }

          | expression TOKEN_DIVIDE expression {
                          $$ = AstBinOp::make(DIVIDE, $1, $3); } 

        

          | TOKEN_LET expression TOKEN_EQ expression TOKEN_IN expression %prec EXPR {
                          Expression* e = $2;
                          assert (e->get_type() == AST_IDENTIFIER);
                          $$ = AstLet::make(static_cast<AstIdentifier*>(e),$4,$6);}

          | TOKEN_LAMBDA id_list TOKEN_DOT expression %prec EXPR  {
                      assert(($2)->get_type() == AST_IDENTIFIER_LIST);
                      AstIdentifierList* ids = static_cast<AstIdentifierList*>($2);
                      $$ = AstLambda::make(ids,$4); }
                     
          | TOKEN_LPAREN expression_application TOKEN_RPAREN { $$ = $2; }
            	           
          | TOKEN_LPAREN expression TOKEN_RPAREN { $$ = $2; }
          
          | TOKEN_IF expression TOKEN_THEN expression TOKEN_ELSE expression %prec EXPR {
                          $$ = AstBranch::make($2,$4,$6); }

          | TOKEN_PRINT expression %prec EXPR {  
                          $$ = AstUnOp::make(PRINT,$2); }           
          | TOKEN_ERROR {
                         // do not change the error rule
                         string lexeme = GET_LEXEME($1);
                         string error = "Lexing error: ";
                         if(lexeme != "") error += lexeme;
                         yyerror(error.c_str());
                         YYERROR; }

id_list: 
           expression {
                  debug({$1});
                  Expression* e = $1;
                  assert(e->get_type() ==AST_IDENTIFIER);
                  AstIdentifier* i = static_cast<AstIdentifier*>(e);
                  $$ = AstIdentifierList::make(i);
                 }

         | id_list TOKEN_COMMA expression {
                  Expression* e =  $1;
                  Expression* e1 = $3;
                  debug({e,e1});
                  assert(e->get_type() == AST_IDENTIFIER_LIST);
                  assert(e1->get_type() == AST_IDENTIFIER);
                  AstIdentifierList* id_list = static_cast<AstIdentifierList*>(e);
                  id_list = id_list->append_id(static_cast<AstIdentifier*>(e1));
                  $$ = id_list;
         }
   


          
       
      




conditional:   
          expression TOKEN_GT expression   {$$ = AstBinOp::make(GT,$1,$3);   }  |
          expression TOKEN_LT expression   {$$ = AstBinOp::make(LT,$1,$3);   }  |
          expression TOKEN_GEQ expression  {$$ = AstBinOp::make(GEQ,$1,$3);  }  |
          expression TOKEN_LEQ expression  {$$ = AstBinOp::make(LEQ,$1,$3);  }  |
          expression TOKEN_EQ expression   {$$ = AstBinOp::make(EQ,$1,$3);   }  |
          expression TOKEN_NEQ expression  {$$ = AstBinOp::make(NEQ,$1,$3);  }         




expression_application: 
            expression expression {
                        	AstExpressionList *l = AstExpressionList::make($1);
                        	l = l->append_exp($2);
                        	$$ = l; }

            | expression_application expression {
                          debug({$1,$2});
                        	Expression* _l = $1;
                        	assert(_l->get_type() == AST_EXPRESSION_LIST);
                        	AstExpressionList* l = static_cast<AstExpressionList*>(_l);
                        	$$ = l->append_exp($2); }

           

            


         










  
