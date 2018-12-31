#lang racket

(require parser-tools/yacc
         "lexer.rkt")

(provide myapl-parse)

(define myapl-parser
  (parser
   (start start)
   (end EOF)
   (tokens value-tokens delimiter-tokens)
   (error (lambda (tok-ok? tok-name tok-value)
            (display (list tok-ok? tok-name tok-value))))
   (grammar
    (start
     [() #f]
     [(expression) $1])

     (datum [(simple-datum) $1])
    (simple-datum [(NUMBER) $1])
    (expression [(literal) $1]
                [(identifier) $1]
                [(procedure-call) $1])
    (literal [(array) $1])
    (identifier [(IDENTIFIER) `(identifier ,$1)])
    (array [(self-evaluating) `(array ,(list $1))]
           [(self-evaluating array-rest) `(array ,(cons $1 (cadr $2)))])
    (array-rest [(SPACE self-evaluating SPACE) `(array ,(list $2))]
                [(SPACE self-evaluating) `(array ,(list $2))]
                [(array) $1])
    (self-evaluating [(NUMBER) `(scalar ,$1)])
    (procedure-call [(operand operator) `(procedure-call ,$2 ,$1)])
    (operator [(identifier) $1])
    (operand [(expression) $1])
     )))

(define (parse parser lexer input-port)
    (define (run)
      (port-count-lines! input-port)
      (parser (lambda () (lexer input-port))))
    (run))

(define (myapl-parse port)
  (parse myapl-parser myapl-lexer port))

; Tests
;(myapl-parse (open-input-string "34"))
;(myapl-parse (open-input-string "3 4"))
;(myapl-parse (open-input-string "4="))
;(myapl-parse (open-input-string "3 4="))
;(myapl-parse (open-input-string "3 4 ="))