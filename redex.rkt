#lang racket

(require redex)

(define-language core
  (e ::=
     e...+       ;an expression is a sequence of expressions
     x           ;variables
     (λ (x) e)   ;abstraction
     )
  (x variable-not-otherwise-mentioned))

(test-equal
 (redex-match? core
              e
              (term (λ (x) x)))
 #t)



(test-results)