//
//  CLBus.h
//  Cooleaf
//
//  Created by Haider Khan on 8/27/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SUBSCRIBE(_event_type_) - (void) on##_event_type_:(_event_type_ *) event

#define PUBLISHER(_event_type_) - (_event_type_ *) get##_event_type_

#define REGISTER() [CLBus.sharedInstance subscribe:self]

#define UNREGISTER() [CLBus.sharedInstance unsubscribe:self]

#define PUBLISH(_value_) [CLBus.sharedInstance publish:_value_]

@interface CLBus : NSObject

@property(nonatomic) BOOL forceMainThread;

@property (nonatomic,strong) NSString *publisherPrefix;
@property (nonatomic,strong) NSString *observerPrefix;

- (void) subscribe:(NSObject *)object;
- (void) unsubscribe:(NSObject *)object;
- (void) publish:(id<NSObject>)type;

// This doesn't prevent you from creating as many instances as you like. This way, you have at least
// one shared instance that you can use right off the bat.
+ (CLBus *) sharedInstance;

@end