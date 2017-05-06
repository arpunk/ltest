(defmodule ltest-generated-tests)

(include-lib "ltest/include/ltest.lfe")

(deftestgen is* (is* 'true))

(deftestgen is-not*-in-list `[,(is-not* 'false)])

(deftestgen many-generators-in-list
  `[,(is* 'true) ,(is-not* 'false) ,(is-equal* 1 1)])

(deftestgen nested-test-set
  `[,(is* 'true)
    ,(is-not* 'false)
    ,(is-equal* 2 2)
    [,(is* 'true) ,(is-not* 'false) ,(is-equal* 1 1)]])
