#lang racket
#|
   Request-reply server in Racket
   Binds REP socket to tcp://*:5560
   Expects "Hello" from client, replies with "World"
|#
(require net/zmq)
;(require (planet jaymccarthy/zeromq))


(define ctxt (context 1))
(define sock (socket ctxt 'REP))
(socket-connect! sock "tcp://localhost:5560")

(let loop ()
  (define message (socket-recv! sock))
  (printf "Received request: ~a\n" message)
  (sleep 1)
  (socket-send! sock #"World")
  (loop))

(context-close! ctxt)
