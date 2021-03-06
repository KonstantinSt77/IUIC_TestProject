//
//  ViewController.m
//  Simple Weather
//
//  Created by Kostya on 05.06.17.
//  Copyright © 2017 Stolyarenko K.S. All rights reserved.
//
#import "SWMainViewController.h"

static NSString *const BasicUrl = @"http://api.openweathermap.org";
static NSString *const WeatherCityNameUrl = @"/data/2.5/weather?q=%@,uk&appid=37e0cb1eed95e56934c68507ca80d49f&mine=true";
static NSString *const UserCityNameUrl1 = @"/data/2.5/weather?lat=%@&lon=%@&appid=37e0cb1eed95e56934c68507ca80d49f";

@interface SWMainViewController ()<UITextFieldDelegate,MyMapProtocol>
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *weatherstatus;
@property (weak, nonatomic) IBOutlet UILabel *pressure;
@property (weak, nonatomic) IBOutlet UILabel *tempmin;
@property (weak, nonatomic) IBOutlet UILabel *tempmax;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *wind;
@property (strong, nonatomic) IBOutlet UIImageView *sun;
@property (strong, nonatomic) IBOutlet UIImageView *rain;
@property (strong, nonatomic) IBOutlet UIImageView *clouds;
@property (strong, nonatomic) IBOutlet UIImageView *snow;
@property (strong, nonatomic) IBOutlet UIImageView *fog;
@property (strong, nonatomic) IBOutlet UIImageView *drizzle;
@property (strong, nonatomic) NSString *passCityWithTemperature;


@end

@implementation SWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    NSString *userCityName = @"";
    userCityName = self.passCity;
    userCityName = [userCityName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.name.text = userCityName;
     NSLog(@"Полученный на основную форму %@",self.name.text);
    [super viewDidLoad];
    [self search];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showMap"])
    {
        SWMapViewController *mapVC = [segue destinationViewController];
        mapVC.mapPassCity = self.passCityWithTemperature;
        mapVC.mapCoordinateForCity = self.ServerMapCoordinateForCity;
        mapVC.imageName = self.mainImageName;
        NSLog(@"координаты на отправление lat = %f lon = %f",self.ServerMapCoordinateForCity.latitude,self.ServerMapCoordinateForCity.longitude);
    }
    else
    {
        [segue.destinationViewController setDelegate:self];
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)search
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [BasicUrl stringByAppendingString:WeatherCityNameUrl];
    urlString = [NSString stringWithFormat:urlString, self.passCity];
    NSURL *url = [NSURL URLWithString:urlString];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *json = responseObject;
    [self configurationScreenWithDictionary:json];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Обрыв связи"
                                                        message:@"Произошел сбой во время выполнения запроса"
                                                       delegate:self
                                              cancelButtonTitle:@"Хорошо."
                                              otherButtonTitles:nil];
         [alert show];
    }];
}

