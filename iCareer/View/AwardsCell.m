//
//  AwardsCell.m
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "AwardsCell.h"

@implementation AwardsCell

-(void)setBorder{
    self.awardNameImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.awardNameImageView.layer.borderWidth = 1.0f;
    [self.awardNameImageView.layer setMasksToBounds:true];
    
    self.awardDescImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.awardDescImageView.layer.borderWidth = 1.0f;
    [self.awardDescImageView.layer setMasksToBounds:true];
    
    self.organizationImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.organizationImageView.layer.borderWidth = 1.0f;
    [self.organizationImageView.layer setMasksToBounds:true];
    
    self.yearImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.yearImageView.layer.borderWidth = 1.0f;
    [self.yearImageView.layer setMasksToBounds:true];
}
@end
