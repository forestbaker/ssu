package org.kikaineko.ssu.db;

public class DBCommander {
	public static final String SELECT_COMP = "selectComp";
	public static final String SELECT_INC = "selectInc";
	public static final String SELECT_COMP_ORDER = "selectCompOrder";
	public static final String SELECTTO = "selectto";
	public static final String SELECTOUT = "selectout";
	public static final String COUNT = "count";
	public static final String COUNTNOT = "countnot";
	public static final String INSERT = "insert";
	public static final String DELETE = "delete";

	public static void exec(String db_option_flag, String filePath,
			String table, String jdbcClass, String url, String where,
			String user, String password) throws Throwable {
		if (SELECT_COMP.equals(db_option_flag)) {
			SelectCommand.selectAssert("complete", filePath, jdbcClass, url,
					user, password, table, where);
		} else if (SELECT_INC.equals(db_option_flag)) {
			SelectCommand.selectAssert("include", filePath, jdbcClass, url,
					user, password, table, where);
		} else if (SELECT_COMP_ORDER.equals(db_option_flag)) {
			SelectCommand.selectAssertOrder(filePath, jdbcClass, url, user,
					password, table, where);
		} else if (COUNT.equals(db_option_flag)) {
			String count = filePath;
			SelectCommand.countAssert(count, jdbcClass, url, user, password,
					table, where);
		} else if (COUNTNOT.equals(db_option_flag)) {
			String count = filePath;
			SelectCommand.countAssertNot(count, jdbcClass, url, user, password,
					table, where);
		} else if (INSERT.equals(db_option_flag)
				&& (where == null || where.trim().length() == 0)) {
			InsertCommand.insert(filePath, jdbcClass, url, user, password,
					table);
		} else if (SELECTTO.equals(db_option_flag)) {
			SelectCommand.selectTo(SELECTTO, filePath, jdbcClass, url, user,
					password, table, where);
		} else if (SELECTOUT.equals(db_option_flag)) {
			SelectCommand.selectTo(SELECTOUT, filePath, jdbcClass, url, user,
					password, table, where);
		} else if (DELETE.equals(db_option_flag)) {
			DeleteCommand.delete(jdbcClass, url, user, password, table, where);
		} else {
			throw new Exception("invalid args");
		}
	}

	public static void exec(String db_option_flag, String targetFile,
			String table, String jdbcClass, String url, String where)
			throws Throwable {
		exec(db_option_flag, targetFile, table, jdbcClass, url, where, null,
				null);
	}

	public static void exec(String db_option_flag, String targetFile,
			String table, String jdbcClass, String url, String user,
			String password) throws Throwable {
		exec(db_option_flag, targetFile, table, jdbcClass, url, null, user,
				password);
	}

	public static void exec(String db_option_flag, String targetFile,
			String table, String jdbcClass, String url) throws Throwable {
		exec(db_option_flag, targetFile, table, jdbcClass, url, null, null,
				null);
	}
}
