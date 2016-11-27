//
//  CoreDataFunction.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 27/11/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CoreDataFunction : NSObject{
    NSManagedObjectContext *managedObjectContext;
}

+(CoreDataFunction *) sharedInstance;
//-(void)insertUserInfo:(NSDictionary*)dictionary;
//-(UserInfo *)getUserProfileModel:(NSString*)userId;

@end