#pragma Mark Map
-(void)didSelectLocation:(CLLocationCoordinate2D)location{
                //get coordinates
                NSString* latt = [NSString stringWithFormat:@"%f", location.latitude];
                NSString* longg = [NSString stringWithFormat:@"%f", location.longitude];
                NSLog(@"Location found from Map %@ %@",latt,longg);
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
                NSString *urlString = [BasicUrl stringByAppendingString:UserCityNameUrl1];
                urlString = [NSString stringWithFormat:urlString, latt,longg];
                NSURL *url = [NSURL URLWithString:urlString];
                [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSDictionary *json = responseObject;
                    [self configurationScreenWithDictionary:json];
                    [self.navigationController popViewControllerAnimated:YES];
    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
}
#pragma mark parsing data by name of the city
- (void)configurationScreenWithDictionary:(NSDictionary *)weatherDictionary {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *nameCity = weatherDictionary[@"name"];
        self.cityNameLabel.text = nameCity;
        
        NSDictionary *coordDictionary = weatherDictionary[@"coord"];
     
        NSString *coordLatString = coordDictionary[@"lat"];
        NSString *coordLonString = coordDictionary[@"lon"];
        
        NSLog(@"координаты от сервера в строке lat = %@ lon = %@",coordLatString,coordLonString);
        
        double coordLon = [coordLonString doubleValue];
        double coordLat = [coordLatString doubleValue];
        
        NSLog(@"координаты от сервера в инте lat = %ld lon = %ld",(long)coordLat,(long)coordLon);
        
        CLLocationCoordinate2D a;
        a.longitude = coordLon;
        a.latitude = coordLat;
        self.ServerMapCoordinateForCity = a;
        
        NSDictionary *mainDictionary = weatherDictionary[@"main"];
        
        NSString *temperatureString = mainDictionary[@"temp"];
        NSInteger temp = [temperatureString integerValue];
        self.temperatureLabel.text = [@(temp - 273) description];
        
        
        NSString *temperatureMINString = mainDictionary[@"temp_min"];
        NSInteger tempMIN = [temperatureMINString integerValue];
        self.tempmin.text = [@(tempMIN - 273) description];
        
        
        NSString *temperatureMAXString = mainDictionary[@"temp_max"];
        NSInteger tempmax = [temperatureMAXString integerValue];
        self.tempmax.text = [@(tempmax - 273) description];
        
        NSString *pressureString = mainDictionary[@"pressure"];
        NSInteger pressure = [pressureString integerValue];
        self.pressure.text = [@(pressure) description];
        
        
        NSString *humidityString = mainDictionary[@"humidity"];
        NSInteger humidity = [humidityString integerValue];
        self.humidity.text = [@(humidity) description];
        
        NSDictionary *windDictionary = weatherDictionary[@"wind"];
        NSString *windString = windDictionary[@"speed"];
        NSInteger wind = [windString integerValue];
        NSLog(@"%li",(long)wind);
        self.wind.text = [@(wind) description];
        
        NSArray *statusesWeather = weatherDictionary[@"weather"];
        NSDictionary *status = statusesWeather[0];
        NSString *weatherstatusString = status[@"main"];
        self.weatherstatus.text = weatherstatusString;
        
        self.passCityWithTemperature = [NSString stringWithFormat:@"%@ %@%@", self.passCity, self.temperatureLabel.text, @"°C"];
        
        //configurate images
        if ([weatherstatusString isEqualToString:@"Clouds"])
        {
            self.clouds.hidden = NO;
            self.sun.hidden = YES;
            self.fog.hidden = YES;
            self.snow.hidden = YES;
            self.rain.hidden = YES;
            self.drizzle.hidden = YES;
            self.mainImageName = @"Bclouds-1";
        }
        else if ([weatherstatusString isEqualToString:@"Sun"]||[weatherstatusString isEqualToString:@"Clear"])
        {
            self.sun.hidden = NO;
            self.clouds.hidden = YES;
            self.fog.hidden = YES;
            self.snow.hidden = YES;
            self.rain.hidden = YES;
            self.drizzle.hidden = YES;
            self.mainImageName = @"Bsun-1";
        }
        else if ([weatherstatusString isEqualToString:@"Rain"])
        {
            self.sun.hidden = YES;
            self.rain.hidden = NO;
            self.clouds.hidden = YES;
            self.fog.hidden = YES;
            self.snow.hidden = YES;
            self.drizzle.hidden = YES;
            self.mainImageName = @"Brain-1";
        }
        else if ([weatherstatusString isEqualToString:@"Snow"])
        {
            self.sun.hidden = YES;
            self.snow.hidden = NO;
            self.clouds.hidden = YES;
            self.fog.hidden = YES;
            self.rain.hidden = YES;
            self.drizzle.hidden = YES;
            self.mainImageName = @"Bsnow-1";
        }
        else if ([weatherstatusString isEqualToString:@"Fog"])
        {
            self.fog.hidden = NO;
            self.clouds.hidden = YES;
            self.sun.hidden = YES;
            self.snow.hidden = YES;
            self.rain.hidden = YES;
            self.drizzle.hidden = YES;
            self.mainImageName = @"BFOG-1";
        }
        else if ([weatherstatusString isEqualToString:@"Drizzle"])
        {
            self.fog.hidden = YES;
            self.clouds.hidden = YES;
            self.sun.hidden = YES;
            self.snow.hidden = YES;
            self.rain.hidden = YES;
            self.drizzle.hidden = NO;
            self.mainImageName = @"Bdrizzle-1";
        }
        else
        {
            self.clouds.hidden = NO;
            self.sun.hidden = YES;
            self.fog.hidden = YES;
            self.snow.hidden = YES;
            self.rain.hidden = YES;
            self.drizzle.hidden = YES;
            self.mainImageName = @"Bclouds-1";
        }
    });
}

@end
