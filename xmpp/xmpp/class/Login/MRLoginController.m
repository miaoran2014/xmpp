#import "MRLoginController.h"
#import "AppDelegate.h"
#import "UIButton+CZ.h"
#import "MBProgressHUD+HM.h"
#import "MRLoginTool.h"

@interface MRLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userField;//用户
@property (weak, nonatomic) IBOutlet UITextField *passwordField;//密码
@property (weak, nonatomic) IBOutlet UITextField *domainField;//域名
@end

@implementation MRLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //按钮图片的拉伸
    [self.registerBtn setResizedNormalBg:@"LoginGreenBigBtn"];
    [self.loginBtn setResizedNormalBg:@"LoginwhiteBtn"];
    //显示上次用户登录数据
    self.userField.text = [MRLoginTool user];
    self.passwordField.text =[MRLoginTool pwd];
    self.domainField.text =[MRLoginTool domain];
    [self textChange];
}

- (IBAction)textChange {
    //三个文本框有文字时候按钮才可用
    BOOL enabled = (self.userField.text.length > 0 && self.passwordField.text.length > 0 && self.domainField.text.length > 0);
    self.registerBtn.enabled = enabled;
    self.loginBtn.enabled = enabled;
}

- (IBAction)login {
    //1.把登录信息保存到沙盒
    NSString *user = self.userField.text;
    NSString *password = self.passwordField.text;
    NSString *domain = self.domainField.text;
    [MRLoginTool saveLoginWithUser:user pwd:password domain:domain];
    
    //获取AppDelegate对象
    id obj = [UIApplication sharedApplication].delegate;
    AppDelegate *appDelegate = obj;
    [self.view endEditing:YES];
    
    __weak UIView *hudView = self.view;
    [MBProgressHUD showMessage:@"正在登录...." toView:hudView];
    
    //调用xmppLogin方法
    [appDelegate xmppLogin:^(XMPPResultType resultType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:hudView];
            switch (resultType) {
                case XMPPResultTypeLoginFailure:
                    NSLog(@"LoginVC 登录失败");
                    [MBProgressHUD showError:@"用户名或者密码错误"];
                    break;
                case XMPPResultTypeNetError:
                    NSLog(@"LoginVC 网络问题");
                    [MBProgressHUD showError:@"网络不给力"];
                    break;
                case XMPPResultTypeLoginSuccuess:
                    NSLog(@"LoginVC 登录成功");
                    break;
                case XMPPResultTypeUnknowDomain:
                   [MBProgressHUD showError:@"主机不存在"];
                    break;
                case XMPPResultTypeConnectionRefused:
                    [MBProgressHUD showError:@"服务器没有开启，拒绝连接"];
                    break;
                default:
                    break;
            }
        });
    }];
}
-(void)dealloc{
        NSLog(@"%s",__func__);
}
@end
