// Compile with -lm -lqlibc -lpthread
// Calculator for normal arithmetic with
//  +, -, *, /, %, ^ (exponent), v (square root)
//  Parenthesis allowed

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <errno.h>
#include <math.h>

#include <qlibc/qlibc.h>

// Operator precedences
#define PINV -100
#define PADD 1
#define PMUL 2
#define PEXP 3
#define PUNARY 4

// A lexer token
struct token {
  char val;
  float fval;
  bool number;
};

// A node in the parse tree
// A stack uses the size of struct node vs the size of a float
// to differentiate between the two. The padding floats are to
// make sure the sizes are never equal on any system.
struct node {
  struct token * t;
  struct node * left;
  struct node * right;
  float paddinga, paddingb;
};

// Function prototypes
float compute(struct node * n);
void free_node(struct node * n);
bool is_special(char c);
bool is_whitespace(char c);
float lex_number();
struct token * lexer();
void node_free(struct node * n);
void make_op(qstack_t * op, qstack_t * vals);
float make_num(char * numbuf);
struct node * parse();
struct node * parse_sub(qstack_t * op, qstack_t * vals, int depth);
int precedence(char op);

int
main(int argc, char ** argv)
{
  struct node * expr = parse();
  float res = compute(expr);
  printf("%f\n", res);
  node_free(expr);
  return EXIT_SUCCESS;
}

// Compute the numeric value of a parse tree
float
compute(struct node * n)
{
  if (!n || !n->t) {
    return 0;
  }

  if (n->t->number) {
    return n->t->fval;
  }

  // Recursively compute left-hand side of node and right-hand side of node
  // If either are NULL (like in unary), the float val will be 0
  float lhs = compute(n->left);
  float rhs = compute(n->right);

  // Take the operands of the operator and compute
  switch (n->t->val) {
    case '+':
      return lhs + rhs;
    case '-':
      return lhs - rhs;
    case '*':
      return lhs * rhs;
    case '/':
      return lhs / rhs;
    case '%':
      return fmodf(lhs, rhs);
    case '^':
      return powf(lhs, rhs);
    case 'N':
      return -lhs;
    case 'v':
      return sqrtf(lhs);
    default:
      fprintf(stderr, "%c is an invalid operator!\n", n->t->val);
      exit(EXIT_FAILURE);
  }

  return 0;
}

// Allowed special characters
bool
is_special(char c)
{
  return c == '+' || c == '-' || c == '*' || c == '/' || c == '%' || c == '^' ||
    c == 'v' || c == '(' || c == ')';
}

// Allowed whitespace (no effect on parsing since numbers need to be split by operators anyway)
bool
is_whitespace(char c)
{
  return c == ' ' || c == '\t' || c == '\v' || c == '\n' || c == '\r';
}

// Take a number from stdin
float
lex_number()
{
  char * numbuf = NULL;
  size_t numlen = 0;
  FILE * stream = open_memstream(&numbuf, &numlen); // Dynamic buffer, easy
  if (!stream) {
    perror("open_memstream: ");
    exit(EXIT_FAILURE);
  }

  char nch = getchar();
  bool radixUsed = false; // Track the decimal point
  bool expUsed = false; // Track the exponent
  bool hasDigit = false;

  if (!isdigit(nch) && nch != '.') {
    fprintf(stderr, "Expected digit or '.'\n");
    exit(EXIT_FAILURE);
  }

  if (nch == '.') {
    putc('0', stream); // .[digit]+ -> 0.[digit]+
    radixUsed = true;
  } else {
    hasDigit = true;
  }
  putc(nch, stream); // Put in buffer char *

  nch = getchar();
  while (isdigit(nch) || nch == '.' || nch == 'e' || nch == 'E') {
    // Found radix in number
    if (nch == '.') {
      if (radixUsed) {
        fprintf(stderr, "Can only have one '.' per number\n");
        exit(EXIT_FAILURE);
      }
      if (expUsed) {
        fprintf(stderr, "Can not have a '.' in the exponent of a number\n");
        exit(EXIT_FAILURE);
      }
      radixUsed = true;
    } else if (nch == 'e' || nch == 'E') {
      // Found exponent
      if (expUsed) {
        fprintf(stderr, "Only one exponent per number\n");
        exit(EXIT_FAILURE);
      }

      if (!hasDigit) {
        fprintf(stderr, "Number must have at least 1 digit\n");
        exit(EXIT_FAILURE);
      }

      expUsed = true;
      putc('e', stream);
      // If next char is + or -, push it then move on
      // else go to next iteration (continue outside of else so another char isn't read)
      nch = getchar();
      if (nch == '+' || nch == '-') {
        putc(nch, stream);
        nch = getchar();
      }
      continue;
    } else {
      hasDigit = true;
    }

    putc(nch, stream);
    nch = getchar();
  }

  ungetc(nch, stdin); // Read in an extra character
  fclose(stream); // Store the buffer in the char *

  float val = make_num(numbuf);
  free(numbuf);
  return val;
}

