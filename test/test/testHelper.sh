. ../../ssu/SSU.sh
SSU_HOME="../../ssu"

beforeTest(){
	h_make_file tmp_0.txt
	h_make_file tmp_1.txt
	h_make_file tmp_2.txt
	h_make_file tmp_3.txt
	h_make_file tmp_4.txt
	echo "0" > tmp_0.txt
	echo "1" > tmp_1.txt
	echo "2" > tmp_2.txt
	echo "3" > tmp_3.txt
	echo "4" > tmp_4.txt
	h_mkdir tmp_dir
	cur_dir=`pwd`
}

test_h_mv(){
	assert_exit_code "h_mv" 99 > /dev/null
	assert_exit_code "h_mv no_exist_file no_exist_file.tmp" 99 > /dev/null
	assert_exit_code "h_mv tmp_0.txt pmt_0.txt -no_exist_option" 99 2&> /dev/null

	h_mv tmp_0.txt pmt_0.txt
	h_mv tmp_1.txt pmt_1.txt -i

	h_make_file hage.txt
	echo "hagemaru" >  hage.txt
	h_mv hage.txt foo.txt
	h_mv foo.txt foo.txt.tmp
	assert_include_in_file "hagemaru" foo.txt.tmp

}

test_h_chmod(){
	assert_exit_code "h_chmod" 99 > /dev/null
	assert_exit_code "h_chmod 666 no_exist_file" 99 2&> /dev/null
	assert_exit_code "h_chmod 888 tmp_4.txt" 99 2&> /dev/null
	h_chmod 666 tmp_0.txt
	h_chmod 444 tmp_1.txt
}

#test_h_chown(){
#	assert_exit_code "h_chown" 99 > /dev/null
#	assert_exit_code "h_chown no_exit_user tmp_0.txt" 99 &> /dev/null
#}

test_h_cp(){
	assert_exit_code "h_cp" 99 > /dev/null
	assert_exit_code "h_cp no_exist_file tmp_0.txt" 99 &> /dev/null
	h_cp tmp_0.txt z1.txt
	assert_file z1.txt
	h_cp z1.txt z2.txt
	assert_file z2.txt
	h_mv z2.txt z3.txt
	h_chmod 777 z3.txt
	assert_exit_code "h_cp z2.txt z4.txt" 99 2&> /dev/null
}

test_h_rm(){
	assert_exit_code "h_rm" 99 > /dev/null
	assert_exit_code "h_rm no_exist_file" 1 2&> /dev/null
	assert_exit_code "h_rm tmp_0.txt tmp_1.txt -f" 99 &> /dev/null
}

test_h_cd(){
	assert_exit_code "h_cd" 99 > /dev/null
	assert_exit_code "h_cd no_exist_dir" 99 &> /dev/null
	assert_exit_code "h_cd tmp_dir no_exist_option" 99 &> /dev/null
	assert_exit_code "h_cd tmp_dir -P aaa" 99 &> /dev/null

	h_cd tmp_dir
	tmp_dir=`pwd`

	assert_not_same_str ${cur_dir} ${tmp_dir}

	h_mkdir tmp_sub_dir
	ln -s tmp_sub_dir hoge

	h_cd tmp_sub_dir
	h_cd ../hoge
	h_cd ..
	h_rm -r hoge

	h_cd - > /dev/null
	h_cd ~
}

#test_h_mkdir(){
#
#}

#test_h_file_name(){
#
#}

afterTest(){
	assert_include_in_file "0" tmp_0.txt
}



date
startSSU
date

