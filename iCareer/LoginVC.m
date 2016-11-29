//
//  LoginVC.m
//  iCareer
//
//  Created by Hitesh Kumar Singh on 27/11/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "LoginVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "Services.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface LoginVC ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialView];
}
#pragma mark - setInitialView
-(void)setInitialView{
    CGRect frame = self.containerView.frame;
    frame.size.height = [UIScreen mainScreen].bounds.size.height;
    self.containerView.frame = frame;
    
    /* Tap anywhere on screenm hide keyboard */
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.containerView addGestureRecognizer:tapGestureRecognizer2];
    tapGestureRecognizer2.delegate = self;
    /*****************************************/
    
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
#pragma mark - tapped
-(void)tapped:(UITapGestureRecognizer*)recognizer {
    [self.view endEditing:true];
}
#pragma mark - login
- (IBAction)login:(id)sender {
    [self.view endEditing:true];
    if ([self isReadyToGo]) {
        [self go];
    }
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        if ([self isReadyToGo]) {
            [self go];
        }
        [textField resignFirstResponder];
    }
    return true;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 200;
}
#pragma mark - go
-(void)go{
    NSMutableDictionary *loginParam = [NSMutableDictionary new];
    [loginParam setObject:[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"email"];
    [loginParam setObject:[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"password"];
    [SVProgressHUD showWithStatus:@"Please wait"];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,VALIDATEUSER] withParam:loginParam success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseDict objectForKey:@"status"];

        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 0) {
                    [AppHelper showToastCenterError:[dict objectForKey:@"msg"] parentView:self.view];
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - isReadyToGo
-(BOOL)isReadyToGo{
    if ([self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        if ([self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
            return true;
        }
        
        [AppHelper showToast:VALID_PASSWORD shakeView:self.passwordTextField parentView:self.view];
        return false;
    } else {
        if ([self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
            [AppHelper showToast:VALID_EMAIL shakeView:self.emailTextField parentView:self.view];
            return false;
        }
        [AppHelper showToast:VALID_EMAIL_PASSWORD shakeView:self.inputView parentView:self.view];
        return false;
    }
    return false;
}
#pragma mark - newUser
- (IBAction)newUser:(id)sender {
    [self.view endEditing:true];
    [self performSegueWithIdentifier:@"RegisterVC" sender:nil];
}
#pragma mark - forgotPassword
- (IBAction)forgotPassword:(id)sender {
    [self.view endEditing:true];
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

@end
