//
//  SideMenuCell.m
//  iCareer
//
//  Created by Hitesh on 12/3/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "SideMenuCell.h"

@implementation SideMenuCell

-(void)assignTitle:(NSString *)title andIcon:(NSString*)icon{
    self.titleLabel.text = title;
    self.iconImageView.image = [UIImage imageNamed:icon];
}
@end
