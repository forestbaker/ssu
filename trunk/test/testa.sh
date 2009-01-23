. /home/masayuki/ssu/SSU.sh

SSU_SELFPATH="../ssu"
beforeTest(){
        . /home/masayuki/ssu/Util.sh
}
test_aa(){
	assert_num 1 1
}
test_bb(){
	assert_num 10 10
}
test_cc(){
	assert_num 1 1
	h_make_file aa
	echo 234 > aa
	u_evi_file aa bb
	echo 234 >> aa
	u_evi_file aa bb
}
test_cc111111111111111111111(){
	assert_num 1 1
}
test_cc111111111111111111112(){
	assert_num 1 1
}
test_cc111111111111111111113(){
	assert_num 1 1
}
#DEBUG_MODE="ON"
date
startSSU;
date

