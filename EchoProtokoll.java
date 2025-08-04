package edu.kit.aifb.proksy.EchoServerMitProtokoll;

import java.io.*;
import java.net.*;

/**
 * 
 * @version 1.0
 * @author ProkSy-Team
 */
public class EchoProtokoll {
	public final String EXIT = "exit";
	private Socket s = null;
	private PrintWriter zumClient = null;
	private BufferedReader vomClient = null;
	private boolean isRunning;

	// Kontstrukor
	public EchoProtokoll(Socket s) {
		try {
			// Belegen der Instanzvariablen und öffnen der Streams
			
			
			
			

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void transact() {
		String echo = null;
		System.out.println("Protokoll gestartet");
		isRunning = true;
		while (isRunning) {
			try {
				// Schreibe zeilenweise den Inputstream vom Client in den Outputstream
				
				
				
				
			} catch (IOException e) {
				isRunning = false;
			}
			if (echo.equalsIgnoreCase(EXIT)) {
				isRunning = false;
			}
		}
		System.out.println("Protokoll beendet");
	}
}
