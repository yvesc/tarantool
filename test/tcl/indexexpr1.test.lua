#!/usr/bin/env ./tcltestrunner.lua

# 2015-08-31
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
# focus of this file is testing indexes on expressions.
#

set testdir [file dirname $argv0]
source $testdir/tester.tcl

# do_execsql_test indexexpr1-100 {
#   CREATE TABLE t1(a,b,c);
#   INSERT INTO t1(a,b,c)
#       /*  123456789 123456789 123456789 123456789 123456789 123456789 */ 
#   VALUES('In_the_beginning_was_the_Word',1,1),
#         ('and_the_Word_was_with_God',1,2),
#         ('and_the_Word_was_God',1,3),
#         ('The_same_was_in_the_beginning_with_God',2,1),
#         ('All_things_were_made_by_him',3,1),
#         ('and_without_him_was_not_any_thing_made_that_was_made',3,2);
#   CREATE INDEX t1a1 ON t1(substr(a,1,12));
# } {}
# do_execsql_test indexexpr1-110 {
#   SELECT b, c, '|' FROM t1 WHERE substr(a,1,12)=='and_the_Word' ORDER BY b, c;
# } {1 2 | 1 3 |}
# do_execsql_test indexexpr1-110eqp {
#   EXPLAIN QUERY PLAN
#   SELECT b, c, '|' FROM t1 WHERE substr(a,1,12)=='and_the_Word' ORDER BY b, c;
# } {/USING INDEX t1a1/}
# do_execsql_test indexexpr1-120 {
#   SELECT b, c, '|' FROM t1 WHERE 'and_the_Word'==substr(a,1,12) ORDER BY b, c;
# } {1 2 | 1 3 |}
# do_execsql_test indexexpr1-120eqp {
#   EXPLAIN QUERY PLAN
#   SELECT b, c, '|' FROM t1 WHERE 'and_the_Word'==substr(a,1,12) ORDER BY b, c;
# } {/USING INDEX t1a1/}

# do_execsql_test indexexpr1-130 {
#   CREATE INDEX t1ba ON t1(b,substr(a,2,3),c);
#   SELECT c FROM t1 WHERE b=1 AND substr(a,2,3)='nd_' ORDER BY c;
# } {2 3}
# do_execsql_test indexexpr1-130eqp {
#   EXPLAIN QUERY PLAN
#   SELECT c FROM t1 WHERE b=1 AND substr(a,2,3)='nd_' ORDER BY c;
# } {/USING INDEX t1ba/}

# do_execsql_test indexexpr1-140 {
#   SELECT rowid, substr(a,b,3), '|' FROM t1 ORDER BY 2;
# } {1 In_ | 2 and | 3 and | 6 d_w | 4 he_ | 5 l_t |}
# do_execsql_test indexexpr1-141 {
#   CREATE INDEX t1abx ON t1(substr(a,b,3));
#   SELECT rowid FROM t1 WHERE substr(a,b,3)<='and' ORDER BY +rowid;
# } {1 2 3}
# do_execsql_test indexexpr1-141eqp {
#   EXPLAIN QUERY PLAN
#   SELECT rowid FROM t1 WHERE substr(a,b,3)<='and' ORDER BY +rowid;
# } {/USING INDEX t1abx/}
# do_execsql_test indexexpr1-142 {
#   SELECT rowid FROM t1 WHERE +substr(a,b,3)<='and' ORDER BY +rowid;
# } {1 2 3}
# do_execsql_test indexexpr1-150 {
#   SELECT rowid FROM t1 WHERE substr(a,b,3) IN ('and','l_t','xyz')
#    ORDER BY +rowid;
# } {2 3 5}
# do_execsql_test indexexpr1-150eqp {
#   EXPLAIN QUERY PLAN
#   SELECT rowid FROM t1 WHERE substr(a,b,3) IN ('and','l_t','xyz')
#    ORDER BY +rowid;
# } {/USING INDEX t1abx/}

# do_execsql_test indexexpr1-160 {
#   ALTER TABLE t1 ADD COLUMN d;
#   UPDATE t1 SET d=length(a);
#   CREATE INDEX t1a2 ON t1(SUBSTR(a, 27, 3)) WHERE d>=29;
#   SELECT rowid, b, c FROM t1
#    WHERE substr(a,27,3)=='ord' AND d>=29;
# } {1 1 1}
# do_execsql_test indexexpr1-160eqp {
#   EXPLAIN QUERY PLAN
#   SELECT rowid, b, c FROM t1
#    WHERE substr(a,27,3)=='ord' AND d>=29;
# } {/USING INDEX t1a2/}

