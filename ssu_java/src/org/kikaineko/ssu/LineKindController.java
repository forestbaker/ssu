package org.kikaineko.ssu;

import org.kikaineko.ssu.source.util.TokenArray;
import org.kikaineko.ssu.source.util.TokenKind;
import org.kikaineko.ssu.sourcescan.Tokenizer;

public class LineKindController implements LineKind, Shell {
	private String hereDocMark = null;

	public int whitch(String inputLine) {
		String temp = inputLine.trim();
		if (temp.length() == 0)
			return NULL_LINE;
		Tokenizer tnz = new Tokenizer(temp);
		TokenArray tokens = new TokenArray(tnz.getTokens());
		if (tokens.length() == 0)
			return NULL_LINE;
		else if (tokens.getKind(0) == TokenKind.Sharpe)
			return NULL_LINE;
		
		int ind = tokens.indexOfKind(TokenKind.Sharpe);
		if (ind != -1) {
			tokens.removeFrom(ind);
		}

		if(hereDocMark!=null){
			if(tokens.getVal(0).equals(hereDocMark) && tokens.length()==1){
				hereDocMark=null;
				return HERE_DOC_END_LINE;
			}
			return HERE_DOC_IN_LINE;
		}
		
		ind = tokens.indexOfKind(TokenKind.BitHidariShift);
		if (ind != -1) {
			if (ind <= tokens.length() - 1) {
				if (tokens.getKind(ind + 1) == TokenKind.Minus) {
					ind++;
				}
				if (ind <= tokens.length() - 1)
					hereDocMark = tokens.getVal(ind + 1);
			}
			return HERE_DOC_START_LINE;
		}

		if (isEndLine(tokens)) {
			if (isContinueLine(tokens))
				return END_WITH_CONTINUE_LINE;
			return END_LINE;
		}

		if (isContinueLine(tokens))
			return RUN_WITH_CONTINUE_LINE;

		if (tokens.getVal(0).equals(CASE))
			return CASE_LINE;
		
		if(tokens.getVal(0).equals(ELIF))
			return ELIF_LINE;
		
		if(tokens.getVal(0).equals(ELSE))
			return NULL_LINE;
		
		return RUN_LINE;
	}

	private boolean isEndLine(TokenArray tokens) {
		String first = tokens.getVal(0);
		if (first.equals(FI) || first.equals(DO) || first.equals(DONE)
				|| first.equals(ESAC) || first.equals(END_KAKKO)) {
			return true;
		}
		return false;
	}

	private boolean isContinueLine(TokenArray tokens) {
		int last = tokens.getKind(tokens.length() - 1);
		if (last == TokenKind.Esc || last==TokenKind.SingleBar)
			return true;
		return false;
	}

	public String getHereDocMark() {
		return hereDocMark;
	}

}
