//
//  AppDelegate.m
//  LittleBook
//
//  Created by hupeng on 15/3/1.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil]];
    }
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:notification.alertBody
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:notification.alertAction, nil];
    
    [alert show];
    // play sound
}

@end
