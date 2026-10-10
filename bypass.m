#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SiriBypass : NSObject
@end

@implementation SiriBypass

+ (id)fake_sharedVocabulary {
    return nil;
}

+ (id)fake_sharedPreferences {
    return nil;
}

+ (id)fake_sharedObject {
    return nil;
}

@end

static void safe_swizzle(Class targetClass, SEL originalSelector, SEL fakeSelector) {
    if (!targetClass) return;
    
    Method original = class_getClassMethod(targetClass, originalSelector);
    Method fake = class_getClassMethod([SiriBypass class], fakeSelector);
    
    if (original && fake) {
        method_exchangeImplementations(original, fake);
    }
}

__attribute__((constructor))
static void initialize_bypass() {
    @autoreleasepool {
        // 1. Swizzle INVocabulary
        safe_swizzle(NSClassFromString(@"INVocabulary"), 
                     NSSelectorFromString(@"sharedVocabulary"), 
                     @selector(fake_sharedVocabulary));

        // 2. Swizzle INPreferences (Fix for Telegram)
        safe_swizzle(NSClassFromString(@"INPreferences"), 
                     NSSelectorFromString(@"sharedPreferences"), 
                     @selector(fake_sharedPreferences));

        // 3. Fallback: Hook sharedPreferences / sharedVocabulary dynamically on any IN* class
        Class INPreferencesClass = NSClassFromString(@"INPreferences");
        if (INPreferencesClass) {
            safe_swizzle(INPreferencesClass, NSSelectorFromString(@"sharedPreferences"), @selector(fake_sharedPreferences));
            safe_swizzle(INPreferencesClass, NSSelectorFromString(@"sharedObject"), @selector(fake_sharedObject));
        }
    }
}
