#import "LoginViewController.h"
#import "KeyManager.h"

@implementation LoginViewController {
    UITextField *keyField;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:
        [UIImage imageWithData:[NSData dataWithContentsOfURL:
        [NSURL URLWithString:@"https://i.imgur.com/MkOyKTP.jpeg"]]]];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 40)];
    title.text = @"Nhập Key Đăng Nhập";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = UIColor.whiteColor;
    [self.view addSubview:title];

    keyField = [[UITextField alloc] initWithFrame:CGRectMake(40, 160, self.view.bounds.size.width-80, 40)];
    keyField.placeholder = @"Nhập key...";
    keyField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:keyField];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(40, 220, self.view.bounds.size.width-80, 45);
    [loginBtn setTitle:@"Đăng Nhập" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor systemBlueColor];
    [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 8;
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)loginAction {
    NSString *inputKey = keyField.text;
    if (inputKey.length == 0) return;

    [[KeyManager shared] validateKey:inputKey completion:^(BOOL success, NSDictionary *info) {
        if (success) {
            NSString *msg = [NSString stringWithFormat:@"Hạn sử dụng: %@\nThiết bị: %@\nIP: %@",
                             info[@"expiry"], info[@"device"], info[@"ip"]];

            UIAlertController *okAlert = [UIAlertController alertControllerWithTitle:@"Hên Cho Nhập Đúng Key Rồi 🗿"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            [okAlert addAction:[UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:okAlert animated:YES completion:nil];
        } else {
            UIAlertController *fail = [UIAlertController alertControllerWithTitle:@"Đụ Má Mày Nhập Sai Key Rồi"
                                                                          message:@"Ứng dụng sẽ thoát sau 3 giây"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:fail animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
        }
    }];
}

@end