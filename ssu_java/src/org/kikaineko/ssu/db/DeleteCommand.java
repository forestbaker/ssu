package org.kikaineko.ssu.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DeleteCommand {
	public static void delete(String jdbcClass, String url,
			String user, String password, String table,String where) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		String sql=null;
		try {
			conn = connect(jdbcClass, url, user, password);
			sql="delete from "+table;
			if(where!=null && where.trim().length()!=0){
				sql+=" "+where;
			}
			conn.setAutoCommit(false);
			stmt=conn.createStatement();
			int count= stmt.executeUpdate(sql);
			conn.commit();
			System.out.print(count);
		} catch (Throwable e) {
			if (conn != null) {
				try {
					conn.rollback();
				} catch (Exception e1) {
				}
			}
			throw new Exception(e.getMessage()+"\n sql=>"+sql,e);
		} finally {
			close(conn, null, stmt);
		}
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
