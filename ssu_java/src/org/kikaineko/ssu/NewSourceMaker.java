package org.kikaineko.ssu;

import java.util.ArrayList;

import org.kikaineko.util.FileIO;

public class NewSourceMaker {
	public static final String funcName = "_ssu_coverageEcho";

	public static final String elsefuncName = "_ssu_elseCoverageEcho";
	private static String BR = System.getProperty("line.separator");

	private static void appendWithBR(StringBuffer sb, String s) {
		sb.append(s);
		sb.append(BR);
	}

	public static void createNewSource(String src, String out) throws Exception {
		ArrayList lines = FileIO.getFileDatas(src,FileIO.FileReadCode);
		LineStateController cnt = new LineStateController();

		StringBuffer sb = new StringBuffer();
		StringBuffer errSb = new StringBuffer();
		if (lines.size() > 0) {
			if (((String)lines.get(0)).startsWith("#!")) {
				appendWithBR(sb, (String)lines.get(0));
			}
		}
		appendWithBR(sb, funcName + "(){");
		appendWithBR(sb, "typeset r=$?");
		appendWithBR(sb, "echo ${1} >> ${2}");
		appendWithBR(sb, "return $r");
		appendWithBR(sb, "}");
		appendWithBR(sb, elsefuncName + "(){");
		appendWithBR(sb, "echo ${1} >> ${2}");
		appendWithBR(sb, "return 0");
		appendWithBR(sb, "}");

		for (int i = 0; i < lines.size(); i++) {
			String s = (String)lines.get(i);
			if (!cnt.isSkipLine(s)) {
				if (cnt.isElifFlag()) {
					int ind = s.indexOf("elif") + "elif".length();
					String otherPart = s.substring(ind);
					appendWithBR(sb, "elif (" + elsefuncName + " \"" + (i + 1)
							+ "\" \"" + out + "\") && " + otherPart);
				} else {
					appendWithBR(sb, funcName + " \"" + (i + 1) + "\" \"" + out
							+ "\"");
					appendWithBR(sb, s);
				}
				appendWithBR(errSb, String.valueOf(i + 1));
			} else {
				appendWithBR(sb, s);
			}

		}
		System.out.println(sb);
		System.err.println(errSb);
	}
}
