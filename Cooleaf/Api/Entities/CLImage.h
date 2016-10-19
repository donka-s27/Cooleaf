//
//  CLImage.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>

@interface CLImage : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *path;

@end
