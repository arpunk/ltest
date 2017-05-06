# ltest

[![Build Status][travis badge]][travis] [![LFE Versions][lfe badge]][lfe] [![Erlang Versions][erlang badge]][versions] [![Tags][github tags badge]][github tags] [![Downloads][hex downloads]][hex package]

*An EUnit based testing framework for LFE (forked from [lfex/ltest](https://github.com/lfex/ltest))*

**NOTE:** This is a slim version of ltest best suited for my
  needs. [I](https://github.com/arpunk) do not need the extra stuff
  the official ltest offers.


## Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [EUnit Compatibility](#eunit-compatibility-)
* [Features](#features-)
* [Using ltest](#using-ltest-)
  * [Adding ltest to Your Project](#adding-ltest-to-your-project-)
  * [Structuring Your Tests](#structuring-your-tests-)
  * [Naming Rules](#naming-rules-)
  * [Creating Unit Tests](#creating-unit-tests-)
  * [Running Your Tests](#running-your-tests-)
* [Dogfood](#dogfood-)
* [License](#license-)


## Introduction [&#x219F;](#contents)

The original implementation of ltest (as lfeunit) was made due to some
difficulties in parsing the Erlang include file for EUnit, ``eunit.hrl``, by
LFE (it didn't convert all the Erlang macros). Good news: that has since been
fixed!

Of particular interest to those coming from the Clojure community, the macros
in this library are inspired by Clojure's excellent unit test framework.

Please note this is an unofficial fork. The current official
implementation of ltest is located
[here](https://github.com/lfex/ltest).


## EUnit Compatibility [&#x219F;](#contents)

The tests created with ltest are compatible with EUnit ane can be run from
either Erlang or LFE, using the standard EUnit listener or the ltest
listener (test runner).


### Features [&#x219F;](#contents)

* ``(deftest ...)`` for standard unit tests
* ``(deftestgen ...)`` for writing tests with generators, including the
  standard EUnit test fixtures (see naming caveat below)
* ``(deftestskip ...)`` for skipping unit tests
* ``(list ...)``-wrapped tests (of arbitrary depth) for use as test sets
* ``(tuple ...)``-wrapped tests for naming/describing tests (first element
  of tuple)


## Using ``ltest`` [&#x219F;](#contents)


### Adding ltest to Your Project [&#x219F;](#contents)

In order to use ltest in your project, all you need to do is add a rebar dep.
Generally, you only need ``ltest`` when running tests, so it's best to add it as
a dependency in the ``test`` profile. You'll also need to tell EUnit where to
take your tests from (``eunit_compile_otps``). In your ``rebar.config``:

```erlang
{profiles, [
  {test, [
    {deps, [
      {ltest, {git, "git://github.com/arpunk/ltest.git", {branch, "slim"}}}
    ]}
  ]}
]}.
```

Once you write some tests (see below for how to do that), you can then do this:

```bash
$ rebar3 eunit
```


### Structuring Your Tests [&#x219F;](#contents)

ltest doesn not support putting your unit tests directly in your modules. If
you do this, things may break or not work properly, even though Erlang's EUnit
does support it.

Instead, you should create a top-level directory in your project called
``test``. In ``test``, create a test cases module for every module your project
has, e.g., ``test/myproj-base-tests.lfe`` and ``test/myproj-util-tests.lfe``.
Obviously, if it makes sense to break things up in a more fine-grained manner,
feel free to do so :-)


### Naming Rules [&#x219F;](#contents)

Keep in mind that your tests will be compiled to ``.beam`` and then run with
Erlang's eunit module. As such, your tests need to following the same
conventions that eunit establishes:

* Test module filenames should end in ``-tests``, e.g.,
  ``some-module-tests.lfe``.

* Test module and filename need to be the same, minus the extension. For
  example, ``test/unit-my-module-tests.lfe`` needs to be declared as
  ``(defmodule unit-my-module-tests ...) in the test case module``.

* If you chose *not* to use the ``deftest`` macro to build each unit test
  function, you will need to name your unit test functions with ``_test``
  appended to them. For example,
  ``(defun unit-my-function-negagive-check_test () ...)``. We recommend,
  however, that you use ``deftest`` instead, and obviate the need for ``_test
  ()`` boilerplate.


### Creating Unit Tests [&#x219F;](#contents)

ltest is entirely macro-based. ltest uses LFE to parse the Erlang macros in
the EUnit header file. It also provides its own header file which defines macros
whose main purpose is to wrap the EUnit macros in a more Lispy form.

ltest also provides a syntactic sugar macro for defining tests: ``deftest``.
Instead of writing something like this for your unit tests:

```cl

    (defun unit-my-function-test ()
      ...)
```

You can use ``deftest`` to write this:

```cl

    (deftest unit-my-function
      ...)
```

Note that the ``-test`` is no longer needed, nor is the empty argument list.

If you would like to use EUnit's fixtures feature, you must use another macro:

```cl
    (deftestgen unit-my-function
      ...)
```

See the unit tests in the ``test`` directory for example usage.


If you would like tests to be skipped, you can use this macro:

```cl
    (deftestskip unit-my-function
      ...)
```

This will simply make the test invisible to EUnit. EUnit doesn't actually
track user-skipped tests; it only tracks tests that are skipped do to issues
as perceived by EUnit.

Here is a more complete example:

```cl
    (defmodule unit-mymodule-tests
      (export all)
      (import
        (from ltest
          (check-failed-assert 2)
          (check-wrong-assert-exception 2))))

    (include-lib "ltest/include/ltest.lfe")

    (deftest is
      (is 'true)
      (is (not 'false))
      (is (not (not 'true))))

    (deftest is-not
      (is-not `'false))

    (deftest is-equal
      (is-equal 2 (+ 1 1)))
```

ltest is working towards full test coverage; while not there yet, the unit
tests for ltest itself provide the best examples of usage.


### Running Your Tests [&#x219F;](#contents)

The recommended way to run unit tests is to use ``rebar3``. Running
unit tests is now as easy as doing the following:

```bash
$ rebar3 eunit
```


## Dogfood [&#x219F;](#contents)

``ltest`` writes its unit tests in ``ltest`` :-) You can run them from the
project directory:

```bash
$ rebar3 eunit
```


## License [&#x219F;](#contents)

BSD 3-Clause License

Copyright © 2013-2016, Duncan McGreggor <oubiwann@gmail.com>

Copyright © 2014, Døkkarr Hirðisson <dokkarr@lfe.io>

Copyright © 2014, Joshua Schairbaum <joshua.schairbaum@gmail.com>

Copyright © 2016, Eric Bailey <eric@ericb.me>

Copyright © 2016, jsc <jonas.skovsgaard.christensen@gmail.com>

Copyright © 2016, skovsgaard <jonas.skovsgaard.christensen@gmail.com>

Copyright © 2017, Ricardo Lanziano <arpunk@fatelectron.net>

<!-- Named page links below: /-->

[org]: https://github.com/lfe-rebar3
[github]: https://github.com/lfex/ltest
[travis]: https://travis-ci.org/lfex/ltest
[travis badge]: https://img.shields.io/travis/lfex/ltest.svg
[lfe]: https://github.com/rvirding/lfe
[lfe badge]: https://img.shields.io/badge/lfe-1.2.0-blue.svg
[erlang badge]: https://img.shields.io/badge/erlang-R15%20to%2019.1-blue.svg
[versions]: https://github.com/lfex/ltest/blob/master/.travis.yml
[github tags]: https://github.com/lfex/ltest/tags
[github tags badge]: https://img.shields.io/github/tag/lfex/ltest.svg
[github downloads]: https://img.shields.io/github/downloads/atom/atom/total.svg
