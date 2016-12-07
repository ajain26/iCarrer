//
//  EditProfileVC.m
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "EditProfileVC.h"
#import "Defines.h"
#import "Services.h"
#import "AppHelper.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface EditProfileVC ()<UITextFieldDelegate>
@property (strong, nonatomic) NSDictionary *userDict;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EditProfileVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitial];
    [self setBorder];
}
#pragma mark - setInitial
-(void)setInitial{
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
    
    self.userNameTextField.text = [self.userDict objectForKey:@"username"];
    self.designationTextField.text = [self.userDict objectForKey:@"short_title"];
    self.addressTextField.text = [self.userDict objectForKey:@"address"];
}
#pragma mark - setBorder
-(void)setBorder{
    self.userNameImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userNameImageView.layer.borderWidth = 1.0f;
    [self.userNameImageView.layer setMasksToBounds:true];
    
    self.designationImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.designationImageView.layer.borderWidth = 1.0f;
    [self.designationImageView.layer setMasksToBounds:true];
    
    self.addressImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addressImageView.layer.borderWidth = 1.0f;
    [self.addressImageView.layer setMasksToBounds:true];
}
#pragma mark - isReadyToGo
-(BOOL)isReadyToGo{
    if ([[self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0 && [[self.designationTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0 && [[self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        return true;
    } else {
        [AppHelper showToast:ALL_FIELDS_MANDATORY shakeView:nil parentView:self.view];
        return false;
    }
}
#pragma mark - go
-(void)go{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"user_name"];
    [param setObject:[self.designationTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"st"];
    [param setObject:[self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"address"];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,UPDATE_PROFILE] withParam:param success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.userDict];
                    [dict setObject:[self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"username"];
                    [dict setObject:[self.designationTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"short_title"];
                    [dict setObject:[self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"address"];
                    [AppHelper saveToUserDefaults:dict withKey:@"user"];
                    
                    [self.navigationController popViewControllerAnimated:true];
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - back
- (IBAction)back:(id)sender {
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark - submit
- (IBAction)submit:(id)sender {
    [self.view endEditing:true];
    if ([self isReadyToGo]) {
        [self go];
    }
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userNameTextField) {
        [self.designationTextField becomeFirstResponder];
    } else if (textField == self.designationTextField){
        [self.addressTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if ([self isReadyToGo]) {
            [self go];
        }
    }
    return true;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 200;
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
