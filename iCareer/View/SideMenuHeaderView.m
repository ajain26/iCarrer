//
//  SideMenuHeaderView.m
//  iCareer
//
//  Created by Hitesh on 12/3/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "SideMenuHeaderView.h"

@implementation SideMenuHeaderView


- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120)];
    
    if (self) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SideMenuHeaderView" owner:self options:nil];
        [[nib objectAtIndex:0] setFrame:CGRectMake(0, 0, self.frame.size.width, 120)];
        self = [nib objectAtIndex:0];
    }
    
    return self;
}

@end
