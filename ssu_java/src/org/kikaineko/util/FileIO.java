package org.kikaineko.util;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * @author masayuki
 * 
 *         To change the template for this generated type comment go to Window -
 *         Preferences - Java - Code Generation - Code and Comments
 */
public class FileIO {
	private static Map codeMap = null;
	private static final String CodeFileName = "ssu_code.properties";
	public static String CodeFilePATH = null;
	public static String CygwinRootPath = null;
	public static boolean IsCygwin;
	public static final String FileReadCode = "FileReadCode";
	public static final String FileWriteCode = "FileWriteCode";
	public static final String DBSelectCode = "DBSelectCode";
	public static final String FileReadCodeToDB = "FileReadCodeToDB";
	public static final String FileWriteCodeFromDB = "FileWriteCodeFromDB";

	public static void init(){
		FileIO.CygwinRootPath=System.getenv("SSU_CYGWIN_ROOT_PATH");
		FileIO.IsCygwin="1".equals(System.getenv("SSU_IS_CYGWIN"));
	}
	public static File getFile_NotDir(String path) throws IOException {
		if (path != null) {
			path = path.trim();
		}
		File f = new File(path);
		if (f.exists() && f.isFile()) {
			return f;
		}
		if (IsCygwin && CygwinRootPath != null) {
			f = new File(CygwinRootPath.trim() + path.trim());
		}
		return f;
	}

	public static String code(String name) throws Exception {
		if (name == null) {
			return null;
		}
		if (CodeFilePATH == null || CodeFilePATH.trim().length() == 0) {
			return null;
		}
		if (codeMap == null) {
			File f = getFile_NotDir(CodeFilePATH);
			codeMap = new HashMap();

			if (!f.exists() || f.isDirectory()) {
				f = getFile_NotDir(CodeFilePATH + "/" + CodeFileName);
				if (!f.exists()) {
					return null;
				}
			}
			ArrayList l = getFileDatas(f, null);
			for (int i = 0; i < l.size(); i++) {
				String s = (String) l.get(i);
				if (!s.trim().startsWith("#") && s.indexOf("=") != -1) {
					String[] ar = s.split("=");
					codeMap.put(ar[0].trim(), ar[1].trim());
				}
			}
		}
		return (String) codeMap.get(name);
	}

	public static ArrayList getFileDatas(String filePath, String code)
			throws Exception {
		return getFileDatas(getFile_NotDir(filePath), code);
	}

	private static ArrayList getFileDatas(File file, String code)
			throws Exception {
		String charCode = code(code);
		ArrayList list = new ArrayList();

		BufferedReader in = null;

		try {
			InputStreamReader objIsr = null;
			if (charCode != null) {
				objIsr = new InputStreamReader(new FileInputStream(file),
						charCode);
			} else {
				objIsr = new InputStreamReader(new FileInputStream(file));
			}
			in = new BufferedReader(objIsr);
			String s;
			while ((s = in.readLine()) != null) {
				list.add(s);
			}
		} finally {
			try {
				in.close();
			} catch (Exception e) {
			}
		}
		return list;
	}

	public static String getFileData(String fileName, String code)
			throws Exception {
		String charCode = code(code);
		if (charCode != null) {
			return new String(getFileDataAsBytes(getFile_NotDir(fileName)), charCode);
		} else {
			return new String(getFileDataAsBytes(getFile_NotDir(fileName)));

		}
	}

	public static byte[] getFileDataAsBytes(String fileName) throws Exception {
		return getFileDataAsBytes(getFile_NotDir(fileName));
	}

	private static byte[] getFileDataAsBytes(File file) throws Exception {
		byte[] bs = new byte[(int) file.length()];
		try {
			InputStream in = new FileInputStream(file);
			BufferedInputStream bin = new BufferedInputStream(in);
			int c;
			int index = 0;
			while ((c = bin.read()) != -1) {
				bs[index++] = (byte) c;
			}
			bin.close();
		} catch (Exception e) {
			throw e;
		}
		return bs;
	}

	public static void writeOutPutFile(String filePath, String str, String code)
			throws Exception {
		File file = getFile_NotDir(filePath);
		writeOutPutFile(file, str, code);
	}

	private static void writeOutPutFile(File file, String str, String code)
			throws Exception {
		String charCode = code(code);
		BufferedWriter out = null;
		try {
			OutputStreamWriter objOsr = null;
			if (charCode != null) {
				objOsr = new OutputStreamWriter(new FileOutputStream(file),
						charCode);
			} else {
				objOsr = new OutputStreamWriter(new FileOutputStream(file));
			}
			out = new BufferedWriter(objOsr);
			out.write(str);
			out.flush();

		} catch (IOException e) {
			throw e;
		} finally {
			try {
				if (out != null) {
					out.close();
				}
			} catch (IOException e) {
			}
		}
	}

}
