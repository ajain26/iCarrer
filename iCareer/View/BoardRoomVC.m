//
//  BoardRoomVC.m
//  iCareer
//
//  Created by Hitesh on 12/3/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "BoardRoomVC.h"
#import "MFSideMenuVC.h"
#import "Services.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppHelper.h"
#import "BoardRoomCell.h"
#import "UIImageView+WebCache.h"

@interface BoardRoomVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSDictionary *userDict;
@property (strong, nonatomic) NSArray *boardArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BoardRoomVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDict = [AppHelper userDefaultsDictionary:@"user"];
    [self getAllBoardRoom];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark - getAllBoardRoom
-(void)getAllBoardRoom{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,FETCHBOARD] withParam:param success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    if (![[responseDict objectForKey:@"response"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"response"]) {
                        self.boardArray = [responseDict objectForKey:@"response"];
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
#pragma mark - tableview
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.boardArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"BoardRoomCell";
    
    BoardRoomCell *cell = (BoardRoomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = @"";
    cell.descLabel.text = @"";
    cell.userNameLabel.text = @"";
    cell.userImageView.image = nil;
    cell.commentsLabel.text = @"";
    cell.dateLabel.text = @"";
    
    NSDictionary *boardDict = [self.boardArray objectAtIndex:indexPath.row];
    
    cell.userNameLabel.text = [boardDict objectForKey:@"username"];
    cell.titleLabel.text = [boardDict objectForKey:@"title"];
    cell.descLabel.text = [boardDict objectForKey:@"desc"];
    cell.commentsLabel.text = [NSString stringWithFormat:@"%@ comments",[boardDict objectForKey:@"comment_count"]];
    [cell setDate:[boardDict objectForKey:@"timestamp"]];
    [cell.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *imagePath = [boardDict objectForKey:@"image_path"];
    if (![imagePath isKindOfClass:[NSNull class]] && imagePath) {
        if (imagePath.length > 0) {
            imagePath = [imagePath stringByReplacingOccurrencesOfString:@"../" withString:BASEURL];
        }
        NSLog(@"--------imagePath: %@",imagePath);
        
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"profile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            cell.userImageView.image = image;
            cell.userImageView.layer.cornerRadius = 25;
            [cell.userImageView.layer setMasksToBounds:YES];

        }];
    } else {
        cell.userImageView.image = [UIImage imageNamed:@"profile"];
    }


    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
#pragma mark - share
-(void)share:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *shareDict = [self.boardArray objectAtIndex:indexPath.row];
    //http://inubex.in/icareer/boardroom_details.php?boardroom_id=2&discussion_owner=5
    NSString *shareString = [shareDict objectForKey:@"title"];
    NSString *url = [NSString stringWithFormat:@"%@/boardroom_details.php?boardroom_id=%@&discussion_owner=%@",BASEURL,[shareDict objectForKey:@"boardroom_id"],[shareDict objectForKey:@"discussion_owner"]];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[shareString, [NSURL URLWithString:url]]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                         // ...
                                     }];
}
@end
