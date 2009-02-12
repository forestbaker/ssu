package org.kikaineko.ssu.db;

public class FormatException extends RuntimeException {
	private static final long serialVersionUID = -3675672693479902135L;
	private String data;
	private int csvLine = -1;
	private int cnmIndex = -1;
	private String columnTypeName;
	private String columnName;

	public FormatException(String mes, Throwable e) {
		super(mes, e);
	}

	public FormatException(Throwable e) {
		super(e);
	}

	public String getMessage() {
		return "Format Error! csvLine=" + getCSVLine() + ", cnmIndex="
				+ getCnmIndex() + ", data=" + getData() + ", columnName="
				+ getColumnName()+", columnTypeName="+getColumnTypeName();
	}

	public int getCnmIndex() {
		return cnmIndex;
	}

	public void setCnmIndex(int cnmInde) {
		this.cnmIndex = cnmInde;
	}

	public void setData(String s) {
		this.data = s;
	}

	public String getData() {
		return data;
	}

	public void setCSVLine(int i) {
		csvLine = i;
	}

	public int getCSVLine() {
		return csvLine;
	}

	public void setColumnTypeName(String columnTypeName) {
		this.columnTypeName = columnTypeName;
	}

	public String getColumnTypeName() {
		return columnTypeName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getColumnName() {
		return columnName;
	}

}
