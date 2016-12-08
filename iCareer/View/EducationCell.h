//
//  EducationCell.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *degreeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *universityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *univAddressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *startYearImageView;
@property (weak, nonatomic) IBOutlet UIImageView *endYearImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UITextField *universityAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *degreeTextField;
@property (weak, nonatomic) IBOutlet UITextField *universityTextField;
@property (weak, nonatomic) IBOutlet UITextField *startYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *endYearTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


-(void)setBorder;
@end
