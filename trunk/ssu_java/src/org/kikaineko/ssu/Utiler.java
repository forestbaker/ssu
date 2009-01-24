package org.kikaineko.ssu;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.kikaineko.util.FileIO;

public class Utiler {
	public static void exec(String string, String string2) {
		if (string.equals("file-time")) {
			File f = new File(string2);
			Date fileDate = new Date(f.lastModified());
			SimpleDateFormat dateFormat = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			System.out.print(dateFormat.format(fileDate));
		}
	}

	public static void fileSame(String string, String string2) throws Throwable {
		File f1 = new File(string.trim());
		File f2 = new File(string2.trim());
		if (f1.length() != f2.length()) {
			File ff=null;
			if(f1.length()==0){
				ff=f1;
			}else if(f2.length()==0){
				ff=f2;
			}
			if(ff!=null && !ff.exists()){
				throw new FileNotFoundException("Not Found "+ff.getName());
			}
			System.out.print(1);
			return;
		}
		
		byte[] bs1 = FileIO.getFileDataAsBytes(f1);
		byte[] bs2 = FileIO.getFileDataAsBytes(f2);
		if (bs1.length != bs2.length) {
			System.out.print(1);
			return;
		}

		for (int i = 0; i < bs1.length; i++) {
			if (bs1[i] != bs2[i]) {
				System.out.print(1);
				return;
			}
		}
		System.out.print(0);
	}

}
