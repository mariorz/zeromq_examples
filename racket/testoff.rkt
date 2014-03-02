#lang racket

;(require zmq)
(require "zmq/main.rkt")

(define *address* "tcp://127.0.0.1:5556")
(define *topic*   "foo")

(define sender (thread (thunk
                        (define socket (make-socket 'pub
                                                    #:connect (list *address*)))
                        (for ((i (in-producer sleep #f 1)))
                          (socket-send socket *topic* "Hello World!")))))


(define receiver (thread (thunk
                          (define socket (make-socket 'sub
                                                      #:subscribe (list *topic*)
                                                      #:bind (list *address*)))

                          (for ((parts (in-producer socket-receive/list #f socket)))
                            (printf "received ~s\n" parts)))))

(sync/timeout 5 sender receiver)
