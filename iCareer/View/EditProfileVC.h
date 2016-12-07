//
//  EditProfileVC.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *designationTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userNameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *designationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;

@end
