//
//  NewsRoomVC.m
//  iCareer
//
//  Created by Hitesh on 12/3/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "NewsRoomVC.h"
#import "MFSideMenuVC.h"
#import "Services.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppHelper.h"
#import "NewsRoomCell.h"

@interface NewsRoomVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSDictionary *userDict;
@property (strong, nonatomic) NSArray *newsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NewsRoomVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitial];
    [self getAllNews];
}
#pragma mark - setInitial
-(void)setInitial{
    self.userDict = [AppHelper userDefaultsDictionary:@"user"];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark - getAllNews
-(void)getAllNews{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];

    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    [param setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,FETCH_NEWS] withParam:param success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    if (![[responseDict objectForKey:@"response"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"response"]) {
                        //self.newsArray = [responseDict objectForKey:@"response"];
                        //[self.tableView reloadData];
                        
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
#pragma mark - leftSideMenuButtonPressed
- (IBAction)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
#pragma mark - search
- (IBAction)search:(id)sender {
    
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NewsRoomCell";
    
    NewsRoomCell *cell = (NewsRoomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = @"";
    //cell.linkLabel.text = @"";
    //cell.timeLabel.text = @"";
    cell.descLabel.text = @"";
    [cell.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *newsDict;
    
    if ([[newsDict objectForKey:@"is_bookmarked"] intValue] == 1){
        [cell.likeButton setImage:[UIImage imageNamed:@"likeSelected"] forState:UIControlStateNormal];
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    if (indexPath.row % 2 == 0) {
    cell.titleLabel.text = @"aks lkajf akjsf kajfk ajf;kaj fja fja fajf ajf afja";
    cell.descLabel.text = @"askf jlkjf ajf ajfk afkaj fkaj fkljfkkj kjf kfkj  ffj kfjkas fkajf akfj kafj kafjkfj ksfksfj ksfjf fjkf klajfklajfla;kjfalkj fakfj ;lkfskfj fj klfj a;kjf aks fj";
    }else{
        cell.titleLabel.text = @"asf as sfa;lkf jaksljf akjf;kaj f;kajf;ajf ;ajf;kj kfajk;fja kfj akfjkafjkasfj kasfjkaks lkajf akjsf kajfk ajf;kaj fja fja fajf ajf afja";
        cell.descLabel.text = @"askf jlkjf ajf ajfk afkaj fkaj fkljfkkj kjf kfkj  ffj kfjkas fkajf akfj kafj kafjkj kja; fja;kfj ;akjf ;kajf ka jfkajfka jfkaj kfjaskfjakslfjkafj kafjkasfj klafjsa fklaj sfklaj kfjak fjkasfj akldfj l;aksf jklasfj klsdfjkfj ksfksfj ksfjf fjkf klajfklajfla;kjfalkj fakfj ;lkfskfj fj klfj a;kjf aks fj";
    }
    return cell;
}
#pragma mark - like
-(void)like:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
}
#pragma mark - share
-(void)share:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
}
@end
