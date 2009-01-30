package org.kikaineko.ssu.db;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.kikaineko.ssu.csv.CSVParser;
import org.kikaineko.util.FileIO;
import org.kikianeko.ssu.exception.SSUException;

public class InsertCommand {
	public static void insert(String filePath, String jdbcClass, String url,
			String user, String password, String table) throws Exception {
		InsertMapper.setDbmsType(jdbcClass);
		ArrayList fileData = FileIO.getFileDatas(new File(filePath),FileIO.FileReadCodeToDB);
		if (fileData.size() < 1) {
			throw new SSUException("no data in " + filePath);
		}

		String head = (String) fileData.get(0);
		List names = null;
		if (!"*".equals(head.trim())) {
			names = CSVParser.lineParse(head);
		}
		fileData.remove(0);
		List csvdata = CSVParser.getCSVLineList(fileData);
		Connection conn = null;
		Statement stmt = null;
		String sql = "";
		try {
			conn = connect(jdbcClass, url, user, password);
			Object[] os = clmDefs(jdbcClass, url, user, password, table, conn);
			Map map = (Map) os[0];
			if (names == null) {
				names = (List) os[1];
			}
			conn.setAutoCommit(false);
			stmt = conn.createStatement();
			for (int i = 0; i < csvdata.size(); i++) {
				List data = (List) csvdata.get(i);
				sql = createSQL(names, map, data, table);

				// �⍇���̎��s
				stmt.executeUpdate(sql);
			}
			conn.commit();
		} catch (Throwable e) {
			if (conn != null) {
				try {
					conn.rollback();
				} catch (Exception e1) {
				}
			}
			throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
		} finally {
			close(conn, null, stmt);
		}
	}
	protected static String createSQL(List names, Map map, List data,String table)
			throws Throwable {
		StringBuffer presql = new StringBuffer("insert into ");
		presql.append(table).append(" (");
		StringBuffer val = new StringBuffer();
		int i = 0;
		try {
			for (i = 0; i < names.size(); i++) {
				String s = (String) names.get(i);
				Object o=InsertMapper.norm(((Integer) map.get(s)).intValue(),
						(String) data.get(i));
				if(o!=null){
					presql.append(s).append(",");
					val.append(o).append(",");
				}
			}
			presql=new StringBuffer(presql.substring(0, presql.length()-1));
			val=new StringBuffer(val.substring(0, val.length()-1));
			val.append(")");
		} catch (Throwable e) {
			throw new RuntimeException("ColumnName " + names.get(i)
					+ " is correct? or data short?", e);
		}
		presql.append(") values (").append(val);
		return presql.toString();
	}

	protected static Object[] clmDefs(String jdbcClass, String url,
			String user, String password, String table, Connection conn)
			throws Exception {
		Map map = new HashMap();
		ResultSet rset = null;
		Statement stmt = null;
		List names = new ArrayList();
		try {
			stmt = conn.createStatement();
			String sql = "select * from " + table;

			// �⍇���̎��s
			rset = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rset.getMetaData();
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				String s = rsmd.getColumnName(i + 1);
				names.add(s);
				map.put(s, Integer.valueOf(rsmd.getColumnType(i + 1)));
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close(null, rset, stmt);
		}
		return new Object[] { map, names };
	}

	private static Connection connect(String jdbcClass, String url,
			String user, String password) throws ClassNotFoundException,
			SQLException {
		Class.forName(jdbcClass);
		Connection conn = null;
		if (user != null && user.length() != 0) {
			conn = DriverManager.getConnection(url, user, password);
		} else {
			conn = DriverManager.getConnection(url);
		}
		return conn;
	}

	private static void close(Connection conn, ResultSet rset, Statement stmt) {
		if (rset != null) {
			try {
				rset.close();
			} catch (SQLException e) {
			}
		}
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
			}
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
			}
		}
	}
}