// Create a token from stdin
struct token *
lexer()
{
  struct token * tok = malloc(sizeof(struct token));

  if (!tok) {
    perror("malloc: ");
    exit(EXIT_FAILURE);
  }
  tok->val = '\0';
  tok->fval = 0;
  tok->number = false;

  char nch = getchar();
  while (is_whitespace(nch)) { // Skip whitespace before token
    nch = getchar();
  }

  if (nch == EOF) {  // EOF is not an error per say, the parser decides
    free(tok);
    return NULL;
  }

  if (is_special(nch)) { // token is an operator or ()
    tok->val = nch;
#ifdef DEBUG
    printf("Got token %c\n", nch);
#endif
    return tok;
  }

  if (isdigit(nch) || nch == '.') { // Operator is a number
    ungetc(nch, stdin);
    tok->number = true;
    tok->fval = lex_number();
#ifdef DEBUG
    printf("Got token %f\n", tok->fval);
#endif
    return tok;
  }

  // Unexpected char
  fprintf(stderr, "Expected operator or number. Failing.\n");
  exit(EXIT_FAILURE);
}

// Recursively free a node
void
node_free(struct node * n)
{
  if (!n) {
    return;
  }

  free(n->t);
  node_free(n->left);
  node_free(n->right);
  free(n);
}

