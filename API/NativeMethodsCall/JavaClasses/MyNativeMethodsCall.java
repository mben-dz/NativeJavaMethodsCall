package com.MBenDelphi.DelphiNativeJavaMethodCallDemo;

public class MyNativeMethodsCall {

    private static MyStaticNativeMethods myNatives;

    // Constructor
    public MyNativeMethodsCall() {}

    private void logHelloWorld() {
        String localMsg = "Hello, World from Java";     

	    myNatives.rturnedStr = localMsg;
        myNatives.nativeOnLog();
    }

    private String reverseString(String inputString) {
        if (inputString == null) {
            
			myNatives.rturnedStr = "Cannot reverse a null string.";
            myNatives.nativeOnLog();
            
			return null;
        }
        StringBuilder localStrBuilder = new StringBuilder(inputString).reverse();
        String localReversedStr = localStrBuilder.toString();

        myNatives.rturnedStr = "Original string: " + inputString;
        myNatives.nativeOnLog();

        myNatives.rturnedStr = "Reversed string: " + localReversedStr;
        myNatives.nativeOnLog();

        return localReversedStr;
    }

    public void doLogHelloWorld() {
        logHelloWorld();
    }

    public String doReverseString(String inputString) {
        return reverseString(inputString);
    }

    // Test function without calling NATIVE METHOD
    public String GetTest() {
        return "Test Works";
    }

}