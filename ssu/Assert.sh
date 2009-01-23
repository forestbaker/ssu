#!/bin/sh

################################################################################
# runs Each assert
################################################################################
_ssu_AssertSetUp(){
        _ssu_CurrentAssertIndex=$((${_ssu_CurrentAssertIndex}+1));
}

################################################################################
# assert_num
# number check function
# $1 expect Value
# $2 actual Value 
# $3 comment (option)
################################################################################
assert_num(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_num";
	fi

	typeset expect_value="${1}";
	typeset actual_value="${2}";
	typeset comment=" ";

	if [ $# = 3 ]
	then
		comment="${3}";
	fi

	if [ ${expect_value} -eq ${actual_value} ]
	then
		_ssu_succeedLog "assert_num" "${comment}";
	else
		_ssu_FailLog_Base  "assert_num" "${expect_value}" "${actual_value}" "${comment}";
	fi
}

################################################################################
# assert_str
# string check function
# $1 expect Value
# $2 actual Value 
# $3 comment (option)
################################################################################
assert_str(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_str";
	fi
	typeset expect_value="${1}";
	typeset actual_value="${2}";
	typeset comment=" ";
	if [ $# = 3 ]
	then
		comment="${3}";
	fi
	
	if [ x"$expect_value" != x"$actual_value" ]
	then 
		_ssu_FailLog_Base  "assert_str" "${expect_value}" "${actual_value}" "${comment}";

	else
		_ssu_succeedLog "assert_str" "${comment}";
	fi
}

################################################################################
# assert_not_same_num
# false check function (${1} != ${2} => true)
# $1 unexpect Value
# $2 actual Value
# $3 comment (option)
################################################################################
assert_not_same_num(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_same_num";
	fi
	typeset unexpect_value="${1}"
	typeset actual_value="${2}"
	typeset comment=" ";
	if [ $# = 3 ]
	then
		comment=$3
	fi

	if [ $unexpect_value -ne $actual_value ]
	then 
		_ssu_succeedLog "assert_not_same_num" "${comment}";
	else
		_ssu_FailLog_False "assert_not_same_num" "${unexpect_value}" "${actual_value}" "${comment}";
	fi
}

################################################################################
# assert_not_same_str
# false check function (${1} != ${2} => true)
# $1 unexpect Value
# $2 actual Value
# $3 comment (option)
################################################################################
assert_not_same_str(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_same_str";
	fi
	typeset unexpect_value=x"${1}"
	typeset actual_value=x"${2}"
	typeset comment=" ";
	if [ $# = 3 ]
	then
		comment=$3
	fi

	if [ "$unexpect_value" = "$actual_value" ]
	then 
		_ssu_FailLog_False "assert_not_same_str" "${unexpect_value}" "${actual_value}" "${comment}";

	else
		_ssu_succeedLog "assert_not_same_str" "${comment}";
	fi
}

################################################################################
# assert_return_code
# return code check function
# $1 command
# $2 return code
# $3 comment (option)
################################################################################
assert_return_code(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_return_code";
	fi

	typeset command="${1}";
	typeset expect_ret_value="${2}";
	typeset comment=" ";

	if [ $# = 3 ]
	then
		comment="${3}";
	fi

	${command}
	typeset actual_value=$?

	if [ ${expect_ret_value} -ne ${actual_value} ]
	then 
		_ssu_FailLog_Base  "assert_return_code" "${expect_ret_value}" "${actual_value}" "${comment}";

	else
		_ssu_succeedLog "assert_return_code" "${comment}";
	fi
}


################################################################################
# assert_exit_code
# exit code check function
# $1 command
# $2 exit code
# $3 comment (option)
################################################################################
assert_exit_code(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_exit_code";
	fi

	typeset command="${1}";
	typeset expect_ret_value="${2}";
	typeset comment=" ";

	if [ $# = 3 ]
	then
		comment="${3}";
	fi

	${command} &
	typeset jid=$!;
	wait $jid;
	typeset actual_value=$?

	if [ ${expect_ret_value} -ne ${actual_value} ]
	then 
		_ssu_FailLog_Base  "assert_exit_code" "${expect_ret_value}" "${actual_value}" "${comment}";
	else
		_ssu_succeedLog "assert_exit_code" "${comment}";
	fi
}



################################################################################
# assert_true
# condition check function
# $1 condition
# $2 comment (option)
# example : assert_true "1 > 0"
################################################################################
assert_true(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_true";
	fi

	typeset condition="${1}";
	typeset comment=" ";

	if [ $# = 2 ]
	then
		comment="${2}";
	fi

	if [ ${condition} ]
	then 
		_ssu_succeedLog "assert_true" "${comment}";

	else
		_ssu_FailLog_Base  "assert_true" "${condition}" "true" "${comment}";
	fi
}

################################################################################
# assert_false
# condition check function
# $1 condition
# $2 comment (option)
# example : assert_false "1 < 0"
################################################################################
assert_false(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_false";
	fi

	typeset condition="${1}";
	typeset comment=" ";

	if [ $# = 2 ]
	then
		comment="${2}";
	fi

	if [ ! ${condition} ]
	then 
		_ssu_succeedLog "assert_false" "${comment}";

	else
		_ssu_FailLog_Base "assert_false" "${condition}" "false" "${comment}";
	fi
}

################################################################################
# assert_dir
# Directory exist check function
# $1 directory name
# $2 comment(option)
################################################################################
assert_dir(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_dir";
	fi
	typeset _dir="${1}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi

	if [ ! -d "${_dir}" ]; then 
		_ssu_FailLog_File "assert_dir" "${_dir}" "${_comment}";
	else
		_ssu_succeedLog "assert_dir" "${_comment}";
	fi
}

################################################################################
# assert_not_found_dir
# Directory not found check function
# $1 directory name
# $2 comment(option)
################################################################################
assert_not_found_dir(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_not_found_dir";
	fi
	typeset _dir="${1}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi

	if [ -d "${_dir}" ]; then 
		_ssu_FailLog_NotFoundFile "assert_not_found_dir" "${_dir}" "${_comment}";
	else
		_ssu_succeedLog "assert_not_found_dir" "${_comment}";
	fi
}
################################################################################
# assert_file
# File exist check function
# $1 file name
# $2 comment (option)
################################################################################
assert_file(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_file";
	fi
	typeset _file="${1}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi

	if [ ! -f "${_file}" ]; then 
		_ssu_FailLog_File  "assert_file" "${_file}" "${_comment}";
	else 
		_ssu_succeedLog "assert_file" "${_comment}";
	fi
}

################################################################################
# assert_not_found_file
# File not found check function
# $1 file name
# $2 comment (option)
################################################################################
assert_not_found_file(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_not_found_file";
	fi
	typeset _file="${1}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi

	if [ -f "${_file}" ]; then 
		_ssu_FailLog_NotFoundFile "assert_not_found_file" "${_file}" "${_comment}";
	else 
		_ssu_succeedLog "assert_not_found_file" "${_comment}";
	fi
}

################################################################################
# assert_blank_str
# blank( "" ) check function
# $1 string
# $2 comment (option)
################################################################################
assert_blank_str(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_blank_str";
	fi
	typeset str="${1}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi

	if [ ! -z "${str}" ]; then
		_ssu_FailLog_Blank "assert_blank_str" "${str}" "${_comment}";
	else
		_ssu_succeedLog "assert_blank_str" "${_comment}";
	fi 
}

################################################################################
# assert_blank_file
# blank file(0byte) check function
# $1 file
# $2 comment (option)
################################################################################
assert_blank_file(){
	_ssu_AssertSetUp;
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_ErrExit "assert_blank_file";
	fi
	typeset file="${1}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi

	if [ -s "${file}" ]; then
		_ssu_FailLog_Blank  "assert_blank_file" "${file}" "${_comment}";
	else
		if [ -f "${file}" ]; then
			_ssu_succeedLog "assert_blank_file" "${_comment}";
		else
			_ssu_FailLog_File  "assert_blank_file" "${file}" "${_comment}";
		fi
	fi 
}

################################################################################
# assert_include
# 
# $1 string
# $2 target
# $3 comment (option)
################################################################################
assert_include(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_include";
	fi
	typeset str="${1}";
	typeset target="${2}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi
	typeset __count_line=`echo "${target}" | grep -c "${str}"`;
	if [ ${__count_line} -eq 0 ];then
		_ssu_FailLog_Include "assert_include" "${str}" "${target}" "${_comment}";
	else
		_ssu_succeedLog "assert_include" "${_comment}";
	fi
}

################################################################################
# assert_include_in_file
# 
# $1 string
# $2 file
# $3 comment (option)
################################################################################
assert_include_in_file(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_include_in_file";
	fi
	typeset str="${1}";
	typeset target="${2}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi
	typeset __count_line=0
	if [ -f ${target} ];then
		__count_line=`grep -c "${str}" "${target}"`;
	else
		_ssu_ErrExit "assert_include_in_file";
	fi
	if [ ${__count_line} -eq 0 ];then
		_ssu_FailLog_Include "assert_include_in_file" "${str}" "${target}" "${_comment}";
	else
		_ssu_succeedLog "assert_include_in_file" "${_comment}";
	fi
}

################################################################################
# assert_not_include
# $1 string
# $2 target
# $3 comment (option)
################################################################################
assert_not_include(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_include";
	fi
	typeset str="${1}";
	typeset target="${2}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi
	typeset __count_line=`echo "${target}" | grep -c "${str}"`;
	if [ ${__count_line} -ne 0 ];then
		_ssu_FailLog_NotInclude "assert_not_include" "${str}" "${target}" "${_comment}";
	else
		_ssu_succeedLog "assert_not_include" "${_comment}";
	fi
}

################################################################################
# assert_not_include_in_file
# $1 string
# $2 file
# $3 comment (option)
################################################################################
assert_not_include_in_file(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_include_in_file";
	fi
	typeset str="${1}";
	typeset target="${2}";
	typeset _comment=" ";
	if [ $# = 2 ]
	then
		_comment="${2}";
	fi
	typeset __count_line=0
	if [ -f ${target} ];then
		__count_line=`grep -c "${str}" "${target}"`;
	else
		_ssu_ErrExit "assert_not_include_in_file";
	fi
	if [ ${__count_line} -ne 0 ];then
		_ssu_FailLog_NotInclude "assert_not_include_in_file" "${str}" "${target}" "${_comment}";
	else
		_ssu_succeedLog "assert_not_include_in_file" "${_comment}";
	fi
}


################################################################################
# assert_same_file
# $1 expect file
# $2 other file
# $3 comment (option)
################################################################################
assert_same_file(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_same_file";
	fi
	typeset expect_file="${1}";
	typeset other_file="${2}";
	typeset _comment=" ";
	if [ $# = 3 ]
	then
		_comment="${3}";
	fi

	#diff "${expect_file}" "${other_file}" > /dev/null
	typeset same=`${JAVA_CMD} -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "utilfilesame" "${expect_file}" "${other_file}"`
	typeset r=`echo "${same}" | wc -c`
	if [ ${r} -gt 3 ]; then
		_ssu_FailLog_SameFile "assert_same_file" "${expect_file}" "${other_file}" "${_comment}";
	else
		if [ "${same}" = "1" ]
		then
			_ssu_FailLog_SameFile "assert_same_file" "${expect_file}" "${other_file}" "${_comment}";
		else
			_ssu_succeedLog "assert_same_file" "${_comment}";
		fi
	fi
}

################################################################################
# assert_not_same_file
# $1 expect file
# $2 other file
# $3 comment (option)
################################################################################
assert_not_same_file(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_ErrExit "assert_not_same_file";
	fi
	typeset expect_file="${1}";
	typeset other_file="${2}";
	typeset _comment=" ";
	if [ $# = 3 ]
	then
		_comment="${3}";
	fi

	typeset same=`${JAVA_CMD} -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "utilfilesame" "${expect_file}" "${other_file}"`
	typeset r=`echo "${same}" | wc -c`
	if [ ${r} -gt 3 ]; then
		_ssu_FailLog_SameFile "assert_not_same_file" "${expect_file}" "${other_file}" "${_comment}";
	else
		if [ "${same}" = "0" ]
		then
			_ssu_FailLog_SameFile "assert_not_same_file" "${expect_file}" "${other_file}" "${_comment}";
		else
			_ssu_succeedLog "assert_not_same_file" "${_comment}";
		fi
	fi
}


################################################################################
# assert_FileDateOrder
# $1 target file name
# $2 operaete ("<" ,">" ,"=" ,"!=" ,"<=" ,">=" )
# $3 timestamp (YYYY-MM-DD HH:MI:SS or YYYY/MM/DD HH:MI:SS)
# $4 comment (option)
# example : assert_FileDateOrder foo.data > "2006-07-01 00:00:00"
################################################################################
assert_FileDateOrder(){
	_ssu_AssertSetUp;
	if [[ $# -ne 3 && $# -ne 4 ]]
	then
		_ssu_ErrExit "assert_FileDateOrder";
	fi
	typeset file="${1}";
	typeset ope="${2}"
	typeset time="${3}"
	typeset comment=" ";
	if [ $# = 4 ]
	then
		comment="${4}";
	fi
	
	typeset f_t=`_ssu_LsFulltime "${file}"`
	typeset f_num=`_ssu_FromDateStyleToInt "${f_t}"`
	typeset t_num=`_ssu_FromDateStyleToInt "${time}"`
	typeset result_flag=1;
	
	case "${ope}" in
	"<")
		if [ ${f_num} -lt ${t_num} ];then
			result_flag=0;
		fi
	;;
	">")
		if [ ${f_num} -gt ${t_num} ];then
			result_flag=0;
		fi
	;;
	"=")
		if [ ${f_num} -eq ${t_num} ];then
			result_flag=0;
		fi
	;;
	"!=")
		if [ ${f_num} -ne ${t_num} ];then
			result_flag=0;
		fi
	;;
	"<=")
		if [ ${f_num} -le ${t_num} ];then
			result_flag=0;
		fi
	;;
	">=")
		if [ ${f_num} -ge ${t_num} ];then
			result_flag=0;
		fi
	;;
	esac

	if [ ${result_flag} -ne 0 ];then
		_ssu_FailLog_FileDateOrder "assert_FileDateOrder" "${f_t} ${ope}" "${time}" "${_comment}";
	else
		_ssu_succeedLog "assert_FileDateOrder" "${comment}";
	fi
}


################################################################################
# assert_db
# 
# $1 expect file
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db";
	fi
	typeset file="${1}";
	typeset table="${2}";
	typeset where=" ";
	typeset comment=" ";
	if [ $# = 3 ]
	then
		where="${3}";
	fi
	if [ $# = 4 ]
	then
		where="${3}";
		comment="${4}";
	fi
	_ssu_TempVar=`${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "selectComp" "${file}" "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}`
	typeset rc=$?
	if [ ${rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db" "${comment}";
	else
		_ssu_FailLog_DB "assert_db" "${_ssu_TempVar}" "${comment}";
	fi
}

################################################################################
# assert_db_ordered
# 
# $1 expect file
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db_ordered(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db_ordered";
	fi
	typeset file="${1}";
	typeset table="${2}";
	typeset where=" ";
	typeset comment=" ";
	if [ $# = 3 ]
	then
		where="${3}";
	fi
	if [ $# = 4 ]
	then
		where="${3}";
		comment="${4}";
	fi
	_ssu_TempVar=`${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "selectCompOrder" "${file}" "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}`
	typeset rc=$?
	if [ ${rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_ordered" "${comment}";
	else
		_ssu_FailLog_DB "assert_db_ordered" "${_ssu_TempVar}" "${comment}";
	fi
}

################################################################################
# assert_db_include
# 
# $1 expect file
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db_include(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db";
	fi
	typeset file="${1}";
	typeset table="${2}";
	typeset where=" ";
	typeset comment=" ";
	if [ $# = 3 ]
	then
		where="${3}";
	fi
	if [ $# = 4 ]
	then
		where="${3}";
		comment="${4}";
	fi
	_ssu_TempVar=`${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "selectInc" "${file}" "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}`
	typeset rc=$?
	if [ ${rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_include" "${comment}";
	else
		_ssu_FailLog_DB "assert_db_include" "${_ssu_TempVar}" "${comment}";
	fi
}


################################################################################
# assert_db_count
# 
# $1 expect count
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db_count(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db_count";
	fi
	typeset count="${1}";
	typeset table="${2}";
	typeset where=" ";
	typeset comment=" ";
	if [ $# = 3 ]
	then
		where="${3}";
	fi
	if [ $# = 4 ]
	then
		where="${3}";
		comment="${4}";
	fi
	_ssu_TempVar=`${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "count" "${count}" "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}`
	typeset rc=$?
	if [ ${rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_count" "${comment}";
	else
		_ssu_FailLog_DB "assert_db_count" "${_ssu_TempVar}" "${comment}";
	fi
}

################################################################################
# assert_db_not_same_count
# 
# $1 not expect count
# $2 table
# $3 where-condition (option)
# $3 comment (option) require where-condition
################################################################################
assert_db_not_same_count(){
	_ssu_AssertSetUp;
	if [[ $# != 2 && $# != 3 && $# != 4 ]]
	then
		_ssu_ErrExit "assert_db_not_same_count";
	fi
	typeset count="${1}";
	typeset table="${2}";
	typeset where=" ";
	typeset comment=" ";
	if [ $# = 3 ]
	then
		where="${3}";
	fi
	if [ $# = 4 ]
	then
		where="${3}";
		comment="${4}";
	fi
	_ssu_TempVar=`${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "countnot" "${count}" "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}`
	typeset rc=$?
	if [ ${rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_not_same_count" "${comment}";
	else
		_ssu_FailLog_DB "assert_db_not_same_count" "${_ssu_TempVar}" "${comment}";
	fi
}


################################################################################
# assert_db_connect
# 
################################################################################
assert_db_connect(){
	_ssu_AssertSetUp;
	${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.db.DBConnectTest "${SSU_CHARCODE}" "${JDBC_CLASS}" "${JDBC_URL}" ${JDBC_USER} ${JDBC_PASSWORD};
	typeset rc=$?
	if [ ${rc} -eq 0 ]; then
		_ssu_succeedLog "assert_db_connect" "${comment}";
	else
		_ssu_FailLog_DB "assert_db_connect" "${JDBC_URL}" "${comment}";
	fi
}


################################################################################
#
# Log functions
#
################################################################################
_ssu_FailLog_Base(){
	typeset assert_name="${1}";
	typeset message1="expect Value : ${2}";
	typeset message2="actual Value : ${3}";
	typeset comment="${4}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" "${message2}" "${comment}"
}
_ssu_FailLog_False(){
	typeset assert_name="${1}";
	typeset message1="unexpect Value : ${2}";
	typeset message2="actual Value : ${3}";
	typeset comment="${4}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" "${message2}" "${comment}"
}
_ssu_FailLog_File(){
	typeset assert_name="${1}";
	typeset message1="not found or directory? : ${2}";
	typeset comment="${3}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" " " "${comment}"
}
_ssu_FailLog_NotFoundFile(){
	typeset assert_name="${1}";
	typeset message1="exist : ${2}";
	typeset comment="${3}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" " " "${comment}"
}
_ssu_FailLog_Blank(){
	typeset assert_name="${1}";
	typeset message1="not blank : ${2}";
	typeset comment="${3}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" " " "${comment}"
}
_ssu_FailLog_Include(){
	typeset assert_name="${1}";
	typeset message1="not find \"${2}\" in ${3}";
	typeset comment="${4}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" " " "${comment}"
}
_ssu_FailLog_NotInclude(){
	typeset assert_name="${1}";
	typeset message1="find \" ${1} \" in ${3}";
	typeset comment="${4}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" " " "${comment}"
}
_ssu_FailLog_SameFile(){
	typeset assert_name="${1}";
	typeset message1="expect File : ${2}";
	typeset message2="actual File : ${3}";
	typeset comment="${4}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" "${message2}" "${comment}"
}
_ssu_FailLog_FileDateOrder(){
	typeset assert_name="${1}";
	typeset message1="expect time : ${2}";
	typeset message2="actual time : ${3}";
	typeset comment="${4}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" "${message2}" "${comment}"
}
_ssu_FailLog_DB(){
	typeset assert_name="${1}";
	typeset message1="${2}";
	typeset comment="${3}";
	_ssu_outputFailLogAndFailSet "${assert_name}" "${message1}" "${comment}"
}
_ssu_outputFailLogAndFailSet(){
	typeset assert_name="${1}";
	typeset message1="${2}";
	typeset message2="${3}";
	typeset comment="${4}";
	if [ "${comment}" = " " ]
	then
		comment="";
	fi
	printf "\n";
	printf "\033[1;31m!!  Assert Fail !!!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m\n" -e
	printf "\033[1;31mTEST_CASE = ${_ssu_CurrentTestName}\033[0m\n" -e
	printf "\033[1;31mASSERT_NAME = ${assert_name}\033[0m\n" -e
	printf "\033[1;31mASSERT_INDEX = ${_ssu_CurrentAssertIndex}\033[0m\n" -e
	printf "\033[1;31m${message1}\033[0m\n" -e
	if [ ${#message2} -ne 0 ]
	then
		printf "\033[1;31m${message2}\033[0m\n" -e
	fi
	
	if [ ${#comment} -ne 0 ]
	then
		printf "\033[1;31m${comment}\033[0m\n" -e
	fi
	printf "\033[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m\n" -e
	printf "\n";
	exit 99;
}

_ssu_ErrExit(){
	printf "\033[1;31m${1} Wrong Arguments in ${_ssu_CurrentTestName}[0m\n" -e
	if [[ $# == 2 ]]
	then
		printf "\033[1;31m${2}[0m\n" -e
	fi
	printf "\033[1;31mThis test-shell exit!![0m\n" -e
	exit 99;
}
_ssu_ErrExit2(){
	printf "\033[1;31mError!! in ${_ssu_CurrentTestName}[0m\n" -e
	printf "\033[1;31m${1}[0m\n" -e
	printf "\033[1;31mThis test-shell exit!![0m\n" -e
	exit 99;
}

################################################################################
# _ssu_succeedLog
# $1 comment
################################################################################
_ssu_succeedLog(){
	${_ssu_succeedLog_INNER} "$*"
}

_ssu_succeedLog_DEBUG(){
	typeset mes=${2}
	if [ "${mes}" = " " ]
	then
		mes="";
	fi

	if [ "${DEBUG_MODE}" = "ON" ]; then
		echo "";
		echo "************   Assertion   ******************";
		echo " ${1} is passed."
		if [ ${#mes} -ne 0 ]
		then
			echo "${mes}";
		fi
		echo "*********************************************";
		echo "";
	fi
}

_ssu_succeedLog_NOT_DEBUG(){
	typeset dummy="";
}



################################################################################
## below's are helper functions
################################################################################

_ssu_tearDown_h(){
	typeset ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	while [ ${ind} -ge 1 ]
	do
		ind=$((${ind}-1))
		${_ssu_tearDown_h_calledFunctions[$ind]}
	done
	unset _ssu_tearDown_h_calledFunctions
}

################################################################################
# mv helper
# $1 src (1 file only)
# $2 dest (1 file only)
# $3 options (like "-i" )
################################################################################
h_mv(){
	typeset src=""
	typeset dest=""
	typeset op=""
	if [[ $# -eq 2 || $# -eq 3 ]];then
		src="${1}"
		dest="${2}"
		op=""
		if [ $# = 3 ]
		then
			op="${3}";
		fi
	else
		_ssu_ErrExit "h_mv"
	fi
	
	if [ ! -f ${src} ];then
		_ssu_ErrExit "h_mv" "not found file ${src}"
	fi
	
	typeset temp_src=`_ssu_TempFileName "${src}"`;
	cp -p  "${src}" "${temp_src}"
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_mv: Fail! No Space?"
	fi
	
	typeset temp_dest=""
	if [ -f ${dest} ];then
		temp_dest=`_ssu_TempFileName "${dest}"`;
		cp -p  "${dest}" "${temp_dest}"
		if [ $? -ne 0 ];then
			rm -f "${temp_src}"
			_ssu_ErrExit2 "h_mv: Fail! No Space?"
		fi
	fi
	
	typeset command="mv ${op} ${src} ${dest}"
	${command}
	typeset rc=$?
	if [ $rc -ne 0 ]
	then
		_ssu_ErrExit2 "h_mv: Fail! No Space?"
	fi
	
	typeset ind=`echo ${#_ssu_h_mv_src[@]}`
	_ssu_h_mv_src[${ind}]="${src}"
	_ssu_h_mv_dest[${ind}]="${dest}"
	_ssu_h_mv_backup_src[${ind}]="${temp_src}"
	_ssu_h_mv_backup_dest[${ind}]="${temp_dest}"
	
	typeset ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${ind}]="_ssu_tearDown_h_mv"
}

_ssu_tearDown_h_mv(){
	typeset ind=`echo ${#_ssu_h_mv_src[@]}`
	ind=$((${ind}-1))
	cp -p "${_ssu_h_mv_backup_src[${ind}]}" "${_ssu_h_mv_src[${ind}]}"
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_mv: Fail! No Space?"
		exit 1
	fi
	rm -f "${_ssu_h_mv_backup_src[${ind}]}"
	if [[ "${_ssu_h_mv_backup_dest[${ind}]}" != "" ]];then
		cp -p "${_ssu_h_mv_backup_dest[${ind}]}" "${_ssu_h_mv_dest[${ind}]}"
		if [ $? -ne 0 ];then
			echo "Error!!"
			echo "_ssu_tearDown_h_mv: Fail! No Space?"
			exit 1
		fi
		rm -f "${_ssu_h_mv_backup_dest[${ind}]}"
	else
		rm -f "${_ssu_h_mv_dest[${ind}]}"
	fi
	unset _ssu_h_mv_src[${ind}]
	unset _ssu_h_mv_dest[${ind}]
	unset _ssu_h_mv_backup_src[${ind}]
	unset _ssu_h_mv_backup_dest[${ind}]
}
################################################################################
# chmod helper
# $1 mod
# $2 file (1 file only)
################################################################################
h_chmod(){
	typeset mod=""
	typeset file=""
	if [[ $# -eq 2 ]];then
		mod="${1}"
		file="${2}"
	else
		_ssu_ErrExit "h_chmod: wrong argument."
	fi
	
	if [ ! -f ${file} ];then
		_ssu_ErrExit "_h_chmod" "${file} cannot access or not file."
	fi
	
	typeset temp_mod=`_ssu_FindModByNum "${file}"`;
	chmod "${mod}" "${file}"
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_chmod: Fail! Cannot Access ${file} ?"
	fi
	typeset ind=`echo ${#_ssu_h_chmod_backup_mod[@]}`
	_ssu_h_chmod_backup_mod[${ind}]="${temp_mod}"
	_ssu_h_chmod_file[${ind}]="${file}"
	
	ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${ind}]="_ssu_tearDown_h_chmod"
}

_ssu_tearDown_h_chmod(){
	typeset ind=`echo ${#_ssu_h_chmod_backup_mod[@]}`
	ind=$((${ind}-1))
	chmod ${_ssu_h_chmod_backup_mod[${ind}]} ${_ssu_h_chmod_file[${ind}]}
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_chmod: Fail! Cannot Access "${_ssu_h_chmod_file[${ind}]}" ?"
		exit 1
	fi
	unset _ssu_h_chmod_backup_mod[${ind}]
	unset _ssu_h_chmod_file[${ind}]
}

################################################################################
# chown helper
# $1 own
# $2 file (1 file only)
################################################################################
h_chown(){
	typeset own=""
	typeset file=""
	if [[ $# -eq 2 ]];then
		own="${1}"
		file="${2}"
	else
		_ssu_ErrExit "h_chown"
	fi
	
	if [ ! -f ${file} ];then
		_ssu_ErrExit "_h_chown" "${file} cannot access or not file."
	fi
	
	typeset temp_ls=`ls -l "${file}"`;
	typeset i=0
	typeset temp_gr=""
	typeset temp_usr=""
	for x in ${temp_ls}
	do
		i=$((${i}+1))
		if [ ${i} -eq 3 ];then
			temp_gr=${x}
		elif [${i} -eq 4 ];then
			temp_usr=${x}
		fi
	done
	
	typeset temp_own=${temp_gr}.${temp_usr}
	
	chown "${own}" "${file}"
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_chown: Fail! Cannot Access "${file}" ?"
	fi
	
	typeset ind=`echo ${#_ssu_h_chown_backup_own[@]}`
	_ssu_h_chown_backup_own[${ind}]="${temp_own}"
	_ssu_h_chown_file[${ind}]="${file}"
	
	ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${ind}]="_ssu_tearDown_h_chown"
}

_ssu_tearDown_h_chown(){
	typeset ind=`echo ${#_ssu_h_chown_backup_own[@]}`
	ind=$((${ind}-1))
	chown ${_ssu_h_chown_backup_own[${ind}]} ${_ssu_h_chown_file[${ind}]}
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_chown: Fail! Cannot Access "${_ssu_h_chown_file[${ind}]}" ?"
		exit 1
	fi
	unset _ssu_h_chown_backup_own[${ind}]
	unset _ssu_h_chown_file[${ind}]
}

################################################################################
# cp helper
# $1 src (1 file only)
# $2 dest (1 file only)
# $3 options (like "-i" )
################################################################################
h_cp(){
	typeset src=""
	typeset dest=""
	typeset op=""
	if [[ $# -eq 2 || $# -eq 3 ]];then
		src="${1}"
		dest="${2}"
		op=""
		if [ $# = 3 ]
		then
			op="${3}";
		fi
	else
		_ssu_ErrExit "h_cp"
	fi
	if [ ! -f ${src} ];then
		_ssu_ErrExit "h_cp" "not found ${src}"
	fi

	typeset temp_src=`_ssu_TempFileName "${src}"`;
	cp -p  "${src}" "${temp_src}"
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_cp: Fail! No Space? :: ${src}"
	fi

	typeset temp_dest=""
	if [ -f ${dest} ];then
		temp_dest=`_ssu_TempFileName "${dest}"`;
		cp -p  "${dest}" "${temp_dest}"
		if [ $? -ne 0 ];then
			rm -f "${temp_src}"
			_ssu_ErrExit2 "h_cp: Fail! No Space? :: ${dest}"
		fi
	fi

	cp ${op} ${src} ${dest}
	typeset rc=$?
	if [ $rc -ne 0 ]
	then
		_ssu_ErrExit2 "h_cp: Fail! No Space?"
	fi
	
	typeset ind=`echo ${#_ssu_h_cp_dest[@]}`
	_ssu_h_cp_src[${ind}]="${src}"
	_ssu_h_cp_dest[${ind}]="${dest}"
	_ssu_h_cp_backup_src[${ind}]="${temp_src}"
	_ssu_h_cp_backup_dest[${ind}]="${temp_dest}"
	
	ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${ind}]="_ssu_tearDown_h_cp"
}

_ssu_tearDown_h_cp(){
	typeset ind=`echo ${#_ssu_h_cp_dest[@]}`
	ind=$((${ind}-1))
	cp -p "${_ssu_h_cp_backup_src[${ind}]}" "${_ssu_h_cp_src[${ind}]}"
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_cp: Fail! No Space?"
		exit 1
	fi
	rm -f ${_ssu_h_cp_dest[${ind}]}
	
	if [[ "${_ssu_h_cp_backup_dest[${ind}]}" != "" ]];then
		cp -p "${_ssu_h_cp_backup_dest[${ind}]}" "${_ssu_h_cp_dest[${ind}]}"
		if [ $? -ne 0 ];then
			echo "Error!!"
			echo "_ssu_tearDown_h_cp: Fail! No Space?"
			exit 1
		fi
		rm -f "${_ssu_h_cp_backup_dest[${ind}]}"
	fi

	unset _ssu_h_cp_dest[${ind}]
}


################################################################################
# rm helper
# $1 src (1 file only)
# $2 options (like "-i" )
################################################################################
h_rm(){
	typeset src=""
	typeset op=""
	if [[ $# -eq 1 || $# -eq 2 ]];then
		src="${1}"
		op=""
		if [ $# = 2 ]
		then
			op="${2}";
		fi
	else
		_ssu_ErrExit "h_rm"
	fi
	

	if [ ! -f ${src} ];then
		# _ssu_ErrExit "h_rm" "not found ${src}"
		return 1
	fi

	typeset backup_src=`_ssu_TempFileName "${src}"`;
	cp -p  ${src} ${backup_src}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_rm: Fail! No Space?"
	fi

	rm ${op} ${src} ${dest}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_rm: cannot rm ${src}"
	fi

	typeset ind=`echo ${#_ssu_h_rm_src[@]}`
	_ssu_h_rm_src[${ind}]="${src}"
	_ssu_h_rm_backup_src[${ind}]="${backup_src}"
	
	ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${ind}]="_ssu_tearDown_h_rm"
}

_ssu_tearDown_h_rm(){
	typeset ind=`echo ${#_ssu_h_rm_src[@]}`
	ind=$((${ind}-1))
	cp -p ${_ssu_h_rm_backup_src[${ind}]} ${_ssu_h_rm_src[${ind}]}
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_rm: Fail! No Space?"
		exit 1
	fi
	rm -f ${_ssu_h_rm_backup_src[${ind}]}
	unset _ssu_h_rm_backup_src[${ind}]
	unset _ssu_h_rm_src[${ind}]
}

################################################################################
# mkdir helper
# $1 dir (1 dir only)
# $2 options (like "-i" )
################################################################################
h_mkdir(){
	typeset dir=""
	typeset op=""
	if [[ $# -eq 1 || $# -eq 2 ]];then
		dir="${1}"
		op=""
		if [ $# = 2 ]
		then
			op="${2}";
		fi
	else
		_ssu_ErrExit "h_mkdir"
	fi
	
	if [ -d ${dir} ];then
		echo "WARNING: already exist "${dir}" : h_mkdir" &>2
		return;
	fi
	
	typeset command="mkdir ${op} ${dir}"
	${command}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_mkdir: Fail! Cannot make dir ${dir}"
	fi
	
	typeset ind=`echo ${#_ssu_h_mkdir_dir[@]}`
	_ssu_h_mkdir_dir[${ind}]="${dir}"
	
	ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${ind}]="_ssu_tearDown_h_mkdir"
}

_ssu_tearDown_h_mkdir(){
	typeset ind=`echo ${#_ssu_h_mkdir_dir[@]}`
	ind=$((${ind}-1))
	rm -fr ${_ssu_h_mkdir_dir[${ind}]}
	if [ $? -ne 0 ];then
		echo "Error!!"
		echo "_ssu_tearDown_h_mkdir: Fail! Cannot remove dir "${_ssu_h_mkdir_dir[${ind}]}
		exit 1
	fi
	unset _ssu_h_mkdir_dir[${ind}]
}


################################################################################
# cd helper
# $1 dir (1 dir only)
################################################################################
h_cd(){
	typeset dir=""
	typeset op=""
	if [[ $# -eq 1 || $# -eq 2 ]];then
		dir="${1}"
		op=""
		if [ $# = 2 ]
		then
			op="${2}";
		fi
	else
		_ssu_ErrExit "h_cd"
	fi
	
	typeset old_dir=`pwd`
	
	typeset command="cd ${op} ${dir}"
	${command}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_cd: Fail! Cannot cd ${dir}"
	fi
	
	typeset ind=`echo ${#_ssu_h_cd_old_dir[@]}`
	_ssu_h_cd_old_dir[${ind}]="${old_dir}"
	
	ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${ind}]="_ssu_tearDown_h_cd"
}

_ssu_tearDown_h_cd(){
	typeset ind=`echo ${#_ssu_h_cd_old_dir[@]}`
	ind=$((${ind}-1))
	cd ${_ssu_h_cd_old_dir[${ind}]}
	unset _ssu_h_cd_old_dir[${ind}]
}

################################################################################
# make file helper
# $1 file (1 file only)
################################################################################
h_make_file(){
	typeset file=""
	if [[ $# -eq 1 ]];then
		file="${1}"
	else
		_ssu_ErrExit "h_make_file"
	fi
	
	typeset backup_src="";
	if [ -f ${file} ];then
		backup_src=`_ssu_TempFileName "${file}"`;
		cp -p  ${file} ${backup_src}
		if [ $? -ne 0 ];then
			_ssu_ErrExit2 "h_make_file: Fail! No Space?"
		fi
		rm -f ${file}
		if [ $? -ne 0 ];then
			_ssu_ErrExit2 "We cannot rm ${file}!"
		fi
	fi
	
	typeset command="touch ${file}"
	${command}
	if [ $? -ne 0 ];then
		_ssu_ErrExit2 "h_make_file: Fail! Cannot make file ${file}"
	fi
	
	typeset ind=`echo ${#_ssu_h_make_file[@]}`
	_ssu_h_make_file[${ind}]="${file}"
	_ssu_h_make_backup_file[${ind}]="${backup_src}"
	
	ind=`echo ${#_ssu_tearDown_h_calledFunctions[@]}`
	_ssu_tearDown_h_calledFunctions[${ind}]="_ssu_tearDown_h_make_file"
}

_ssu_tearDown_h_make_file(){
	typeset ind=`echo ${#_ssu_h_make_file[@]}`
	ind=$((${ind}-1))
	rm -f "${_ssu_h_make_file[${ind}]}"

	if [[ "${_ssu_h_make_backup_file[${ind}]}" != "" ]];then
		cp -p "${_ssu_h_make_backup_file[${ind}]}" "${_ssu_h_make_file[${ind}]}"
		if [ $? -ne 0 ];then
			echo "Error!!"
			echo "_ssu_tearDown_h_make_file: Fail! No Space?"
			exit 1
		fi
		rm -f "${_ssu_h_make_backup_file[${ind}]}"
	fi

	unset _ssu_h_make_file[${ind}]
	unset _ssu_h_make_backup_file[${ind}]
}

################################################################################
## assert util
################################################################################
_ssu_TempFileName(){
	typeset name=`basename $1`
	typeset tempName=${name}"__"
	typeset i=1
	while [[ -a ${_ssu_WorkDir}/"${tempName}${i}" ]] 
	do
		i=$((${i}+1))
	done
	touch ${_ssu_WorkDir}/"${tempName}${i}"
	echo ${_ssu_WorkDir}/"${tempName}${i}"
}

_ssu_FindModByNum(){
	typeset m=`ls -l ${1} |cut -d " " -f 1`
	typeset t=`echo ${m} | cut  -c 2-4`
	typeset num=`_ssu_ModToNum ${t}`
	t=`echo ${m} | cut  -c 5-7`
	typeset temp=`_ssu_ModToNum ${t}`
	num=${num}${temp}
	t=`echo ${m} | cut  -c 8-`
	temp=`_ssu_ModToNum ${t}`
	num=${num}${temp}
	echo $num
}

_ssu_ModToNum(){
	typeset i=0;
	typeset t=`echo ${1} | cut -c 1`
	if [ ${t} = "r" ];then
		i=$((${i}+4))
	fi
	t=`echo ${1} | cut -c 2`
	if [ ${t} = "w" ];then
		i=$((${i}+2))
	fi
	t=`echo ${1} | cut -c 3`
	if [ ${t} = "x" ];then
		i=$((${i}+1))
	fi
	echo ${i}
}

_ssu_LsFulltime(){
	typeset file="${1}"
	typeset op="${2}"
	${JAVA_CMD} -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "util" "file-time" "${file}"
}

_ssu_FromDateStyleToInt(){
	echo ${1} |tr -d "-" |tr -d "/" | tr -d " " |tr -d ":"
}

