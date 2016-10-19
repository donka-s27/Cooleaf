//
//  CLBaseNotificationRegistry.m
//  Cooleaf
//
//  Created by Haider Khan on 8/26/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLBaseNotificationRegistry.h"
#import "CLBaseSubscriber.h"
#import "CLAuthenticationSubscriber.h"
#import "CLInterestSubscriber.h"
#import "CLEventSubscriber.h"
#import "CLUserSubscriber.h"
#import "CLSearchSubscriber.h"
#import "CLGroupSubscriber.h"
#import "CLFeedSubscriber.h"
#import "CLCommentSubscriber.h"
#import "CLParticipantSubscriber.h"
#import "CLRegistrationSubscriber.h"
#import "CLFilePreviewsSubscriber.h"

@implementation CLBaseNotificationRegistry

# pragma mark - init

- (id)init {
    _eventBus = [CLBus sharedInstance];
    _defaultNotificationSubscribers = [NSMutableArray array];
    _notificationSubscribers = [[NSMapTable alloc] init];
    _notificationSubscribers = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                     valueOptions:NSMapTableWeakMemory];
    return self;
}

# pragma mark - Singleton

+ (CLBaseNotificationRegistry *)getInstance {
    // Create a singleton instance of the registry on application startup
    static CLBaseNotificationRegistry *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

# pragma mark - registerDefaultSubscribers

- (void)registerDefaultSubscribers {
    // Register all default subscribers when application starts
    [_defaultNotificationSubscribers removeAllObjects];
    [_defaultNotificationSubscribers addObjectsFromArray:[self createDefaultSubscribers]];
    for (id<CLNotificationSubscriber> subscriber in _defaultNotificationSubscribers) {
        [self registerSubscriber:subscriber];
    }
}

# pragma mark - unregisterDefaultSubscribers

- (void)unregisterDefaultSubscribers {
    // Unregister all default subscribers when application terminates
    for (CLBaseSubscriber *subscriber in _defaultNotificationSubscribers) {
        [subscriber unregisterOnBus:_eventBus];
    }
    [_notificationSubscribers removeAllObjects];
}

# pragma mark - registerSubscriber

- (void)registerSubscriber:(id<CLNotificationSubscriber>)subscriber {
    // Register an individual subscriber if it is not inside the MapTable
    if ([_notificationSubscribers objectForKey:subscriber]) {
        return;
    }
    NSObject *registeredSubscriber = [subscriber registerOnBus:_eventBus];
    [_notificationSubscribers setObject:registeredSubscriber forKey:subscriber];
}

# pragma mark - unregisterSubscriber

- (void)unregisterSubscriber:(NSObject *)subscriber {
    if (![_notificationSubscribers objectForKey:subscriber])
        return;
    CLBaseSubscriber *visitor = [_notificationSubscribers objectForKey:subscriber];
    [visitor unregisterOnBus:_eventBus];
    [_notificationSubscribers removeObjectForKey:subscriber];
}

# pragma mark - createDefaultSubscribers

- (NSMutableArray *)createDefaultSubscribers {
    // Init array for subscribers
    NSMutableArray *defaultSubscribers = [NSMutableArray array];
    
    // Initialize subscribers
    CLAuthenticationSubscriber *authenticationSubcriber = [[CLAuthenticationSubscriber alloc] init];
    CLInterestSubscriber *interestSubscriber = [[CLInterestSubscriber alloc] init];
    CLEventSubscriber *eventSubscriber = [[CLEventSubscriber alloc] init];
    CLUserSubscriber *userSubscriber = [[CLUserSubscriber alloc] init];
    CLSearchSubscriber *searchSubscriber = [[CLSearchSubscriber alloc] init];
    CLGroupSubscriber *groupSubscriber = [[CLGroupSubscriber alloc] init];
    CLFeedSubscriber *feedSubscriber = [[CLFeedSubscriber alloc] init];
    CLCommentSubscriber *commentSubscriber = [[CLCommentSubscriber alloc] init];
    CLParticipantSubscriber *participantSubscriber = [[CLParticipantSubscriber alloc] init];
    CLRegistrationSubscriber *registrationSubscriber = [[CLRegistrationSubscriber alloc] init];
    CLFilePreviewsSubscriber *filePreviewsSubscriber = [[CLFilePreviewsSubscriber alloc] init];
    
    // Add subscribers to registry to be able to recieve events
    [defaultSubscribers addObject:authenticationSubcriber];
    [defaultSubscribers addObject:interestSubscriber];
    [defaultSubscribers addObject:eventSubscriber];
    [defaultSubscribers addObject:userSubscriber];
    [defaultSubscribers addObject:searchSubscriber];
    [defaultSubscribers addObject:groupSubscriber];
    [defaultSubscribers addObject:feedSubscriber];
    [defaultSubscribers addObject:commentSubscriber];
    [defaultSubscribers addObject:participantSubscriber];
    [defaultSubscribers addObject:registrationSubscriber];
    [defaultSubscribers addObject:filePreviewsSubscriber];
    
    return defaultSubscribers;
}

@end