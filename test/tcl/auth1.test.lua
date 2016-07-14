#!/usr/bin/env ./tcltestrunner.lua

# 2003 April 4
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
# focus of this script is testing the sqlite3_set_authorizer() API
# and related functionality.
#
# $Id: auth.test,v 1.46 2009/07/02 18:40:35 danielk1977 Exp $
#

set testdir [file dirname $argv0]
source $testdir/tester.tcl

# disable this test if the SQLITE_OMIT_AUTHORIZATION macro is
# defined during compilation.
if {[catch {db auth {}} msg]} {
  finish_test
  return
}

rename proc proc_real
# proc_real proc {name arguments script} {
#   proc_real $name $arguments $script
#   if {$name=="auth"} {
#     db authorizer ::auth
#   }
# }

# do_test auth-1.1.1 {
#   db close
#   set ::DB [sqlite3 db test.db]
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   db authorizer ::auth
#   catchsql {CREATE TABLE t1(a,b,c)}
# } {1 {not authorized}}
# do_test auth-1.1.2 {
#   db errorcode
# } {23}
# do_test auth-1.1.3 {
#   db authorizer
# } {::auth}
# do_test auth-1.1.4 {
#   # Ticket #896.
#   catchsql {
#     SELECT x;
#   }
# } {1 {no such column: x}}
# do_test auth-1.2 {
#   execsql {SELECT name FROM sqlite_master}
# } {}
# do_test auth-1.3.1 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TABLE"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE TABLE t1(a,b,c)}
# } {1 {not authorized}}
# do_test auth-1.3.2 {
#   db errorcode
# } {23}
# do_test auth-1.3.3 {
#   set ::authargs
# } {t1 {} main {}}
# do_test auth-1.4 {
#   execsql {SELECT name FROM sqlite_master}
# } {}

# ifcapable tempdb {
#   do_test auth-1.5 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_INSERT" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMP TABLE t1(a,b,c)}
#   } {1 {not authorized}}
#   do_test auth-1.6 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {}
#   do_test auth-1.7.1 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_CREATE_TEMP_TABLE"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMP TABLE t1(a,b,c)}
#   } {1 {not authorized}}
#   do_test auth-1.7.2 {
#      set ::authargs
#   } {t1 {} temp {}}
#   do_test auth-1.8 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {}
# }

# do_test auth-1.9 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE TABLE t1(a,b,c)}
# } {0 {}}
# do_test auth-1.10 {
#   execsql {SELECT name FROM sqlite_master}
# } {}
# do_test auth-1.11 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TABLE"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE TABLE t1(a,b,c)}
# } {0 {}}
# do_test auth-1.12 {
#   execsql {SELECT name FROM sqlite_master}
# } {}

# ifcapable tempdb {
#   do_test auth-1.13 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_INSERT" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMP TABLE t1(a,b,c)}
#   } {0 {}}
#   do_test auth-1.14 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {}
#   do_test auth-1.15 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_CREATE_TEMP_TABLE"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMP TABLE t1(a,b,c)}
#   } {0 {}}
#   do_test auth-1.16 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {}
  
#   do_test auth-1.17 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_CREATE_TABLE"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMP TABLE t1(a,b,c)}
#   } {0 {}}
#   do_test auth-1.18 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
# }

# do_test auth-1.19.1 {
#   set ::authargs {}
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TEMP_TABLE"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE TABLE t2(a,b,c)}
# } {0 {}}
# do_test auth-1.19.2 {
#   set ::authargs
# } {}
# do_test auth-1.20 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}

# do_test auth-1.21.1 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_TABLE"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TABLE t2}
# } {1 {not authorized}}
# do_test auth-1.21.2 {
#   set ::authargs
# } {t2 {} main {}}
# do_test auth-1.22 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.23.1 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_TABLE"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TABLE t2}
# } {0 {}}
# do_test auth-1.23.2 {
#   set ::authargs
# } {t2 {} main {}}
# do_test auth-1.24 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}

# ifcapable tempdb {
#   do_test auth-1.25 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DROP_TEMP_TABLE"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP TABLE t1}
#   } {1 {not authorized}}
#   do_test auth-1.26 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.27 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DROP_TEMP_TABLE"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP TABLE t1}
#   } {0 {}}
#   do_test auth-1.28 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
# }

# do_test auth-1.29 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="t2"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {INSERT INTO t2 VALUES(1,2,3)}
# } {1 {not authorized}}
# do_test auth-1.30 {
#   execsql {SELECT * FROM t2}
# } {}
# do_test auth-1.31 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="t2"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {INSERT INTO t2 VALUES(1,2,3)}
# } {0 {}}
# do_test auth-1.32 {
#   execsql {SELECT * FROM t2}
# } {}
# do_test auth-1.33 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="t1"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {INSERT INTO t2 VALUES(1,2,3)}
# } {0 {}}
# do_test auth-1.34 {
#   execsql {SELECT * FROM t2}
# } {1 2 3}

# do_test auth-1.35.1 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="b"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2}
# } {1 {access to t2.b is prohibited}}
# ifcapable attach {
#   do_test auth-1.35.2 {
#     execsql {ATTACH DATABASE 'test.db' AS two}
#     catchsql {SELECT * FROM two.t2}
#   } {1 {access to two.t2.b is prohibited}}
#   execsql {DETACH DATABASE two}
# }
# do_test auth-1.36 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="b"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2}
# } {0 {1 {} 3}}
# do_test auth-1.37 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="b"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2 WHERE b=2}
# } {0 {}}
# do_test auth-1.38 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="a"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2 WHERE b=2}
# } {0 {{} 2 3}}
# do_test auth-1.39 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="b"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2 WHERE b IS NULL}
# } {0 {1 {} 3}}
# do_test auth-1.40 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="b"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT a,c FROM t2 WHERE b IS NULL}
# } {1 {access to t2.b is prohibited}}
  
# do_test auth-1.41 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_UPDATE" && $arg1=="t2" && $arg2=="b"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {UPDATE t2 SET a=11}
# } {0 {}}
# do_test auth-1.42 {
#   execsql {SELECT * FROM t2}
# } {11 2 3}
# do_test auth-1.43 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_UPDATE" && $arg1=="t2" && $arg2=="b"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {UPDATE t2 SET b=22, c=33}
# } {1 {not authorized}}
# do_test auth-1.44 {
#   execsql {SELECT * FROM t2}
# } {11 2 3}
# do_test auth-1.45 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_UPDATE" && $arg1=="t2" && $arg2=="b"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {UPDATE t2 SET b=22, c=33}
# } {0 {}}
# do_test auth-1.46 {
#   execsql {SELECT * FROM t2}
# } {11 2 33}

