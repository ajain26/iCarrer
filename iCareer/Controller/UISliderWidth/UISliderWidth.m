//
//  UISliderWidth.m
//  iCareer
//
//  Created by Hitesh on 11/30/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "UISliderWidth.h"

@implementation UISliderWidth

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)trackRectForBounds:(CGRect)bounds{
    bounds.size.height = 10;
    return bounds;
}
@end
