#lang racket
#|
   Simple Request-reply broker in Racket
|#
(require net/zmq)

(define ctxt (context 1))
(define frontend (socket ctxt 'ROUTER))
(define backend (socket ctxt 'DEALER))

(socket-bind! frontend "tcp://*:5559")
(socket-bind! backend "tcp://*:5560")

(define poller
  (vector (make-poll-item frontend 0 'POLLIN empty)
	  (make-poll-item backend 0 'POLLIN empty)))

(define fevents (poll-item-revents (vector-ref poller 0)))
(define bevents (poll-item-revents (vector-ref poller 1)))

(let loop ()
    (printf "before polling\n")
    (poll! poller -1)
    (printf "after polling\n")
    (when (equal? fevents '(POLLIN))
	(socket-send! backend "hey"))
    (when (equal? bevents '(POLLIN))
	(socket-send! frontend "ho"))
    (loop))
(context-close! ctxt)