# do_test auth-1.47 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="t2"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DELETE FROM t2 WHERE a=11}
# } {1 {not authorized}}
# do_test auth-1.48 {
#   execsql {SELECT * FROM t2}
# } {11 2 33}
# do_test auth-1.49 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="t2"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DELETE FROM t2 WHERE a=11}
# } {0 {}}
# do_test auth-1.50 {
#   execsql {SELECT * FROM t2}
# } {}
# do_test auth-1.50.2 {
#   execsql {INSERT INTO t2 VALUES(11, 2, 33)}
# } {}

# do_test auth-1.51 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_SELECT"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2}
# } {1 {not authorized}}
# do_test auth-1.52 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_SELECT"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2}
# } {0 {}}
# do_test auth-1.53 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_SELECT"} {
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2}
# } {0 {11 2 33}}

# # Update for version 3: There used to be a handful of test here that
# # tested the authorisation callback with the COPY command. The following
# # test makes the same database modifications as they used to.
# do_test auth-1.54 {
#   execsql {INSERT INTO t2 VALUES(7, 8, 9);}
# } {}
# do_test auth-1.55 {
#   execsql {SELECT * FROM t2}
# } {11 2 33 7 8 9}

# do_test auth-1.63 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_master"} {
#        return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TABLE t2}
# } {1 {not authorized}}
# do_test auth-1.64 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.65 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="t2"} {
#        return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TABLE t2}
# } {1 {not authorized}}
# do_test auth-1.66 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}

# ifcapable tempdb {
#   do_test auth-1.67 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DELETE" && $arg1=="sqlite_temp_master"} {
#          return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP TABLE t1}
#   } {1 {not authorized}}
#   do_test auth-1.68 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.69 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DELETE" && $arg1=="t1"} {
#          return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP TABLE t1}
#   } {1 {not authorized}}
#   do_test auth-1.70 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
# }

# do_test auth-1.71 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_master"} {
#        return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TABLE t2}
# } {0 {}}
# do_test auth-1.72 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.73 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="t2"} {
#        return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TABLE t2}
# } {0 {}}
# do_test auth-1.74 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}

# ifcapable tempdb {
#   do_test auth-1.75 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DELETE" && $arg1=="sqlite_temp_master"} {
#          return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP TABLE t1}
#   } {0 {}}
#   do_test auth-1.76 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.77 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DELETE" && $arg1=="t1"} {
#          return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP TABLE t1}
#   } {0 {}}
#   do_test auth-1.78 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
# }

# # Test cases auth-1.79 to auth-1.124 test creating and dropping views.
# # Omit these if the library was compiled with views omitted.
# ifcapable view {
# do_test auth-1.79 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_VIEW"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4] 
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE VIEW v1 AS SELECT a+1,b+1 FROM t2}
# } {1 {not authorized}}
# do_test auth-1.80 {
#   set ::authargs
# } {v1 {} main {}}
# do_test auth-1.81 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.82 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_VIEW"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4] 
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE VIEW v1 AS SELECT a+1,b+1 FROM t2}
# } {0 {}}
# do_test auth-1.83 {
#   set ::authargs
# } {v1 {} main {}}
# do_test auth-1.84 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}

# ifcapable tempdb {
#   do_test auth-1.85 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_CREATE_TEMP_VIEW"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4] 
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMPORARY VIEW v1 AS SELECT a+1,b+1 FROM t2}
#   } {1 {not authorized}}
#   do_test auth-1.86 {
#     set ::authargs
#   } {v1 {} temp {}}
#   do_test auth-1.87 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.88 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_CREATE_TEMP_VIEW"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4] 
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMPORARY VIEW v1 AS SELECT a+1,b+1 FROM t2}
#   } {0 {}}
#   do_test auth-1.89 {
#     set ::authargs
#   } {v1 {} temp {}}
#   do_test auth-1.90 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
# }

# do_test auth-1.91 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE VIEW v1 AS SELECT a+1,b+1 FROM t2}
# } {1 {not authorized}}
# do_test auth-1.92 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.93 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE VIEW v1 AS SELECT a+1,b+1 FROM t2}
# } {0 {}}
# do_test auth-1.94 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}

# ifcapable tempdb {
#   do_test auth-1.95 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_INSERT" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMPORARY VIEW v1 AS SELECT a+1,b+1 FROM t2}
#   } {1 {not authorized}}
#   do_test auth-1.96 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.97 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_INSERT" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE TEMPORARY VIEW v1 AS SELECT a+1,b+1 FROM t2}
#   } {0 {}}
#   do_test auth-1.98 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
# }

# do_test auth-1.99 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE VIEW v2 AS SELECT a+1,b+1 FROM t2;
#     DROP VIEW v2
#   }
# } {1 {not authorized}}
# do_test auth-1.100 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 v2}
# do_test auth-1.101 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_VIEW"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP VIEW v2}
# } {1 {not authorized}}
# do_test auth-1.102 {
#   set ::authargs
# } {v2 {} main {}}
# do_test auth-1.103 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 v2}
# do_test auth-1.104 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP VIEW v2}
# } {0 {}}
# do_test auth-1.105 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 v2}
# do_test auth-1.106 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_VIEW"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP VIEW v2}
# } {0 {}}
# do_test auth-1.107 {
#   set ::authargs
# } {v2 {} main {}}
# do_test auth-1.108 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 v2}
# do_test auth-1.109 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_VIEW"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP VIEW v2}
# } {0 {}}
# do_test auth-1.110 {
#   set ::authargs
# } {v2 {} main {}}
# do_test auth-1.111 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}


