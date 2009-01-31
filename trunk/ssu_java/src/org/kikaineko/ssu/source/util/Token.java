/*
 * 作成日： 2005/02/09
 *
 * TODO この生成されたファイルのテンプレートを変更するには次を参照。
 * ウィンドウ ＞ 設定 ＞ Java ＞ コード・スタイル ＞ コード・テンプレート
 */
package org.kikaineko.ssu.source.util;

/**
 * トークンを表現するクラス。
 * 文字列としての値と、種類、それがリテラルかどうかの真偽値を持つ。
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
