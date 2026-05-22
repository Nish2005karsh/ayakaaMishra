-dontwarn com.google.**
-dontwarn io.grpc.**
-dontwarn okio.**

# Keep all Google Navigation SDK and Driver SDK public API
-keep class com.google.android.libraries.navigation.** { *; }
-keep class com.google.android.libraries.mapsplatform.transportation.** { *; }

# Keep internal Driver SDK classes — they're loaded via ServiceLoader and
# need their no-arg constructors. Without this, R8 strips them in release
# builds and you get:
#   ServiceConfigurationError: Provider ... could not be instantiated
#   NoSuchMethodException: ...<init> []
-keep class com.google.android.gms.internal.transportation_driver.** { *; }
-keep class com.google.android.gms.internal.maps_navigation.** { *; }
-keepclassmembers class com.google.android.gms.internal.transportation_driver.** {
    public <init>(...);
    <init>();
}
-keepclassmembers class com.google.android.gms.internal.maps_navigation.** {
    public <init>(...);
    <init>();
}

# Generic ServiceLoader support — keep no-arg constructors for any service
# provider listed under META-INF/services.
-keepclassmembers class * {
    @com.google.android.gms.common.annotation.KeepName *;
}
-keepnames @com.google.android.gms.common.annotation.KeepName class *

# gRPC + protobuf (Driver SDK transport)
-keep class io.grpc.** { *; }
-keep class com.google.protobuf.** { *; }

# Firebase JWT (driver token)
-keep class com.google.firebase.** { *; }
