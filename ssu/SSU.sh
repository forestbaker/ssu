#!/bin/sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
# either express or implied. See the License for the specific language
# governing permissions and limitations under the License.
#
################################################################################
################################################################################
#
# SSU : ShellScript Unit
# You can use this tool as xUnit.
# This tool requires Asser.sh and .jar and Util.sh
#
# author : Masayuki Ioki,Takumi Hosaka
# Version : 0.5
# Date ; 2009.01.20
_ssu_version="0.5 :: 2009.01.20"
################################################################################
################################################################################
## You MUST Define "SSU_SELFPATH" in your test_case.
## SSU_SELFPATH is relative path-name from your test_case to SSU.
## like SSU_SELFPATH="../test" (/home/foo/test/SSU.sh , /home/foo/testcase/test.sh)

SSU_SELFPATH="dummy"

################################################################################
## Options -start-

DEBUG_MODE=OFF;
TARGET_TEST_PATTERN="^test";
SSU_EVIDENCE_BASEDIR="";
SSU_CHARCODE=""

## TARGET_SHELL_FOR_COVERAGE="../src/foo.sh"
## if you want to check coverage,please define TARGET_SHELL_FOR_COVERAGE.
## TARGET_SHELL_FOR_COVERAGE is a relative path-name to target shell from your test_case.
## like TARGET_SHELL_FOR_COVERAGE="tax.sh" (/home/foo/testcase/test.sh , /home/foo/testcase/tax.sh)
TARGET_SHELL_FOR_COVERAGE="";

## SSU requires Java.
## Please define Your JavaPath.
## eg. JAVA_CMD="/opt/java/bin/java"
JAVA_CMD="java";

## If you use assert_db*, please set these vars.
## e.g. JDBC_JAR="/opt/oraclexe/app/oracle/product/10.2.0/server/jdbc/lib/ojdbc14.jar";
##      JDBC_CLASS="oracle.jdbc.driver.OracleDriver";
##      JDBC_URL="jdbc:oracle:thin:@localhost:1521:xe";
##      JDBC_USER="pooh";
##      JDBC_PASSWORD="piglet";
JDBC_JAR="";
JDBC_CLASS="";
JDBC_URL="";
JDBC_USER="";
JDBC_PASSWORD="";


## Options -end-
################################################################################
################################################################################
################################################################################
################################################################################

_ssu_CurrentTestName=""; #current executing test-function name
_ssu_CurrentAssertIndex=0; #current executing assert index

_ssu_WorkDir="" #for temp file

_ssu_UtilJar=""
_ssu_jarsep=":"

_ssu_TestJobID=""

_ssu_evi_dir=""
_ssu_Lock=""

_ssu_succeedLog_INNER="_ssu_succeedLog_DEBUG"



