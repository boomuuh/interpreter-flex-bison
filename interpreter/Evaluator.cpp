
#include "Evaluator.h"

#include "ast/expression.h"





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
	
	if (b->get_binop_type() == CONS) {
		Expression* head = eval(b->get_first());
		Expression* tail = eval(b->get_second());
		return AstList::make(head,tail);
	}

	assert(false);
}
// Expression* eval_expression_list(AstExpressionList* l);

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
	default:
		assert(false);


	}
	return res_exp;
}
