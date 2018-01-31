package com.spring.config;

import java.util.Arrays;

public class Utils {

	public static String rpad(String str, int length, char fillChar) {
		if (str.length() > length) return str;
		char[] chars = new char[length];
		Arrays.fill(chars, fillChar);
		System.arraycopy(str.toCharArray(), 0, chars, 0, str.length());
		return new String(chars);
	}
}
