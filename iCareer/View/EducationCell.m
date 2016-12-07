//
//  EducationCell.m
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "EducationCell.h"

@implementation EducationCell

-(void)setBorder{
    self.degreeImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.degreeImageView.layer.borderWidth = 1.0f;
    [self.degreeImageView.layer setMasksToBounds:true];
    
    self.universityImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.universityImageView.layer.borderWidth = 1.0f;
    [self.universityImageView.layer setMasksToBounds:true];
    
    self.univAddressImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.univAddressImageView.layer.borderWidth = 1.0f;
    [self.univAddressImageView.layer setMasksToBounds:true];
    
    self.startYearImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.startYearImageView.layer.borderWidth = 1.0f;
    [self.startYearImageView.layer setMasksToBounds:true];
    
    self.endYearImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.endYearImageView.layer.borderWidth = 1.0f;
    [self.endYearImageView.layer setMasksToBounds:true];
}

@end
