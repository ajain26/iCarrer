//
//  ExperienceCell.m
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "ExperienceCell.h"

@implementation ExperienceCell
-(void)setBorder{
    self.designationImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.designationImageView.layer.borderWidth = 1.0f;
    [self.designationImageView.layer setMasksToBounds:true];
    
    self.companyImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.companyImageView.layer.borderWidth = 1.0f;
    [self.companyImageView.layer setMasksToBounds:true];
    
    self.companyAddressImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.companyAddressImageView.layer.borderWidth = 1.0f;
    [self.companyAddressImageView.layer setMasksToBounds:true];
    
    self.startImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.startImageView.layer.borderWidth = 1.0f;
    [self.startImageView.layer setMasksToBounds:true];
    
    self.endImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.endImageView.layer.borderWidth = 1.0f;
    [self.endImageView.layer setMasksToBounds:true];
    
    self.descImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.descImageView.layer.borderWidth = 1.0f;
    [self.descImageView.layer setMasksToBounds:true];
}
@end
