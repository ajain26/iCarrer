//
//  AppHelper.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 27/11/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Toast/UIView+Toast.h>

@interface AppHelper : NSObject
#pragma mark - saveToUserDefaults
/**
 Saves value to the key to the NSUserDefaults.
 
 @param value value stores the value for the key.
 @param key key with which the value is associated.
*/
+(void)saveToUserDefaults:(id)value withKey:(NSString*)key;
#pragma mark - userDefaultsForKey
/**
 Retrieve the value stored in NSUserDefaults, using key.
 
 @param key key with which the value is associated.
*/
+(NSString*)userDefaultsForKey:(NSString*)key;
#pragma mark - removeFromUserDefaultsWithKey
/**
 Removes the value from NSUserDefaults, using key.
 
 @param key key with which the value is associated.
*/
+(void)removeFromUserDefaultsWithKey:(NSString*)key;
#pragma mark - addShadow
/**
 Add shadow to the view's border.
 
 @param view view which needs shadow around it's border.
 @param color color of the view.
*/
+(void)addShadow:(UIView *)view withColor: (UIColor *)color;
#pragma mark - showToast
/**
 Show toast message for 1.5 seconds.
 
 @param msg msg to show in toast message.
 @param shakeView shakeView would be subclass of UIView to shake.
 @param parentView parentView contains the toast message.
*/
+(void)showToast:(NSString *)msg shakeView:(UIView *)shakeView parentView:(UIView*)parentView;
+(void)showToastCenterError:(NSString*)msg parentView:(UIView*)parentView;
+(NSDictionary*)userDefaultsDictionary:(NSString*)key;
@end
