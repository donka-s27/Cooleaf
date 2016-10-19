//
//  CLFilePreview.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>
#import "CLVersions.h"

@interface CLFilePreview : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *fileCache;
@property (nonatomic) NSString *originalUrl;
@property (nonatomic) CLVersions *versions;

@end