# ifcapable tempdb {
#   do_test auth-1.112 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DELETE" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {
#       CREATE TEMP VIEW v1 AS SELECT a+1,b+1 FROM t1;
#       DROP VIEW v1
#     }
#   } {1 {not authorized}}
#   do_test auth-1.113 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 v1}
#   do_test auth-1.114 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DROP_TEMP_VIEW"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP VIEW v1}
#   } {1 {not authorized}}
#   do_test auth-1.115 {
#     set ::authargs
#   } {v1 {} temp {}}
#   do_test auth-1.116 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 v1}
#   do_test auth-1.117 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DELETE" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP VIEW v1}
#   } {0 {}}
#   do_test auth-1.118 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 v1}
#   do_test auth-1.119 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DROP_TEMP_VIEW"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP VIEW v1}
#   } {0 {}}
#   do_test auth-1.120 {
#     set ::authargs
#   } {v1 {} temp {}}
#   do_test auth-1.121 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 v1}
#   do_test auth-1.122 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DROP_TEMP_VIEW"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_OK
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP VIEW v1}
#   } {0 {}}
#   do_test auth-1.123 {
#     set ::authargs
#   } {v1 {} temp {}}
#   do_test auth-1.124 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
# }
# } ;# ifcapable view

# # Test cases auth-1.125 to auth-1.176 test creating and dropping triggers.
# # Omit these if the library was compiled with triggers omitted.
# #
# ifcapable trigger&&tempdb {
# do_test auth-1.125 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r2 DELETE on t2 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {1 {not authorized}}
# do_test auth-1.126 {
#   set ::authargs
# } {r2 t2 main {}}
# do_test auth-1.127 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.128 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r2 DELETE on t2 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {1 {not authorized}}
# do_test auth-1.129 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.130 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r2 DELETE on t2 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {0 {}}
# do_test auth-1.131 {
#   set ::authargs
# } {r2 t2 main {}}
# do_test auth-1.132 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.133 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r2 DELETE on t2 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {0 {}}
# do_test auth-1.134 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.135 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TABLE tx(id);
#     CREATE TRIGGER r2 AFTER INSERT ON t2 BEGIN
#        INSERT INTO tx VALUES(NEW.rowid);
#     END;
#   }
# } {0 {}}
# do_test auth-1.136.1 {
#   set ::authargs
# } {r2 t2 main {}}
# do_test auth-1.136.2 {
#   execsql {
#     SELECT name FROM sqlite_master WHERE type='trigger'
#   }
# } {r2}
# do_test auth-1.136.3 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     lappend ::authargs $code $arg1 $arg2 $arg3 $arg4
#     return SQLITE_OK
#   }
#   set ::authargs {}
#   execsql {
#     INSERT INTO t2 VALUES(1,2,3);
#   }
#   set ::authargs 
# } {SQLITE_INSERT t2 {} main {} SQLITE_INSERT tx {} main r2 SQLITE_READ t2 ROWID main r2}
# do_test auth-1.136.4 {
#   execsql {
#     SELECT * FROM tx;
#   }
# } {3}
# do_test auth-1.137 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 tx r2}
# do_test auth-1.138 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TEMP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r1 DELETE on t1 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {1 {not authorized}}
# do_test auth-1.139 {
#   set ::authargs
# } {r1 t1 temp {}}
# do_test auth-1.140 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1}
# do_test auth-1.141 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_temp_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r1 DELETE on t1 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {1 {not authorized}}
# do_test auth-1.142 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1}
# do_test auth-1.143 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TEMP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r1 DELETE on t1 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {0 {}}
# do_test auth-1.144 {
#   set ::authargs
# } {r1 t1 temp {}}
# do_test auth-1.145 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1}
# do_test auth-1.146 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_temp_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r1 DELETE on t1 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {0 {}}
# do_test auth-1.147 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1}
# do_test auth-1.148 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_TEMP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     CREATE TRIGGER r1 DELETE on t1 BEGIN
#         SELECT NULL;
#     END;
#   }
# } {0 {}}
# do_test auth-1.149 {
#   set ::authargs
# } {r1 t1 temp {}}
# do_test auth-1.150 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1 r1}

# do_test auth-1.151 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r2}
# } {1 {not authorized}}
# do_test auth-1.152 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 tx r2}
# do_test auth-1.153 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r2}
# } {1 {not authorized}}
# do_test auth-1.154 {
#   set ::authargs
# } {r2 t2 main {}}
# do_test auth-1.155 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 tx r2}
# do_test auth-1.156 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r2}
# } {0 {}}
# do_test auth-1.157 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 tx r2}
# do_test auth-1.158 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r2}
# } {0 {}}
# do_test auth-1.159 {
#   set ::authargs
# } {r2 t2 main {}}
# do_test auth-1.160 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 tx r2}
# do_test auth-1.161 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r2}
# } {0 {}}
# do_test auth-1.162 {
#   set ::authargs
# } {r2 t2 main {}}
# do_test auth-1.163 {
#   execsql {
#     DROP TABLE tx;
#     DELETE FROM t2 WHERE a=1 AND b=2 AND c=3;
#     SELECT name FROM sqlite_master;
#   }
# } {t2}

# do_test auth-1.164 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_temp_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r1}
# } {1 {not authorized}}
# do_test auth-1.165 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1 r1}
# do_test auth-1.166 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_TEMP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r1}
# } {1 {not authorized}}
# do_test auth-1.167 {
#   set ::authargs
# } {r1 t1 temp {}}
# do_test auth-1.168 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1 r1}
# do_test auth-1.169 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_temp_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r1}
# } {0 {}}
# do_test auth-1.170 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1 r1}
# do_test auth-1.171 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_TEMP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r1}
# } {0 {}}
# do_test auth-1.172 {
#   set ::authargs
# } {r1 t1 temp {}}
# do_test auth-1.173 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1 r1}
# do_test auth-1.174 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_TEMP_TRIGGER"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP TRIGGER r1}
# } {0 {}}
# do_test auth-1.175 {
#   set ::authargs
# } {r1 t1 temp {}}
# do_test auth-1.176 {
#   execsql {SELECT name FROM sqlite_temp_master}
# } {t1}
# } ;# ifcapable trigger