# # ORDER BY using an indexed expression
# #
# do_execsql_test indexexpr1-170 {
#   CREATE INDEX t1alen ON t1(length(a));
#   SELECT length(a) FROM t1 ORDER BY length(a);
# } {20 25 27 29 38 52}
# do_execsql_test indexexpr1-170eqp {
#   EXPLAIN QUERY PLAN
#   SELECT length(a) FROM t1 ORDER BY length(a);
# } {/SCAN TABLE t1 USING INDEX t1alen/}
# do_execsql_test indexexpr1-171 {
#   SELECT length(a) FROM t1 ORDER BY length(a) DESC;
# } {52 38 29 27 25 20}
# do_execsql_test indexexpr1-171eqp {
#   EXPLAIN QUERY PLAN
#   SELECT length(a) FROM t1 ORDER BY length(a) DESC;
# } {/SCAN TABLE t1 USING INDEX t1alen/}

# do_execsql_test indexexpr1-200 {
#   DROP TABLE t1;
#   CREATE TABLE t1(id ANY PRIMARY KEY, a,b,c) WITHOUT ROWID;
#   INSERT INTO t1(id,a,b,c)
#   VALUES(1,'In_the_beginning_was_the_Word',1,1),
#         (2,'and_the_Word_was_with_God',1,2),
#         (3,'and_the_Word_was_God',1,3),
#         (4,'The_same_was_in_the_beginning_with_God',2,1),
#         (5,'All_things_were_made_by_him',3,1),
#         (6,'and_without_him_was_not_any_thing_made_that_was_made',3,2);
#   CREATE INDEX t1a1 ON t1(substr(a,1,12));
# } {}
# do_execsql_test indexexpr1-210 {
#   SELECT b, c, '|' FROM t1 WHERE substr(a,1,12)=='and_the_Word' ORDER BY b, c;
# } {1 2 | 1 3 |}
# do_execsql_test indexexpr1-210eqp {
#   EXPLAIN QUERY PLAN
#   SELECT b, c, '|' FROM t1 WHERE substr(a,1,12)=='and_the_Word' ORDER BY b, c;
# } {/USING INDEX t1a1/}
# do_execsql_test indexexpr1-220 {
#   SELECT b, c, '|' FROM t1 WHERE 'and_the_Word'==substr(a,1,12) ORDER BY b, c;
# } {1 2 | 1 3 |}
# do_execsql_test indexexpr1-220eqp {
#   EXPLAIN QUERY PLAN
#   SELECT b, c, '|' FROM t1 WHERE 'and_the_Word'==substr(a,1,12) ORDER BY b, c;
# } {/USING INDEX t1a1/}

# do_execsql_test indexexpr1-230 {
#   CREATE INDEX t1ba ON t1(b,substr(a,2,3),c);
#   SELECT c FROM t1 WHERE b=1 AND substr(a,2,3)='nd_' ORDER BY c;
# } {2 3}
# do_execsql_test indexexpr1-230eqp {
#   EXPLAIN QUERY PLAN
#   SELECT c FROM t1 WHERE b=1 AND substr(a,2,3)='nd_' ORDER BY c;
# } {/USING INDEX t1ba/}

# do_execsql_test indexexpr1-240 {
#   SELECT id, substr(a,b,3), '|' FROM t1 ORDER BY 2;
# } {1 In_ | 2 and | 3 and | 6 d_w | 4 he_ | 5 l_t |}
# do_execsql_test indexexpr1-241 {
#   CREATE INDEX t1abx ON t1(substr(a,b,3));
#   SELECT id FROM t1 WHERE substr(a,b,3)<='and' ORDER BY +id;
# } {1 2 3}
# do_execsql_test indexexpr1-241eqp {
#   EXPLAIN QUERY PLAN
#   SELECT id FROM t1 WHERE substr(a,b,3)<='and' ORDER BY +id;
# } {/USING INDEX t1abx/}
# do_execsql_test indexexpr1-242 {
#   SELECT id FROM t1 WHERE +substr(a,b,3)<='and' ORDER BY +id;
# } {1 2 3}
# do_execsql_test indexexpr1-250 {
#   SELECT id FROM t1 WHERE substr(a,b,3) IN ('and','l_t','xyz')
#    ORDER BY +id;
# } {2 3 5}
# do_execsql_test indexexpr1-250eqp {
#   EXPLAIN QUERY PLAN
#   SELECT id FROM t1 WHERE substr(a,b,3) IN ('and','l_t','xyz')
#    ORDER BY +id;
# } {/USING INDEX t1abx/}

