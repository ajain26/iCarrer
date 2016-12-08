//
//  ExperienceCell.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExperienceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *designationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *companyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *companyAddressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;
@property (weak, nonatomic) IBOutlet UIImageView *endImageView;
@property (weak, nonatomic) IBOutlet UIImageView *descImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UITextField *designationTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *companAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *startYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *endYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *jobDescTextField;


-(void)setBorder;
@end
