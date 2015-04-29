
#import "MRHistoryController.h"
#import "AppDelegate.h"
#import "MRCommon.h"

@interface MRHistoryController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;//转圈圈的view
@end

@implementation MRHistoryController

- (void)viewDidLoad
{
   [super viewDidLoad];
    //注册一个登录状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatu:) name:@"LoginStatuNotification" object:nil];
}

-(void)loginStatu:(NSNotification *)notifi{
    //获取登录状态
    int loginStatu = [notifi.userInfo[@"LoginStatu"] intValue];
    HMLogInfo(@"%d",loginStatu);
    switch (loginStatu) {
        case XMPPResultTypeLogining://登录中
            [self.indicatorView startAnimating];
            break;
        case XMPPResultTypeLoginSuccuess://自动登录成功
            [self.indicatorView stopAnimating];
            break;
        case XMPPResultTypeLoginFailure://自动登录失败
            [self.indicatorView stopAnimating];
            break;
        default:
            break;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

@end