# do_execsql_test indexexpr1-260 {
#   ALTER TABLE t1 ADD COLUMN d;
#   UPDATE t1 SET d=length(a);
#   CREATE INDEX t1a2 ON t1(SUBSTR(a, 27, 3)) WHERE d>=29;
#   SELECT id, b, c FROM t1
#    WHERE substr(a,27,3)=='ord' AND d>=29;
# } {1 1 1}
# do_execsql_test indexexpr1-260eqp {
#   EXPLAIN QUERY PLAN
#   SELECT id, b, c FROM t1
#    WHERE substr(a,27,3)=='ord' AND d>=29;
# } {/USING INDEX t1a2/}


# do_catchsql_test indexexpr1-300 {
#   CREATE TABLE t2(a,b,c);
#   CREATE INDEX t2x1 ON t2(a,b+random());
# } {1 {non-deterministic functions prohibited in index expressions}}
# do_catchsql_test indexexpr1-301 {
#   CREATE INDEX t2x1 ON t2(a+julianday('now'));
# } {1 {non-deterministic functions prohibited in index expressions}}
# do_catchsql_test indexexpr1-310 {
#   CREATE INDEX t2x2 ON t2(a,b+(SELECT 15));
# } {1 {subqueries prohibited in index expressions}}
# do_catchsql_test indexexpr1-320 {
#   CREATE TABLE e1(x,y,UNIQUE(y,substr(x,1,5)));
# } {1 {expressions prohibited in PRIMARY KEY and UNIQUE constraints}}
# do_catchsql_test indexexpr1-330 {
#   CREATE TABLE e1(x,y,PRIMARY KEY(y,substr(x,1,5)));
# } {1 {expressions prohibited in PRIMARY KEY and UNIQUE constraints}}
# do_catchsql_test indexexpr1-331 {
#   CREATE TABLE e1(x,y,PRIMARY KEY(y,substr(x,1,5))) WITHOUT ROWID;
# } {1 {expressions prohibited in PRIMARY KEY and UNIQUE constraints}}
# do_catchsql_test indexexpr1-340 {
#   CREATE TABLE e1(x,y,FOREIGN KEY(substr(y,1,5)) REFERENCES t1);
# } {1 {near "(": syntax error}}

# do_execsql_test indexexpr1-400 {
#   CREATE TABLE t3(a,b,c);
#   WITH RECURSIVE c(x) AS (VALUES(1) UNION SELECT x+1 FROM c WHERE x<30)
#   INSERT INTO t3(a,b,c)
#     SELECT x, printf('ab%04xyz',x), random() FROM c;
#   CREATE UNIQUE INDEX t3abc ON t3(CAST(a AS text), b, substr(c,1,3));
#   SELECT a FROM t3 WHERE CAST(a AS text)<='10' ORDER BY +a;
#   PRAGMA integrity_check;
# } {1 10 ok}
# do_catchsql_test indexexpr1-410 {
#   INSERT INTO t3 SELECT * FROM t3 WHERE rowid=10;
# } {1 {UNIQUE constraint failed: index 't3abc'}}

# do_execsql_test indexexpr1-500 {
#   CREATE TABLE t5(a);
#   CREATE TABLE cnt(x);
#   WITH RECURSIVE
#     c(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM c WHERE x<5)
#   INSERT INTO cnt(x) SELECT x FROM c;
#   INSERT INTO t5(a) SELECT printf('abc%03dxyz',x) FROM cnt;
#   CREATE INDEX t5ax ON t5( substr(a,4,3) );
# } {}
# do_execsql_test indexexpr1-510 {
#   -- The use of the "k" alias in the WHERE clause is technically
#   -- illegal, but SQLite allows it for historical reasons.  In this
#   -- test and the next, verify that "k" can be used by the t5ax index
#   SELECT substr(a,4,3) AS k FROM cnt, t5 WHERE k=printf('%03d',x);
# } {001 002 003 004 005}
# do_execsql_test indexexpr1-510eqp {
#   EXPLAIN QUERY PLAN
#   SELECT substr(a,4,3) AS k FROM cnt, t5 WHERE k=printf('%03d',x);
# } {/USING INDEX t5ax/}

