//
//  CLNotificationSubscriber.h
//  Cooleaf
//
//  Created by Haider Khan on 8/26/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

@protocol CLNotificationSubscriber <NSObject>

- (id<NSObject>)registerOnBus:(CLBus *)eventBus;
- (void)unregisterOnBus:(CLBus *)eventBus;

@end