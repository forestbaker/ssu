/*
 * �쐬���F 2005/02/09
 *
 * TODO ���̐������ꂽ�t�@�C���̃e���v���[�g��ύX����ɂ͎����Q�ƁB
 * �E�B���h�E �� �ݒ� �� Java �� �R�[�h�E�X�^�C�� �� �R�[�h�E�e���v���[�g
 */
package org.kikaineko.ssu.source.util;

/**
 * �g�[�N����\������N���X�B
 * ������Ƃ��Ă̒l�ƁA��ށA���ꂪ���e�������ǂ����̐^�U�l�����B
 * @author Masayuki Ioki
 *
 */
public class Token {
	private int kind;
	private String val;
	public boolean isStringOrChar=false;
	int lineNo;
	
	public Token(int kind,String val){
		this.kind=kind;
		this.val=val;
	}
	
	public void setKind(int kind){
		this.kind=kind;
	}
	/**
	 * @return kind
	 */
	public int getKind() {
		return kind;
	}
	/**
	 * @return val
	 */
	public String getVal() {
		return val;
	}

	public int getLineNo() {
		return lineNo;
	}

	public void setLineNo(int lineNo) {
		this.lineNo = lineNo;
	}
	
	public String toString(){
		return "["+kind+","+val+","+isStringOrChar+","+lineNo+"]";
	}
}
