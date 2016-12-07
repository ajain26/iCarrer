//
//  Services.m
//  iCareer
//
//  Created by Hitesh Kumar Singh on 27/11/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "Services.h"
#import "Defines.h"
#import <AFNetworking/AFNetworking.h>
#import "AppHelper.h"

@implementation Services
#pragma mark - sharedInstance
+ (instancetype)sharedInstance{
    static Services *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Services alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
#pragma mark - servicePOSTWithPath
-(void)servicePOSTWithPath:(NSString *)urlPath withParam:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"URL: %@",urlPath);
    NSLog(@"PARAM: %@",params);
    
    [manager POST:urlPath parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"json: %@",json);
        if (![json isKindOfClass:[NSNull class]] && json) {
            
            if ([urlPath containsString:VALIDATEUSER] || [urlPath containsString:USERREGISTRATION]) {
                [self insertUserDetailsToDB:json];
            } else if ([urlPath containsString:SUBMITANSWERS]){
                [self saveMySuitableCareer:json];
            }
            
            success(json);
        } else {
            success(nil);
        }
    }
          failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              failure(error);
          }];
}
-(void)servicePOSTMultipartWithPath:(NSString *)urlPath withParam:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(NSString *aKey in [params allKeys]){
            NSLog(@"Key: %@ - Value: %@",aKey, [params objectForKey:aKey]);
            [formData appendPartWithFormData:[[params objectForKey:aKey] dataUsingEncoding:NSUTF8StringEncoding] name:aKey];
        }
        [formData appendPartWithFormData:[NSData data] name:@"profile_image"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *myString = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
        if (![myString isKindOfClass:[NSNull class]] && myString) {
            NSLog(@"%@",myString);
            
            NSArray *strArray = [myString componentsSeparatedByString:@"}{"];
            NSLog(@"%@",strArray);
            
            id json = nil;
            
            if (![strArray isKindOfClass:[NSNull class]] && strArray) {
                NSString *str0 = [[strArray objectAtIndex:0] stringByAppendingString:@"}"];
                NSLog(@"%@",str0);
                NSData *data = [str0 dataUsingEncoding:NSUTF8StringEncoding];
                
                json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"%@",json);
            }
            
            if (![json isKindOfClass:[NSNull class]] && json) {
                if ([urlPath containsString:USERREGISTRATION]) {
                    [self insertUserDetailsToDB:json];
                }
                success(json);
            } else {
                success(nil);
            }
        }else {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}
#pragma mark - inserUserDetailToDB
-(void)insertUserDetailsToDB:(NSDictionary*)json{
    if (![[json objectForKey:@"response"] isKindOfClass:[NSNull class]] && [json objectForKey:@"response"]) {
        if ([[json objectForKey:@"response"] isKindOfClass:[NSArray class]]) {
            if ([[json objectForKey:@"response"] count] > 0) {
                NSDictionary *user = [[json objectForKey:@"response"] objectAtIndex:0];
                [AppHelper saveToUserDefaults:user withKey:@"user"];
            }
        }
    }
}
#pragma mark - saveMySuitableCareer
-(void)saveMySuitableCareer:(NSDictionary*)json{
    if (![[json objectForKey:@"trait_rating"] isKindOfClass:[NSNull class]] && [json objectForKey:@"trait_rating"]) {
        NSArray *traitRatingArray = [json objectForKey:@"trait_rating"];
        
        NSDictionary *skillDict;
        float maxRate = 0;
        if (traitRatingArray.count > 0) {
            skillDict = [traitRatingArray objectAtIndex:0];
            maxRate = [[skillDict objectForKey:@"rating"] floatValue];
        }
        for (int i = 1; i < traitRatingArray.count; i++){
            NSDictionary *dict = [traitRatingArray objectAtIndex:i];
            float rating = [[dict objectForKey:@"rating"] floatValue];
            
            if (maxRate < rating){
                skillDict = dict;
                maxRate = rating;
            }
        }
        if (![skillDict isKindOfClass:[NSNull class]] && skillDict) {
            [AppHelper saveToUserDefaults:skillDict withKey:@"skill"];
        }
        NSLog(@"%@",[AppHelper userDefaultsDictionary:@"skill"]);
        [AppHelper saveToUserDefaults:json withKey:@"traitRating"];
        NSLog(@"%@",[AppHelper userDefaultsDictionary:@"traitRating"]);
    }
}
#pragma mark - connected
- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
@end
