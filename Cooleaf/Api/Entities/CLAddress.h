//
//  CLAddress.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>

@interface CLAddress : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *addressLine1;
@property (nonatomic) NSString *addressLine2;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *zipcode;
@property (nonatomic) NSString *name;

@end
