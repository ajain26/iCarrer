//
//  BoardAddPostVC.m
//  iCareer
//
//  Created by Hitesh on 12/4/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "BoardAddPostVC.h"
#import "AppHelper.h"
#import "Services.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface BoardAddPostVC ()<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *userDict;
@end

@implementation BoardAddPostVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialView];
}
#pragma mark - setInitialView
-(void)setInitialView{
    self.userDict = [AppHelper userDefaultsDictionary:@"user"];
    
    self.emailImageView.layer.borderWidth = 1.0f;
    self.emailImageView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0f].CGColor;
    
    self.messageImageView.layer.borderWidth = 1.0f;
    self.messageImageView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0f].CGColor;
    
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
}
#pragma mark - back
- (IBAction)back:(id)sender {
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.messageTextView becomeFirstResponder];
    return true;
}
#pragma mark - textview
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Message"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Message";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([self isReadyToGo]) {
            [self go];
        }
        return NO;
    }
    
    return YES;
}
#pragma mark - isReadyToGo
-(BOOL)isReadyToGo{
    if ([self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        if ([self.messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
            return true;
        }
        
        [AppHelper showToast:VALID_MESSAGE shakeView:nil parentView:self.view];
        return false;
    } else {
        if ([self.messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
            [AppHelper showToast:VALID_TITLE shakeView:nil parentView:self.view];
            return false;
        }
        [AppHelper showToast:VALID_TITLE_MESSAGE shakeView:nil parentView:self.view];
        return false;
    }
    return false;
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
- (IBAction)post:(id)sender {
    [self.view endEditing:true];
    if ([self isReadyToGo]) {
        [self go];
    }
}
#pragma mark - go
-(void)go{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    [param setObject:@"" forKey:@"title"];
    [param setObject:@"" forKey:@"desc"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    [param setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"timestamp"];
    
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,ADD_POST] withParam:param success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                [AppHelper showToast:[dict objectForKey:@"msg"] shakeView:nil parentView:self.view];

                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    [self.navigationController popViewControllerAnimated:true];
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
@end
