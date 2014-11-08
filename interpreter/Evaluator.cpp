
#include "Evaluator.h"

#include "ast/expression.h"



bool DEBUG = false;
void printer(Expression* e) {
		cout << "******  DEBUG   ******* \n " << e->to_value() << endl;
	cout << endl;
}

/*
 * This skeleton currently only contains code to handle integer constants, print and read. 
 * It is your job to handle all of the rest of the L language.
 */



/*
 * Call this function to report any run-time errors
 * This will abort execution.
 */
void report_error(Expression* e, const string & s)
{	

	cout << "Run-time error in expression " << e->to_value() << endl;
	cout << s << endl;
	exit(1);

}



Evaluator::Evaluator()
{
	sym_tab.push();
	c = 0;

}


Expression* Evaluator::eval_binop(AstBinOp* b) {
	binop_type bt = b->get_binop_type();
	Expression* e1 = eval(b->get_first());
	Expression* e2 = eval(b->get_second());
	if (bt == CONS) {
		return AstList::make(e1,e2);
	} else {

		if (e1->get_type() == AST_LIST || e2->get_type() == AST_LIST) {
			report_error(b,"Binpo @ is the only legal binop for lists");
		}

		if (e1->get_type() == AST_INT && e2->get_type() == AST_INT) {
					AstInt* n1 = static_cast<AstInt*>(e1);
					AstInt* n2 = static_cast<AstInt*>(e2);
					Expression* res = NULL;
							switch (bt) {
								case PLUS: res =  AstInt::make((n1->get_int()) + (n2->get_int())); break;
								case MINUS: res =  AstInt::make((n1->get_int()) - (n2->get_int())); break;
								case TIMES: res =  AstInt::make((n1->get_int()) * (n2->get_int())); break;
								case DIVIDE: res =  AstInt::make((n1->get_int()) / (n2->get_int())); break;
								case AND: res =  AstInt::make((n1->get_int()) & (n2->get_int())); break;
								case OR: res =  AstInt::make((n1->get_int()) | (n2->get_int())); break;
								case EQ  : res =  AstInt::make(((n1->get_int()) == (n2->get_int()) ? 1 : 0)); break;
								case NEQ : res =  AstInt::make(((n1->get_int()) != (n2->get_int()) ? 1 : 0)); break;
								case LT : res =  AstInt::make(((n1->get_int()) < (n2->get_int()) ? 1 : 0)); break;
								case LEQ : res =  AstInt::make(((n1->get_int()) <= (n2->get_int()) ? 1 : 0)); break;
								case GT : res =  AstInt::make(((n1->get_int()) > (n2->get_int()) ? 1 : 0)); break;
								case GEQ : res =  AstInt::make(((n1->get_int()) >= (n2->get_int()) ? 1 : 0)); break;
								default: report_error(b,"This shouldn't really happen...");
							}
					return res;
				}

		if (e1->get_type() == AST_STRING && e2->get_type() == AST_STRING) {
					AstString* n1 = static_cast<AstString*>(e1);
					AstString* n2 = static_cast<AstString*>(e2);
					Expression* res = NULL;
					switch (bt) {
						case PLUS: res =  AstString::make((n1->get_string()) + (n2->get_string())); break;
						case EQ  : res =  AstInt::make(((n1->get_string()) == (n2->get_string()) ? 1 : 0)); break;
						case NEQ : res =  AstInt::make(((n1->get_string()) != (n2->get_string()) ? 1 : 0)); break;
						default: report_error(b,"Binop " + AstBinOp::binop_type_to_string(bt) + " cannot be applied to strings");
					}

					return res;
	 		
			}

		report_error(b,"Binop can only be applied to expressions of same type");
	} 

}