# do_test auth-1.177 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_INDEX"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE INDEX i2 ON t2(a)}
# } {1 {not authorized}}
# do_test auth-1.178 {
#   set ::authargs
# } {i2 t2 main {}}
# do_test auth-1.179 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.180 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE INDEX i2 ON t2(a)}
# } {1 {not authorized}}
# do_test auth-1.181 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.182 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_INDEX"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE INDEX i2 ON t2(b)}
# } {0 {}}
# do_test auth-1.183 {
#   set ::authargs
# } {i2 t2 main {}}
# do_test auth-1.184 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.185 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_INSERT" && $arg1=="sqlite_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE INDEX i2 ON t2(b)}
# } {0 {}}
# do_test auth-1.186 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}
# do_test auth-1.187 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_CREATE_INDEX"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {CREATE INDEX i2 ON t2(a)}
# } {0 {}}
# do_test auth-1.188 {
#   set ::authargs
# } {i2 t2 main {}}
# do_test auth-1.189 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 i2}

# ifcapable tempdb {
#   do_test auth-1.190 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_CREATE_TEMP_INDEX"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE INDEX i1 ON t1(a)}
#   } {1 {not authorized}}
#   do_test auth-1.191 {
#     set ::authargs
#   } {i1 t1 temp {}}
#   do_test auth-1.192 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.193 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_INSERT" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE INDEX i1 ON t1(b)}
#   } {1 {not authorized}}
#   do_test auth-1.194 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.195 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_CREATE_TEMP_INDEX"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE INDEX i1 ON t1(b)}
#   } {0 {}}
#   do_test auth-1.196 {
#     set ::authargs
#   } {i1 t1 temp {}}
#   do_test auth-1.197 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.198 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_INSERT" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE INDEX i1 ON t1(c)}
#   } {0 {}}
#   do_test auth-1.199 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
#   do_test auth-1.200 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_CREATE_TEMP_INDEX"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_OK
#       }
#       return SQLITE_OK
#     }
#     catchsql {CREATE INDEX i1 ON t1(a)}
#   } {0 {}}
#   do_test auth-1.201 {
#     set ::authargs
#   } {i1 t1 temp {}}
#   do_test auth-1.202 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 i1}
# }

# do_test auth-1.203 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_master"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP INDEX i2}
# } {1 {not authorized}}
# do_test auth-1.204 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 i2}
# do_test auth-1.205 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_INDEX"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP INDEX i2}
# } {1 {not authorized}}
# do_test auth-1.206 {
#   set ::authargs
# } {i2 t2 main {}}
# do_test auth-1.207 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 i2}
# do_test auth-1.208 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DELETE" && $arg1=="sqlite_master"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP INDEX i2}
# } {0 {}}
# do_test auth-1.209 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 i2}
# do_test auth-1.210 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_INDEX"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP INDEX i2}
# } {0 {}}
# do_test auth-1.211 {
#   set ::authargs
# } {i2 t2 main {}}
# do_test auth-1.212 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2 i2}
# do_test auth-1.213 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_DROP_INDEX"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {DROP INDEX i2}
# } {0 {}}
# do_test auth-1.214 {
#   set ::authargs
# } {i2 t2 main {}}
# do_test auth-1.215 {
#   execsql {SELECT name FROM sqlite_master}
# } {t2}

# ifcapable tempdb {
#   do_test auth-1.216 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DELETE" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP INDEX i1}
#   } {1 {not authorized}}
#   do_test auth-1.217 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 i1}
#   do_test auth-1.218 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DROP_TEMP_INDEX"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP INDEX i1}
#   } {1 {not authorized}}
#   do_test auth-1.219 {
#     set ::authargs
#   } {i1 t1 temp {}}
#   do_test auth-1.220 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 i1}
#   do_test auth-1.221 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DELETE" && $arg1=="sqlite_temp_master"} {
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP INDEX i1}
#   } {0 {}}
#   do_test auth-1.222 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 i1}
#   do_test auth-1.223 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DROP_TEMP_INDEX"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP INDEX i1}
#   } {0 {}}
#   do_test auth-1.224 {
#     set ::authargs
#   } {i1 t1 temp {}}
#   do_test auth-1.225 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1 i1}
#   do_test auth-1.226 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DROP_TEMP_INDEX"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_OK
#       }
#       return SQLITE_OK
#     }
#     catchsql {DROP INDEX i1}
#   } {0 {}}
#   do_test auth-1.227 {
#     set ::authargs
#   } {i1 t1 temp {}}
#   do_test auth-1.228 {
#     execsql {SELECT name FROM sqlite_temp_master}
#   } {t1}
# }

# do_test auth-1.229 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_PRAGMA"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {PRAGMA full_column_names=on}
# } {1 {not authorized}}
# do_test auth-1.230 {
#   set ::authargs
# } {full_column_names on {} {}}
# do_test auth-1.231 {
#   execsql2 {SELECT a FROM t2}
# } {a 11 a 7}
# do_test auth-1.232 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_PRAGMA"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {PRAGMA full_column_names=on}
# } {0 {}}
# do_test auth-1.233 {
#   set ::authargs
# } {full_column_names on {} {}}
# do_test auth-1.234 {
#   execsql2 {SELECT a FROM t2}
# } {a 11 a 7}
# do_test auth-1.235 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_PRAGMA"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {PRAGMA full_column_names=on}
# } {0 {}}
# do_test auth-1.236 {
#   execsql2 {SELECT a FROM t2}
# } {t2.a 11 t2.a 7}
# do_test auth-1.237 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_PRAGMA"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {PRAGMA full_column_names=OFF}
# } {0 {}}
# do_test auth-1.238 {
#   set ::authargs
# } {full_column_names OFF {} {}}
# do_test auth-1.239 {
#   execsql2 {SELECT a FROM t2}
# } {a 11 a 7}

# do_test auth-1.240 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_TRANSACTION"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {BEGIN}
# } {1 {not authorized}}
# do_test auth-1.241 {
#   set ::authargs
# } {BEGIN {} {} {}}
# do_test auth-1.242 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_TRANSACTION" && $arg1!="BEGIN"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {BEGIN; INSERT INTO t2 VALUES(44,55,66); COMMIT}
# } {1 {not authorized}}
# do_test auth-1.243 {
#   set ::authargs
# } {COMMIT {} {} {}}
# do_test auth-1.244 {
#   execsql {SELECT * FROM t2}
# } {11 2 33 7 8 9 44 55 66}
# do_test auth-1.245 {
#   catchsql {ROLLBACK}
# } {1 {not authorized}}
# do_test auth-1.246 {
#   set ::authargs
# } {ROLLBACK {} {} {}}
# do_test auth-1.247 {
#   catchsql {END TRANSACTION}
# } {1 {not authorized}}
# do_test auth-1.248 {
#   set ::authargs
# } {COMMIT {} {} {}}
# do_test auth-1.249 {
#   db authorizer {}
#   catchsql {ROLLBACK}
# } {0 {}}
# do_test auth-1.250 {
#   execsql {SELECT * FROM t2}
# } {11 2 33 7 8 9}

