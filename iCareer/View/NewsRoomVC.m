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
#import "WebViewVC.h"

@interface NewsRoomVC ()<UITableViewDelegate, UITableViewDataSource>{
    NSIndexPath *selectedIndexPath;
}
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

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
                        self.newsArray = [responseDict objectForKey:@"response"];
                        [self.tableView reloadData];
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
    return self.newsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NewsRoomCell";
    
    NewsRoomCell *cell = (NewsRoomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = @"";
    cell.linkLabel.text = @"";
    cell.timeLabel.text = @"";
    cell.descLabel.text = @"";
    [cell.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *newsDict = [self.newsArray objectAtIndex:indexPath.row];
    
    if ([[newsDict objectForKey:@"is_bookmarked"] intValue] == 1){
        [cell.likeButton setImage:[UIImage imageNamed:@"likeSelected"] forState:UIControlStateNormal];
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    
    cell.titleLabel.text = [newsDict objectForKey:@"news_title"];
    cell.descLabel.text = [newsDict objectForKey:@"news_desc"];
    cell.linkLabel.text = [newsDict objectForKey:@"news_url"];
    
    [cell assignTime:[newsDict objectForKey:@"news_timestamp"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"WebViewVC" sender:nil];
}
#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"WebViewVC"]) {
        NSDictionary *linkDict = [self.newsArray objectAtIndex:selectedIndexPath.row];
        WebViewVC *web = (WebViewVC*)segue.destinationViewController;
        web.url = [linkDict objectForKey:@"news_url"];
    }
}
#pragma mark - like
-(void)like:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *likeDict = [self.newsArray objectAtIndex:indexPath.row];

    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    [param setObject:[NSString stringWithFormat:@"%d",![[likeDict objectForKey:@"is_bookmarked"] intValue]] forKey:@"isbookmark"];
    [param setObject:[likeDict objectForKey:@"news_id"] forKey:@"newsid"];
   
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,LIKE_NEWS] withParam:param success:^(NSDictionary *responseDict) {
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    [self getAllNews];
                } else {
                    [SVProgressHUD dismiss];
                }
            } else {
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - share
-(void)share:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *shareDict = [self.newsArray objectAtIndex:indexPath.row];
    
    NSString *shareString = [shareDict objectForKey:@"news_title"];
    NSString *url = [shareDict objectForKey:@"news_url"];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[shareString, [NSURL URLWithString:url]]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                          }];

    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    [param setObject:[NSString stringWithFormat:@"%d",![[shareDict objectForKey:@"is_shared"] intValue]] forKey:@"isshared"];
    [param setObject:[shareDict objectForKey:@"news_id"] forKey:@"newsid"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,SHARE_NEWS] withParam:param success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
@end
