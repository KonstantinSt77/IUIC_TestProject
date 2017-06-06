//
//  SWMapViewController.h
//  Simple Weather
//
//  Created by Kostya on 05.06.17.
//  Copyright © 2017 Stolyarenko K.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AFNetworking.h"
#import "SWMainViewController.h"

@protocol MyMapProtocol
-(void)didSelectLocation:(CLLocationCoordinate2D)location;
@end

@interface SWMapViewController : UIViewController
@property (nonatomic, weak) id <MyMapProtocol> delegate;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *mapPassCity;
@property (nonatomic, assign) CLLocationCoordinate2D mapCoordinateForCity;
@end
