//
//  AppDelegate.m
//  iCareer
//
//  Created by Hitesh Kumar Singh on 27/11/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "AppDelegate.h"
#import <MFSideMenu/MFSideMenuContainerViewController.h>
#import "MFSideMenuVC.h"
#import "SideMenuVC.h"
#import "AppHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (![[AppHelper userDefaultsDictionary:@"user"] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsDictionary:@"user"]) {
        [self setupSideMenu];
    }
    
    return YES;
}
#pragma mark - getAppdelegate
+ (AppDelegate*)getAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"iCareer"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    //NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
#pragma mark - setupSideMenu
-(void)setupSideMenu{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
     
    SideMenuVC *leftSideMenuViewController = (SideMenuVC*)[storyboard instantiateViewControllerWithIdentifier:@"SideMenuVC"];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navController"];

     MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
     containerWithCenterViewController:navigationController
     leftMenuViewController:leftSideMenuViewController
     rightMenuViewController:nil];
     self.window.rootViewController = container;
     [self.window makeKeyAndVisible];
    
}
-(void)logout{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    
    self.window.rootViewController = navigationController;
}
@end
