//
//  ViewController.m
//  KeyArchiver
//
//  Created by Mr.Yang on 13-7-17.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "ViewController.h"
#import "UserDataModel.h"

@interface ViewController ()

@end

@implementation ViewController

#define USER_DATA_MODEL_NAME  @"UserdataModel"   
- (void)viewDidLoad
{
    [super viewDidLoad];
    UserDataModel *datamodel = [[UserDataModel alloc] init];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:datamodel];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:USER_DATA_MODEL_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];

    data = nil;
    data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DATA_MODEL_NAME];
    datamodel = nil;
    datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"DataModel:%@", datamodel);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
