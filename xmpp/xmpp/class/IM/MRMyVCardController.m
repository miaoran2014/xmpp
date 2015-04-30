

#import "MRMyVCardController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#define delegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface MRMyVCardController ()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *jidLabel;//jid
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//公司名
@property (weak, nonatomic) IBOutlet UILabel *orgUnitsLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *telLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮箱
- (IBAction)logout:(id)sender;

@end

@implementation MRMyVCardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadVCard];
}
//从数据库获取登录用户电子名片数据
-(void)loadVCard{
    XMPPvCardTemp *myCard = delegate.vCardModule.myvCardTemp;
    //显示图片
    if (myCard.photo) {
        self.headView.image = [UIImage imageWithData:myCard.photo];
    }
    //昵称
    self.nickNameLabel.text = myCard.nickname;
    //jid
    //myCard.jid是空，因为返回的xml数据没有JABBERID标签
    self.jidLabel.text = delegate.xmppStream.myJID.bare;
    //设置公司
    self.orgNameLabel.text = myCard.orgName;
    //设置部门
    //一个人可能属于多个部门，所以orgUnits是一个数组
    if (myCard.orgUnits.count > 0) {
        self.orgUnitsLabel.text = myCard.orgUnits[0];
    }
    //设置职位
    self.titleLabel.text = myCard.title;
    //设置电话
    //因为myCard.telecomsAddresses这个get方法，没有实现xml的数据解析，所以用note字段充当电话
    self.telLabel.text = myCard.note;
    //设置邮箱
    //因为myCard.emailAddresses这个get方法，没有实现xml的数据解析，所以用mailer字段充当邮箱
    self.emailLabel.text = myCard.mailer;
 
}
//注销
- (IBAction)logout:(id)sender {
    [delegate xmppLogout];
}
@end
