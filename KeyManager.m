#import "KeyManager.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@implementation KeyManager {
    NSTimer *exitTimer;
}

+ (instancetype)shared {
    static KeyManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [KeyManager new];
    });
    return shared;
}

- (void)startKeyTimer {
    // ⏳ Sau 3 phút auto thoát
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(180 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        exit(0);
    });
}

// 📱 Lấy model máy
- (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

// 🔑 Validate key với server
- (void)validateKey:(NSString *)key completion:(void (^)(BOOL success, NSDictionary *info))completion {
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *model = [self deviceModel];

    // ✅ Token cố định (mật khẩu chung giữa app & server)
    NSString *token = @"6koz9fnxflrcgnpbhj7lwk8wr6qvv3r1kist384oimuyw=fdbu3g94qdaqm8cmh7nj40u0te/eoy95tycidp21v2hxa6j0slzsbp_7e1zag525x";

    // ✅ URL gọi API kèm key người dùng nhập + token cố định
    NSString *urlString = [NSString stringWithFormat:
                           @"https://tuankhang.xyz/document.php?key=%@&token=%@&uuid=%@&model=%@",
                           key, token, uuid, model];

    NSURL *url = [NSURL URLWithString:urlString];

    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) {
        completion(NO, nil);
        return;
    }

    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error && [json[@"status"] isEqualToString:@"OK"]) {
        // ✅ Key hợp lệ
        completion(YES, json);
    } else {
        // ❌ Key sai hoặc lỗi khác
        completion(NO, nil);
    }
}

@end