# # ticket #340 - authorization for ATTACH and DETACH.
# #
# ifcapable attach {
#   do_test auth-1.251 {
#     db authorizer ::auth
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_ATTACH"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       }
#       return SQLITE_OK
#     }
#     catchsql {
#       ATTACH DATABASE ':memory:' AS test1
#     }
#   } {0 {}}
#   do_test auth-1.252a {
#     set ::authargs
#   } {:memory: {} {} {}}
#   do_test auth-1.252b {
#     db eval {DETACH test1}
#     set ::attachfilename :memory:
#     db eval {ATTACH $::attachfilename AS test1}
#     set ::authargs
#   } {{} {} {} {}}
#   do_test auth-1.252c {
#     db eval {DETACH test1}
#     db eval {ATTACH ':mem' || 'ory:' AS test1}
#     set ::authargs
#   } {{} {} {} {}}
#   do_test auth-1.253 {
#     catchsql {DETACH DATABASE test1}
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_ATTACH"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {
#       ATTACH DATABASE ':memory:' AS test1;
#     }
#   } {1 {not authorized}}
#   do_test auth-1.254 {
#     lindex [execsql {PRAGMA database_list}] 7
#   } {}
#   do_test auth-1.255 {
#     catchsql {DETACH DATABASE test1}
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_ATTACH"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {
#       ATTACH DATABASE ':memory:' AS test1;
#     }
#   } {0 {}}
#   do_test auth-1.256 {
#     lindex [execsql {PRAGMA database_list}] 7
#   } {}
#   do_test auth-1.257 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DETACH"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_OK
#       }
#       return SQLITE_OK
#     }
#     execsql {ATTACH DATABASE ':memory:' AS test1}
#     catchsql {
#       DETACH DATABASE test1;
#     }
#   } {0 {}}
#   do_test auth-1.258 {
#     lindex [execsql {PRAGMA database_list}] 7
#   } {}
#   do_test auth-1.259 {
#     execsql {ATTACH DATABASE ':memory:' AS test1}
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_DETACH"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {
#       DETACH DATABASE test1;
#     }
#   } {0 {}}
#   ifcapable tempdb {
#     ifcapable schema_pragmas {
#     do_test auth-1.260 {
#       lindex [execsql {PRAGMA database_list}] 7
#     } {test1}
#     } ;# ifcapable schema_pragmas
#     do_test auth-1.261 {
#       proc auth {code arg1 arg2 arg3 arg4 args} {
#         if {$code=="SQLITE_DETACH"} {
#           set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#           return SQLITE_DENY
#         }
#         return SQLITE_OK
#       }
#       catchsql {
#         DETACH DATABASE test1;
#       }
#     } {1 {not authorized}}
#     ifcapable schema_pragmas {
#     do_test auth-1.262 {
#       lindex [execsql {PRAGMA database_list}] 7
#     } {test1}
#     } ;# ifcapable schema_pragmas
#     db authorizer {}
#     execsql {DETACH DATABASE test1}
#     db authorizer ::auth
    
#     # Authorization for ALTER TABLE. These tests are omitted if the library
#     # was built without ALTER TABLE support.
#     ifcapable altertable {
    
#       do_test auth-1.263 {
#         proc auth {code arg1 arg2 arg3 arg4 args} {
#           if {$code=="SQLITE_ALTER_TABLE"} {
#             set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#             return SQLITE_OK
#           }
#           return SQLITE_OK
#         }
#         catchsql {
#           ALTER TABLE t1 RENAME TO t1x
#         }
#       } {0 {}}
#       do_test auth-1.264 {
#         execsql {SELECT name FROM sqlite_temp_master WHERE type='table'}
#       } {t1x}
#       do_test auth-1.265 {
#         set authargs
#       } {temp t1 {} {}}
#       do_test auth-1.266 {
#         proc auth {code arg1 arg2 arg3 arg4 args} {
#           if {$code=="SQLITE_ALTER_TABLE"} {
#             set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#             return SQLITE_IGNORE
#           }
#           return SQLITE_OK
#         }
#         catchsql {
#           ALTER TABLE t1x RENAME TO t1
#         }
#       } {0 {}}
#       do_test auth-1.267 {
#         execsql {SELECT name FROM sqlite_temp_master WHERE type='table'}
#       } {t1x}
#       do_test auth-1.268 {
#         set authargs
#       } {temp t1x {} {}}
#       do_test auth-1.269 {
#         proc auth {code arg1 arg2 arg3 arg4 args} {
#           if {$code=="SQLITE_ALTER_TABLE"} {
#             set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#             return SQLITE_DENY
#           }
#           return SQLITE_OK
#         }
#         catchsql {
#           ALTER TABLE t1x RENAME TO t1
#         }
#       } {1 {not authorized}}
#       do_test auth-1.270 {
#         execsql {SELECT name FROM sqlite_temp_master WHERE type='table'}
#       } {t1x}
  
#       do_test auth-1.271 {
#         set authargs
#       } {temp t1x {} {}}
#     } ;# ifcapable altertable
  
#   } else {
#     db authorizer {}
#     db eval {
#       DETACH DATABASE test1;
#     }
#   }
# }

# ifcapable  altertable {
# db authorizer {}
# catchsql {ALTER TABLE t1x RENAME TO t1}
# db authorizer ::auth
# do_test auth-1.272 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_ALTER_TABLE"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_OK
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     ALTER TABLE t2 RENAME TO t2x
#   }
# } {0 {}}
# do_test auth-1.273 {
#   execsql {SELECT name FROM sqlite_master WHERE type='table'}
# } {t2x}
# do_test auth-1.274 {
#   set authargs
# } {main t2 {} {}}
# do_test auth-1.275 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_ALTER_TABLE"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     ALTER TABLE t2x RENAME TO t2
#   }
# } {0 {}}
# do_test auth-1.276 {
#   execsql {SELECT name FROM sqlite_master WHERE type='table'}
# } {t2x}
# do_test auth-1.277 {
#   set authargs
# } {main t2x {} {}}
# do_test auth-1.278 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_ALTER_TABLE"} {
#       set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   catchsql {
#     ALTER TABLE t2x RENAME TO t2
#   }
# } {1 {not authorized}}
# do_test auth-1.279 {
#   execsql {SELECT name FROM sqlite_master WHERE type='table'}
# } {t2x}
# do_test auth-1.280 {
#   set authargs
# } {main t2x {} {}}
# db authorizer {}
# catchsql {ALTER TABLE t2x RENAME TO t2}

