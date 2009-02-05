package org.kikaineko.ssu;

import org.kikaineko.ssu.db.DBCommander;
import org.kikaineko.util.FileIO;

public class Main {

	/**
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) {
		try {
			if (args.length != 4 && args.length != 6) {
				badArgs();
			}
			FileIO.CodeFilePATH=args[0];
			
			if (args[1].equals("new")) {
				NewSourceMaker.createNewSource(args[2], args[3]);
			} else if (args[1].equals("analyze")) {
				Analyzer.analyze(args[2], args[3]);
			} else if (args[1].equals("util")) {
				Utiler.exec(args[2], args[3]);
			} else if (args[1].equals("utilfilesame")) {
				Utiler.fileSame(args[2], args[3]);
			} else if (args[1].equals("utilincludeinfile")) {
				Utiler.includeInFile(args[2], args[3]);
			} else if (args[1].equals("report")) {
				Report.exec(args[2], args[3], args[4], args[5]);
			} else {
				badArgs();
			}
		} catch (Throwable e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
			System.exit(1);
		}
	}

	private static void badArgs() {
		System.err.println("bad args!");
		System.err.println("usage:");
		System.err
				.println("java -jar ssu.jar [option_flag] [inputfile] [outputfile/count_max]");
		System.err.println("options = new , analyze , util , utilfilesame");
		System.err.println("\t\t db");
		System.err.println("Case of db:");
		System.err
				.println("java -jar ssu.jar db [db_option_flag] [targetFile] [table] [jdbcClass] [url] <[where]> <[user]> <[password]> <[where]>");
		System.err.println("db_option_flag = " + DBCommander.SELECT_COMP
				+ " , " + DBCommander.SELECT_INC);
		System.exit(1);
	}

}
