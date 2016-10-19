//
//  CLParticipant.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>
#import "CLProfile.h"

@interface CLParticipant : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSNumber *participantId;
@property (nonatomic) NSString *name;
@property (nonatomic) CLProfile *profile;
@property (nonatomic) NSMutableArray *categories;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, readonly) NSNumber *eventId;
@property (nonatomic) NSMutableArray *checkedOutEvents;

@end
