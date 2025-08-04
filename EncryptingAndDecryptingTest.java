
import org.junit.*;
import static org.junit.Assert.*;

public class EncryptingAndDecryptingTest
{

    @Test
    public void testCharToInt(){
    	int testInt1 = EncryptingAndDecrypting.charToInt('c');
    	int testInt2 = EncryptingAndDecrypting.charToInt('u');
    	assertTrue("Char not translated correctly to Int",testInt1 == 2 && testInt2 == 20);
    }   
      
    
    @Test
    public void testEncryptThenDecrypt(){
    	String testMessage = "";
    	String keyword = "";
    	char[] alphabet = "abcdefghijklmnopqrstuvwxyz".toCharArray();
    	for(int i=0; i<35;i++) {
    		testMessage += alphabet[(int)(Math.random() * 25)];
    		if(i<10) keyword += alphabet[(int)(Math.random() * 24)+1];
    	}
    	String encryptedMessage = EncryptingAndDecrypting.encryptUsingKeyword(testMessage, keyword);
    	String encryptedMessageDecrypted = EncryptingAndDecrypting.decryptUsingKeyword(encryptedMessage, keyword);
    	assertTrue("Message encrypted then decrypted isn't the same as original message",encryptedMessageDecrypted.equals(testMessage));
    	assertFalse("Encrypting doesn't change the message",encryptedMessage.equals(testMessage));
    
    
}
    @Test
    public void testEncryptOnly() {
    	String testMessage = "informatik";
    	String keyword = "key";
    	String encryptedMessage = EncryptingAndDecrypting.encryptUsingKeyword(testMessage, keyword);
    	String solutionMessage = "srdyvkkxgu";
    	assertTrue("Encrypted message not as expected",encryptedMessage.equals(solutionMessage));
    }
}

