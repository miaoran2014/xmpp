#import <UIKit/UIKit.h>

@class MREditVCardController;
@protocol MREditVCardControllerDelagate <NSObject>

//完成编辑保存
//而且只有数据改变的时候，才会调用
-(void)editVCardViewControllerDidFinishChange;

@end
@interface MREditVCardController : UIViewController

@property (nonatomic, weak) UILabel *leftLabel;

@property (nonatomic, weak) UILabel *rightLabel;

@property (nonatomic, weak) id<MREditVCardControllerDelagate> delegate;

@end
