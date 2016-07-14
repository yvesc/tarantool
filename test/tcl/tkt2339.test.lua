#!/usr/bin/env ./tcltestrunner.lua

# 2007 May 6
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
# $Id: tkt2339.test,v 1.2 2007/09/12 17:01:45 danielk1977 Exp $
#

set testdir [file dirname $argv0]
source $testdir/tester.tcl

ifcapable !subquery||!compound {
  finish_test
  return
}

do_test tkt2339.1 {
  execsql {
    create table t1(num int primary key);
    insert into t1 values (1);
    insert into t1 values (2);
    insert into t1 values (3);
    insert into t1 values (4);
    
    create table t2(num int primary key);
    insert into t2 values (11);
    insert into t2 values (12);
    insert into t2 values (13);
    insert into t2 values (14);
    
    SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC LIMIT 2)
    UNION
    SELECT * FROM (SELECT * FROM t2 ORDER BY num DESC LIMIT 2)
  }
} {3 4 13 14}
do_test tkt2339.2 {
  execsql {
    SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC LIMIT 2)
    UNION ALL
    SELECT * FROM (SELECT * FROM t2 ORDER BY num DESC LIMIT 2)
  }
} {4 3 14 13}
do_test tkt2339.3 {
  execsql {
    SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC)
    UNION ALL
    SELECT * FROM (SELECT * FROM t2 ORDER BY num DESC LIMIT 2)
  }
} {4 3 2 1 14 13}
do_test tkt2339.4 {
  execsql {
    SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC LIMIT 2)
    UNION ALL
    SELECT * FROM (SELECT * FROM t2 ORDER BY num DESC)
  }
} {4 3 14 13 12 11}
do_test tkt2339.5 {
  execsql {
    SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC LIMIT 2)
    UNION
    SELECT * FROM (SELECT * FROM t2 ORDER BY num DESC)
  }
} {3 4 11 12 13 14}
do_test tkt2339.6 {
  execsql {
    SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC LIMIT 2)
    EXCEPT
    SELECT * FROM (SELECT * FROM t2 ORDER BY num DESC)
  }
} {3 4}
do_test tkt2339.7 {
  execsql {
    SELECT * FROM (SELECT * FROM t1 LIMIT 2)
    UNION
    SELECT * FROM (SELECT * FROM t2 ORDER BY num DESC LIMIT 2)
  }
} {1 2 13 14}
do_test tkt2339.8 {
  execsql {
    SELECT * FROM (SELECT * FROM t1 LIMIT 2)
    UNION
    SELECT * FROM (SELECT * FROM t2 LIMIT 2)
  }
} {1 2 11 12}
do_test tkt2339.9 {
  execsql {
    SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC LIMIT 2)
    UNION
    SELECT * FROM (SELECT * FROM t2 LIMIT 2)
  }
} {3 4 11 12}


finish_test
