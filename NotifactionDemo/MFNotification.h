//
//  MFNotification.h
//  NotifactionDemo
//
//  Created by mao on 9/18/15.
//  Copyright (c) 2015 Maokebing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFNotification : NSObject

@property (readonly, copy) NSString *name;
@property (readonly, strong) id object;
@property (readonly, copy) NSDictionary *userInfo;

- (instancetype)initWithName:(NSString *)aName object:(id)object userInfo:(NSDictionary *)userInfo;

@end

@interface MFNotificationCenter : NSObject

+ (MFNotificationCenter *)defaultCenter;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;

- (void)postNotification:(MFNotification *)notification;
- (void)postNotificationName:(NSString *)aName object:(id)anObject;
- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject;

@end
