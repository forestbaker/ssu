#!/bin/sh

################################################################################
#String
################################################################################
# u_str_capitalize
# capitalizing string
# ex) abc -> Abc , XYZ -> Xyz
# $1 string
################################################################################
u_str_capitalize(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_capitalize";
		return 1;
	fi
	typeset str=${1}
	typeset num=`echo ${#str}`
	str=`echo ${str} | tr [:upper:] [:lower:]`
	typeset c=`echo ${str}|cut -c 1`
	c=`echo ${c} | tr [:lower:] [:upper:]`
	typeset other=`echo ${str}|cut -c 2-${num}`
	echo ${c}${other}
}

################################################################################
# u_str_chop
# last char delete. if last char is [\r,\n],this function also delets these chars.
# ex) abc -> ab
# $1 string
################################################################################
u_str_chop(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_chop";
		return 1;
	fi
	typeset str=`echo "${1}"`
	typeset num=`echo ${#str}`
	if [[ ${num} -eq 0 ]];then
		echo "";
		return 0;
	fi
	num=$((${num} - 1))
	typeset other=`echo "${str}"|cut -c 1-${num}`
	echo "${other}"
}

################################################################################
# u_str_delete
# slike tr
# $1 string
# $2 delete string
################################################################################
u_str_delete(){
	if [[ $# != 2 ]]
	then
		_ssu_util_ExitLog "u_str_delete";
		return 1;
	fi
	typeset str=`echo "${1}" | tr -d "${2}"`
	echo "${str}"
}

################################################################################
# u_str_downcase
# to downcase
# $1 string
################################################################################
u_str_downcase(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_downcase";
		return 1;
	fi
	typeset str=`echo "${1}" | tr [:upper:] [:lower:]`
	echo "${str}"
}

################################################################################
# u_str_isEmpty
# empty check
# true -> return 0
# false -> return 1
# $1 string
################################################################################
u_str_isEmpty(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_isEmpty";
		return 1;
	fi
	if [ -z "${1}" ]
	then
		echo 0;
	else
		echo 1;
	fi
}

################################################################################
# u_str_gsub
# replace
# $1 string
# $2 pattern
# $3 replace
################################################################################
u_str_gsub(){
	if [[ $# != 3 ]]
	then
		_ssu_util_ExitLog "u_str_gsub";
		return 1;
	fi
	typeset str="${1}";
	typeset pattern="${2}";
	typeset replace="${3}";
	if [ -z "${replace}" ]
	then
		typeset new_str=`echo "${str}" | tr -d "${pattern}"`
	else
		typeset new_str=`echo "${str}" | tr "${pattern}" "${replace}"`
	fi
	echo "${new_str}"
}

################################################################################
# u_str_isInclude
# string contains other check
# true -> 0
# false -> 1
# $1 string
# $2 other
################################################################################
u_str_isInclude(){
	if [[ $# != 2 ]]
	then
		_ssu_util_ExitLog "u_str_isInclude";
		return 1;
	fi
	typeset str="${1}";
	typeset other="${2}";
	echo "${str}" | grep "${other}" > /dev/null 2>&1
	if [[ $? -eq 0 ]]
	then
		echo 0;
	else
		echo 1;
	fi
}

################################################################################
# u_str_index
# index of other in string
# u_str_index abcd bc  #-> 1
# u_str_index abcd bcx  #-> -1
# $1 string
# $2 other
################################################################################
u_str_index(){
	if [[ $# != 2 ]]
	then
		_ssu_util_ExitLog "u_str_index";
		return 1;
	fi
	typeset str="${1}";
	typeset str_num=${#str}
	typeset other="${2}";
	typeset other_num=${#other}

	if [[ ${other_num} -gt ${str_num} ]]
	then
		echo "-1"
		return 0;
	fi
	typeset max=$((${str_num} - ${other_num}))
	typeset i=0;
	typeset j=0;
	typeset s="";
	while [ ${i} -le ${max} ]
	do
		j=$((${i}+${other_num}))
		i=$((${i}+1))
		s=`echo "${str}" |cut -c ${i}-${j}`
		if [ "${s}" = "${other}" ]
		then
			i=$((${i}-1))
			echo ${i}
			return 0;
		fi
	done
	echo -1
}

################################################################################
# u_str_insert
# insert other into string
# ex: u_str_insert foobaz 3 bar #-> foobarbaz
# $1 string
# $2 index
# $3 other
################################################################################
u_str_insert(){
	if [[ $# != 3 ]]
	then
		_ssu_util_ExitLog "u_str_insert";
		return 1;
	fi
	typeset str="${1}"
	typeset index=${2}
	typeset other="${3}"
	typeset size=${#str}
	if [[ ${index} -lt 0 ]]
	then
		echo "index must be over 0"
		return 1;
	elif [[ ${index} -gt ${size} ]]
	then
		echo "index out of string"
		return 1;
	fi
	if [[ ${index} -eq ${size} ]]
	then
		echo "${str}""${other}"
		return 0;
	elif [[ ${index} -eq 0 ]]
	then
		echo "${other}""${str}"
		return 0;
	fi
	typeset pre=`echo "${str}" |cut -c 1-${index}`
	index=$((${index}+1))
	typeset post=`echo "${str}" | cut -c ${index}-${size}`
	echo "${pre}""${other}""${post}"
}

################################################################################
# u_str_reverse
# reverse string
# $1 string
################################################################################
u_str_reverse(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_reverse";
		return 1;
	fi
	typeset str=`echo "${1}"`
	typeset size=${#str}
	if [[ ${size} -eq 0 || ${size} -eq 1 ]]
	then
		echo "${str}"
		return 0;
	fi
	typeset i=${size}
	typeset s=""
	typeset new_str=""
	while [ ${i} -gt 0 ]
	do
		s=`echo ${str} | cut -c ${i}`
		new_str="${new_str}""${s}"
		i=$((${i}-1))
	done
	echo "${new_str}"
}

################################################################################
# u_str_size
# size of string
# $1 string
################################################################################
u_str_size(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_size";
		return 1;
	fi
	typeset str=`echo "${1}"`
	echo ${#str}
}

################################################################################
# u_str_split
# separate of string and return index-th str
# u_str_split "abc 123" 1 #-> 123
# $1 string
# $2 index
################################################################################
u_str_split(){
	if [[ $# != 2 ]]
	then
		_ssu_util_ExitLog "u_str_split";
		return 1;
	fi
	typeset str="${1}"
	typeset max=${#str}
	typeset index=${2}
	index=$((${index}+1))
	typeset i=1
	typeset _index=1
	typeset s="";
	while [ ${_index} -le ${index} ]
	do
		s=`echo "${str}" | cut -d " " -f ${i}`
		if [[ ! -z "${s}" ]]
		then
			_index=$((${_index}+1))
		fi
		i=$((${i}+1))
		if [[ ${i} -gt ${max} ]]
		then
			echo "index is out of string range";
			return 1;
		fi
	done
	echo "${s}"
}

################################################################################
# u_str_upcase
# to upcase
# $1 string
################################################################################
u_str_upcase(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_upcase";
		return 1;
	fi
	typeset str=`echo "${1}" | tr [:lower:] [:upper:]`
	echo "${str}"
}

################################################################################
# u_str_toFilePermissionNumber
# ex: u_str_toFilePermissionNumber "rw-" #-> 6
# ex: u_str_toFilePermissionNumber "rw-r--r--" #-> 644
# $1 string
################################################################################
u_str_toFilePermissionNumber(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_str_toFilePermissionNumber";
		return 1;
	fi
	typeset str="${1}"
	typeset number=""
	typeset s="";
	typeset istart=1
	typeset iend=0
	typeset i="";
	if [[ ${#str} -gt 9 ]]
	then
		_ssu_util_ExitLog "u_str_toFilePermissionNumber";
		return 1;
	fi
	while [ ${istart} -lt 8 ]
	do
		iend=$((${istart}+2))
		s=`echo "${str}" | cut -c ${istart}-${iend}`
		if [ ! -z "${s}" ]
		then
			i=`u_str_toFilePermissionNumber_inner "${s}"`
			if [[ $? -ne 0 ]]
			then
				_ssu_util_ExitLog "u_str_toFilePermissionNumber";
				return 1;
			fi
			number="${number}""${i}"
		fi
		istart=$((${istart}+3))
	done
	echo ${number}
}
u_str_toFilePermissionNumber_inner(){
	typeset i=0;
	typeset t=`echo ${1} | cut -c 1`
	if [ ${t} = "r" ];then
		i=$((${i}+4))
	elif [ ${t} != "-" ]
	then
		return 1;
	fi
	t=`echo ${1} | cut -c 2`
	if [ ${t} = "w" ];then
		i=$((${i}+2))
	elif [ ${t} != "-" ]
	then
		return 1;
	fi
	t=`echo ${1} | cut -c 3`
	if [ ${t} = "x" ];then
		i=$((${i}+1))
	elif [ ${t} != "-" ]
	then
		return 1;
	fi
	echo ${i}
}


################################################################################
#NUMBER
################################################################################
# u_num_toFilePermission
# ex: u_num_toFilePermission 6 #-> "rw-"
# ex: u_num_toFilePermission 644 #-> "rw-r--r--"
# $1 string
################################################################################
u_num_toFilePermission(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_num_toFilePermission";
		return 1;
	fi
	
	typeset number="${1}"
	typeset str=""
	typeset s="";
	typeset istart=1
	typeset i="";
	if [[ ${#number} -gt 3 ]]
	then
		_ssu_util_ExitLog "u_num_toFilePermission";
		return 1;
	fi
	while [ ${istart} -lt 4 ]
	do
		s=`echo "${number}" | cut -c ${istart}`
		if [ ! -z "${s}" ]
		then
			i=`u_num_toFilePermission_inner "${s}"`
			if [[ $? -ne 0 ]]
			then
				_ssu_util_ExitLog "u_num_toFilePermission";
				return 1;
			fi
			str="${str}""${i}"
		fi
		istart=$((${istart}+1))
	done
	echo ${str}
}
u_num_toFilePermission_inner(){
	typeset i=${1}
	if [ ${i} -eq 7 ];then
		echo "rwx"
	elif [ ${i} -eq 6 ];then
		echo "rw-"
	elif [ ${i} -eq 5 ];then
		echo "r-x"
	elif [ ${i} -eq 4 ];then
		echo "r--"
	elif [ ${i} -eq 3 ];then
		echo "-wx"
	elif [ ${i} -eq 2 ];then
		echo "-w-"
	elif [ ${i} -eq 1 ];then
		echo "--x"
	elif [ ${i} -eq 0 ];then
		echo "---"
	else
		return 1;
	fi
}

################################################################################
#File
################################################################################
# u_f_isFile
# is file check
# true -> 0
# false -> 1
# $1 file path
################################################################################
u_f_isFile(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_isFile";
		return 1;
	fi
	typeset file="${1}"
	if [[ -f "${file}" || -L "${file}" ]]
	then
		echo 0;
		return 0;
	fi
	echo 1;
}

################################################################################
# u_f_isDir
# is dir check
# true -> 0
# false -> 1
# $1 file path
################################################################################
u_f_isDir(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_isDir";
		return 1;
	fi
	typeset dir="${1}"
	if [[ -d "${dir}" ]]
	then
		echo 0;
		return 0;
	fi
	echo 1;
}

################################################################################
# u_f_getPermission
# $1 file path
################################################################################
u_f_getPermission(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getPermission";
		return 1;
	fi
	typeset file="${1}"
	if [[ ! -f "${file}" && ! -d "${file}" && ! -L "${file}" ]]
	then
		echo "cannot find ${file}";
		return 1;
	fi
	typeset perm=`ls -ld "${file}" | cut -d " " -f 1 |cut -c 2-10`
	echo ${perm}
}

################################################################################
# u_f_getSize
# $1 file path
################################################################################
u_f_getSize(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getSize";
		return 1;
	fi
	typeset file="${1}"
	if [[ ! -f "${file}" && ! -d "${file}" && ! -L "${file}" ]]
	then
		echo "cannot find ${file}";
		return 1;
	fi
	typeset status=`ls -lod "${file}"`
	typeset size=`u_str_split "${status}" 3`
	echo ${size}
}


################################################################################
# u_f_getUser
# $1 file path
################################################################################
u_f_getUser(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getUser";
		return 1;
	fi
	typeset file="${1}"
	if [[ ! -f "${file}" && ! -d "${file}" && ! -L "${file}" ]]
	then
		echo "cannot find ${file}";
		return 1;
	fi
	typeset status=`ls -lod "${file}"`
	typeset u=`u_str_split "${status}" 2`
	echo ${u}
}

################################################################################
# u_f_getGroup
# $1 file path
################################################################################
u_f_getGroup(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getGroup";
		return 1;
	fi
	typeset file="${1}"
	if [[ ! -f "${file}" && ! -d "${file}" && ! -L "${file}" ]]
	then
		echo "cannot find ${file}";
		return 1;
	fi
	typeset status=`ls -ld "${file}"`
	typeset g=`u_str_split "${status}" 3`
	echo ${g}
}

################################################################################
# u_f_getOwn
# $1 file path
################################################################################
u_f_getOwn(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getOwn";
		return 1;
	fi
	typeset file="${1}"
	if [[ ! -f "${file}" && ! -d "${file}" && ! -L "${file}" ]]
	then
		echo "cannot find ${file}";
		return 1;
	fi
	typeset status=`ls -ld "${file}"`
	typeset u=`u_str_split "${status}" 2`
	typeset g=`u_str_split "${status}" 3`
	echo "${u}"."${g}"
}

################################################################################
# u_f_getTimestamp
# $1 file path
################################################################################
u_f_getTimestamp(){
	if [[ $# != 1 ]]
	then
		_ssu_util_ExitLog "u_f_getTimestamp";
		return 1;
	fi
	typeset file="${1}"
	if [[ ! -f "${file}" && ! -d "${file}" && ! -L "${file}" ]]
	then
		echo "cannot find ${file}";
		return 1;
	fi
	${JAVA_CMD} -jar ${_ssu_UtilJar} "${SSU_CHARCODE}" "util" "file-time" "${file}"
}

################################################################################
# u_db_insert
# $1 inout file
# $2 table
# $3 where-condition (option)
################################################################################
u_db_insert(){
	if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_util_ExitLog "u_db_insert";
		return 1;
	fi
	typeset file="${1}";
	typeset table="${2}";
	typeset where=" ";
	if [ $# = 3 ]
	then
		where="${3}";
	fi
	
	${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "insert" "${file}" "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}
	typeset r=$?
	if [ $r -ne 0 ]
	then
		echo "u_db_insert error!! ${table} ${file}"
		exit 1
	fi
}

################################################################################
# u_db_delete
# $1 table
# $3 where-condition (option)
################################################################################
u_db_delete(){
	if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_db_delete";
		return 1;
	fi
	typeset table="${1}";
	typeset where=" ";
	if [ $# = 2 ]
	then
		where="${2}";
	fi
	
	${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "delete" ".." "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}
	typeset r=$?
	if [ $r -ne 0 ]
	then
		echo "u_db_delete error!! ${table}"
		exit 1
	fi
}

################################################################################
# u_db_select_to
# $1 inout file
# $2 table
# $3 where-condition (option)
################################################################################
u_db_select_to(){
if [[ $# != 2 && $# != 3 ]]
	then
		_ssu_util_ExitLog "u_db_select_to";
		return 1;
	fi
	typeset file="${1}";
	typeset table="${2}";
	typeset where=" ";
	if [ $# = 3 ]
	then
		where="${3}";
	fi
	
	${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "selectto" "${file}" "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}
	typeset r=$?
	if [ $r -ne 0 ]
	then
		echo "u_db_select_to error!! ${table} ${file}"
		exit 1
	fi
}


################################################################################
# u_db_select
# $1 table
# $2 where-condition (option)
################################################################################
u_db_select(){
if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_db_select";
		return 1;
	fi
	typeset table="${1}";
	typeset where=" ";
	if [ $# = 2 ]
	then
		where="${2}";
	fi
	
	${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "selectout" ".." "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}
	typeset r=$?
	if [ $r -ne 0 ]
	then
		echo "u_db_select error!! ${table}"
		exit 1
	fi
}


################################################################################
# u_evi_db
# $1 table
# $2 evi-filename (option)
################################################################################
u_evi_db(){
if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_evi_db";
		return 1;
	fi
	typeset table="${1}";
	typeset name="${table}";
	if [ $# = 2 ]
	then
		name="${2}";
	fi
	name=`basename "${name}"`
	
	typeset file=`_ssu_util_evi_FileName "${name}"`
	
	typeset where=" ";
	${JAVA_CMD} -cp "${JDBC_JAR}${_ssu_jarsep}${_ssu_UtilJar}" org.kikaineko.ssu.Main "${SSU_CHARCODE}" "db" "selectto" "${file}" "${table}" "${JDBC_CLASS}" "${JDBC_URL}" "${where}" ${JDBC_USER} ${JDBC_PASSWORD}
	typeset r=$?
	if [ $r -ne 0 ]
	then
		echo "u_evi_db error!! ${table} ${file}"
		exit 1
	fi
}

################################################################################
# u_evi_file
# $1 filename
# $2 evi-filename (option)
################################################################################
u_evi_file(){
if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_evi_file";
		return 1;
	fi
	typeset moto="${1}";
	typeset name=`basename "${moto}"`
	if [ $# = 2 ]
	then
		name="${2}";
	fi
	name=`basename "${name}"`
	
	typeset file=`_ssu_util_evi_FileName "${name}"`
	cp -pf "${moto}" "${file}"
	typeset r=$?
	if [ $r -ne 0 ]
	then
		echo "u_evi_file error!! ${moto} ${file}"
		exit 1
	fi
}

################################################################################
# u_evi_dir
# $1 dir-name
# $2 evi-dir-name (option)
################################################################################
u_evi_dir(){
if [[ $# != 1 && $# != 2 ]]
	then
		_ssu_util_ExitLog "u_evi_file";
		return 1;
	fi
	typeset moto="${1}";
	typeset name=`basename "${moto}"`
	if [ $# = 2 ]
	then
		name="${2}";
	fi
	name=`basename "${name}"`
	
	typeset dir=`_ssu_util_evi_FileName "${name}"`
	rm ${dir}
	mkdir ${dir}
	typeset r=$?
	if [ $r -ne 0 ]
	then
		echo "u_evi_dir error!!:cannot create dir: ${moto} ${dir}"
		exit 1
	fi
	
	cp -pfr "${moto}" "${dir}"
	r=$?
	if [ $r -ne 0 ]
	then
		echo "u_evi_dir error!! ${moto} ${dir}"
		exit 1
	fi
}


################################################################################
_ssu_util_ExitLog(){
	echo ${1}" Wrong Arguments!";
	if [[ $# == 2 ]]
	then
		echo "${2}";
	fi
	
}

_ssu_util_evi_FileName(){
	typeset name=`basename $1`
	typeset tempName=${name}"_"
	typeset i=1
	while [[ -a ${_ssu_evi_dir}/"${tempName}${i}.log" ]] 
	do
		i=$((${i}+1))
	done
	touch ${_ssu_evi_dir}/"${tempName}${i}.log"
	echo ${_ssu_evi_dir}/"${tempName}${i}.log"
}