# } ;# ifcapable altertable

# # Test the authorization callbacks for the REINDEX command.
# ifcapable reindex {

# proc auth {code args} {
#   if {$code=="SQLITE_REINDEX"} {
#     set ::authargs [concat $::authargs [lrange $args 0 3]]
#   }
#   return SQLITE_OK
# }
# db authorizer auth
# do_test auth-1.281 {
#   execsql {
#     CREATE TABLE t3(a PRIMARY KEY, b, c);
#     CREATE INDEX t3_idx1 ON t3(c COLLATE BINARY);
#     CREATE INDEX t3_idx2 ON t3(b COLLATE NOCASE);
#   }
# } {}
# do_test auth-1.282 {
#   set ::authargs {}
#   execsql {
#     REINDEX t3_idx1;
#   }
#   set ::authargs
# } {t3_idx1 {} main {}}
# do_test auth-1.283 {
#   set ::authargs {}
#   execsql {
#     REINDEX BINARY;
#   }
#   set ::authargs
# } {t3_idx1 {} main {} sqlite_autoindex_t3_1 {} main {}}
# do_test auth-1.284 {
#   set ::authargs {}
#   execsql {
#     REINDEX NOCASE;
#   }
#   set ::authargs
# } {t3_idx2 {} main {}}
# do_test auth-1.285 {
#   set ::authargs {}
#   execsql {
#     REINDEX t3;
#   }
#   set ::authargs
# } {t3_idx2 {} main {} t3_idx1 {} main {} sqlite_autoindex_t3_1 {} main {}}
# do_test auth-1.286 {
#   execsql {
#     DROP TABLE t3;
#   }
# } {}
# ifcapable tempdb {
#   do_test auth-1.287 {
#     execsql {
#       CREATE TEMP TABLE t3(a PRIMARY KEY, b, c);
#       CREATE INDEX t3_idx1 ON t3(c COLLATE BINARY);
#       CREATE INDEX t3_idx2 ON t3(b COLLATE NOCASE);
#     }
#   } {}
#   do_test auth-1.288 {
#     set ::authargs {}
#     execsql {
#       REINDEX temp.t3_idx1;
#     }
#     set ::authargs
#   } {t3_idx1 {} temp {}}
#   do_test auth-1.289 {
#     set ::authargs {}
#     execsql {
#       REINDEX BINARY;
#     }
#     set ::authargs
#   } {t3_idx1 {} temp {} sqlite_autoindex_t3_1 {} temp {}}
#   do_test auth-1.290 {
#     set ::authargs {}
#     execsql {
#       REINDEX NOCASE;
#     }
#     set ::authargs
#   } {t3_idx2 {} temp {}}
#   do_test auth-1.291 {
#     set ::authargs {}
#     execsql {
#       REINDEX temp.t3;
#     }
#     set ::authargs
#   } {t3_idx2 {} temp {} t3_idx1 {} temp {} sqlite_autoindex_t3_1 {} temp {}}
#   proc auth {code args} {
#     if {$code=="SQLITE_REINDEX"} {
#       set ::authargs [concat $::authargs [lrange $args 0 3]]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   do_test auth-1.292 {
#     set ::authargs {}
#     catchsql {
#       REINDEX temp.t3;
#     }
#   } {1 {not authorized}}
#   do_test auth-1.293 {
#     execsql {
#       DROP TABLE t3;
#     }
#   } {}
# }

# } ;# ifcapable reindex 

