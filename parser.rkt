#lang racket

(require parser-tools/yacc
         "lexer.rkt")

(provide myapl-parse)

(define myapl-parser
  (parser
   (start start)
   (end EOF)
   (tokens verbs nouns delimiters)
   (error (lambda (tok-ok? tok-name tok-value)
            (display (list tok-ok? tok-name tok-value))))
   (grammar
    (start
     [() #f]
     [(expression) $1])
     (self-evaluating [(NUMBER) `(number ,$1)])
     (verb [(VERB) $1])
     (procedure-call [(operand operator) `(procedure-call ,$2 ,$1)])
     (operator [(verb) `(verb ,$1)])
     (operand [(self-evaluating SPACE self-evaluating) (list $3 $1)])
     (expression [(self-evaluating) $1]
                 [(procedure-call) $1]
                 [(verb) $1])
     )))

(define (parse parser lexer input-port)
    (define (run)
      (port-count-lines! input-port)
      (parser (lambda () (lexer input-port))))
    (run))

(define (myapl-parse port)
  `(,(parse myapl-parser myapl-lexer port)))

; Tests
;(myapl-parse "34")
;(myapl-parse (open-input-string "4 4="))
;(myapl-parse (open-input-string "44="))