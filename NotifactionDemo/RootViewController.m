//
//  RootViewController.m
//  NotifactionDemo
//
//  Created by mao on 9/18/15.
//  Copyright (c) 2015 Maokebing. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "MFNotification.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"Notification";
	
	
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.bounds = CGRectMake(0, 0, 300, 100);
	button.center = CGPointMake(self.view.center.x, self.view.center.y - 75.0f);
	button.backgroundColor = [UIColor lightGrayColor];
	[button addTarget:self action:@selector(pushPage) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"Push Page for Test" forState:UIControlStateNormal];
	[self.view addSubview:button];
	
	UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button2.bounds = CGRectMake(0, 0, 300, 100);
	button2.center = CGPointMake(self.view.center.x, self.view.center.y + 75.0f);
	button2.backgroundColor = [UIColor lightGrayColor];
	[button2 addTarget:self action:@selector(pushNotifaction) forControlEvents:UIControlEventTouchUpInside];
	[button2 setTitle:@"Push Notifaction" forState:UIControlStateNormal];
	[self.view addSubview:button2];
	
	[[MFNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification1:) name:@"TestNotifaction" object:nil];
}

- (void)receivedNotification1:(NSNotification *)notifaction {
	NSLog(@"Rev  Notification:%@, isMainThread:%d", notifaction, [NSThread isMainThread]);
}

- (void)pushPage {
	ViewController* vc = [ViewController new];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)pushNotifaction {
	[[MFNotificationCenter defaultCenter] postNotificationName:@"TestNotifaction" object:nil];
}

@end
