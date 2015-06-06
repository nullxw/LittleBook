//
//  AppDelegate.m
//  LittleBook
//
//  Created by hupeng on 15/3/1.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AppDelegate.h"
#import "LBAudioManager.h"
#import "LBGuideManager.h"
#import "LBTaskCenter.h"

@interface AppDelegate ()
{
    BOOL _activeFormBackGround;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil]];
    }

    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    [[LBTaskCenter defaultCenter] registerAppTasks];
    
    if ([[LBTaskCenter defaultCenter] completeTask:LB_GUIDE_FILE_IMPORT_TASK_KEY]) {
        [[[LBGuideManager alloc] init] importGuideInfo];
    }
    
    
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
    _activeFormBackGround = TRUE;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    _activeFormBackGround = FALSE;
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
    
    if (!_activeFormBackGround) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:notification.alertBody
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:notification.alertAction, nil];
        
        [alert show];
        
        [[[LBAudioManager alloc] init] playSystemSound:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"]];
    }
}

@end
