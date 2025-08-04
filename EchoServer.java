import java.io.*;
import java.net.*;
class EchoServer {
  public static void main(String[] args) {
    try {
      ServerSocket server = new ServerSocket(7);
      System.out.println("EchoServer laeuft"); 
      Socket s = server.accept(); 

      PrintWriter out = 
          new PrintWriter(s.getOutputStream(), true);

      BufferedReader in = 
          new BufferedReader(new InputStreamReader(s.getInputStream()));

      while (true) {
        String str = in.readLine();
        out.println(str);
        if (str.equalsIgnoreCase("quit")) 
          break;
      }
    } catch (Exception e) { }
  }
}
