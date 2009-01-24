package org.kikaineko.ssu.csv;

class CSVTokenKind {
	public static CSVTokenKind Start=new CSVTokenKind(0);
	public static CSVTokenKind DoubleQ=new CSVTokenKind(1);
	public static CSVTokenKind ClosedStart=new CSVTokenKind(2);
	public static CSVTokenKind Comma=new CSVTokenKind(3);
	public static CSVTokenKind ClosedWord=new CSVTokenKind(4);
	public static CSVTokenKind ClosedEnd=new CSVTokenKind(5);
	public static CSVTokenKind Word=new CSVTokenKind(6);
	private int index=-1;
	private CSVTokenKind(int i){
		index=i;
	}
	public boolean equals(Object other){
		if(other==null){
			return false;
		}
		if(other instanceof CSVTokenKind){
			CSVTokenKind o=(CSVTokenKind)other;
			return o.index==this.index;
		}
		return false;
	}
}
