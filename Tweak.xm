#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "KeyManager.h"
#import "LoginViewController.h"

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;

    // Start timer auto văng sau 3 phút
    [[KeyManager shared] startKeyTimer];

    // Hiện login sau khi app load xong
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC
                                                                                     animated:YES
                                                                                   completion:nil];
    });

    return result;
}

%end