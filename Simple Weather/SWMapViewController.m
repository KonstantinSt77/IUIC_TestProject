//
//  SWMapViewController.m
//  Simple Weather
//
//  Created by Kostya on 05.06.17.
//  Copyright © 2017 Stolyarenko K.S. All rights reserved.
//
#import "SWMapViewController.h"
//@import Mapbox;
@interface SWMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
@end

@implementation SWMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    //
//    NSURL *styleURL = [MGLStyle lightStyleURLWithVersion:9];
//    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:styleURL];
//    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    mapView.tintColor = [UIColor darkGrayColor];
//    
//    // Set the map‘s bounds to Pisa, Italy.
//    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(
//                                                         CLLocationCoordinate2DMake(43.7115, 10.3725),
//                                                         CLLocationCoordinate2DMake(43.7318, 10.4222));
//    [mapView setVisibleCoordinateBounds:bounds];
//    
//    [self.view addSubview:mapView];
//    
//    // Set the map view‘s delegate property.
//    mapView.delegate = self;
//    
//    // Initialize and add the point annotation.
//    MGLPointAnnotation *pisa = [[MGLPointAnnotation alloc] init];
//    pisa.coordinate = CLLocationCoordinate2DMake(43.723, 10.396633);
//    pisa.title = @"Leaning Tower of Pisa";
//    [mapView addAnnotation:pisa];
//    //
//    
    
    
    
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annView=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (annView==nil) {
        annView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    }
    annView.canShowCallout = YES;
    UIImage *image = [UIImage imageNamed:@"pin2"];
    annView.image = image;
    [annView setFrame:CGRectMake(0, 0, 50, 50)];
    annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annView.centerOffset = CGPointMake(0,-25);//image.size.width /2, -image.size.height /2
    return annView;
}

- (IBAction)tapMap:(UILongPressGestureRecognizer *)sender {

        if (sender.state == UIGestureRecognizerStateEnded)
        {
            CGPoint point = [sender locationInView:self.mapView];
            CLLocationCoordinate2D mapCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = mapCoordinate;
            annotation.title = @"New point";
            annotation.subtitle = @"information";
            [self.mapView addAnnotation:annotation];
            [self.delegate didSelectLocation:mapCoordinate];
        }
        else if (sender.state == UIGestureRecognizerStateBegan)
        {

        }
}
@end
