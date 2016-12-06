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
        if ([value isKindOfClass:[NSString class]]) {
            [standardUserDefaults setObject:value forKey:key];
        } else {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
            [standardUserDefaults setObject:data forKey:key];
        }
        [standardUserDefaults synchronize];
    }
}
#pragma mark - userDefaultsForKey
+(NSString*)userDefaultsForKey:(NSString*)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults){
        val = [standardUserDefaults objectForKey:key];
    }
    return val;
}
#pragma mark - userDefaultsDictionary
+(NSDictionary*)userDefaultsDictionary:(NSString*)key{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *val = nil;

    if (standardUserDefaults){
        NSData *dictionaryData = [standardUserDefaults objectForKey:key];
        val = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
    }
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
    [vw setBorderColor:[UIColor colorWithRed:58.0/255.0 green:100.0/255.0 blue:90.0/255.0 alpha:0.8f].CGColor];
    [vw setBorderWidth:0.6];
    [vw setShadowPath:[UIBezierPath bezierPathWithRect:vw.bounds].CGPath];
}
#pragma mark - showToast
+(void)showToast:(NSString*)msg shakeView:(UIView*)shakeView parentView:(UIView*)parentView{
    [parentView makeToast:msg duration:1.5 position:CSToastPositionBottom];
}
#pragma mark - showToast
+(void)showToastCenterError:(NSString*)msg parentView:(UIView*)parentView{
    [parentView makeToast:msg duration:1.5 position:CSToastPositionCenter];
}
+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
