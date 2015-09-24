//
//  ViewController.m
//  NotifactionDemo
//
//  Created by mao on 9/18/15.
//  Copyright (c) 2015 Maokebing. All rights reserved.
//

#import "ViewController.h"
#import "MFNotification.h"

@interface MyObj : NSObject

@end

@implementation MyObj

- (void)dealloc{
	NSLog(@"%s", __FUNCTION__);
}

@end

@interface ViewController ()
@property (nonatomic, weak) id observer;
@property (nonatomic, strong) NSNotificationCenter* notificationCenter;
@end

@implementation ViewController

- (instancetype)init
{
	self = [super init];
	if (self) {
		_notificationCenter  = [[NSNotificationCenter alloc] init];
	}
	return self;
}

- (void)dealloc {
	NSLog(@"%s", __FUNCTION__);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.bounds = CGRectMake(0, 0, 300, 100);
	button.center = self.view.center;
	button.backgroundColor = [UIColor lightGrayColor];
	[button addTarget:self action:@selector(postNotification) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"PostNotifation" forState:UIControlStateNormal];
	[self.view addSubview:button];
	
//	NSLog(@"+++:navigationController:%p", self.navigationController);
	
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"TestNotifaction" object:nil];

	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification1:) name:@"TestNotifaction" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification2:) name:@"TestNotifaction" object:nil];
	
//	NSOperationQueue* queue = [[NSOperationQueue alloc] init];
//	NSOperationQueue* queue = [NSOperationQueue mainQueue];
//	id observer =  [[NSNotificationCenter defaultCenter] addObserverForName:@"TestNotifaction" object:nil queue:queue usingBlock:^(NSNotification *note) {
//		NSLog(@"Rev  Notification:%@, inThread:%p", note, [NSThread currentThread]);
//		
//		NSLog(@"observer:%p", self.observer);
//	}];
//	
//	[[NSNotificationCenter defaultCenter] removeObserver:observer];
//
//	NSLog(@"observer:%p", observer);
//	NSLog(@"self:%p", self);
//	self.observer = observer;
//	
////	[[NSNotificationCenter defaultCenter] removeObserver:observer];
//	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
//	[self.notificationCenter addObserver:self selector:@selector(receivedNotification1:) name:nil object:nil];

	[[MFNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"TestNotifaction" object:nil];
}

- (void)postNotification{
//	NSLog(@"MainThread:%p", [NSThread mainThread]);
//	NSLog(@"Post InThread:%p", [NSThread currentThread]);
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotifaction" object:nil];


	
//	MyObj* obj = [[MyObj alloc] init];
//	NSNotification* notifaction = [NSNotification notificationWithName:@"TestNotifaction" object:nil];
//	NSLog(@"Post Notification:%@, inThread:%p", notifaction, [NSThread currentThread]);

//	[[NSNotificationCenter defaultCenter] postNotification:notifaction];
//	[self.notificationCenter postNotification:notifaction];
	[[MFNotificationCenter defaultCenter] postNotificationName:@"TestNotifaction" object:@"123"];
}

- (void)postNotificationInThread {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		[self postNotification];
	});
}

- (void)receivedNotification:(MFNotification *)notifaction {
	NSLog(@"Rev  Notification:%@, inThread:%p", notifaction, [NSThread currentThread]);
}

- (void)receivedNotification1:(NSNotification *)notifaction {
	NSLog(@"Rev  Notification:%@, inThread:%p", notifaction, [NSThread currentThread]);
//	NSString* name = notifaction.name;
//	id object = notifaction.object;
//	NSDictionary* userInfo = notifaction.userInfo;
	
}

- (void)receivedNotification2:(NSNotification *)notifaction {
	NSLog(@"Rev  Notification:%@, inThread:%p", notifaction, [NSThread currentThread]);
}


@end
