//
//  SWAppDelegate.m
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "SWAppDelegate.h"
#import "MKiCloudSync.h"

@import EventKit;
@implementation SWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];

    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        NSLog(@"%d          %@",granted,error);
        
        if (granted) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

            NSArray *calendars = [eventStore calendarsForEntityType:EKEntityTypeReminder];
            NSArray *storedKeys = [[defaults objectForKey:@"calendarIDs"] copy];

            NSMutableArray *workingArray = nil;

            if (storedKeys) {
                workingArray = [NSMutableArray arrayWithArray:storedKeys];
            }else{
                workingArray = [NSMutableArray new];
            }

            for (EKCalendar *calendar in calendars) {
                if (![workingArray containsObject:calendar.calendarIdentifier]) {
                    [workingArray addObject:calendar.calendarIdentifier];
                }
            }

            for (NSString *calendarID in [workingArray copy]) {
                if (![eventStore calendarWithIdentifier:calendarID]) {
                    [workingArray removeObject:calendarID];

                    if ([defaults objectForKey:calendarID]) {
                        [defaults removeObjectForKey:calendarID];
                    }
                }
            }

            [defaults setObject:[workingArray copy] forKey:@"calendarIDs"];
            [defaults synchronize];
            NSLog(@"%@",[defaults dictionaryRepresentation]);
        }
    }];

    [MKiCloudSync start];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
