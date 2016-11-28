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
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:urlPath parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSError *error = nil;
        //NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                          //     error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"%@",json);
        if (![json isKindOfClass:[NSNull class]] && json) {
            success(json);
        }
    }
    failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}
@end