// Given an operator stack and operator stack,
// Make a node to represent the top operator.
// Pop the necessary operands
// Push the resulting node as an operand.
void
make_op(qstack_t * op, qstack_t * vals)
{
  if (!op || !vals) {
    fprintf(stderr, "make_op null stack operands\n");
    exit(EXIT_FAILURE);
  }

  errno = 0;
  char cop = (char)qstack_popint(op);
  if (errno) {
    fprintf(stderr, "Stack pop failure\n");
    exit(EXIT_FAILURE);
  }

  int prec = precedence(cop);
  if (prec == PINV) {
    fprintf(stderr, "%c is an invalid operator\n", cop);
    exit(EXIT_FAILURE);
  }

#ifdef DEBUG
  printf("Making %c node.\n", cop);
#endif

  // Node to create
  struct node top;
  top.t = malloc(sizeof(*top.t));
  if (!top.t) {
    perror("malloc: ");
    exit(EXIT_FAILURE);
  }

  top.t->number = false;
  top.t->fval = 0;
  top.t->val = cop;
  top.left = NULL;
  top.right = NULL;

  if (prec == PUNARY) { // Unary - Only pop one operand
    size_t popped = 0;
    void * stk = qstack_pop(vals, &popped);
    if (!stk) {
      fprintf(stderr, "%c requires an operand.", op);
      exit(EXIT_FAILURE);
    }
    if (popped == sizeof(*top.left)) { // Popped operand is a node
      top.left = stk; // Note that the pop value is already malloc'd, no need to memcpy into a new one
#ifdef DEBUG
      printf("Unary child is another node. It is:");
      if (top.left->t->number) {
        printf("A number node: %f\n", top.left->t->fval);
      } else {
        printf("An operator node: %c\n", top.left->t->val);
      }
#endif
    } else { // Popped operand is a float - make a number node and put it as unary's left child
      top.left = malloc(sizeof(struct node));
      if (!top.left) {
        perror("malloc: ");
        exit(EXIT_FAILURE);
      }

      top.left->t = malloc(sizeof(*top.left->t));
      if (!top.left->t) {
        perror("malloc: ");
        exit(EXIT_FAILURE);
      }

      top.left->t->number = true;
      top.left->t->fval = *((float *)stk);
      top.left->t->val = '\0';
      free(stk);
#ifdef DEBUG
      printf("Unary child is a number: %f\n", top.left->t->fval);
#endif
    }
  } else { // binary operator
    size_t popped = 0;
    void * rhs = qstack_pop(vals, &popped);
    if (!rhs) {
      fprintf(stderr, "%c requires an operand.", op);
      exit(EXIT_FAILURE);
    }

    if (popped == sizeof(*top.right)) { // The right hand side operand is a node
      top.right = rhs;
#ifdef DEBUG
      printf("RHS is a node: ");
      if (top.right->t->number) {
        printf("It is a number node: %f\n", top.right->t->fval);
      } else {
        printf("It is an operator node: %c\n", top.right->t->val);
      }
#endif
    } else {
      top.right = malloc(sizeof(struct node)); // The right hand side is a float, make a node
      if (!top.right) {
        perror("malloc: ");
        exit(EXIT_FAILURE);
      }

      top.right->t = malloc(sizeof(*top.right->t));
      if (!top.right->t) {
        perror("malloc: ");
        exit(EXIT_FAILURE);
      }

      top.right->t->number = true;
      top.right->t->fval = *((float *)rhs);
      top.right->t->val = '\0';
      free(rhs);
#ifdef DEBUG
      printf("RHS is a number: %f\n", top.right->t->fval);
#endif
    }

    void * lhs = qstack_pop(vals, &popped);
    if (!lhs) {
      fprintf(stderr, "%c requires a left operand.", op);
      exit(EXIT_FAILURE);
    }

    if (popped == sizeof(*top.left)) {
      top.left = lhs; // Left hand side is a node
#ifdef DEBUG
      printf("LHS is a node: ");
      if (top.right->t->number) {
        printf("It is a number node: %f\n", top.left->t->fval);
      } else {
        printf("It is an operator node: %c\n", top.left->t->val);
      }
#endif
    } else {
      top.left = malloc(sizeof(struct node)); // Left hand side is a float
      if (!top.left) {
        perror("malloc: ");
        exit(EXIT_FAILURE);
      }

      top.left->t = malloc(sizeof(*top.left->t));
      if (!top.left->t) {
        perror("malloc: ");
        exit(EXIT_FAILURE);
      }

      top.left->t->number = true;
      top.left->t->fval = *((float *)lhs);
      top.left->t->val = '\0';
      free(lhs);
#ifdef DEBUG
      printf("LHS is a number: %f\n", top.left->t->fval);
#endif
    }
  }

  // Push the new node as an operand
  if (!qstack_push(vals, &top, sizeof(top))) {
    fprintf(stderr, "Failed to push to stack\n");
    exit(EXIT_FAILURE);
  }

}

