package org.kikaineko.ssu.db;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.kikaineko.ssu.csv.CSVParser;
import org.kikaineko.util.FileIO;
import org.kikianeko.ssu.exception.DBCheckException;
import org.kikianeko.ssu.exception.SSUException;

public class SelectCommand {
	private static String BR = System.getProperty("line.separator");

	public static void selectTo(String flag, String filePath, String jdbcClass,
			String url, String user, String password, String table, String where)
			throws Exception {
		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		StringBuffer sb = new StringBuffer();
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);

			sql = "select * from " + table;
			if (where != null && where.trim().length() != 0) {
				sql += " " + where;
			}
			// 問合せの実行
			rset = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rset.getMetaData();
			List names = new ArrayList();
			List types = new ArrayList();
			names.add(rsmd.getColumnName(1));
			types.add(Integer.valueOf(rsmd.getColumnType(1)));
			sb.append(rsmd.getColumnName(1));
			for (int i = 1; i < rsmd.getColumnCount(); i++) {
				names.add(rsmd.getColumnName(i + 1));
				types.add(Integer.valueOf(rsmd.getColumnType(i + 1)));
				sb.append(",");
				sb.append(rsmd.getColumnName(i + 1));
			}
			sb.append(BR);
			// 問合せ結果の表示
			while (rset.next()) {
				String name = (String) names.get(0);
				int type = ((Integer) types.get(0)).intValue();
				sb.append(Mapper.normTOCSV(rset, name, type));
				for (int i = 1; i < names.size(); i++) {
					name = (String) names.get(i);
					type = ((Integer) types.get(i)).intValue();
					sb.append(",");
					sb.append(Mapper.normTOCSV(rset, name, type));
				}
				sb.append(BR);
			}
		} catch (Throwable e) {
			throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
		} finally {
			close(conn, rset, stmt);
		}
		if (DBCommander.SELECTTO.equals(flag)) {
			FileIO.writeOutPutFile(filePath, sb.toString(),
					FileIO.FileWriteCodeFromDB);
		} else {
			System.out.print(sb);
		}
	}

	public static void selectAssertOrder(String filePath, String jdbcClass,
			String url, String user, String password, String table, String where)
			throws Throwable {
		ArrayList fileData = FileIO.getFileDatas(new File(filePath),
				FileIO.FileReadCodeToDB);
		if (fileData.size() < 2) {
			throw new SSUException("no data in " + filePath);
		}
		String head = (String) fileData.get(0);
		fileData.remove(0);
		List csvdata = CSVParser.getCSVLineList(fileData);
		int max = ((List) csvdata.get(0)).size();
		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);

			sql = "select " + head + " from " + table;
			if (where != null && where.trim().length() != 0) {
				sql += " " + where;
			}
			// 問合せの実行
			rset = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rset.getMetaData();

			// 問合せ結果の表示
			while (rset.next()) {
				ArrayList temp = new ArrayList();
				for (int i = 1; i <= max; i++) {
					temp.add(Mapper.normFromDB(rset, i, rsmd.getColumnType(i)));
				}

				if (csvdata.size() == 0) {
					throw new DBCheckException("not find " + temp.toString()
							+ " in " + filePath + "\n sql => " + sql);
				}
				List data = (List) csvdata.get(0);
				List csvtmp = new ArrayList();
				for (int i = 0; i < data.size(); i++) {
					csvtmp.add(Mapper.normFromCSV((String) data.get(i), rsmd
							.getColumnType(i + 1)));
				}

				if (csvtmp.size() != temp.size()) {
					throw new DBCheckException("unmuched count of columns DB:"
							+ temp.toString() + " FILE:" + csvtmp
							+ "\n sql => " + sql);
				}
				for (int i = 0; i < csvtmp.size(); i++) {
					Object co = csvtmp.get(i);
					Object dbo = temp.get(i);
					if (co != null && co.equals(dbo)) {
					} else if (co == null && dbo == null) {
					} else {
						throw new DBCheckException("unmuched DB:"
								+ temp.toString() + " FILE:" + csvtmp
								+ "\n unmuched column number is " + (i + 1)
								+ " DB:" + dbo + " FILE:" + co + "  \n sql => "
								+ sql);
					}
				}
				csvdata.remove(0);
			}

			if (csvdata.size() != 0) {
				throw new DBCheckException("not find " + csvdata.toString()
						+ " in table<" + table + ">\n sql => " + sql);
			}
		} catch (Throwable e) {
			if (e instanceof DBCheckException) {
				throw e;
			} else {
				throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
			}
		} finally {
			close(conn, rset, stmt);
		}
	}

	/**
	 * flagは、complete/includeの２つ。completeはCSVとDBが完全に一致する。includeはCSVの内容がDBに含まれていればよい。<br>
	 * flagにcomplete以外を指定した場合、includeと解釈される。
	 * 
	 * @param flag
	 * @param filePath
	 * @param jdbcClass
	 * @param url
	 * @param user
	 * @param password
	 * @param table
	 * @param where
	 * @throws Throwable
	 */
	public static void selectAssert(String flag, String filePath,
			String jdbcClass, String url, String user, String password,
			String table, String where) throws Throwable {
		if (!flag.equals("complete")) {
			flag = "include";
		}
		ArrayList fileData = FileIO.getFileDatas(new File(filePath),
				FileIO.FileReadCodeToDB);
		if (fileData.size() < 2) {
			throw new SSUException("no data in " + filePath);
		}
		String head = (String) fileData.get(0);
		fileData.remove(0);
		List csvdata = CSVParser.getCSVLineList(fileData);
		int max = ((List) csvdata.get(0)).size();
		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);

			sql = "select " + head + " from " + table;
			if (where != null && where.trim().length() != 0) {
				sql += " " + where;
			}
			// 問合せの実行
			rset = stmt.executeQuery(sql);
			ResultSetMetaData rsmd = rset.getMetaData();

			List csvMapped = new ArrayList();
			for (int i = 0; i < csvdata.size(); i++) {
				List data = (List) csvdata.get(i);
				List csvtmp = new ArrayList();
				for (int j = 0; j < data.size(); j++) {
					csvtmp.add(Mapper.normFromCSV((String) data.get(j), rsmd
							.getColumnType(j + 1)));
				}
				csvMapped.add(csvtmp);
			}

			// 問合せ結果の表示
			while (rset.next()) {
				if (!flag.equals("complete")) {
					if (csvdata.size() == 0) {
						break;
					}
				}
				// 列番号による指定
				ArrayList temp = new ArrayList();
				for (int i = 1; i <= max; i++) {
					temp.add(Mapper.normFromDB(rset, i, rsmd.getColumnType(i)));
				}
				int index = -1;
				for (int i = 0; i < csvMapped.size(); i++) {
					List csvtmp = (List) csvMapped.get(i);

					if (csvtmp.equals(temp)) {
						index = i;
						break;
					}
				}
				if (flag.equals("complete")) {
					if (index == -1) {
						throw new DBCheckException("not find "
								+ temp.toString() + " in " + filePath
								+ "\n sql => " + sql);
					}
				}
				if (index != -1) {
					csvMapped.remove(index);
				}
			}

			if (csvMapped.size() != 0) {
				throw new DBCheckException("not find " + csvMapped.toString()
						+ " in table<" + table + ">\n sql => " + sql);
			}
		} catch (Throwable e) {
			if (e instanceof DBCheckException) {
				throw e;
			} else {
				throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
			}
		} finally {
			close(conn, rset, stmt);
		}
	}

	public static void countAssert(String count, String jdbcClass, String url,
			String user, String password, String table, String where)
			throws Throwable {
		try {
			Integer.parseInt(count);
		} catch (Throwable t) {
			throw new DBCheckException("UnCorrect Count! ExpectedValue is not number? " + count);
		}
		String[] ss = count(jdbcClass, url, user, password, table, where);
		String res = ss[1];
		String sql = ss[0];
		if (res != null && res.length() != 0) {
			if (!res.trim().equals(count.trim())) {
				throw new DBCheckException("UnCorrect Count! Expected:" + count
						+ " ,but Actual:" + res + "!! \n sql => " + sql);
			}
		} else {
			throw new DBCheckException("UnCorrect Count! Expected:" + count
					+ " ,but We cannnot get Count!! \n sql => " + sql);
		}
	}

	public static void countAssertNot(String count, String jdbcClass,
			String url, String user, String password, String table, String where)
			throws Throwable {
		try {
			Integer.parseInt(count);
		} catch (Throwable t) {
			throw new DBCheckException("UnCorrect Count! UnExpectedValue is not number? " + count);
		}
		String[] ss = count(jdbcClass, url, user, password, table, where);
		String res = ss[1];
		String sql = ss[0];
		if (res != null && res.length() != 0) {
			if (res.trim().equals(count.trim())) {
				throw new DBCheckException("UnCorrect Count! UnExpected:" + count
						+ " ,but Actual:" + res + "!! \n sql => " + sql);
			}
		} else {
			throw new DBCheckException("UnCorrect Count! Expected:" + count
					+ " ,but We cannnot get Count!! \n sql => " + sql);
		}
	}

	private static String[] count(String jdbcClass, String url, String user,
			String password, String table, String where) throws Throwable {

		Connection conn = null;
		ResultSet rset = null;
		Statement stmt = null;
		String sql = null;
		try {
			stmt = connect(jdbcClass, conn, url, user, password);

			sql = "select count(1) from " + table;
			if (where != null && where.trim().length() != 0) {
				sql += " " + where;
			}
			// 問合せの実行
			rset = stmt.executeQuery(sql);
			rset.next();
			String res = rset.getString(1);
			String[] ss = new String[2];
			ss[0] = sql;
			ss[1] = res.trim();
			return ss;
		} catch (Throwable e) {
			if (e instanceof DBCheckException) {
				throw e;
			}
			throw new Exception(e.getMessage() + "\n sql=>" + sql, e);
		} finally {
			close(conn, rset, stmt);
		}
	}

	private static Statement connect(String jdbcClass, Connection conn,
			String url, String user, String password)
			throws ClassNotFoundException, SQLException {
		Class.forName(jdbcClass);
		if (user != null && user.length() != 0) {
			conn = DriverManager.getConnection(url, user, password);
		} else {
			conn = DriverManager.getConnection(url);
		}
		return conn.createStatement();
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
