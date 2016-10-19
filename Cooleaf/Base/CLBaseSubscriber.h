//
//  CLBaseSubscriber.h
//  Cooleaf
//
//  Created by Haider Khan on 8/26/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBus.h"
#import "CLNotificationSubscriber.h"

@interface CLBaseSubscriber : NSObject <CLNotificationSubscriber>

@property (nonatomic) CLBus *eventBus;

- (id<NSObject>)registerOnBus:(CLBus *)eventBus;
- (void)unregisterOnBus:(CLBus *)eventBus;
- (void)post:(id<NSObject>)event;

@end