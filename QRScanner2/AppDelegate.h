//
//  AppDelegate.h
//  QRScanner2
//
//  Created by Simon Cook on 10/11/2015.
//  Copyright © 2015 Simon Cook. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow            *window;
@property (strong, nonatomic) NSMutableDictionary *offersDictionary;
@property (strong, nonatomic) NSArray             *offersArray;

- (void)clearOffers;

@end

