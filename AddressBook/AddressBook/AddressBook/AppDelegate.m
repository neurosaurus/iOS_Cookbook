//
//  AppDelegate.m
//  AddressBook
//
//  Created by Tripta Gupta on 4/20/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>

NSString *const kDenied = @"Acces to address book is denied";
NSString *const kRestricted = @"Acces to address book is restricted";

ABAddressBookRef addressBook;

@implementation AppDelegate

- (void)displayMessage:(NSString *)paramMessage{
    [[[UIAlertView alloc] initWithTitle:nil
                                message:paramMessage
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CFErrorRef error = NULL;
    
    switch (ABAddressBookGetAuthorizationStatus()){
    case kABAuthorizationStatusAuthorized:{
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        /*Do you work and once you are finished*/
        if (addressBook != NULL) {
            CFRelease(addressBook);
        }
        break;
    }
    //The user has explicitly denied your app from having access to the address book
    case kABAuthorizationStatusDenied:
    {
        [self displayMessage:kDenied];
        break;
    }
    //The user has not yet decided whether they would like to grant access to your app
    case kABAuthorizationStatusNotDetermined:
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
        {
            if (granted){
                NSLog(@"Access was granted");
            } else {
                NSLog(@"Access was not granted");
            }
            if (addressBook != NULL){
                CFRelease(addressBook);
            }
        });
        break;
    }
    case kABAuthorizationStatusRestricted:
        {
            [self displayMessage:kRestricted];
            break;
        }
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
