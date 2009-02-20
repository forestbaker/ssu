package org.kikaineko.ssu.db;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.kikaineko.util.FileIO;

public class Convertor {
	private static Map map = null;
	private static String MapFileName = "ssu_convert.properties";

	public static void init(String path) throws Exception {
		File f = new File(path);
		map = new HashMap();
		if (!f.exists() || f.isDirectory()) {
			f = new File(path + "/" + MapFileName);
			if (!f.exists()) {
				throw new FileNotFoundException(path);
			}
		}
		ArrayList ls = FileIO.getFileDatas(f, null);
		for (int i = 0; i < ls.size(); i++) {
			String s = (String) ls.get(i);
			s = s.trim();
			if (s.length()==0 || s.startsWith("#") || s.indexOf("=") == -1) {
				continue;
			}
			String[] ss = s.toUpperCase().split("=");
			if (ss.length != 2) {
				throw new Exception("format error.Is this properties?");
			}
			String key = ss[0];
			String[] vals = null;
			if (s.indexOf(",") != -1) {
				vals = ss[1].split(",");
			} else {
				vals = new String[] { ss[1] };
			}
			Character k = new Character((char) calc(key));
			for (int j = 0; j < vals.length; j++) {
				Character cc = new Character((char) calc(vals[j].trim()));
				map.put(cc, k);
			}
		}
	}

	protected static int calc(String s) {
		s = s.replaceAll("\\\\u", "");
		char[] cs = s.toCharArray();
		int sum = 0;
		for (int i = 0; i < cs.length; i++) {
			sum = to16c(cs[i]) + sum * 16;
		}
		return sum;
	}

	private static int to16c(char c) {
		if ('0' <= c && '9' >= c) {
			return ((int) c) - 48;
		}

		if (c == 'A') {
			return 10;
		} else if (c == 'B') {
			return 11;
		} else if (c == 'C') {
			return 12;
		} else if (c == 'D') {
			return 13;
		} else if (c == 'E') {
			return 14;
		} else if (c == 'F') {
			return 15;
		}
		return 0;
	}

	public static String convert(String s) {
		char[] cs = s.toCharArray();
		char[] res = new char[cs.length];
		for (int i = 0; i < cs.length; i++) {
			Character c = new Character(cs[i]);
			Object o = map.get(c);
			if (o != null) {
				res[i] = ((Character) o).charValue();
			} else {
				res[i] = cs[i];
			}
		}
		return new String(res);
	}
}
