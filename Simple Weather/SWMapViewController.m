//
//  SWMapViewController.m
//  Simple Weather
//
//  Created by Kostya on 05.06.17.
//  Copyright © 2017 Stolyarenko K.S. All rights reserved.
//
#import "SWMapViewController.h"

@interface SWMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
@end

@implementation SWMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocationCoordinate2D mapCoordinate111;
    mapCoordinate111.latitude = 42;
    mapCoordinate111.longitude = 32;
    [self showWeather:mapCoordinate111];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annView=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (annView==nil) {
        annView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    }
    
    annView.canShowCallout = YES;
    UIImage *image = [UIImage imageNamed:@"Bsun-1"];
    annView.image = image;
    [annView setFrame:CGRectMake(0, 0, 50, 50)];
    annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annView.centerOffset = CGPointMake(0,-25);
    return annView;
}

//- (IBAction)tapMap:(UILongPressGestureRecognizer *)sender {
//
//        if (sender.state == UIGestureRecognizerStateEnded)
//        {
//            CGPoint point = [sender locationInView:self.mapView];
//            CLLocationCoordinate2D mapCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
//            
//            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//            annotation.coordinate = mapCoordinate;
//            annotation.title = @"New point";
//            annotation.subtitle = @"information";
//            [self.mapView addAnnotation:annotation];
//            [self.delegate didSelectLocation:mapCoordinate];
//        }
//        else if (sender.state == UIGestureRecognizerStateBegan)
//        {
//
//        }
//}

- (void)showWeather:(CLLocationCoordinate2D)mapCoordinate
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:mapCoordinate];
    [annotation setTitle:self.mapPassCity]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
}

@end