# ifcapable analyze {
#   proc auth {code args} {
#     if {$code=="SQLITE_ANALYZE"} {
#       set ::authargs [concat $::authargs [lrange $args 0 3]]
#     }
#     return SQLITE_OK
#   }
#   do_test auth-1.294 {
#     set ::authargs {}
#     execsql {
#       CREATE TABLE t4(a,b,c);
#       CREATE INDEX t4i1 ON t4(a);
#       CREATE INDEX t4i2 ON t4(b,a,c);
#       INSERT INTO t4 VALUES(1,2,3);
#       ANALYZE;
#     }
#     set ::authargs
#   } {t4 {} main {} t2 {} main {}}
#   do_test auth-1.295 {
#     execsql {
#       SELECT count(*) FROM sqlite_stat1;
#     }
#   } 3
#   proc auth {code args} {
#     if {$code=="SQLITE_ANALYZE"} {
#       set ::authargs [concat $::authargs $args]
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   do_test auth-1.296 {
#     set ::authargs {}
#     catchsql {
#       ANALYZE;
#     }
#   } {1 {not authorized}}
#   do_test auth-1.297 {
#     execsql {
#       SELECT count(*) FROM sqlite_stat1;
#     }
#   } 3
# } ;# ifcapable analyze


# # Authorization for ALTER TABLE ADD COLUMN.
# # These tests are omitted if the library
# # was built without ALTER TABLE support.
# ifcapable {altertable} {
#   do_test auth-1.300 {
#     execsql {CREATE TABLE t5(x)}
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_ALTER_TABLE"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_OK
#       }
#       return SQLITE_OK
#     }
#     catchsql {
#       ALTER TABLE t5 ADD COLUMN new_col_1;
#     }
#   } {0 {}}
#   do_test auth-1.301 {
#     set x [execsql {SELECT sql FROM sqlite_master WHERE name='t5'}]
#     regexp new_col_1 $x
#   } {1}
#   do_test auth-1.302 {
#     set authargs
#   } {main t5 {} {}}
#   do_test auth-1.303 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_ALTER_TABLE"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     catchsql {
#       ALTER TABLE t5 ADD COLUMN new_col_2;
#     }
#   } {0 {}}
#   do_test auth-1.304 {
#     set x [execsql {SELECT sql FROM sqlite_master WHERE name='t5'}]
#     regexp new_col_2 $x
#   } {0}
#   do_test auth-1.305 {
#     set authargs
#   } {main t5 {} {}}
#   do_test auth-1.306 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_ALTER_TABLE"} {
#         set ::authargs [list $arg1 $arg2 $arg3 $arg4]
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     catchsql {
#       ALTER TABLE t5 ADD COLUMN new_col_3
#     }
#   } {1 {not authorized}}
#   do_test auth-1.307 {
#     set x [execsql {SELECT sql FROM sqlite_temp_master WHERE type='t5'}]
#     regexp new_col_3 $x
#   } {0}

#   do_test auth-1.308 {
#     set authargs
#   } {main t5 {} {}}
#   execsql {DROP TABLE t5}
# } ;# ifcapable altertable

# ifcapable {cte} {
#   do_test auth-1.310 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_RECURSIVE"} {
#         return SQLITE_DENY
#       }
#       return SQLITE_OK
#     }
#     db eval {
#        DROP TABLE IF EXISTS t1;
#        CREATE TABLE t1(a,b);
#        INSERT INTO t1 VALUES(1,2),(3,4),(5,6);
#     }
#   } {}
#   do_catchsql_test auth-1.311 {
#     WITH
#        auth1311(x,y) AS (SELECT a+b, b-a FROM t1)
#     SELECT * FROM auth1311 ORDER BY x;
#   } {0 {3 1 7 1 11 1}}
#   do_catchsql_test auth-1.312 {
#     WITH RECURSIVE
#        auth1312(x,y) AS (SELECT a+b, b-a FROM t1)
#     SELECT x, y FROM auth1312 ORDER BY x;
#   } {0 {3 1 7 1 11 1}}
#   do_catchsql_test auth-1.313 {
#     WITH RECURSIVE
#        auth1313(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM auth1313 WHERE x<5)
#     SELECT * FROM t1;
#   } {0 {1 2 3 4 5 6}}
#   do_catchsql_test auth-1.314 {
#     WITH RECURSIVE
#        auth1314(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM auth1314 WHERE x<5)
#     SELECT * FROM t1 LEFT JOIN auth1314;
#   } {1 {not authorized}}
# } ;# ifcapable cte

# do_test auth-2.1 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t3" && $arg2=="x"} {
#       return SQLITE_DENY
#     }
#     return SQLITE_OK
#   }
#   db authorizer ::auth
#   execsql {CREATE TABLE t3(x INTEGER PRIMARY KEY, y, z)}
#   catchsql {SELECT * FROM t3}
# } {1 {access to t3.x is prohibited}}
# do_test auth-2.1 {
#   catchsql {SELECT y,z FROM t3}
# } {0 {}}
# do_test auth-2.2 {
#   catchsql {SELECT ROWID,y,z FROM t3}
# } {1 {access to t3.x is prohibited}}
# do_test auth-2.3 {
#   catchsql {SELECT OID,y,z FROM t3}
# } {1 {access to t3.x is prohibited}}
# do_test auth-2.4 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t3" && $arg2=="x"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   execsql {INSERT INTO t3 VALUES(44,55,66)}
#   catchsql {SELECT * FROM t3}
# } {0 {{} 55 66}}
# do_test auth-2.5 {
#   catchsql {SELECT rowid,y,z FROM t3}
# } {0 {{} 55 66}}
# do_test auth-2.6 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t3" && $arg2=="ROWID"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t3}
# } {0 {44 55 66}}
# do_test auth-2.7 {
#   catchsql {SELECT ROWID,y,z FROM t3}
# } {0 {44 55 66}}
# do_test auth-2.8 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="ROWID"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT ROWID,b,c FROM t2}
# } {0 {{} 2 33 {} 8 9}}
# do_test auth-2.9.1 {
#   # We have to flush the cache here in case the Tcl interface tries to
#   # reuse a statement compiled with sqlite3_prepare_v2(). In this case,
#   # the first error encountered is an SQLITE_SCHEMA error. Then, when
#   # trying to recompile the statement, the authorization error is encountered.
#   # If we do not flush the cache, the correct error message is returned, but
#   # the error code is SQLITE_SCHEMA, not SQLITE_ERROR as required by the test
#   # case after this one.
#   #
#   db cache flush

#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="ROWID"} {
#       return bogus
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT ROWID,b,c FROM t2}
# } {1 {authorizer malfunction}}
# do_test auth-2.9.2 {
#   db errorcode
# } {1}
# do_test auth-2.10 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_SELECT"} {
#       return bogus
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT ROWID,b,c FROM t2}
# } {1 {authorizer malfunction}}
# do_test auth-2.11.1 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg2=="a"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2, t3}
# } {0 {{} 2 33 44 55 66 {} 8 9 44 55 66}}
# do_test auth-2.11.2 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     if {$code=="SQLITE_READ" && $arg2=="x"} {
#       return SQLITE_IGNORE
#     }
#     return SQLITE_OK
#   }
#   catchsql {SELECT * FROM t2, t3}
# } {0 {11 2 33 {} 55 66 7 8 9 {} 55 66}}

# # Make sure the OLD and NEW pseudo-tables of a trigger get authorized.
# #
# ifcapable trigger {
#   do_test auth-3.1 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       return SQLITE_OK
#     }
#     execsql {
#       CREATE TABLE tx(a1,a2,b1,b2,c1,c2);
#       CREATE TRIGGER r1 AFTER UPDATE ON t2 FOR EACH ROW BEGIN
#         INSERT INTO tx VALUES(OLD.a,NEW.a,OLD.b,NEW.b,OLD.c,NEW.c);
#       END;
#       UPDATE t2 SET a=a+1;
#       SELECT * FROM tx;
#     }
#   } {11 12 2 2 33 33 7 8 8 8 9 9}
#   do_test auth-3.2 {
#     proc auth {code arg1 arg2 arg3 arg4 args} {
#       if {$code=="SQLITE_READ" && $arg1=="t2" && $arg2=="c"} {
#         return SQLITE_IGNORE
#       }
#       return SQLITE_OK
#     }
#     execsql {
#       DELETE FROM tx;
#       UPDATE t2 SET a=a+100;
#       SELECT * FROM tx;
#     }
#   } {12 112 2 2 {} {} 8 108 8 8 {} {}}
# } ;# ifcapable trigger

