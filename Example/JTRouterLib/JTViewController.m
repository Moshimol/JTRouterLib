//
//  JTViewController.m
//  JTRouterLib
//
//  Created by lushitong on 07/22/2020.
//  Copyright (c) 2020 lushitong. All rights reserved.
//

#import "JTViewController.h"
#import <JTRouterLib/JTRouter.h>

@interface JTViewController ()

@end

@implementation JTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [JTRouter openURL:@"ciRouter://search/push/SearchVC" parameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
