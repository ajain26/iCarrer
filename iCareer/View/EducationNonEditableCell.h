//
//  EducationNonEditableCell.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationNonEditableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
