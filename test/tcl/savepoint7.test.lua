#!/usr/bin/env ./tcltestrunner.lua

# 2012 March 31
#
# The author disclaims copyright to this source code.  In place of
# a legal notice, here is a blessing:
#
#    May you do good and not evil.
#    May you find forgiveness for yourself and forgive others.
#    May you share freely, never taking more than you give.
#
#***********************************************************************
#
# Focus on the interaction between RELEASE and ROLLBACK TO with
# pending query aborts.  See ticket [27ca74af3c083f787a1c44b11fbb7c53bdbbcf1e].
#

set testdir [file dirname $argv0]
source $testdir/tester.tcl

# # The RELEASE of an inner savepoint should not effect pending queries.
# #
# do_test savepoint7-1.1 {
#   db eval {
#     CREATE TABLE t1(a,b,c);
#     CREATE TABLE t2(x,y,z);
#     INSERT INTO t1 VALUES(1,2,3);
#     INSERT INTO t1 VALUES(4,5,6);
#     INSERT INTO t1 VALUES(7,8,9);
#     SAVEPOINT x1;
#   }
#   db eval {SELECT * FROM t1} {
#     db eval {
#       SAVEPOINT x2;
#       CREATE TABLE IF NOT EXISTS t3(xyz);
#       INSERT INTO t2 VALUES($a,$b,$c);
#       RELEASE x2;
#     }
#   }
#   db eval {SELECT * FROM t2; RELEASE x1}
# } {1 2 3 4 5 6 7 8 9}

# do_test savepoint7-1.2 {
#   db eval {DELETE FROM t2;}
#   db eval {SELECT * FROM t1} {
#     db eval {
#       SAVEPOINT x2;
#       INSERT INTO t2 VALUES($a,$b,$c);
#       RELEASE x2;
#     }
#   }
#   db eval {SELECT * FROM t2;}
# } {1 2 3 4 5 6 7 8 9}

# do_test savepoint7-1.3 {
#   db eval {DELETE FROM t2; BEGIN;}
#   db eval {SELECT * FROM t1} {
#     db eval {
#       SAVEPOINT x2;
#       INSERT INTO t2 VALUES($a,$b,$c);
#       RELEASE x2;
#     }
#   }
#   db eval {SELECT * FROM t2; ROLLBACK;}
# } {1 2 3 4 5 6 7 8 9}

# # However, a ROLLBACK of an inner savepoint will abort all queries, including
# # queries in outer contexts.
# #
# do_test savepoint7-2.1 {
#   db eval {DELETE FROM t2; SAVEPOINT x1; CREATE TABLE t4(abc);}
#   set rc [catch {
#     db eval {SELECT * FROM t1} {
#       db eval {
#         SAVEPOINT x2;
#         INSERT INTO t2 VALUES($a,$b,$c);
#         ROLLBACK TO x2;
#       }
#     }
#   } msg]
#   db eval {RELEASE x1}
#   list $rc $msg [db eval {SELECT * FROM t2}]
# } {1 {abort due to ROLLBACK} {}}

# do_test savepoint7-2.2 {
#   db eval {DELETE FROM t2;}
#   set rc [catch {
#     db eval {SELECT * FROM t1} {
#       db eval {
#         SAVEPOINT x2;
#         CREATE TABLE t5(pqr);
#         INSERT INTO t2 VALUES($a,$b,$c);
#         ROLLBACK TO x2;
#       }
#     }
#   } msg]
#   list $rc $msg [db eval {SELECT * FROM t2}]
# } {1 {abort due to ROLLBACK} {}}

finish_test
