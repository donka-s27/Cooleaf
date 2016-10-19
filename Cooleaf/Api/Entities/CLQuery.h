//
//  CLQuery.h
//  Cooleaf
//
//  Created by Haider Khan on 9/14/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface CLQuery : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *queryId;
@property (nonatomic, copy) NSString *queryName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSMutableArray *tags;
@property (nonatomic, copy) NSString *itemPath;
@property (nonatomic, copy) NSString *imagePath;

@end