/*Expression* Evaluator::eval_expression_list(AstExpressionList* l) {
	vector<Expression*> exps = l->get_expression();
	// (e1 e2)
	// must evaluate e1 to a lambda expression
	sym_tab.push();
	Expression* e1 = eval(exps.at(0));
	assert(e1->get_type() == AST_LAMBDA);
	
	Expression* e2 = exps.at(1);
	

	sym_tab.pop();


	return
}*/

Expression* Evaluator::eval_unop(AstUnOp* b)
{

	Expression* e = b->get_expression();
	Expression* eval_e = eval(e);

	if(b->get_unop_type() == PRINT) {
		if(eval_e->get_type() == AST_STRING) {
			AstString* s = static_cast<AstString*>(eval_e);
			cout << s->get_string() << endl;
		}
		else cout << eval_e->to_value() << endl;
		return AstInt::make(0);
	} 
	else if (b->get_unop_type() == ISNIL) {
		return AstInt::make((eval_e->get_type() == AST_NIL ? 1 : 0));
	} 
	else if (b->get_unop_type() == HD) {
		  return (eval_e->get_type() == AST_LIST ? static_cast<AstList*>(eval_e)->get_hd() : eval_e);
	}
	else if (b->get_unop_type() == TL) {
		  if (eval_e->get_type() == AST_LIST) 
		  	return static_cast<AstList*>(eval_e)->get_tl();
		  else 
		  	return AstNil::make();
	} else {
		assert(false);
	}
}






Expression* Evaluator::eval(Expression* e)
{


	Expression* res_exp = NULL;
	switch(e->get_type())
	{
	
	case AST_UNOP:
	{
		AstUnOp* b = static_cast<AstUnOp*>(e);
		res_exp = eval_unop(b);
		break;
	}
	case AST_BINOP:
	{
		AstBinOp* b = static_cast<AstBinOp*>(e);
		res_exp = eval_binop(b);
		break;
	}
/*	case AST_EXPRESSION_LIST:
	{
		AstExpressionList* elist = static_cast<AstExpressionList*>(e);
		res_exp = eval_expression_list(elist);
		break;
	}*/
	case AST_READ:
	{
		AstRead* r = static_cast<AstRead*>(e);
		string input;
		getline(cin, input);
		if(r->read_integer()) {
			return AstInt::make(string_to_int(input));
		}
		return AstString::make(input);


		break;
	}
	case AST_IDENTIFIER:
	{	
		AstIdentifier* id = static_cast<AstIdentifier*>(e);
		Expression* var = sym_tab.find(id);
		if(DEBUG){
				printer(id);
				printer(var);
				sym_tab.print_contents();}
		if (var != NULL)
			return var; //eval(var);
		else
			report_error(id,"Identifier " + id->to_value() + " is not bound in current context");
	}
	case AST_INT:
	{
		res_exp = e;
		break;
	}
	case AST_STRING:
	{
		return static_cast<AstString*>(e);
	}
	case AST_NIL:
	{	
		return static_cast<AstNil*>(e);
	}
	case AST_BRANCH:
	{
		AstBranch* branch = static_cast<AstBranch*>(e);
		Expression* pred = eval(branch->get_pred());
		res_exp = eval((static_cast<AstInt*>(pred)->get_int() > 0 ? branch->get_then_exp() : branch->get_else_exp()));
		break;
	}
	case AST_LET: 
	{
		AstLet* let = static_cast<AstLet*>(e);
		sym_tab.push();
		Expression* v2 = eval(let->get_val());
		//v2 = (let->get_val())->substitute(let->get_val(),v2);
		sym_tab.pop();
		sym_tab.add(static_cast<AstIdentifier*>(let->get_id()),v2);
		Expression* b2 = eval(let->get_body());
		
	
		return b2;
	
	
	}
	/*case AST_LAMBDA:
	{
		AstLambda* lam = static_cast<AstLambda*>(e);

		sym_tab.add(lam->get_formal(),eval(lam->get_body()));
		return lam;


	}*/
	default:
		assert(false);


	}
	return res_exp;
}
