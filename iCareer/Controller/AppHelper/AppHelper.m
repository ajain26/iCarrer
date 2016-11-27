//
//  AppHelper.m
//  iCareer
//
//  Created by Hitesh Kumar Singh on 27/11/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "AppHelper.h"
#import <AudioToolbox/AudioServices.h>

@implementation AppHelper

#pragma mark - saveToUserDefaults
+(void)saveToUserDefaults:(id)value withKey:(NSString*)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}
#pragma mark - userDefaultsForKey
+(NSString*)userDefaultsForKey:(NSString*)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
    val = [standardUserDefaults objectForKey:key];
    
    return val;
}
#pragma mark - removeFromUserDefaultsWithKey
+(void)removeFromUserDefaultsWithKey:(NSString*)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults removeObjectForKey:key];
    [standardUserDefaults synchronize];
}
#pragma mark - addShadow
+(void)addShadow:(UIView *)view withColor: (UIColor *)color{
    view.backgroundColor = color;
    CALayer *vw = [view layer];
    [vw setMasksToBounds:NO ];
    [vw setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [vw setShadowOpacity:1.0 ];
    [vw setShadowRadius:3.0 ];
    [vw setShadowOffset:CGSizeMake( 0 , 0 )];
    [vw setShouldRasterize:YES];
    [vw setBorderColor:[UIColor blackColor].CGColor];
    [vw setBorderWidth:1.0];
    [vw setShadowPath:[UIBezierPath bezierPathWithRect:vw.bounds].CGPath];
}
#pragma mark - showToast
+(void)showToast:(NSString*)msg shakeView:(UIView*)shakeView parentView:(UIView*)parentView{
    [parentView makeToast:msg duration:1.5 position:CSToastPositionBottom];
}
@end
