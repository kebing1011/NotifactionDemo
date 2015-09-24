//
//  MFNotification.m
//  NotifactionDemo
//
//  Created by mao on 9/18/15.
//  Copyright (c) 2015 Maokebing. All rights reserved.
//

#import "MFNotification.h"

@implementation MFNotification

- (instancetype)initWithName:(NSString *)aName
					  object:(id)object
					userInfo:(NSDictionary *)userInfo {
	self = [super init];
	if (self) {
		_name = aName;
		_object = object;
		_userInfo = userInfo;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p, name:%@, object:%@, userInfo:%@>", [self class], self, self.name, self.object, self.userInfo];
}

@end

@interface MFCallbackObject : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic, strong)id object;
@end

@implementation MFCallbackObject
@end


@interface MFNotificationCenter() {
	NSMutableArray* _Callbacks;
	NSRecursiveLock* _lock;
}

@end


@implementation MFNotificationCenter

#pragma mark - Class Methods

+ (MFNotificationCenter *)defaultCenter {
	static MFNotificationCenter* center = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		center = [[MFNotificationCenter alloc] init];
	});
	return center;
}

#pragma mark - Lifecycle

- (instancetype)init
{
	self = [super init];
	if (self) {
		_Callbacks = [NSMutableArray array];
		_lock = [[NSRecursiveLock alloc] init];
	}
	return self;
}

- (void)dealloc {
	
}

#pragma mark - Public Methods

- (void)addObserver:(id)observer
		   selector:(SEL)aSelector
			   name:(NSString *)aName
			 object:(id)anObject {
	[_lock lock];
	
	MFCallbackObject* callbackObj = [MFCallbackObject new];
	callbackObj.name = aName;
	callbackObj.target = observer;
	callbackObj.action = aSelector;
	callbackObj.object = anObject;
	
	[_Callbacks addObject:callbackObj];
	
	[_lock unlock];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject {
	[_lock lock];

	[self postNotificationName:aName object:anObject userInfo:nil];
	
	[_lock unlock];
}
- (void)postNotificationName:(NSString *)aName
					  object:(id)anObject
					userInfo:(NSDictionary *)aUserInfo {
	[_lock lock];

	
	MFNotification* noto = [[MFNotification alloc] initWithName:aName object:anObject userInfo:aUserInfo];
	[self postNotification:noto];
	
	[_lock unlock];
}

//按observer取消注册
- (void)removeObserver:(id)observer {
	[_lock lock];

	NSArray* callbacks = [_Callbacks copy];
	for (MFCallbackObject* callbackObj in callbacks) {
		if (callbackObj.target == observer) {
			[_Callbacks removeObject:callbackObj];
		}
	}
	
	[_lock unlock];
}

//按条件取消注册
- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject {
	[_lock lock];

	NSArray* callbacks = [_Callbacks copy];
	for (MFCallbackObject* callbackObj in callbacks) {
		if (callbackObj.target == observer
			&& [callbackObj.name isEqualToString:aName]
			&& [callbackObj.object isEqual:anObject]) {
			[_Callbacks removeObject:callbackObj];
		}
	}
	
	[_lock unlock];
}

- (void)postNotification:(MFNotification *)notification {
	[_lock lock];
	
	for (MFCallbackObject* callbackObj in _Callbacks) {
		
		//按条件分发通知
		if ([notification.name isEqualToString:callbackObj.name]
			&& [notification.object isEqual:callbackObj.object]) {
			[self dispathNotifactionWithTarget:callbackObj.target action:callbackObj.action object:notification];
			continue;
		}
		
		if ([notification.object isEqual:callbackObj.object]) {
			[self dispathNotifactionWithTarget:callbackObj.target action:callbackObj.action object:notification];
			continue;
		}
		
		if ([notification.name isEqualToString:callbackObj.name]) {
			[self dispathNotifactionWithTarget:callbackObj.target action:callbackObj.action object:notification];
			continue;
		}
		
		[self dispathNotifactionWithTarget:callbackObj.target action:callbackObj.action object:notification];
	}
	
	[_lock unlock];
}

#pragma mark Private Methods

- (void)dispathNotifactionWithTarget:(id)target action:(SEL)action object:(id)object {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[target performSelector:action withObject:object];
#pragma clang diagnostic pop
}



@end
