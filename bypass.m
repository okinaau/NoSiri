#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SiriBypass : NSObject
@end

@implementation SiriBypass
+ (id)fake_sharedVocabulary {
    return nil;
}
@end

__attribute__((constructor))
static void initialize_bypass() {
    Class INVocabularyClass = NSClassFromString(@"INVocabulary");
    if (INVocabularyClass) {
        Method original = class_getClassMethod(INVocabularyClass, NSSelectorFromString(@"sharedVocabulary"));
        Method fake = class_getClassMethod([SiriBypass class], @selector(fake_sharedVocabulary));
        
        if (original && fake) {
            method_exchangeImplementations(original, fake);
        }
    }
}
