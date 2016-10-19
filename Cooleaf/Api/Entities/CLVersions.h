//
//  NPVersions.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>

@interface CLVersions : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *thumbUrl;
@property (nonatomic) NSString *iconUrl;
@property (nonatomic) NSString *smallUrl;
@property (nonatomic) NSString *mediumUrl;
@property (nonatomic) NSString *largeUrl;
@property (nonatomic) NSString *bigUrl;
@property (nonatomic) NSString *mainUrl;
@property (nonatomic) NSString *coverUrl;

@end
