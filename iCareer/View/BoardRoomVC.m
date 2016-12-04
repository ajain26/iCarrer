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
#import "BoardRoomDetailVC.h"

@interface BoardRoomVC ()<UITableViewDelegate, UITableViewDataSource>{
    int currentSelectedTab;//0-all; 1-my;
    NSIndexPath *selectedIndexPath;
}
@property (strong, nonatomic) NSDictionary *userDict;
@property (strong, nonatomic) NSArray *boardArray;
@property (strong, nonatomic) NSMutableArray *myBoardArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *allImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIButton *allDiscussButton;
@property (weak, nonatomic) IBOutlet UIButton *myDiscussButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation BoardRoomVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    currentSelectedTab = 0;
    self.userDict = [AppHelper userDefaultsDictionary:@"user"];
    self.myBoardArray = [NSArray new];
    [self getAllBoardRoom];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self setTabView];
}
#pragma mark - setTabView
-(void)setTabView{
    if (currentSelectedTab == 0) {
        self.allImageView.hidden = false;
        self.myImageView.hidden = true;
    } else {
        self.allImageView.hidden = true;
        self.myImageView.hidden = false;
    }
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
                        
                        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"discussion_owner", [self.userDict objectForKey:@"user_id"]];//keySelected is NSString itself
                        NSLog(@"predicate %@",predicateString);
                        self.myBoardArray = [NSMutableArray arrayWithArray:[self.boardArray filteredArrayUsingPredicate:predicateString]];
                        
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
    if (currentSelectedTab == 0){
        self.messageLabel.hidden = true;
        self.tableView.hidden = false;
        return self.boardArray.count;
    } else {
        if (self.myBoardArray.count > 0) {
            self.messageLabel.hidden = true;
            self.tableView.hidden = false;
        } else {
            self.messageLabel.hidden = false;
            self.tableView.hidden = true;
        }
        
        return self.myBoardArray.count;
    }
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
    
    NSDictionary *boardDict;
    if (currentSelectedTab == 0) {
        boardDict = [self.boardArray objectAtIndex:indexPath.row];
    } else {
        boardDict = [self.boardArray objectAtIndex:indexPath.row];
    }
    
    if ([[boardDict objectForKey:@"is_bookmarked"] intValue] == 0){
        [cell.likeButton setImage:[UIImage imageNamed:@"likeSelected"] forState:UIControlStateNormal];
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    
    cell.userNameLabel.text = [boardDict objectForKey:@"username"];
    cell.titleLabel.text = [boardDict objectForKey:@"title"];
    cell.descLabel.text = [boardDict objectForKey:@"desc"];
    cell.commentsLabel.text = [NSString stringWithFormat:@"%@ comments",[boardDict objectForKey:@"comment_count"]];
    [cell setDate:[boardDict objectForKey:@"timestamp"]];
    
    [cell.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bookmarkButton addTarget:self action:@selector(bookmark:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];

    
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
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"BoardRoomDetailVC" sender:nil];
}
#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"BoardRoomDetailVC"]) {
        NSDictionary *dict;
        if (currentSelectedTab == 0) {
            dict = [self.boardArray objectAtIndex:selectedIndexPath.row];
        } else {
            dict = [self.myBoardArray objectAtIndex:selectedIndexPath.row];
        }
        
        BoardRoomDetailVC *board = (BoardRoomDetailVC*)segue.destinationViewController;
        board.boardDict = dict;
    }
}
#pragma mark - bookmark 
-(void)bookmark:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *dict;
    if (currentSelectedTab == 0) {
        dict = [self.boardArray objectAtIndex:indexPath.row];
    } else {
        dict = [self.myBoardArray objectAtIndex:indexPath.row];
    }
    
    [self addBookMark:dict];
}
#pragma mark - like
-(void)like:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSDictionary *dict;
    if (currentSelectedTab == 0) {
        dict = [self.boardArray objectAtIndex:indexPath.row];
    } else {
        dict = [self.myBoardArray objectAtIndex:indexPath.row];
    }
    [self addBookMark:dict];
}
-(void)addBookMark:(NSDictionary*)dict{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    [param setObject:[dict objectForKey:@"boardroom_id"] forKey:@"boardroom_id"];
    [param setObject:[NSString stringWithFormat:@"%d",![[dict objectForKey:@"is_bookmarked"] intValue]] forKey:@"isbookmark"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,BOOKMARK] withParam:param success:^(NSDictionary *responseDict) {
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    [self getAllBoardRoom];
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
#pragma mark - comment
-(void)comment:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"BoardRoomDetailVC" sender:nil];
}
#pragma mark - share
-(void)share:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *shareDict;
    if (currentSelectedTab == 0) {
        shareDict = [self.boardArray objectAtIndex:indexPath.row];
    } else {
        shareDict = [self.myBoardArray objectAtIndex:indexPath.row];
    }

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
#pragma mark - addPost
- (IBAction)addPost:(id)sender {
    
}
#pragma mark - tabChanged
-(IBAction)tabChanged:(UIButton*)sender{
    if (sender == self.allDiscussButton) {
        currentSelectedTab = 0;
    } else {
        currentSelectedTab = 1;
    }
    [self setTabView];
    [self.tableView reloadData];
}
@end
