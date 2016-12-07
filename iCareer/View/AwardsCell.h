//
//  AwardsCell.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwardsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *awardNameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *awardDescImageView;
@property (weak, nonatomic) IBOutlet UIImageView *organizationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yearImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *awardNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *awardDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *organisationTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;



-(void)setBorder;

@end
