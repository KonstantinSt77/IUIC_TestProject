//
//  SWTableViewController.m
//  Simple Weather
//
//  Created by Kostya on 05.06.17.
//  Copyright © 2017 Stolyarenko K.S. All rights reserved.
//

#import "SWTableViewController.h"
#import "SWMainViewController.h"

@interface SWTableViewController ()
@property (strong, nonatomic) NSMutableArray *myArray2;
@property (strong, nonatomic) NSString *myString;
@property (weak, nonatomic) NSString *CityName;
@end

@implementation SWTableViewController



- (void)viewDidLoad
{
    NSLog(@"Полученный от picker- %@",self.passNumber);
    [super viewDidLoad];
    [self doSomethingWithTheJson];
    
}


- (void)doSomethingWithTheJson
{
    
    NSDictionary *dict = [self JSONFromFile];
    
    self.myArray2 = [dict objectForKey:self.passNumber];
    
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countriesToCities" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myArray2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //Поиск ячейки
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Если ячейка не найдена
    if (cell == nil) {
        //Создание ячейки
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.myArray2 objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    NSString *userCityName = [self.myArray2 objectAtIndex:indexPath.row];
    userCityName = [userCityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.CityName = userCityName;
    
    NSLog(@"Выбранный и отправленный через таблицу= %@",userCityName);
    
    [self performSegueWithIdentifier:@"start2" sender:userCityName];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"start2"])
    {
        SWMainViewController *nextVC1 = [segue destinationViewController];
        nextVC1.passCity = self.CityName ;
    }
    
    
}

@end

