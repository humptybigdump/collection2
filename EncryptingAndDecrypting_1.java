public class EncryptingAndDecrypting {
	public static final char[] ALPHABET = "abcdefghijklmnopqrstuvwxyz".toCharArray();

	public static int charToInt(char a) {
		int entsprechenderInt = 0;

		for (int i = 0; i < ALPHABET.length; i++) {
			if (ALPHABET[i] == a) {
				entsprechenderInt = i;
			}
		}

		return entsprechenderInt;
	}

	public static void main(String[] args) {
		String keyword = "key";
		String message = "informatik";
		String encryptedMessage = encryptUsingKeyword(message, keyword);
		System.out.println(encryptedMessage);
		System.out.println(decryptUsingKeyword(encryptedMessage, keyword));
	}

	public static String encryptUsingKeyword(String message, String keyword) {
		String encryptedMessage = "";
		char[] messageArray = message.toCharArray();
		char[] keywordArray = keyword.toCharArray();

		for (int i = 0; i < messageArray.length; i++) {
			int keywordPlace = i % keywordArray.length;
			int encryptedPlace = (charToInt(messageArray[i]) +
							   charToInt(keywordArray[keywordPlace])) % ALPHABET.length;
			encryptedMessage = encryptedMessage +  ALPHABET[encryptedPlace];
		}

		return encryptedMessage;
	}

	public static String decryptUsingKeyword(String encryptedMessage,
											String keyword) {
		String decryptedMessage = "";
		char[] encryptedArray = encryptedMessage.toCharArray();
		char[] keywordArray = keyword.toCharArray();

		for (int i = 0; i < encryptedArray.length; i++) {
			int keywordPlace = i % keywordArray.length;
			int decryptedPlaceBeforeMod = charToInt(encryptedArray[i]) -
										charToInt(keywordArray[keywordPlace]);

			if (decryptedPlaceBeforeMod < 0) 
			{decryptedPlaceBeforeMod += ALPHABET.length;
			}

			int decryptedPlace = decryptedPlaceBeforeMod % ALPHABET.length;
			decryptedMessage = decryptedMessage + ALPHABET[decryptedPlace];
		}

		return decryptedMessage;
	}
}
