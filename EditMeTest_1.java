package edu.kit.ipd.swt1;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class EditMeTest {

	private EditMe editMe;

	@BeforeEach
	public void setUp() throws Exception {
		editMe = new EditMe();
	}

	@AfterEach
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
