//
//  CLBaseNotificationRegistry.h
//  Cooleaf
//
//  Created by Haider Khan on 8/26/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBus.h"
#import "CLNotificationSubscriber.h"

@interface CLBaseNotificationRegistry : NSObject

@property (nonatomic, strong) CLBus *eventBus;
@property (nonatomic, strong, retain) NSMutableArray *defaultNotificationSubscribers;
@property (nonatomic, strong, retain) NSMapTable *notificationSubscribers;

+ (CLBaseNotificationRegistry *)getInstance;
- (void)registerDefaultSubscribers;
- (void)unregisterDefaultSubscribers;
- (void)registerSubscriber:(id<CLNotificationSubscriber>)subscriber;
- (void)unregisterSubscriber:(NSObject *)subscriber;
- (NSMutableArray *)createDefaultSubscribers;

@end