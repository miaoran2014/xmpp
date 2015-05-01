
#import "MRRosterController.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "MRChatController.h"
#define Delegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface MRRosterController ()<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_resultContr;//数据的结果控制器
}

@property (nonatomic, strong) NSArray *friends;

@end

@implementation MRRosterController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFriends2];
   
}
//获取好友列表的第二种方法
-(void)loadFriends2{
    //从数据库XMPPRoster.sqlite里获取好友列表数据
    //XMPPUserCoreDataStorageObject
    //1.获取XMPPRoster.sqlite上下文
    NSManagedObjectContext *context = Delegate.rosterStroage.mainThreadManagedObjectContext;
    //2.添加请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    //3.设置排序 根据displayName的升序排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //创建数据结果控制器对象
    //a.下面的数据获取是没有分组
    //_resultContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    //b.sectionNum是好友的在线状态的标识
    _resultContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"sectionNum" cacheName:nil];
    _resultContr.delegate=self;
    //执行查询
    NSError *error = nil;
    [_resultContr performFetch:&error];
}

//获取好友列表的第一种方法
-(void)loadFriends1{
    //从数据库XMPPRoster.sqlite里获取好友列表数据
    //XMPPUserCoreDataStorageObject
    //1.获取XMPPRoster.sqlite上下文
    NSManagedObjectContext *context = Delegate.rosterStroage.mainThreadManagedObjectContext;
    //2.添加请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    //3.设置排序 根据displayName的升序排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    //4.执行
    NSArray *friends = [context executeFetchRequest:request error:nil];
    self.friends = friends;
}

#pragma mark 表格有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //返回多少组
    return _resultContr.sections.count;
}

#pragma mark 表格每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.friends.count;
    
    //通过resultContr获取到的好友数据，是放在fetchedObjects属性里面
    //return _resultContr.fetchedObjects.count;
    
    id<NSFetchedResultsSectionInfo> groupInfo = _resultContr.sections[section];

    //每一组的有多少行数据保存到numberOfObjects属性
    return [groupInfo numberOfObjects];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //获取分组信息
    id<NSFetchedResultsSectionInfo> groupInfo = _resultContr.sections[section];
    
    NSInteger state = [[groupInfo indexTitle] integerValue];
    switch (state) {
        case 0:
            return @"在线";
            break;
        case 1:
            return @"离开";
            break;
        case 2:
            return @"离线";
            break;
        default:
            return @"未知状态";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //获取好友
//    XMPPUserCoreDataStorageObject *friend = self.friends[indexPath.row];
    //XMPPUserCoreDataStorageObject *friend = _resultContr.fetchedObjects[indexPath.row];
    
   // 直接把indexPath传进去，就可以获取到对应组和行的数据
    XMPPUserCoreDataStorageObject *friend = [_resultContr objectAtIndexPath:indexPath];
    cell.textLabel.text = friend.displayName;
    return cell;
    
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    [self.tableView reloadData];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
     [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //获取好友
        XMPPUserCoreDataStorageObject *friend = [_resultContr objectAtIndexPath:indexPath];
        //删除好友
        [Delegate.roster removeUser:friend.jid];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   NSIndexPath* index= [self.tableView indexPathForSelectedRow];
    //获取好友
   XMPPUserCoreDataStorageObject *friend = [_resultContr objectAtIndexPath:index];
    //获取好友的jid
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[MRChatController class] ]) {
        MRChatController *chatVc = destVc;
        chatVc.friendJid = friend.jid;
    }
}

@end
