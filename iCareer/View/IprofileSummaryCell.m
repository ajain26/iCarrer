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
    self.contentImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentImageView.layer setMasksToBounds:true];
}
@end
