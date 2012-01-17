//
//  mAAppDelegate.m
//  miniAudicle iOS
//
//  Created by Spencer Salazar on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "mAAppDelegate.h"

#import "mAMasterViewController.h"
#import "mADetailViewController.h"

#import "mAChucKController.h"
#import "miniAudicle.h"


NSString * const kmAUserDefaultsSelectedScript = @"mAUserDefaultsSelectedScript";


@interface mAAppDelegate ()

@property (strong, nonatomic) mAMasterViewController * masterViewController;
@property (strong, nonatomic) mADetailViewController * detailViewController;

- (NSMutableArray *)loadScripts;
- (void)saveScripts:(NSArray *)scripts;

@end


@implementation mAAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;
@synthesize masterViewController = _masterViewController, detailViewController = _detailViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [mAChucKController chuckController].ma->start_vm();
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.masterViewController = [[mAMasterViewController alloc] initWithNibName:@"mAMasterViewController_iPhone" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.masterViewController];
        self.window.rootViewController = self.navigationController;
    } else {
        self.masterViewController = [[mAMasterViewController alloc] initWithNibName:@"mAMasterViewController_iPad" bundle:nil];
//        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        self.detailViewController = [[mADetailViewController alloc] initWithNibName:@"mADetailViewController_iPad" bundle:nil];
//        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    	
        self.masterViewController.detailViewController = self.detailViewController;
        self.detailViewController.masterViewController = self.masterViewController;
        
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = self.detailViewController;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.masterViewController, self.detailViewController, nil];
        
        self.window.rootViewController = self.splitViewController;
        
        self.masterViewController.scripts = [self loadScripts];
        
        if([self.masterViewController.scripts count] == 0)
        {
            [self.masterViewController newScript];
        }
        else
        {
            [self.masterViewController selectScript:[[NSUserDefaults standardUserDefaults] integerForKey:kmAUserDefaultsSelectedScript]];
        }
    }    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [[NSUserDefaults standardUserDefaults] setInteger:[self.masterViewController selectedScript]
                                               forKey:kmAUserDefaultsSelectedScript];
    [self saveScripts:self.masterViewController.scripts];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    [[NSUserDefaults standardUserDefaults] setInteger:[self.masterViewController selectedScript]
                                               forKey:kmAUserDefaultsSelectedScript];
    [self saveScripts:self.masterViewController.scripts];
}

- (NSMutableArray *)loadScripts
{
    NSMutableArray * scripts = [NSMutableArray array];
    
    NSString * path = [NSString stringWithFormat:@"%@/scripts.plist", 
                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    NSArray * scripts2 = [NSArray arrayWithContentsOfFile:path];
    
    for(NSDictionary * item in scripts2)
    {
        [scripts addObject:[mADetailItem detailItemFromDictionary:item]];
    }
    
    return scripts;
}

- (void)saveScripts:(NSArray *)scripts
{
    [self.detailViewController saveScript];
    
    NSString * path = [NSString stringWithFormat:@"%@/scripts.plist", 
                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    NSMutableArray * scripts2 = [NSMutableArray array];
    
    for(mADetailItem * item in scripts)
    {
        [scripts2 addObject:[item dictionary]];
    }
    
    [scripts2 writeToFile:path atomically:YES];
}

@end


