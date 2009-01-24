package org.kikaineko.ssu;

public class Report {
	private static final String RED = "\\033[41m\\033[1;37m";
	private static final String GREEN = "\\033[42m\\033[1;37m";
	private static final String WHITE = "\\033[46m\\033[30m";
	private static final String END = "\\033[0m";
	private static final int leng = 75;

	public static void exec(String testName, String cnt, String max,
			String color) {
		System.out.print(innerExec(testName, cnt, max, color));
	}

	protected static String innerExec(String testName, String cnt, String max,
			String color) {
		int c = Integer.parseInt(cnt);
		int imax = Integer.parseInt(max);
		StringBuffer sb = new StringBuffer();
		sb.append(" ").append(testName).append(" ");
		if (c < imax) {
			sb.append("(done:").append(c).append("/").append(max).append(")");
		}else{
			sb.append("(done:").append(c).append("/").append(max).append(")");
			
		}
		for (int i = sb.length(); i < leng; i++) {
			sb.append(" ");
		}
		int range = (int) ((((float) c / imax)) * leng);
		String pre = sb.substring(0, range);
		String post = sb.substring(range);
		StringBuffer res = new StringBuffer();
		if (color.equals("green")) {
			res.append(GREEN);
		} else {
			res.append(RED);
		}
		res.append(pre).append(END);
		res.append(WHITE);
		res.append(post).append(END);
		return res.toString();
	}
}
