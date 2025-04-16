-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-keepattributes *Annotation*

-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}

-optimizations !method/inlining/*

-keepclasseswithmembers class * {
  public void onPayment*(...);
}

-keepattributes AutoValue
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class com.google.firebase.** { *; }
-keep class com.google.android.play.** { *; }
-keepclassmembers class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

-keepclassmembers,allowobfuscation class * { @com.google.gson.annotations.SerializedName <fields>; }
-keepclassmembers enum * { *; }
-keepclassmembers class * { @android.webkit.JavascriptInterface <methods>; }
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-keep class com.olivelib.** {*;}
-keep class com.olive.** {*;}
-keep class org.apache.xml.security.** {*;}
-keep interface org.apache.xml.security.** {*;}
-keep class org.npci.** {*;}
-keep interface org.npci.** {*;}
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }

-dontwarn com.appsflyer.**
-keep public class com.google.firebase.messaging.FirebaseMessagingService {
    public *;
}
