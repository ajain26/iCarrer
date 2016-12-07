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
-(void)setBorder;
@end
