//
//  CLSeries.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>

@interface CLSeries : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSNumber *seriesId;
@property (nonatomic) NSMutableArray *eventIds;

@end