if [ $# = 1 ]
then
	if [ "$1" = "-version" ]
	then
		echo "SSU version "$_ssu_version
		echo "author Masayuki Ioki,Takumi Hosaka."
		exit 1
	fi
fi

################################################################################
# at Runtime, This function runs Only Once.
################################################################################
_ssu_BeforeTest(){

	if [ "${DEBUG_MODE}" = "ON" ]; then
		typeset t_name=`basename $0`;
		echo "";
		echo "###########################################################################";
		echo "Start : ${t_name}";
		echo "";
		
		_ssu_succeedLog_INNER="_ssu_succeedLog_DEBUG"
	fi

	beforeTest;
}

################################################################################
# beforeTest
# Execute Before Test(Only once).
# This is dummy.Plese override.
################################################################################
beforeTest(){
	typeset dummy="";
}

################################################################################
# _ssu_SetUp
# inner setup
################################################################################
_ssu_SetUp(){

	if [ "${DEBUG_MODE}" = "ON" ]; then
		typeset __case_name=$1
		echo "";
		echo "------------------------------------------------------------------";
		echo "TestCase Start : ${__case_name}";
	fi
	
	setUp;
}

################################################################################
# setUp
# Execute setUp(Each test-functions).
# This is dummy.Plese override.
################################################################################
setUp(){
	typeset dummy="";
}

################################################################################
# _ssu_TearDown
# inner teardown
################################################################################
_ssu_TearDown(){

	tearDown;
	_ssu_TeardownForEvidence_test
	_ssu_tearDown_h;
	if [ "${DEBUG_MODE}" = "ON" ]; then
		typeset _case_num=$1;
		echo "TestCase END : ${__case_num}";
		echo "------------------------------------------------------------------";
		echo "";
	fi
}

################################################################################
# tearDown
# Please Override.
# this is dummy.
################################################################################
tearDown(){
	typeset dummy=;
}

################################################################################
# _ssu_AfterTest
################################################################################
_ssu_AfterTest(){

        if [ "${DEBUG_MODE}" = "ON" ]; then
		typeset sh_name=`basename $0`;
                echo "";
                echo "Done : ${sh_name}";
                echo "###########################################################################";
        fi

        afterTest;
}

################################################################################
# afterTest
# Execute After Test(Only once).
# This is dummy.Plese override.
################################################################################
afterTest(){
        typeset dummy="";
}


################################################################################
# Each Test Runs.
################################################################################
_ssu_DoSSU(){
	if [ ${#_ssu_TestArray[*]} -eq 0 ]
	then 
		echo "No TestCase.";
		exit 1;
	fi

	_ssu_cnt=0;
	_ssu_countOfSuccessTest=0;
	_ssu_countOfFailedTest=0;


	_ssu_CheckCoverage
	_ssu_SetupForCoverage

	_ssu_BeforeTest;
	typeset test_cnt_max=${#_ssu_TestArray[*]}
	typeset color="green";
	
	#Each Test Run!
	while [ ${_ssu_cnt} -lt ${#_ssu_TestArray[*]} ]
	do
		
		_ssu_CurrentTestName=${_ssu_TestArray[$_ssu_cnt]};
		_ssu_mkdir_evi_test
		
		if [ "${DEBUG_MODE}" != "ON" ]; then
			typeset mes=`${JAVA_CMD} -jar  ${_ssu_UtilJar} "${SSU_CHARCODE}" "report" "START ${_ssu_CurrentTestName}" "${_ssu_cnt}" "${test_cnt_max}" "${color}"`
			printf "\r${mes}" -e
		fi
		
		#testing
		_ssu_test_run &
		_ssu_TestJobID=$!;
		wait ${_ssu_TestJobID};
		typeset test_rc=$?;
		_ssu_TestJobID="";
		
		#result testing
		if [ ${test_rc} -eq 0 ] 
		then 
			_ssu_countOfSuccessTest=$((${_ssu_countOfSuccessTest}+1))
		else
			_ssu_countOfFailedTest=$((${_ssu_countOfFailedTest}+1))
			color="red"
		fi
		
		_ssu_cnt=$((${_ssu_cnt}+1));
		
		if [ "${DEBUG_MODE}" != "ON" ]; then
			typeset mes=`${JAVA_CMD} -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "report" "END   ${_ssu_CurrentTestName}" "${_ssu_cnt}" "${test_cnt_max}" "${color}"`
			printf "\r${mes}" -e
		fi
		
	done
	
	if [ "${DEBUG_MODE}" != "ON" ]; then
		typeset mes=`${JAVA_CMD} -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "report" "TEST END" "${_ssu_cnt}" "${test_cnt_max}" "${color}"`
		printf "\r${mes}" -e
	fi
	
    _ssu_AfterTest;
    
	echo ""
}

_ssu_SystemOut(){
	if [[ ${_ssu_cnt} -eq 0 ]]
	then
		return 0;
	fi
	echo "** Result Of Test ***************************";
	echo "Run Tests:${_ssu_cnt}";
	echo "Success Tests:${_ssu_countOfSuccessTest}";
	echo "Failure Tests:${_ssu_countOfFailedTest}";
	echo "*********************************************";
	_ssu_cnt=0
}

################################################################################
# test run function.
################################################################################
_ssu_test_run(){
	if [ ! -f "${_ssu_Lock}" ]
	then
		return 1;
	fi
	echo "1" > ${_ssu_Lock};
	trap _ssu_test_trap_function 0 1 2 3 15
	unset _ssu_tearDown_h_calledFunctions
	
	_ssu_SetUp "${_ssu_CurrentTestName}";
	
	_ssu_CurrentAssertIndex=0;
	
	#testing
	${_ssu_CurrentTestName}
	
	_ssu_TearDown "${_ssu_CurrentTestName}";
}


########################################################################
# trap functions

_ssu_test_trap_function(){
	if [ ! -f "${_ssu_Lock}" ]
	then
		return 1;
	fi
	echo "2" > ${_ssu_Lock};
	_ssu_tearDown_h
	_ssu_TeardownForEvidence_test
	echo "3" > ${_ssu_Lock};
}

_ssu_trap_function(){
	unset _ssu_TestArray
	if [ ! -z "${_ssu_TestJobID}" ]; then
		typeset status=`cat ${_ssu_Lock}`
		if [ "${status}" = "0" -o "${status}" = "1" ]; then
			kill -15 ${_ssu_TestJobID}
		fi
		status=`cat ${_ssu_Lock}`
		while [ "${status}" != "3" ];
		do
			sleep 1
			status=`cat ${_ssu_Lock}`
		done

		_ssu_TestJobID=""
	fi
	
	_ssu_TeardownForEvidence
	_ssu_tearDown_h
	_ssu_TearDownForCoverage
	rm -fr "${_ssu_WorkDir}"
	_ssu_SystemOut
}
trap _ssu_trap_function 0 1 2 3 15


################################################################################
# find functions whose name match TARGET_TEST_PATTERN.And execute.
################################################################################
startSSU(){
	## Checking
	typeset td=`dirname ${SSU_SELFPATH}`;
	typeset tf=`basename ${SSU_SELFPATH}`;
	
	SSU_SELFPATH=${td}/${tf}
	
	
	if [[ ! -d "${SSU_SELFPATH}" || ! -f "${SSU_SELFPATH}/SSU.sh" ]];then
		echo "\"${SSU_SELFPATH}\" is wrong."
		echo "Please Define SSU_SELFPATH in your test_case."
		echo "SSU_SELFPATH is relative path-name from your test_case to SSU."
		echo "like SSU_SELFPATH=\"../test\" (/home/foo/test/SSU.sh , /home/foo/testcase/test.sh)"
		exit 1;
	fi
	if [ ! -w "${SSU_SELFPATH}" ];then
		echo "We cannot write in ${SSU_SELFPATH}"
		echo "Please Allow to write in ${SSU_SELFPATH}"
		exit 1;
	fi
	if [ ! -f "${SSU_SELFPATH}/Assert.sh" ];then
		echo "Not Found Assert.sh in ${SSU_SELFPATH}"
		echo "We need Assert.sh"
		exit 1;
	fi
	if [ ! -f "${SSU_SELFPATH}/ssu.jar" ];then
		echo "Not Found ssu.jar in ${SSU_SELFPATH}"
		echo "We need ssu.jar"
		exit 1;
	fi
	
	
	${JAVA_CMD} -version > /dev/null 2>&1
	typeset rc=$?
	if [ ${rc} -ne 0 ]
	then
		echo "Not Found java"
		echo "We need java!"
		exit 1;
	fi
	
	. ${SSU_SELFPATH}/Assert.sh
	. ${SSU_SELFPATH}/Util.sh

	_ssu_UtilJar="${SSU_SELFPATH}"/ssu.jar

	#make work dir
	_ssu_WorkDir="${SSU_SELFPATH}"/$$;
	typeset i=1;
	while [[ -d "${_ssu_WorkDir}${i}" ]] 
	do
		i=$((${i}+1))
	done
	mkdir "${_ssu_WorkDir}${i}";
	rc=$?
	if [ ${rc} -ne 0 ]
	then
		echo "We Cannot create work dir!! ${_ssu_WorkDir}${i}"
		exit 1;
	fi
	_ssu_WorkDir="${_ssu_WorkDir}${i}";
	touch ${_ssu_WorkDir}/lock;
	rc=$?
	if [ ${rc} -ne 0 ]
	then
		echo "We Cannot create lock file!!"
		exit 1;
	fi
	_ssu_Lock=${_ssu_WorkDir}/lock;
	echo "0" > ${_ssu_Lock};
	#end
	
	typeset isCygwin=`uname |grep CYGWIN`;
	if [ ! -z "${isCygwin}" ]
	then
		_ssu_jarsep=";"
	fi
	
	_ssu_SetupForEvidence
	
	typeset test_funcs=`typeset -f |sed 's/function //'| sed 's/()//' | grep ${TARGET_TEST_PATTERN}`;

	typeset t="";
	i=0;
	for t in ${test_funcs}
	do
		_ssu_TestArray[$i]=$t
		i=$(($i+1))
	done

	_ssu_DoSSU;
}


#####################################################################################################
## below's are For Coverage.
_ssu_CheckCoverage(){
	if [ "${TARGET_SHELL_FOR_COVERAGE}" != "" ];
	then
		if [ ! -f "${TARGET_SHELL_FOR_COVERAGE}" ];then
			echo "${TARGET_SHELL_FOR_COVERAGE} is wrong."
			echo "Plase set correct TARGET_SHELL_FOR_COVERAGE."
			exit 1;
		fi
		_ssu_TARGET_SHELL_FILE=`basename "${TARGET_SHELL_FOR_COVERAGE}"`;
		typeset rc=$?;
		if [ $rc -ne 0 ]
		then
			echo "Cannot read TARGET_SHELL_FOR_COVERAGE !";
			exit 1;
		fi
		_ssu_TARGET_SHELL_DIR=`dirname "${TARGET_SHELL_FOR_COVERAGE}"`;
		rc=$?;
		if [ $rc -ne 0 ]
		then
			echo "Cannot read TARGET_SHELL_FOR_COVERAGE !";
			exit 1;
		fi
	fi
}

_ssu_SetupForCoverage(){
	if [ "${TARGET_SHELL_FOR_COVERAGE}" != "" ];
	then
		_ssu_BACKUP_TARGET=`_ssu_TempFileName "${_ssu_TARGET_SHELL_FILE}"`;
		typeset rc=$?;
		if [ $rc -ne 0 ]
		then
			echo "Cannot BackUP ${_ssu_TARGET_SHELL_FILE} !";
			exit 1;
		fi
		_ssu_COVERAGE_EXPECTED=`_ssu_TempFileName expect_f`;
		rc=$?;
		if [ $rc -ne 0 ]
		then
			echo "Cannot make a file in ${_ssu_WorkDir} !";
			exit 1;
		fi
		_ssu_COVERAGE_RESULT=`_ssu_TempFileName result_f`;
		rc=$?;
		if [ $rc -ne 0 ]
		then
			echo "Cannot make a file in ${_ssu_WorkDir} !";
			exit 1;
		fi
		cp -p "${_ssu_TARGET_SHELL_DIR}/${_ssu_TARGET_SHELL_FILE}" "${_ssu_BACKUP_TARGET}";
		rc=$?;
		if [ $rc -ne 0 ]
		then
			echo "Cannot BackUP ${_ssu_TARGET_SHELL_FILE} !";
			exit 1;
		fi
		
		typeset same=`${JAVA_CMD} -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "utilfilesame" "${_ssu_TARGET_SHELL_DIR}/${_ssu_TARGET_SHELL_FILE}" "${_ssu_BACKUP_TARGET}"`
		if [ $same -eq 1 ]
		then
			echo "Cannot BackUP ${_ssu_TARGET_SHELL_FILE} !";
			exit 1;
		fi
		
		${JAVA_CMD} -jar "${_ssu_UtilJar}" "${SSU_CHARCODE}" new "${_ssu_BACKUP_TARGET}" "${_ssu_COVERAGE_RESULT}" > "${_ssu_TARGET_SHELL_DIR}/${_ssu_TARGET_SHELL_FILE}" 2> "${_ssu_COVERAGE_EXPECTED}"
		typeset rc=$?;
		if [ $rc -ne 0 ]
		then
			echo "Cannot Over Write To ${_ssu_TARGET_SHELL_FILE}!";
			echo "Do you open ${_ssu_TARGET_SHELL_FILE} ?";
			exit 1;
		fi
		
		typeset isCygwin=`uname |grep CYGWIN`;
		if [ ! -z ${isCygwin} ];then
			dos2unix "${_ssu_TARGET_SHELL_DIR}/${_ssu_TARGET_SHELL_FILE}" 2> /dev/null
			dos2unix "${_ssu_COVERAGE_RESULT}" 2> /dev/null
		fi
	fi
}

_ssu_TearDownForCoverage(){
	if [  "${TARGET_SHELL_FOR_COVERAGE}" != "" ];
	then
		${JAVA_CMD} -jar "${_ssu_UtilJar}" "${SSU_CHARCODE}" analyze "${_ssu_COVERAGE_EXPECTED}" "${_ssu_COVERAGE_RESULT}"
		if [ ! -f "${_ssu_BACKUP_TARGET}" ]
		then
			return 0;
		fi
		
		if [ -s "${_ssu_BACKUP_TARGET}" ]
		then
			cp -p "${_ssu_BACKUP_TARGET}" "${_ssu_TARGET_SHELL_DIR}/${_ssu_TARGET_SHELL_FILE}" &
			typeset j=$!
			wait $j;
		fi
		rm -f "${_ssu_BACKUP_TARGET}"
		rm -f "${_ssu_COVERAGE_EXPECTED}";
		rm -f "${_ssu_COVERAGE_RESULT}";
	fi
	TARGET_SHELL_FOR_COVERAGE=""
}



#####################################################################################################
## below's are For Evidence.

_ssu_mkdir_evi(){
	typeset dname=$1;
	if [[ ! -d "${dname}" ]]
	then
		mkdir "${dname}"
		r=$?;
		if [ $r -ne 0 ]
		then
			echo "Cannot creake Dir!! ${dname}"
			exit 1;
		fi
	fi
}

_ssu_mkdir_evi_test(){
	_ssu_evi_dir="${SSU_EVIDENCE_BASEDIR}/${_ssu_CurrentTestName}"
	_ssu_mkdir_evi "${_ssu_evi_dir}"
}

_ssu_SetupForEvidence(){
	typeset evi_dir=${SSU_SELFPATH}
	if [ "${SSU_EVIDENCE_BASEDIR}" != "" ]
	then
		evi_dir=${SSU_EVIDENCE_BASEDIR}
	fi

	typeset r="";
	typeset dname="${evi_dir}/evidence"
	_ssu_mkdir_evi "${dname}"
	
	typeset usr=`whoami`
	dname="${dname}/${usr}"
	_ssu_mkdir_evi "${dname}"
	
	typeset f_t=`_ssu_LsFulltime "${_ssu_Lock}"`
	typeset f_num=`_ssu_FromDateStyleToInt "${f_t}"`
	dname="${dname}/${f_num}"
	_ssu_mkdir_evi "${dname}"
	
	typeset casename=`basename $0`
	dname="${dname}/${casename}"
	_ssu_mkdir_evi "${dname}"
	
	SSU_EVIDENCE_BASEDIR="${dname}"

}

_ssu_teardown_rmdir(){
	typeset dd="$1";
	if [ -d "${dd}" ]
	then
		typeset l=`ls ${dd} |wc -l`
		if [ $l = 0 ]
		then
			rm -fr "${dd}"
		fi
	fi
}

_ssu_TeardownForEvidence_test(){
	if [ -d "${_ssu_evi_dir}" ]
	then
		_ssu_teardown_rmdir "${_ssu_evi_dir}"
	fi
}
_ssu_TeardownForEvidence(){
	typeset d="${SSU_EVIDENCE_BASEDIR}"
	#casename
	_ssu_teardown_rmdir "${d}"
	
	#time
	d=`dirname "${d}"`
	_ssu_teardown_rmdir "${d}"
	
	#usr
	d=`dirname "${d}"`
	_ssu_teardown_rmdir "${d}"
	
	#evi
	d=`dirname "${d}"`
	_ssu_teardown_rmdir "${d}"
	
}


