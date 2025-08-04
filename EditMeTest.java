package edu.kit.ipd.swt1;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class EditMeTest {

	private EditMe editMe;

	@Before
	public void setUp() throws Exception {
		editMe = new EditMe();
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testMatNum() {
		assertEquals(123456, editMe.getMatNum());
	}

	@Test
	public void testFoo() {
		assertEquals("bar", editMe.getFoo());
	}
}
