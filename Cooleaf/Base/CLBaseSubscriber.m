//
//  CLBaseSubscriber.m
//  Cooleaf
//
//  Created by Haider Khan on 8/26/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLBaseSubscriber.h"

@implementation CLBaseSubscriber

# pragma mark - registerOnBus

- (id<NSObject>)registerOnBus:(CLBus *)eventBus {
    _eventBus = eventBus;
    REGISTER();
    return self;
}

# pragma mark - unregisterOnBus

- (void)unregisterOnBus:(CLBus *)eventBus {
    UNREGISTER();
    _eventBus = nil;
}

# pragma mark - post

- (void)post:(id<NSObject>)event {
    if (event == nil) {
        // Throw an exception
    }
    PUBLISH(event);
}

@end