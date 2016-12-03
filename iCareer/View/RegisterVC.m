//
//  RegisterVC.m
//  iCareer
//
//  Created by Hitesh on 11/29/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "RegisterVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "Services.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface RegisterVC ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RegisterVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialView];
}
#pragma mark - signup
- (IBAction)signup:(id)sender {
    [self.view endEditing:true];
    if ([self isReadyToGo]) {
        [self go];
    } else {
        [AppHelper showToastCenterError:@"Please fill empty fields" parentView:self.view];
    }
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
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField){
        [self.confirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.confirmPasswordTextField){
        [self.emailTextField becomeFirstResponder];
    } else {
        if ([self isReadyToGo]) {
            [self go];
        } else {
            [AppHelper showToastCenterError:@"Please fill empty fields" parentView:self.view];
        }
        [textField resignFirstResponder];
    }
    return true;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 200;
}
#pragma mark - isReadyToGo
-(BOOL)isReadyToGo{
    if ([self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && [self.confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        return true;
    }
    return false;
}
#pragma mark - go
-(void)go{
    if ([self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        self.userNameTextField.text = @"";
        [AppHelper showToast:VALID_NAME shakeView:self.userNameTextField parentView:self.view];
    } else if ([self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        self.passwordTextField.text = @"";
        [AppHelper showToast:VALID_PASSWORD shakeView:self.passwordTextField parentView:self.view];
    } else if ([self.confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        self.confirmPasswordTextField.text = @"";
        [AppHelper showToast:VALID_CONFIRM_PASS shakeView:self.confirmPasswordTextField parentView:self.view];
    } else if (![[self.confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        self.confirmPasswordTextField.text = @"";
        [AppHelper showToast:PASSWORD_MISMATCH shakeView:self.confirmPasswordTextField parentView:self.view];
    } else if ([self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        self.emailTextField.text = @"";
        [AppHelper showToast:VALID_EMAIL_ONLY shakeView:self.emailTextField parentView:self.view];
    } else {
        NSMutableDictionary *loginParam = [NSMutableDictionary new];
        [loginParam setObject:[self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"username"];
        [loginParam setObject:[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"password"];
        [loginParam setObject:[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"email"];
        /*[loginParam setObject:@"a" forKey:@"summary"];
        [loginParam setObject:@"a" forKey:@"address"];*/
        [loginParam setObject:@"9999999999" forKey:@"telephone"];
        /*[loginParam setObject:@"a" forKey:@"short_title"];*/

        [SVProgressHUD showWithStatus:@"Please wait..."];
        
        [[Services sharedInstance] servicePOSTMultipartWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,USERREGISTRATION] withParam:loginParam success:^(NSDictionary *responseDict) {
            [SVProgressHUD dismiss];
            NSDictionary *dict = [responseDict objectForKey:@"status"];
            
            if (![dict isKindOfClass:[NSNull class]] && dict) {
                if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                    if ([[dict objectForKey:@"statuscode"] intValue] == 0) {
                        [AppHelper showToastCenterError:[dict objectForKey:@"msg"] parentView:self.view];
                    } else {
                        [self performSegueWithIdentifier:@"WelcomeVC" sender:nil];//TODO:
                    }
                }
            } else {
                [AppHelper showToastCenterError:@"Error" parentView:self.view];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];

        }];
        
        /*[[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,USERREGISTRATION] withParam:loginParam success:^(NSDictionary *responseDict) {
            [SVProgressHUD dismiss];
            NSDictionary *dict = [responseDict objectForKey:@"status"];
            
            if (![dict isKindOfClass:[NSNull class]] && dict) {
                if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                    if ([[dict objectForKey:@"statuscode"] intValue] == 0) {
                        [AppHelper showToastCenterError:[dict objectForKey:@"msg"] parentView:self.view];
                    }
                }
            } else {
                [self performSegueWithIdentifier:@"WelcomeVC" sender:nil];//TODO:
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];*/
    }
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
