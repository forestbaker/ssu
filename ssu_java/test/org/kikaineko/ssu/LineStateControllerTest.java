package org.kikaineko.ssu;

import org.kikaineko.ssu.LineStateController;

import junit.framework.TestCase;

public class LineStateControllerTest extends TestCase {
	LineStateController cnt;
	protected void setUp(){
		cnt=new LineStateController();
	}
	
	public void testNormal(){
		assertEquals(true,cnt.isSkipLine("#aaa"));
		assertEquals(false,cnt.isSkipLine("bbb#aaa"));
	}
	
	public void testelif(){
		assertEquals(false,cnt.isSkipLine("bbb#aaa"));
		assertEquals(false,cnt.isSkipLine("if aaa"));
		assertEquals(false,cnt.isSkipLine("echo 333"));
		assertEquals(true,cnt.isSkipLine("  else"));
		assertEquals(false,cnt.isSkipLine("  echo 33"));
		assertEquals(false,cnt.isSkipLine("  fi"));
	}
}
