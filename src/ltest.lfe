(defmodule ltest
  (export all))

(include-lib "include/ltest.lfe")

(defun check-failed-assert (data expected)
  "This function
    1) unwraps the data held in the error result returned by a failed
       assertion, and
    2) checks the buried failure type against an expected value, asserting
       that they are the same."
  (let ((`#(,failure-type ,_) data))
    (is-equal failure-type expected)))

(defun check-wrong-assert-exception (data expected)
  "This function
    1) unwraps the data held in the error result returned by
       assert-exception when an unexpected error occurs, and
    2) checks the buried failure type against an expected value, asserting
       that they are the same."
  (let* ((reason (assert-exception-failed))
         (`#(,reason (,_ ,_ ,_ ,_ #(,fail-type ,_))) data))
    (is-equal fail-type expected)))
