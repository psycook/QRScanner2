//
//  AppDelegate.m
//  QRScanner2
//
//  Created by Simon Cook on 10/11/2015.
//  Copyright © 2015 Simon Cook. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation AppDelegate

@synthesize offersArray, offersDictionary;

static NSString * const purpleBeaconUUID  = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
static NSString * const blueBeaconUUID    = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
static NSString * const greenBeaconUUID   = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
static NSString * const virtualBeaconUUID = @"8492E75F-4FD6-469D-B132-043FE94921D8";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.offersDictionary = [[NSMutableDictionary alloc] init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //remove existing regions
    for (CLRegion *monitored in [_locationManager monitoredRegions])
        [_locationManager stopMonitoringForRegion:monitored];
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
                                                        initWithUUIDString:purpleBeaconUUID]
                                                                     major:12538
                                                                     minor:61339
                                                                identifier:@"Wholemeal Rice"];
    CLBeaconRegion *region2 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
                                                                             initWithUUIDString:blueBeaconUUID]
                                                                      major:50825
                                                                      minor:27804
                                                                 identifier:@"Red Chillies"];
    CLBeaconRegion *region3 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
                                                                             initWithUUIDString:greenBeaconUUID]
                                                                      major:48074
                                                                      minor:47114
                                                                 identifier:@"Sausages"];
    CLBeaconRegion *region4 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
                                                                             initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"]
                                                                      major:10374
                                                                      minor:24794
                                                                 identifier:@"Fennel Seeds"];

    [self.locationManager startRangingBeaconsInRegion:region1];
    [self.locationManager startRangingBeaconsInRegion:region2];
    [self.locationManager startRangingBeaconsInRegion:region3];
    [self.locationManager startRangingBeaconsInRegion:region4];
    NSLog(@"Monitoring Beacons");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Beacon Delegate Methods
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    NSLog(@"Did Enter Region %@", [region identifier]);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Did Fail With Error %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
    NSLog(@"Did Exit Region %@", [region identifier]);
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    NSString *regionID = region.identifier;

    if ([beacons count] > 0) {
        CLBeacon *beacon = [beacons firstObject];
        if(beacon.proximity == CLProximityNear) {
            if([offersDictionary objectForKey:regionID] == nil) {
                [offersDictionary setValue:regionID forKey:regionID];
                offersArray = [offersDictionary allValues];
                NSLog(@"Added Offer %@, there are %d offers", regionID, (int)[offersDictionary count]);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
            }
        }
    }
}

@end