float
make_num(char * numbuf)
{
  int ipart = 0;
  int fpart = 0;
  int flen = 0;
  int expSign = 1;
  int exponent = 0;

  char * ipartptr = numbuf;
  while (*ipartptr != '\0' && *ipartptr != '.' && *ipartptr != 'e') {
    ipartptr++;
  }

  if (*ipartptr == '\0') { // No radix or exponent
    if (ipartptr == numbuf) {
      return 0;
    }
    ipart = atoi(numbuf);
    return (float)ipart;
  }

  char save = *ipartptr;

  if (ipartptr == numbuf) {
    ipart = 0;
  } else {
    *ipartptr = '\0'; // Get the integer part up to .
    ipart = atoi(numbuf);
    *ipartptr = save;
  }

  if (save == '.') { // Parse radix
    char * fpartptr = ipartptr + 1;
    while (*fpartptr != '\0' && *fpartptr != 'e') {
      ++fpartptr;
      ++flen;
    }

    if (*fpartptr == '\0') { // No exponent part
      fpart = atoi(ipartptr + 1);
    } else {
      *fpartptr = '\0';
      fpart = atoi(ipartptr + 1);
      *fpartptr = 'e';
    }

    ipartptr = fpartptr;
  } else {
    flen = 1;
  }


  if (*ipartptr == 'e') { // Found exponent
    char * exppartptr = ipartptr + 1;
    if (*exppartptr == '\0') {
      fprintf(stderr, "Need actual digits in exponent\n");
      exit(EXIT_FAILURE);
    }

    exponent = atoi(exppartptr);
    if (exponent < 0) {
      expSign = -1;
      exponent = -exponent;
    }
  }

  float val = (float)ipart;

  int div10 = 1;
  for (int i=0; i < flen; ++i) {
    div10 *= 10;
  }

  val += (float)fpart / div10;

  div10 = 1;
  for (int i=0; i < exponent; ++i) {
    div10 *= 10;
  }

  if (expSign > 0) {
    val *= div10;
  } else {
    val /= div10;
  }
}

// Start parsing
struct node *
parse()
{
  // Make the stacks
  qstack_t * ops = qstack(0);
  if (!ops) {
    perror("qstack: ");
    exit(EXIT_FAILURE);
  }

  qstack_t * vs = qstack(0);
  if (!vs) {
    perror("qstack: ");
    exit(EXIT_FAILURE);
  }

  // Start parsing a subexpression of depth 0
  return parse_sub(ops, vs, 0);
}

