package org.kikaineko.ssu.csv;

class CSVState {
	public static CSVState End=new CSVState(0);
	public static CSVState NotYetEnd=new CSVState(1);
	public static CSVState NotWord=new CSVState(2);
	private int index=-1;
	private CSVState(int i){
		index=i;
	}
	public boolean equals(Object other){
		if(other==null){
			return false;
		}
		if(other instanceof CSVState){
			CSVState o=(CSVState)other;
			return o.index==this.index;
		}
		return false;
	}
}
