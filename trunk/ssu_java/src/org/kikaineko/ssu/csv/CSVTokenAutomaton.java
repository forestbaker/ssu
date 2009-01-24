package org.kikaineko.ssu.csv;

class CSVTokenAutomaton {
	private CSVTokenKind state = CSVTokenKind.Start;

	/**
	 * @param c
	 * @return
	 */
	public CSVState isToken(char c) {
		if (state == CSVTokenKind.Start)
			start(c);
		else if (state == CSVTokenKind.ClosedStart)
			closedStart(c);
		else if (state == CSVTokenKind.ClosedEnd)
			closedEnd(c);
		else if (state == CSVTokenKind.Word)
			word(c);
		else if (state == CSVTokenKind.Comma)
			start(c);
		else if (state == CSVTokenKind.ClosedWord)
			closedWord(c);
		else
			end();

		if (state == CSVTokenKind.Comma) {
			return CSVState.End;
		} else if (state == CSVTokenKind.ClosedStart) {
			return CSVState.NotWord;
		} else if (state == CSVTokenKind.ClosedEnd) {
			return CSVState.NotWord;
		}
		return CSVState.NotYetEnd;
	}

	private void closedStart(char c) {
		CSVTokenKind ss = findCharKind(c);
		if (ss == CSVTokenKind.DoubleQ) {
			closedEnd();
		} else {
			state = CSVTokenKind.ClosedWord;
		}
	}

	private void word(char c) {
		CSVTokenKind ss = findCharKind(c);
		if (ss == CSVTokenKind.Comma) {
			end();
		}
	}

	private void closedWord(char c) {
		CSVTokenKind ss = findCharKind(c);
		if (ss == CSVTokenKind.DoubleQ) {
			closedEnd();
		}
	}

	private void closedEnd(char c) {
		CSVTokenKind ss = findCharKind(c);
		if (ss == CSVTokenKind.Comma) {
			state = CSVTokenKind.Comma;
		}else if(ss==CSVTokenKind.DoubleQ){
			state=CSVTokenKind.ClosedWord;
		}
	}

	private void end() {
		state = CSVTokenKind.Comma;
	}

	private void closedEnd() {
		state = CSVTokenKind.ClosedEnd;
	}

	private CSVTokenKind findCharKind(char c) {
		if (c == '\"') {
			return CSVTokenKind.DoubleQ;
		} else if (c == ',') {
			return CSVTokenKind.Comma;
		} else {
			return CSVTokenKind.Word;
		}
	}

	private void start(char c) {
		CSVTokenKind k = findCharKind(c);
		if (k == CSVTokenKind.DoubleQ)
			state = CSVTokenKind.ClosedStart;
		else if (k == CSVTokenKind.Comma)
			state = k;
		else
			state = CSVTokenKind.Word;
	}
}
