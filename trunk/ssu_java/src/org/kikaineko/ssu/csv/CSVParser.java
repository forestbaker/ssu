package org.kikaineko.ssu.csv;

import java.util.ArrayList;
import java.util.List;

/**
 * CSVƒp[ƒT
 * @author IBM
 *
 */
public class CSVParser {
	public static List getCSVLineList(List ls) {
		List datas = new ArrayList();
		for (int i=0;i<ls.size();i++) {
			datas.add(lineParse((String)ls.get(i)));
		}
		return datas;
	}

	public static List lineParse(String line) {
		List l = new ArrayList();
		char[] cs = line.toCharArray();
		CSVTokenAutomaton automaton = new CSVTokenAutomaton();
		StringBuffer sb = new StringBuffer();
		CSVState state = null;
		for (int i=0;i<cs.length;i++) {
			char c=cs[i];
			state = automaton.isToken(c);
			if (state == CSVState.NotYetEnd)
				sb.append(c);
			else if (state == CSVState.End) {
				l.add(sb.toString());
				sb = new StringBuffer();
			}
		}
		if(state!=CSVState.End)
			l.add(sb.toString());
		else if(line.trim().endsWith(","))
			l.add(sb.toString());
		
		return l;
	}
}
