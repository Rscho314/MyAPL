#lang racket

(provide #%top
         #%app
         #%datum
         (rename-out [myapl-module-begin #%module-begin])
         interpret
         myapl-environment)

(define-syntax-rule (myapl-module-begin expression)
  (#%module-begin
   (interpret 'expression myapl-environment)))

(define (interpret expression environment)
  (let* ([type (car expression)]
         [value (cdr expression)])
    (match type
      ['array
       (let ([array-values (car value)])
         (list->vector (map (λ (v) (interpret v environment)) array-values)))]
      ['scalar
       (string->number (car value))]
      ['identifier
       (hash-ref environment (car value))]
      ['procedure-call
       (let* ([operator
              (interpret (car value) environment)]
              [operands
               (interpret (cadr value) environment)])
         (vector-map operator operands))]
[else (error "AST node could not be evaluated: " value)])))

(define myapl-environment
  (hash
   "=" =))

#;(map (λ (expr) (interpret expr myapl-environment))
     (list
      '(array ((scalar "34")))
      '(array ((scalar "3") (scalar "4")))
      '(procedure-call (identifier "=") (array ((scalar "4"))))
      '(procedure-call (identifier "=") (array ((scalar "3") (scalar "4"))))
      '(procedure-call (identifier "=") (array ((scalar "3") (scalar "4"))))))