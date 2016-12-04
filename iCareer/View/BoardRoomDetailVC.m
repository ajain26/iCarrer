//
//  BoardRoomDetailVC.m
//  iCareer
//
//  Created by Hitesh on 12/4/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "BoardRoomDetailVC.h"
#import "Services.h"
#import "Defines.h"
#import "AppHelper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "BoardRoomDetailCell.h"
#import "UIImageView+WebCache.h"
#import "BoardRoomCommentCell.h"

@interface BoardRoomDetailVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSString *textViewText;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) NSDictionary *userDict;
@end

@implementation BoardRoomDetailVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.boardDict);
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    textViewText = @"";
    
    self.userDict = [AppHelper userDefaultsDictionary:@"user"];
    
    /* Add notification to keyboard appear/disappear */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    /*************************************************/
    
    [self getAllComments];
}
#pragma mark - back
- (IBAction)back:(id)sender {
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.commentsArray.count > 0) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.commentsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"BoardRoomDetailCell";
    
        BoardRoomDetailCell *cell = (BoardRoomDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = @"";
        cell.descLabel.text = @"";
        cell.userNameLabel.text = @"";
        cell.userImageView.image = nil;
        cell.dateLabel.text = @"";
        cell.commentTextField.text = @"";
        cell.commentTextField.delegate = self;
        cell.commentTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.commentTextField.layer.borderWidth = 1.0f;
        cell.commentTextField.layer.cornerRadius = 5.0f;
    
        if ([[self.boardDict objectForKey:@"is_bookmarked"] intValue] == 0){
            [cell.likeButton setImage:[UIImage imageNamed:@"likeSelected"] forState:UIControlStateNormal];
        } else {
            [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        }
    
        cell.userNameLabel.text = [self.boardDict objectForKey:@"username"];
        cell.titleLabel.text = [self.boardDict objectForKey:@"title"];
        cell.descLabel.text = [self.boardDict objectForKey:@"desc"];
        [cell setDate:[self.boardDict objectForKey:@"timestamp"]];
        [cell.commentButton setTitle:[NSString stringWithFormat:@"(%@)",[self.boardDict objectForKey:@"comment_count"]] forState:UIControlStateNormal];
    
        [cell.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [cell.postButton addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    
        cell.commentTextField.text = textViewText;
    
        NSString *imagePath = [self.boardDict objectForKey:@"image_path"];
        if (![imagePath isKindOfClass:[NSNull class]] && imagePath) {
            if (imagePath.length > 0) {
                imagePath = [imagePath stringByReplacingOccurrencesOfString:@"../" withString:BASEURL];
            }

            
            [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"profile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.userImageView.image = image;
                cell.userImageView.layer.cornerRadius = 25;
                [cell.userImageView.layer setMasksToBounds:YES];
            
            }];
        } else {
            cell.userImageView.image = [UIImage imageNamed:@"profile"];
        }

        return cell;
    } else {
        static NSString *cellIdentifier = @"BoardRoomCommentCell";
        
        BoardRoomCommentCell *cell = (BoardRoomCommentCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"BoardRoomCommentCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.userImageView.image = nil;
        cell.userNameLabel.text = @"";
        cell.dateLabel.text = @"";
        cell.titleLabel.text = @"";
        
        NSDictionary *commentDict = [self.commentsArray objectAtIndex:indexPath.row];
        
        cell.userNameLabel.text = [commentDict objectForKey:@"commentor_name"];
        cell.titleLabel.text = [commentDict objectForKey:@"commentor_comment"];
        [cell setDate:[commentDict objectForKey:@"commentor_timestamp"]];
        
        NSString *imagePath = [commentDict objectForKey:@"commentor_image_path"];
        if (![imagePath isKindOfClass:[NSNull class]] && imagePath) {
            if (imagePath.length > 0) {
                imagePath = [imagePath stringByReplacingOccurrencesOfString:@"../" withString:BASEURL];
            }
            
            
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
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:true];
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textViewText = textField.text;
}

#pragma mark - share
-(void)share:(UIButton*)sender{
    [self.view endEditing: true];
}
#pragma mark - like
-(void)like:(UIButton*)sender{
    [self.view endEditing: true];
    
    [self addBookMark:self.boardDict];
}
#pragma mark - addBookMark
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
                    [self getAllComments];
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
#pragma mark - getAllComments
-(void)getAllComments{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    [param setObject:[self.boardDict objectForKey:@"boardroom_id"] forKey:@"boardroom_id"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,FETCH_BOARD_BY_ID] withParam:param success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    if (![[responseDict objectForKey:@"response"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"response"]) {
                        if ([[responseDict objectForKey:@"response"] isKindOfClass:[NSArray class]]) {
                            if ([[responseDict objectForKey:@"response"] count] > 0) {
                                self.boardDict = [[responseDict objectForKey:@"response"] objectAtIndex:0];
                            }
                        }
                    }
                    if (![[responseDict objectForKey:@"comments_array"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"comments_array"]) {
                        self.commentsArray = [responseDict objectForKey:@"comments_array"];
                    }
                    [self.tableView reloadData];
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
#pragma mark - keyboardWillShow
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:.3 animations:^(void){
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }];
    
    
}
#pragma mark - keyboardWillHide
-(void)keyboardWillHide:(NSNotification*)notification{
    [UIView animateWithDuration:.3 animations:^(void){
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}
#pragma mark - post
-(void)post:(UIButton*)btn{
    [self.view endEditing:true];
    NSLog(@"%@",textViewText);
    if ([textViewText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
        [param setObject:[self.boardDict objectForKey:@"boardroom_id"] forKey:@"boardroom_id"];
        [param setObject:textViewText forKey:@"user_comments"];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        
        [param setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"timestamp"];

        
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,ADD_COMMENTS] withParam:param success:^(NSDictionary *responseDict) {
            [SVProgressHUD dismiss];
            NSDictionary *dict = [responseDict objectForKey:@"status"];
            
            if (![dict isKindOfClass:[NSNull class]] && dict) {
                if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                    if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                        [self getAllComments];
                    }
                }
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
    }
}
@end
