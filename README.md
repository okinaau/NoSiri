This dylib is supposed to fix the following error:

__"Use of the class INVocabulary or INPreferences requires the entitlement com.apple.developer.siri. Make sure you have enabled the Siri capability in your Xcode project."__

When sideloading apps on a free developer account.

Download and inject the nosiri.dylib into your IPA using ksign, feather, LiveContainer, etc..
