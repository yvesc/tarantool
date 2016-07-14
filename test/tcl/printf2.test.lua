#!/usr/bin/env ./tcltestrunner.lua

# 2013-12-17
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
# focus of this file is testing the printf() SQL function.
#
#
# EVIDENCE-OF: R-63057-40065 The printf(FORMAT,...) SQL function works
# like the sqlite3_mprintf() C-language function and the printf()
# function from the standard C library.
#

set testdir [file dirname $argv0]
source $testdir/tester.tcl

# EVIDENCE-OF: R-40086-60101 If the FORMAT argument is missing or NULL
# then the result is NULL.
#
do_execsql_test printf2-1.1 {
  SELECT quote(printf()), quote(printf(NULL,1,2,3));
} {NULL NULL}


do_execsql_test printf2-1.2 {
  SELECT printf('hello');
} {hello}
do_execsql_test printf2-1.3 {
  SELECT printf('%d,%d,%d',55,-11,3421);
} {55,-11,3421}
do_execsql_test printf2-1.4 {
  SELECT printf('%d,%d,%d',55,'-11',3421);
} {55,-11,3421}
do_execsql_test printf2-1.5 {
  SELECT printf('%d,%d,%d,%d',55,'-11',3421);
} {55,-11,3421,0}
do_execsql_test printf2-1.6 {
  SELECT printf('%.2f',3.141592653);
} {3.14}
do_execsql_test printf2-1.7 {
  SELECT printf('%.*f',2,3.141592653);
} {3.14}
do_execsql_test printf2-1.8 {
  SELECT printf('%*.*f',5,2,3.141592653);
} {{ 3.14}}
do_execsql_test printf2-1.9 {
  SELECT printf('%d',314159.2653);
} {314159}
do_execsql_test printf2-1.10 {
  SELECT printf('%lld',314159.2653);
} {314159}
do_execsql_test printf2-1.11 {
  SELECT printf('%lld%n',314159.2653,'hi');
} {314159}
do_execsql_test printf2-1.12 {
  SELECT printf('%n',0);
} {{}}

# EVIDENCE-OF: R-17002-27534 The %z format is interchangeable with %s.
#
do_execsql_test printf2-1.12 {
  SELECT printf('%.*z',5,'abcdefghijklmnop');
} {abcde}
do_execsql_test printf2-1.13 {
  SELECT printf('%c','abcdefghijklmnop');
} {a}

# EVIDENCE-OF: R-02347-27622 The %n format is silently ignored and does
# not consume an argument.
#
do_execsql_test printf2-2.1 {
  CREATE TABLE t1(id primary key, a,b,c);
  INSERT INTO t1 VALUES(1, 1,2,3);
  INSERT INTO t1 VALUES(2, -1,-2,-3);
  INSERT INTO t1 VALUES(3, 'abc','def','ghi');
  INSERT INTO t1 VALUES(4, 1.5,2.25,3.125);
  SELECT printf('(%s)-%n-(%s)',a,b,c) FROM t1 ORDER BY id;
} {(1)--(2) (-1)--(-2) (abc)--(def) (1.5)--(2.25)}

# EVIDENCE-OF: R-56064-04001 The %p format is an alias for %X.
#
do_execsql_test printf2-2.2 {
  SELECT printf('%s=(%p)',a,a) FROM t1 ORDER BY a;
} {-1=(FFFFFFFFFFFFFFFF) 1=(1) 1.5=(1) abc=(0)}

# EVIDENCE-OF: R-29410-53018 If there are too few arguments in the
# argument list, missing arguments are assumed to have a NULL value,
# which is translated into 0 or 0.0 for numeric formats or an empty
# string for %s.
#
do_execsql_test printf2-2.3 {
  SELECT printf('%s=(%d/%g/%s)',a) FROM t1 ORDER BY a;
} {-1=(0/0/) 1=(0/0/) 1.5=(0/0/) abc=(0/0/)}

# The precision of the %c conversion causes the character to repeat.
#
do_execsql_test printf2-3.1 {
  SELECT printf('|%110.100c|','*');
} {{|          ****************************************************************************************************|}}
do_execsql_test printf2-3.2 {
  SELECT printf('|%-110.100c|','*');
} {{|****************************************************************************************************          |}}
do_execsql_test printf2-3.3 {
  SELECT printf('|%9.8c|%-9.8c|','*','*');
} {{| ********|******** |}}
do_execsql_test printf2-3.4 {
  SELECT printf('|%8.8c|%-8.8c|','*','*');
} {|********|********|}
do_execsql_test printf2-3.5 {
  SELECT printf('|%7.8c|%-7.8c|','*','*');
} {|********|********|}




finish_test
