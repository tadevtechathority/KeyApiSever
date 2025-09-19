#import <Foundation/Foundation.h>

@interface KeyManager : NSObject

+ (instancetype)shared;
- (void)startKeyTimer;
- (void)validateKey:(NSString *)key completion:(void (^)(BOOL success, NSDictionary *info))completion;

@end