// Parse a subexpression (the top-level or a parethesized expression)
struct node *
parse_sub(qstack_t * op, qstack_t * vals, int depth)
{
  if (!op || !vals) {
    fprintf(stderr, "parse_sub null stack operands\n");
    exit(EXIT_FAILURE);
  }

  if (depth < 0) {
    fprintf(stderr, "parse_sub negative depth\n");
    exit(EXIT_FAILURE);
  }

  size_t opstart = qstack_size(op);
  size_t valsstart = qstack_size(vals);

#ifdef DEBUG
  printf("Starting level %d\n", depth);
#endif

  bool opLast = true;

  struct token * t = lexer();
  while (t) {
    if (!t->number && t->val == '(') { // Make new subexpression
      parse_sub(op, vals, depth + 1);
      goto contwhile;
    }

    if (!t->number && t->val == ')') { // End this subexpression (if possible)
      if (!depth) {
        fprintf(stderr, "Unmatched ')'");
        exit(EXIT_FAILURE);
      }

      break;
    }

    if (t->number) { // Add a number to the operand stack
      if (!opLast) {
        fprintf(stderr, "Can not have two consecutive numbers\n");
        exit(EXIT_FAILURE);
      }

      opLast = false;
      if (!qstack_push(vals, &t->fval, sizeof(float))) {
        fprintf(stderr, "Push error\n");
        exit(EXIT_FAILURE);
      }

#ifdef DEBUG
      printf("Pushed %f to operand stack.\n", t->fval);
#endif

      goto contwhile;
    }

    if (opLast && t->val == '+') { // Unary + (+ after another operator is unary)
#ifdef DEBUG
      printf("Skipping unary +\n");
#endif
      goto contwhile;
    }

    if (opLast && t->val == '-') { // Unary - (- after another operator is unary)
      if (!qstack_pushint(op, 'N')) {
        fprintf(stderr, "Push error\n");
        exit(EXIT_FAILURE);
      }
#ifdef DEBUG
      printf("Pushing unary -\n");
#endif
      goto contwhile;
    }

    // If we got here then we are an operator

    int prec = precedence(t->val);
    if (prec == PINV) {
      fprintf(stderr, "%c is an invalid operator\n", t->val);
      exit(EXIT_FAILURE);
    }

    if (prec == PUNARY && !opLast) { // Unary expressions must be preceeded by an operator; they do not seperate operands
      fprintf(stderr, "Unary operation %c requires another operation before\n", t->val);
      exit(EXIT_FAILURE);
    }

    opLast = true;

    if (qstack_size(op) == opstart) { // If this subexpression's stack is empty, push the operator
      if (!qstack_pushint(op, t->val)) {
        fprintf(stderr, "Push error\n");
        exit(EXIT_FAILURE);
      }
#ifdef DEBUG
      printf("Pushing %c to operator stack.\n", t->val);
#endif
    } else {
      errno = 0;
      // If the current operator has less precedence than the top of the stack,
      // then the top of the stack should be placed into the parse tree before this operator.
      // The = in >= makes the expression left-to-right associative

      char topop = (char)qstack_popint(op);
      if (errno) {
        fprintf(stderr, "Error popping\n");
        exit(EXIT_FAILURE);
      }

#ifdef DEBUG
      printf("Precedence: %d, top precedence: %d\n", prec, precedence(topop));
#endif

      while (precedence(topop) >= prec && qstack_size(op) + 1 > opstart) {
        if (!qstack_pushint(op, topop)) {
          fprintf(stderr, "Push error\n");
          exit(EXIT_FAILURE);
        }
        make_op(op, vals);

        if (qstack_size(op) == opstart) { // Stop when we reach the end of stack
          topop = '\0';
          break;
        }

        errno = 0;
        topop = (char)qstack_popint(op);
        if (errno) {
          fprintf(stderr, "Error popping\n");
          exit(EXIT_FAILURE);
        }
      }

      if (topop != '\0') { // Check for early break
          if (!qstack_pushint(op, topop)) {
            fprintf(stderr, "Push error\n");
            exit(EXIT_FAILURE);
          }
      }

      // Push our operator
      if (!qstack_pushint(op, t->val)) {
        fprintf(stderr, "Push error\n");
        exit(EXIT_FAILURE);
      }
    }

    // Common 2 lines to load in next token from lexer
    // it is two statements thus this is a while loop not a for(t = lexer(); cond; free, t = lexer()) loop
    contwhile:
    free(t);
    t = lexer(t);
  }

  // We reached end of input but still haven't closed this level's (
  if (!t && depth) {
    fprintf(stderr, "Unmatched '('\n");
    exit(EXIT_FAILURE);
  }

  // Every subexpression should add an operand to the stack overall
  // That operand is the parse tree of the subexpression
  // If it does not, the subexpression was empty
  if (qstack_size(vals) == valsstart) {
    fprintf(stderr, "Can not have empty parenthesis!\n");
    exit(EXIT_FAILURE);
  }

  // Go ahead and make the rest of the parse tree
  // The operator precedence above made sure this is in the right order
  while (qstack_size(op) > opstart) {
    make_op(op, vals);
  }

  // Somehow ended up with a wrong number of operands
  if (qstack_size(vals) != valsstart + 1) {
    fprintf(stderr, "Invalid expression\n");
    exit(EXIT_FAILURE);
  }

  free(t);
  if (depth) {
    return NULL;
  }

  // Return the full tree to parse() if this is level 0
  size_t s = 0;
  void * stk= qstack_pop(vals, &s);
  if (!stk) {
    fprintf(stderr, "Error popping stack\n");
    exit(EXIT_FAILURE);
  }

  if (s == sizeof(struct node)) {
    // TOS is node, already malloc'd
    return stk;
  }

  // TOS is just a number, the entire input was one number.
  struct node * n = malloc(sizeof(struct node));
  if (!n) {
    perror("malloc: ");
    exit(EXIT_FAILURE);
  }
  n->t = malloc(sizeof(*n->t));
  if (!n->t) {
    perror("malloc: ");
    exit(EXIT_FAILURE);
  }

  qstack_free(op);
  qstack_free(vals);

  n->left = NULL;
  n->right = NULL;
  n->t->number = true;
  n->t->val = '\0';
  n->t->fval = *((float *)stk);
  free(stk);
  return n;
}

int
precedence(char op)
{
  if (op == '+' || op == '-') {
    return PADD;
  }

  if (op == '*' || op == '/' || op == '%') {
    return PMUL;
  }

  if (op == '^') {
    return PEXP;
  }

  if (op == 'v' || op == 'N') {
    return PUNARY;
  }

  return PINV;
}

