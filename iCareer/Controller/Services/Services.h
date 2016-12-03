//
//  Services.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 27/11/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Services : NSObject
+ (instancetype)sharedInstance;
- (void)servicePOSTWithPath:(NSString*)path withParam:(NSDictionary*)params success:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
-(void)servicePOSTMultipartWithPath:(NSString *)urlPath withParam:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
@end
