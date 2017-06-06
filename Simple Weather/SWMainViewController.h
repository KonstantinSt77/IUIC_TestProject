//
//  ViewController.h
//  Simple Weather
//
//  Created by Kostya on 05.06.17.
//  Copyright © 2017 Stolyarenko K.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SWMapViewController.h"
#import "AFNetworking.h"
@interface SWMainViewController : UIViewController
@property (strong, nonatomic) NSString *passCity;
@property (nonatomic, assign) CLLocationCoordinate2D ServerMapCoordinateForCity;
@end

