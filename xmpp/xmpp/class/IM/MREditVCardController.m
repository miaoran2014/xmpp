#import "MREditVCardController.h"

@interface MREditVCardController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)save:(id)sender;

@end

@implementation MREditVCardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题
    self.title = self.leftLabel.text;
    //设置textField的文本
    self.textField.text = self.rightLabel.text;
    //设置提醒
    self.textField.placeholder = [NSString stringWithFormat:@"请输入%@",self.leftLabel.text];
}

- (IBAction)save:(id)sender {
    //判断数据有没有修改,有修改才通知上一个控制器
    if (![self.rightLabel.text isEqualToString:self.textField.text]) {
        if ([self.delegate respondsToSelector:@selector(editVCardViewControllerDidFinishChange)]) {
            //改变上一个控制器cell的右边的Label的数据
            //是同一个label
            self.rightLabel.text = self.textField.text;
            
            [self.delegate editVCardViewControllerDidFinishChange];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
