//
//  IprofileSummaryCell.m
//  iCareer
//
//  Created by Hitesh on 12/6/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "IprofileSummaryCell.h"

@implementation IprofileSummaryCell

-(void)setBorderToContentImageView{
    self.contentImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;//[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0f].CGColor;
    [self.contentImageView.layer setMasksToBounds:true];
}
@end