# # Make sure the names of views and triggers are passed on on arg4.
# #
# ifcapable trigger {
# do_test auth-4.1 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     lappend ::authargs $code $arg1 $arg2 $arg3 $arg4
#     return SQLITE_OK
#   }
#   set authargs {}
#   execsql {
#     UPDATE t2 SET a=a+1;
#   }
#   set authargs
# } [list \
#   SQLITE_READ   t2 a  main {} \
#   SQLITE_UPDATE t2 a  main {} \
#   SQLITE_INSERT tx {} main r1 \
#   SQLITE_READ   t2 a  main r1 \
#   SQLITE_READ   t2 a  main r1 \
#   SQLITE_READ   t2 b  main r1 \
#   SQLITE_READ   t2 b  main r1 \
#   SQLITE_READ   t2 c  main r1 \
#   SQLITE_READ   t2 c  main r1]
# }

# ifcapable {view && trigger} {
# do_test auth-4.2 {
#   execsql {
#     CREATE VIEW v1 AS SELECT a+b AS x FROM t2;
#     CREATE TABLE v1chng(x1,x2);
#     CREATE TRIGGER r2 INSTEAD OF UPDATE ON v1 BEGIN
#       INSERT INTO v1chng VALUES(OLD.x,NEW.x);
#     END;
#     SELECT * FROM v1;
#   }
# } {115 117}
# do_test auth-4.3 {
#   set authargs {}
#   execsql {
#     UPDATE v1 SET x=1 WHERE x=117
#   }
#   set authargs
# } [list \
#   SQLITE_UPDATE v1     x  main {} \
#   SQLITE_SELECT {}     {} {}   v1 \
#   SQLITE_READ   t2     a  main v1 \
#   SQLITE_READ   t2     b  main v1 \
#   SQLITE_READ   v1     x  main v1 \
#   SQLITE_READ   v1     x  main v1 \
#   SQLITE_SELECT {}     {} {} v1   \
#   SQLITE_READ   v1     x  main v1 \
#   SQLITE_INSERT v1chng {} main r2 \
#   SQLITE_READ   v1     x  main r2 \
#   SQLITE_READ   v1     x  main r2 \
# ]

# do_test auth-4.4 {
#   execsql {
#     CREATE TRIGGER r3 INSTEAD OF DELETE ON v1 BEGIN
#       INSERT INTO v1chng VALUES(OLD.x,NULL);
#     END;
#     SELECT * FROM v1;
#   }
# } {115 117}
# do_test auth-4.5 {
#   set authargs {}
#   execsql {
#     DELETE FROM v1 WHERE x=117
#   }
#   set authargs
# } [list \
#   SQLITE_DELETE v1     {} main {} \
#   SQLITE_SELECT {}     {} {}   v1 \
#   SQLITE_READ   t2     a  main v1 \
#   SQLITE_READ   t2     b  main v1 \
#   SQLITE_READ   v1     x  main v1 \
#   SQLITE_READ   v1     x  main v1 \
#   SQLITE_SELECT {}     {} {} v1   \
#   SQLITE_READ   v1     x  main v1 \
#   SQLITE_INSERT v1chng {} main r3 \
#   SQLITE_READ   v1     x  main r3 \
# ]

# } ;# ifcapable view && trigger

# # Ticket #1338:  Make sure authentication works in the presence of an AS
# # clause.
# #
# do_test auth-5.1 {
#   proc auth {code arg1 arg2 arg3 arg4 args} {
#     return SQLITE_OK
#   }
#   execsql {
#     SELECT count(a) AS cnt FROM t4 ORDER BY cnt
#   }
# } {1}

# # Ticket #1607
# #
# ifcapable compound&&subquery {
#   ifcapable trigger {
#     execsql {
#       DROP TABLE tx;
#     }
#     ifcapable view {
#       execsql {
#         DROP TABLE v1chng;
#       }
#     }
#   }
#   ifcapable stat4 {
#     set stat4 "sqlite_stat4 "
#   } else {
#     ifcapable stat3 {
#       set stat4 "sqlite_stat3 "
#     } else {
#       set stat4 ""
#     }
#   }
#   do_test auth-5.2 {
#     execsql {
#       SELECT name FROM (
#         SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master)
#       WHERE type='table'
#       ORDER BY name
#     }
#   } "sqlite_stat1 ${stat4}t1 t2 t3 t4"
# }

# # Ticket #3944
# #
# ifcapable trigger {
#   do_test auth-5.3.1 {
#     execsql {
#       CREATE TABLE t5 ( x );
#       CREATE TRIGGER t5_tr1 AFTER INSERT ON t5 BEGIN 
#         UPDATE t5 SET x = 1 WHERE NEW.x = 0;
#       END;
#     }
#   } {}
#   set ::authargs [list]
#   proc auth {args} {
#     eval lappend ::authargs [lrange $args 0 4]
#     return SQLITE_OK
#   }
#   do_test auth-5.3.2 {
#     execsql { INSERT INTO t5 (x) values(0) }
#     set ::authargs
#   } [list SQLITE_INSERT t5 {} main {}    \
#           SQLITE_UPDATE t5 x main t5_tr1 \
#           SQLITE_READ t5 x main t5_tr1   \
#     ]
#   do_test auth-5.3.2 {
#     execsql { SELECT * FROM t5 }
#   } {1}
# }

# # Ticket [0eb70d77cb05bb22720]:  Invalid pointer passsed to the authorizer
# # callback when updating a ROWID.
# #
# do_test auth-6.1 {
#   execsql {
#     CREATE TABLE t6(a,b,c,d,e,f,g,h);
#     INSERT INTO t6 VALUES(1,2,3,4,5,6,7,8);
#   }
# } {}
# set ::authargs [list]
# proc auth {args} {
#   eval lappend ::authargs [lrange $args 0 4]
#   return SQLITE_OK
# }
# do_test auth-6.2 {
#   execsql {UPDATE t6 SET rowID=rowID+100}
#   set ::authargs
# } [list SQLITE_READ   t6 ROWID main {} \
#         SQLITE_UPDATE t6 ROWID main {} \
# ]
# do_test auth-6.3 {
#   execsql {SELECT rowid, * FROM t6}
# } {101 1 2 3 4 5 6 7 8}

# rename proc {}
# rename proc_real proc


finish_test
