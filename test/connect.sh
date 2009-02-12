. ../ssu/SSU.sh
. ../ssu/Assert.sh
. ../ssu/Util.sh
JAVA_CMD="java";
JDBC_JAR="oracle/ojdbc14.jar";
JDBC_CLASS="oracle.jdbc.driver.OracleDriver";
JDBC_URL="jdbc:oracle:thin:@localhost:1521:xe";
JDBC_USER="system";
JDBC_PASSWORD="tiger";

_ssu_UtilJar="../ssu/ssu.jar"
_ssu_jarsep=";"

u_db_delete EMP
u_db_insert k.data EMP
u_db_select_to hoge.data EMP

assert_db k.data EMP
assert_db hoge.data EMP


