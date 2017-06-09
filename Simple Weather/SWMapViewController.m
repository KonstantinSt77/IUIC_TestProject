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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showWeather:self.mapCoordinateForCity];
    [self.mapView setCenterCoordinate:self.mapCoordinateForCity animated:YES];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mapCoordinateForCity, 800000, 800000);
    [self.mapView setRegion:viewRegion];
    viewRegion.center = self.mapCoordinateForCity;
    [self.mapView setRegion:viewRegion animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annView=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (annView==nil) {
        annView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    }
    CGRect rect = CGRectMake(0,0, 50, 50);
    annView.canShowCallout = YES;
    UIImage *image = [UIImage imageNamed:self.imageName];
    annView.image = image;
    [annView setFrame:rect];
    annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annView.centerOffset = CGPointMake(0, -50 / 2);
    return annView;
}

- (IBAction)tapMap:(UILongPressGestureRecognizer *)sender {}

- (void)showWeather:(CLLocationCoordinate2D)mapCoordinate
{
    NSString *userCityName = @"";
    userCityName = self.mapPassCity;
    userCityName = [userCityName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Полученный на карте %@",userCityName);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:mapCoordinate];
    [annotation setTitle:userCityName]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
}

@end
