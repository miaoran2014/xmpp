
#import "MRChatController.h"
#import "AppDelegate.h"
#import "MRLoginTool.h"
#import "NSDate+CZ.h"
#define Delegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kBaseURL @"http://localhost:8080/imfileserver/Upload/Image/"

@interface MRChatController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSFetchedResultsControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSFetchedResultsController *_resultControler;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MRChatController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupKeyboardNotification];
    [self setUpdata];
}

-(void)setUpdata{
    //从数据加载数据
    //1.获取上下文
    NSManagedObjectContext *context = Delegate.msgStorage.mainThreadManagedObjectContext;
    //2.请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //3.设置时间排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    //4.过滤条件
    NSString *friendJid = self.friendJid.bare;
    NSString *selfJib = Delegate.xmppStream.myJID.bare;
    //bareJidStr 对应好友的jib streamBareJidStr对就登录用户的jid
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr = %@",friendJid,selfJib];
    request.predicate = pre;
    
    _resultControler = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultControler.delegate = self;
    [_resultControler performFetch:nil];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
    //游动到底
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_resultControler.fetchedObjects.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)setupKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFrmChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)kbFrmChange:(NSNotification *)notifi{
    //1.获取键盘改变后的frm
    CGRect kbEndFrm = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //2.读取输入框容器底部的约束
    CGFloat screemH = [[UIScreen mainScreen] bounds].size.height;
    //底部的距离
    CGFloat bottomDist = screemH - kbEndFrm.origin.y;
    self.inputConstraint.constant = bottomDist;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultControler.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //获取聊天记录
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultControler.fetchedObjects[indexPath.row];
    //显示聊天内
    cell.textLabel.text = msg.body;
    return cell;
}


//隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

//发送聊天数据
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    NSString *text = textField.text;
  
    
    //创建msg对象
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    //添加消息内容
    [msg addBody:text];
    NSLog(@"%@",msg);
    //发送消息
    [Delegate.xmppStream sendElement:msg];
    
    
    //清空数据
    textField.text = nil;
    return YES;
}
- (IBAction)selectedImage {
    
    //从相册里获取相片
    UIImagePickerController *imageControl = [[UIImagePickerController alloc] init];
    imageControl.delegate = self;
    
    imageControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imageControl animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //1.获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2定义文件(图片)上传到服务器保存的名称 user + time
    NSString *user = [MRLoginTool user];
    //20140905151530
    NSString *time = [NSDate nowDateFormat:CZDateFormatyyyyMMddHHmmss];
    NSString *imageName = [user stringByAppendingString:time];
    //3.往文件服务上传图片
    //3.1获取上传的地址
    //http://localhost:8080/imfileserver/Upload/Image/ + imageName
    NSString *imageUploadUrl = [kBaseURL stringByAppendingString:imageName];
    NSLog(@"%@",imageUploadUrl);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

