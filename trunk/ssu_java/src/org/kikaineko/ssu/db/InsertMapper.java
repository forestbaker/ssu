package org.kikaineko.ssu.db;

import java.math.BigDecimal;
import java.sql.Types;

public class InsertMapper {
	private static final String DB2 = "db2";
	private static final String ORACLE = "oracle";
	private static String dbmsType = null;
	
	public static void setDbmsType(String jdbcClass) {
		String s = jdbcClass.toLowerCase();
		if (s.indexOf("db2") != -1) {
			dbmsType = "db2";
		} else if (s.indexOf("oracle") != -1) {
			dbmsType = "oracle";
		}
	}
	
	private static boolean isEmpty(String s) {
		return s == null || s.length() == 0;
	}
	
	
	protected static String sanit(String s) {
		if (s.indexOf("'") != -1) {
			s = s.replaceAll("'", "''");
		}
		return s;
	}
	
	public static String norm(int type, String s) {
		switch (type) {
		case Types.CHAR:
		case Types.VARCHAR:
		case Types.LONGVARCHAR:
		case Types.BINARY:
		case Types.VARBINARY:
		case Types.LONGVARBINARY:
			if (isEmpty(s)) {
				return "''";
			}
			return "'"+sanit(s)+"'";
		case Types.BIT:
			if ("0".equals(s)
					|| (!isEmpty(s) && "true".equals(s.toLowerCase()))) {
				return "'0'";
			} else {
				if(!isEmpty(s) && "false".equals(s.toLowerCase())){
					//数値の確認
					Integer.parseInt(s);
				}
				return "'1'";
			}
		case Types.TINYINT:
		case Types.SMALLINT:
			if (!isEmpty(s)) {
				return Short.valueOf(s).toString();
			} else {
				return "0";
			}
		case Types.INTEGER:
			if (!isEmpty(s)) {
				return Integer.valueOf(s).toString();
			} else {
				return "0";
			}
		case Types.BIGINT:
			if (!isEmpty(s)) {
				return Long.valueOf(s).toString();
			} else {
				return "0";
			}

		case Types.REAL:
			if (!isEmpty(s)) {
				return Float.valueOf(s).toString();
			} else {
				return "0";
			}
		case Types.FLOAT:
		case Types.DOUBLE:
			if (!isEmpty(s)) {
				return Double.valueOf(s).toString();
			} else {
				return "0";
			}
		case Types.NUMERIC:
		case Types.DECIMAL:
			if (!isEmpty(s)) {
				return new BigDecimal(Double.parseDouble(s)).toString();
			} else {
				return null;
			}

		case Types.DATE:
			return datef(s);
		case Types.TIME:
			//TODO
		case Types.TIMESTAMP:
			return timestampf(s);
		default:
			break;
		}
		return null;
	}
	
	protected static String timestampf(String s) {
		String t = TimeF.toSFromTimestamp(s);
		if(t.length()==0){
			return null;
		}
		if (DB2.equals(dbmsType)) {
			return "'" + t + "'";
		}
		if (ORACLE.equals(dbmsType)) {
			return "to_timestamp('" + t + "','yyyy-mm-dd hh24:mi:ss.ff3')";
		}
		return "'" + s + "'";
	}

	protected static String datef(String s) {
	//	String t = TimeF.toSFromDate(s);
		//TODO 一時的な対応
		String t = TimeF.toSFromTimestamp(s);
		if(t.length()==0){
			return null;
		}
		String[] ss=t.split("\\.");
		t=ss[0];
		if (DB2.equals(dbmsType)) {
			return "'" + t + "'";
		}
		if (ORACLE.equals(dbmsType)) {
			return "to_date('" + t + "','yyyy-mm-dd hh24:mi:ss')";
		}
		return "'" + s + "'";
	}
}