# # Skip-scan on an indexed expression
# #
# do_execsql_test indexexpr1-600 {
#   DROP TABLE IF EXISTS t4;
#   CREATE TABLE t4(a,b,c,d,e,f,g,h,i);
#   CREATE INDEX t4all ON t4(a,b,c<d,e,f,i,h);
#   INSERT INTO t4 VALUES(1,2,3,4,5,6,7,8,9);
#   ANALYZE;
#   DELETE FROM sqlite_stat1;
#   INSERT INTO sqlite_stat1
#     VALUES('t4','t4all','600000 160000 40000 10000 2000 600 100 40 10');
#   ANALYZE sqlite_master;
#   SELECT i FROM t4 WHERE e=5;
# } {9}

# # Indexed expressions on both sides of an == in a WHERE clause.
# #
# do_execsql_test indexexpr1-700 {
#   DROP TABLE IF EXISTS t7;
#   CREATE TABLE t7(a,b,c);
#   INSERT INTO t7(a,b,c) VALUES(1,2,2),('abc','def','def'),(4,5,6);
#   CREATE INDEX t7b ON t7(+b);
#   CREATE INDEX t7c ON t7(+c);
#   SELECT *, '|' FROM t7 WHERE +b=+c ORDER BY +a;
# } {1 2 2 | abc def def |}
# do_execsql_test indexexpr1-710 {
#   CREATE TABLE t71(a,b,c);
#   CREATE INDEX t71bc ON t71(b+c);
#   CREATE TABLE t72(x,y,z);
#   CREATE INDEX t72yz ON t72(y+z);
#   INSERT INTO t71(a,b,c) VALUES(1,11,2),(2,7,15),(3,5,4);
#   INSERT INTO t72(x,y,z) VALUES(1,10,3),(2,8,14),(3,9,9);
#   SELECT a, x, '|' FROM t71, t72
#    WHERE b+c=y+z
#   ORDER BY +a, +x;
# } {1 1 | 2 2 |}

# # Collating sequences on indexes of expressions
# #
# do_execsql_test indexexpr1-800 {
#   DROP TABLE IF EXISTS t8;
#   CREATE TABLE t8(a INTEGER PRIMARY KEY, b TEXT);
#   CREATE UNIQUE INDEX t8bx ON t8(substr(b,2,4) COLLATE nocase);
#   INSERT INTO t8(a,b) VALUES(1,'Alice'),(2,'Bartholemew'),(3,'Cynthia');
#   SELECT * FROM t8 WHERE substr(b,2,4)='ARTH' COLLATE nocase;
# } {2 Bartholemew}
# do_catchsql_test indexexpr1-810 {
#   INSERT INTO t8(a,b) VALUES(4,'BARTHMERE');
# } {1 {UNIQUE constraint failed: index 't8bx'}}
# do_catchsql_test indexexpr1-820 {
#   DROP INDEX t8bx;
#   CREATE UNIQUE INDEX t8bx ON t8(substr(b,2,4) COLLATE rtrim);
#   INSERT INTO t8(a,b) VALUES(4,'BARTHMERE');
# } {0 {}}

# # Check that PRAGMA integrity_check works correctly on a
# # UNIQUE index that includes rowid and expression terms.
# #
# do_execsql_test indexexpr1-900 {
#   CREATE TABLE t9(a,b,c,d);
#   CREATE UNIQUE INDEX t9x1 ON t9(c,abs(d),b);
#   INSERT INTO t9(rowid,a,b,c,d) VALUES(1,2,3,4,5);
#   INSERT INTO t9(rowid,a,b,c,d) VALUES(2,NULL,NULL,NULL,NULL);
#   INSERT INTO t9(rowid,a,b,c,d) VALUES(3,NULL,NULL,NULL,NULL);
#   INSERT INTO t9(rowid,a,b,c,d) VALUES(4,5,6,7,8);
#   PRAGMA integrity_check;
# } {ok}
# do_catchsql_test indexexpr1-910 {
#   INSERT INTO t9(a,b,c,d) VALUES(5,6,7,-8);
# } {1 {UNIQUE constraint failed: index 't9x1'}}


finish_test
