package org.kikaineko.ssu.db;

import java.math.BigDecimal;

public class SSUBigDecimal {
	public BigDecimal bd;
	public SSUBigDecimal(BigDecimal bd){
		this.bd=bd;
	}
	public boolean equals(Object other){
		if(other==null || !(other instanceof SSUBigDecimal)){
			return false;
		}
		BigDecimal ob=((SSUBigDecimal)other).bd;
		if(this.bd.equals(ob)){
			return true;
		}
		int thisScale=this.bd.scale();
		int otherScale=ob.scale();
		if(thisScale<otherScale){
			thisScale=otherScale;
		}
		BigDecimal b0=this.bd.setScale(thisScale);
		BigDecimal b1=ob.setScale(thisScale);
		if(b0.equals(b1)){
			return true;
		}
		return false;
	}
	
	public String toString(){
		return bd.toString();
	}
}
