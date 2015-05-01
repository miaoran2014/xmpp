//
//  HMAddRosterViewController.m
//  企信通
//
//  Created by apple on 14-9-5.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MRAddRosterController.h"
#import "MRLoginTool.h"
#import "AppDelegate.h"
#define Delegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
@interface MRAddRosterController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)add:(id)sender;

@end

@implementation MRAddRosterController


- (IBAction)add:(id)sender {
    //添加好友
    //1获取好友的名字
    NSString *user = self.textField.text;
    //lisi 自动补充全lisi@teacher.local
    //获取有没有@符号 如果有，用户名格式不正确
    NSRange range = [user rangeOfString:@"@"];
    if (range.location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"输入的用户名格式不正确，不能带@字符" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    //自动补全@teacher.local
    NSString *domain = [MRLoginTool domain];
    NSString *userJid = [NSString stringWithFormat:@"%@@%@",user,domain];
    //添加好友
    XMPPJID *friendJid = [XMPPJID jidWithString:userJid];
    //好友已经存在了，就不需要再添加
    BOOL exist = [Delegate.rosterStroage userExistsWithJID:friendJid xmppStream:Delegate.xmppStream];
    if (exist) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"当前添加的用户已经是你的好友，无须添加" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }else{
        //不存在好友，才添加
        [Delegate.roster subscribePresenceToUser:friendJid];
    }
    //让当前的控制器销毁
    [self.navigationController popViewControllerAnimated:YES];
}
@end
