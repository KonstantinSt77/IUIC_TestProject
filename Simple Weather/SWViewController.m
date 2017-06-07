//
//  SWViewController.m
//  Simple Weather
//
//  Created by Kostya on 05.06.17.
//  Copyright © 2017 Stolyarenko K.S. All rights reserved.
//

#import "SWViewController.h"
#import "SWTableViewController.h"
#import "SWMainViewController.h"
#import "Reachability.h"
static NSString *const countries = @"https://raw.githubusercontent.com/David-Haim/CountriesToCitiesJSON/master/countriesToCities.json";

@interface SWViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray *myArray;
@property (weak, nonatomic) IBOutlet UIPickerView *pik;
@property (weak, nonatomic) NSString *stri;
@property (weak, nonatomic) NSString *city;
@property (weak, nonatomic) IBOutlet UILabel *internetInfo;
@property Reachability* internetReachable;
@property Reachability* hostReachable;
@end

@implementation SWViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pik.delegate = self;
    self.pik.dataSource = self;
    [self doSomethingWithTheJson];
}

-(void) viewWillAppear:(BOOL)animated
{
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    _internetReachable = [Reachability reachabilityForInternetConnection];
    [_internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    _hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [_hostReachable startNotifier];
    
    [super viewWillAppear:self];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:self];
}


-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [_internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            self.internetInfo.text = @"Нет подключения к сети";
            NSLog(@"The internet is down.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Нет подключения к сети"
                                                            message:@"В данный момент, Ваше устройство не подключено к сети интернет."
                                                           delegate:self
                                                  cancelButtonTitle:@"Хорошо."
                                                  otherButtonTitles:nil];
            [alert show];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetInfo.text = @"Подключено через WIFI";
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetInfo.text = @"Подключено через 3G";
            break;
        }
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSString *userCityName = textField.text;
    userCityName = [userCityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     // userCityName = [userCityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    //userCityName = [userCityName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.city = @"";
    self.city = userCityName;
    
  
    
    NSLog(@"Отправленный из StartVC= %@",self.city);
    
    [self performSegueWithIdentifier:@"start1" sender:self.city];
    
  
    
    textField.text = nil;
    return YES;
}


- (void)doSomethingWithTheJson
{
    
    NSDictionary *dict = [self JSONFromFile];
    
    self.myArray = [NSMutableArray array];
    
    for (NSString *countries in dict) {
        [self.myArray addObject:countries];
    }
    
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countriesToCities" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.myArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.myArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.stri = [self.myArray objectAtIndex:row];
    
    NSLog(@"Выбранный и отправленный = %@",self.stri);
    
    [self performSegueWithIdentifier:@"start" sender:self.stri];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"start"])
    {
        SWTableViewController *nextVC = [segue destinationViewController];
        nextVC.passNumber = self.stri;
    }
    
    if([[segue identifier] isEqualToString:@"start1"])
    {
    
        SWMainViewController *nextVC1 = [segue destinationViewController];
        nextVC1.passCity = self.city;
    }
    
    
}



@end