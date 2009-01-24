package org.kikaineko.ssu;

public interface LineKind {
	public static final int NULL_LINE=0;
	public static final int RUN_LINE=1;
	public static final int RUN_WITH_CONTINUE_LINE=2;
	public static final int END_LINE=3;
	public static final int END_WITH_CONTINUE_LINE=4;
	public static final int CASE_LINE=5;
	public static final int HERE_DOC_START_LINE=6;
	public static final int HERE_DOC_END_LINE=7;
	public static final int HERE_DOC_IN_LINE=8;
	public static final int ELIF_LINE=9;
}
