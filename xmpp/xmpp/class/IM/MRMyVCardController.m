#import "MRMyVCardController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "MREditVCardController.h"
#define Delegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface MRMyVCardController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MREditVCardControllerDelagate>

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
    XMPPvCardTemp *myCard = Delegate.vCardModule.myvCardTemp;
    //显示图片
    if (myCard.photo) {
        self.headView.image = [UIImage imageWithData:myCard.photo];
    }
    //昵称
    self.nickNameLabel.text = myCard.nickname;
    //jid
    //myCard.jid是空，因为返回的xml数据没有JABBERID标签
    self.jidLabel.text = Delegate.xmppStream.myJID.bare;
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

#pragma mark tableview的代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    int cellTag = (int)selectedCell.tag;
    if (cellTag == 2 ) return; //如果tag为2，不做任何事件 直接返回
    
    if (cellTag == 0) {//图片选择
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
    }else{
        //跳转,,讲cell传递过去
        [self performSegueWithIdentifier:@"editVCardSegue" sender:selectedCell];
    }
}

#pragma mark actionsheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //如果是取消，直接返回
    if (buttonIndex == 2) return;
    UIImagePickerController *imageContr = [[UIImagePickerController alloc] init];
    //允许图片可以编辑
    imageContr.allowsEditing = YES;
    //设置代理
    imageContr.delegate = self;
    
    if (buttonIndex == 0) {//照相
        imageContr.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){//相册
        imageContr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //弹出控制器
    [self presentViewController:imageContr animated:YES completion:nil];
}


#pragma mark 图片选择控制器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //获取编辑后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //设置imageView
    self.headView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
//注销
- (IBAction)logout:(id)sender {
    [Delegate xmppLogout];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id con=segue.destinationViewController;
    if([con isKindOfClass:[MREditVCardController class]]){
        MREditVCardController* edit=(MREditVCardController*)con;
        UITableViewCell* cell=sender;
        for (UIView* view in cell.contentView.subviews) {
            if([view isKindOfClass:[UILabel class]]){
                UILabel* label=(UILabel*)view;
                if (label.tag == 0) {//左边
                    edit.leftLabel = label;
                }else if (label.tag == 1){
                    edit.rightLabel = label;
                }
            }
        }
    }
}
-(void)editVCardViewControllerDidFinishChange{
    NSLog(@"come here");
}
@end
