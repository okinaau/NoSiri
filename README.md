This dylib is supposed to fix the following error:
"Use of the class INVocabulary requires the entitlement com.apple.developer.siri. Make sure you have enabled the Siri capability in your Xcode project."
When sideloading apps on a free developer account.
Download and inject the nosiri.dylib into your IPA using ksign, feather etc..
