//
//  MapViewController
//  QRScanner2
//
//  Created by Simon Cook on 10/11/2015.
//  Copyright © 2015 Simon Cook. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@end

@implementation MapViewController

#pragma mark Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set the map view delegate
    _myMap.delegate = self;
    
    //Add the stores
    [self addAnnotationWithTitle:@"Sainsburys" andSubTitle:@"Staines-Upon-Thames" atLocation:CLLocationCoordinate2DMake(51.432561, -0.519359)];
    [self addAnnotationWithTitle:@"Sainsburys" andSubTitle:@"Hove Lyons Farm" atLocation:CLLocationCoordinate2DMake(50.836519, -0.364568)];
    [self addAnnotationWithTitle:@"Sainsburys" andSubTitle:@"Brighton New England" atLocation:CLLocationCoordinate2DMake(50.831278, 0.138449)];
    [self addAnnotationWithTitle:@"Sainsburys" andSubTitle:@"Brighton Lewes Road" atLocation:CLLocationCoordinate2DMake(50.837684, -0.12456)];
    [self addAnnotationWithTitle:@"Sainsburys" andSubTitle:@"Brighton West Hove" atLocation:CLLocationCoordinate2DMake(50.842277, 0.205041)];
}

#pragma mark Map related Methods

- (void)addAnnotationWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle atLocation:(CLLocationCoordinate2D)location {
    MKPointAnnotation *store1 = [[MKPointAnnotation alloc] init];
    store1.coordinate = location;
    store1.title = title;
    store1.subtitle = subTitle;
    [_myMap addAnnotation:store1];
}

#pragma mark Memory Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
