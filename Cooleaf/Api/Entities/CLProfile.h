//
//  NPProfile.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>
#import "CLPicture.h"
#import "CLSettings.h"

@interface CLProfile : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) CLPicture *picture;
@property (nonatomic, copy) CLSettings *settings;

@end
