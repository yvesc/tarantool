#!/usr/bin/env ./tcltestrunner.lua

# 2007 November 23
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
# The tests in this file ensure that a temporary table is used
# when required by an "INSERT INTO ... SELECT ..." statement.
#
# $Id: insert5.test,v 1.5 2008/08/04 03:51:24 danielk1977 Exp $

set testdir [file dirname $argv0]
source $testdir/tester.tcl

ifcapable !subquery {
  finish_test
  return
}

# Return true if the compilation of the sql passed as an argument 
# includes the opcode OpenEphemeral. An "INSERT INTO ... SELECT"
# statement includes such an opcode if a temp-table is used
# to store intermediate results.
# 
proc uses_temp_table {sql} {
  return [expr {[lsearch [execsql "EXPLAIN $sql"] OpenEphemeral]>=0}]
}

# Construct the sample database.
#
do_test insert5-1.0 {
  #forcedelete test2.db test2.db-journal
  execsql {
    CREATE TABLE MAIN(pk integer primary key autoincrement, Id INTEGER, Id1 INTEGER); 
    CREATE TABLE B(pk integer primary key autoincrement, Id INTEGER, Id1 INTEGER); 
    CREATE VIEW v1 AS SELECT Id, Id1 FROM B;
    CREATE VIEW v2 AS SELECT Id, Id1 FROM MAIN;
    INSERT INTO MAIN(Id,Id1) VALUES(2,3); 
    INSERT INTO B(Id,Id1) VALUES(2,3); 
  }
} {}

# Run the query.
#
ifcapable compound {
  do_test insert5-1.1 {
    execsql {
      INSERT INTO B(Id,Id1) 
        SELECT Id,Id1 FROM B UNION ALL 
        SELECT Id,Id1 FROM MAIN WHERE exists (select Id,Id1 FROM B WHERE B.Id = MAIN.Id);
      SELECT Id,Id1 FROM B;
    }
  } {2 3 2 3 2 3}
} else {
  do_test insert5-1.1 {
    execsql {
      INSERT INTO B(Id,Id1) SELECT Id,Id1 FROM B;
      INSERT INTO B
        SELECT Id,Id1 FROM MAIN WHERE exists (select Id,Id1 FROM B WHERE B.Id = MAIN.Id);
      SELECT Id,Id1 FROM B;
    }
  } {2 3 2 3 2 3}
}
do_test insert5-2.1 {
  uses_temp_table { INSERT INTO b(Id,Id1) SELECT Id,Id1 FROM main }
} {0}
do_test insert5-2.2 {
  uses_temp_table { INSERT INTO b(Id,Id1) SELECT Id,Id1 FROM b }
} {1}
do_test insert5-2.3 {
  uses_temp_table { INSERT INTO b(Id,Id1) SELECT (SELECT id FROM b), id1 FROM main }
} {1}
do_test insert5-2.4 {
  uses_temp_table { INSERT INTO b(Id,Id1) SELECT id1, (SELECT id FROM b) FROM main }
} {1}
do_test insert5-2.5 {
  uses_temp_table { 
    INSERT INTO b(Id,Id1) 
      SELECT Id,Id1 FROM main WHERE id = (SELECT id1 FROM b WHERE main.id = b.id) }
} {1}
do_test insert5-2.6 {
  uses_temp_table { INSERT INTO b(Id,Id1) SELECT * FROM v1 }
} {1}
do_test insert5-2.7 {
  uses_temp_table { INSERT INTO b(Id,Id1) SELECT * FROM v2 }
} {0}
do_test insert5-2.8 {
  uses_temp_table { 
    INSERT INTO b(Id,Id1) 
    SELECT Id,Id1 FROM main WHERE id > 10 AND max(id1, (SELECT id FROM b)) > 10;
  }
} {1}

# UPDATE: Using a column from the outer query (main.id) in the GROUP BY
# or ORDER BY of a sub-query is no longer supported.
#
# do_test insert5-2.9 {
#   uses_temp_table { 
#     INSERT INTO b 
#     SELECT * FROM main 
#     WHERE id > 10 AND (SELECT count(*) FROM v2 GROUP BY main.id)
#   }
# } {}
do_test insert5-2.9 {
  catchsql { 
    INSERT INTO b(Id,Id1) 
    SELECT Id,Id1 FROM main 
    WHERE id > 10 AND (SELECT count(*) FROM v2 GROUP BY main.id)
  }
} {1 {no such column: main.id}}

finish_test
