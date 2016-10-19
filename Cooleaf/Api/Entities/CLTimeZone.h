//
//  CLTimeZone.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>

@interface CLTimeZone : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *offset;
@property (nonatomic) NSString *abbrv;
@property (nonatomic) NSString *momentName;

@end
