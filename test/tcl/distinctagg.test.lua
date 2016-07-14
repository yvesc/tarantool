#!/usr/bin/env ./tcltestrunner.lua

# 2005 September 11
#
# The author disclaims copyright to this source code.  In place of
# a legal notice, here is a blessing:
#
#    May you do good and not evil.
#    May you find forgiveness for yourself and forgive others.
#    May you share freely, never taking more than you give.
#
#***********************************************************************
# This file implements regression tests for SQLite library.  The
# focus of this script is the DISTINCT modifier on aggregate functions.
#
# $Id: distinctagg.test,v 1.3 2009/02/09 13:19:28 drh Exp $


set testdir [file dirname $argv0]
source $testdir/tester.tcl

do_test distinctagg-1.1 {
  execsql {
    CREATE TABLE t1(a,b,c primary key);
    INSERT INTO t1 VALUES(1,2,3);
    INSERT INTO t1 VALUES(1,3,4);
    INSERT INTO t1 VALUES(1,3,5);
    SELECT count(distinct a),
           count(distinct b),
           count(distinct c),
           count(all a) FROM t1;
  }
} {1 2 3 3}
do_test distinctagg-1.2 {
  execsql {
    SELECT b, count(distinct c) FROM t1 GROUP BY b ORDER BY b
  }
} {2 1 3 2}
do_test distinctagg-1.3 {
  execsql {
    INSERT INTO t1 SELECT a+1, b+3, c+5 FROM t1;
    INSERT INTO t1 SELECT a+2, b+6, c+10 FROM t1;
    INSERT INTO t1 SELECT a+4, b+12, c+20 FROM t1;
    SELECT count(*), count(distinct a), count(distinct b) FROM t1
  }
} {24 8 16}
do_test distinctagg-1.4 {
  execsql {
    SELECT a, count(distinct c) FROM t1 GROUP BY a ORDER BY a
  }
} {1 3 2 3 3 3 4 3 5 3 6 3 7 3 8 3}

do_test distinctagg-2.1 {
  catchsql {
    SELECT count(distinct) FROM t1;
  }
} {1 {DISTINCT aggregates must have exactly one argument}}
do_test distinctagg-2.2 {
  catchsql {
    SELECT group_concat(distinct a,b) FROM t1;
  }
} {1 {DISTINCT aggregates must have exactly one argument}}

finish_test
