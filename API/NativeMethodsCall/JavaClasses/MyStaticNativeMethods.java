package com.MBenDelphi.DelphiNativeJavaMethodCallDemo;

public class MyStaticNativeMethods {

   public static String rturnedStr;

   static {
        System.loadLibrary("DelphiNativeJavaMethodCallDemo"); // In my case i use my project "so" library
    }

   public static native void nativeOnLog();

}
