#!/usr/bin/env ./tcltestrunner.lua

# 2005 july 8
#
# The author disclaims copyright to this source code.  In place of
# a legal notice, here is a blessing:
#
#    May you do good and not evil.
#    May you find forgiveness for yourself and forgive others.
#    May you share freely, never taking more than you give.
#
#***********************************************************************
# This file test the busy handler
#
# $Id: busy.test,v 1.3 2008/03/15 02:09:22 drh Exp $


set testdir [file dirname $argv0]
source $testdir/tester.tcl

do_test busy-1.1 {
  sqlite3 db2 test.db
  execsql {
    CREATE TABLE t1(x primary key);
    INSERT INTO t1 VALUES(1);
    SELECT * FROM t1
  }
} 1
proc busy x {
  lappend ::busyargs $x
  if {$x>2} {return 1}
  return 0
}
set busyargs {}
do_test busy-1.2 {
  db busy busy
  db2 eval {BEGIN EXCLUSIVE}
  catchsql {BEGIN IMMEDIATE}
} {1 {database is locked}}
do_test busy-1.3 {
  set busyargs
} {0 1 2 3}
do_test busy-1.4 {
  set busyargs {}
  catchsql {BEGIN IMMEDIATE}
  set busyargs
} {0 1 2 3}

do_test busy-2.1 {
  db2 eval {COMMIT}
  db eval {BEGIN; INSERT INTO t1 VALUES(5)}
  db2 eval {BEGIN; SELECT * FROM t1}
  set busyargs {}
  catchsql COMMIT
} {1 {database is locked}}
do_test busy-2.2 {
  set busyargs
} {0 1 2 3}


db2 close

finish_test
