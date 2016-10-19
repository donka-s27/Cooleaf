//
//  NPCooleafClient.m
//  Cooleaf
//
//  Created by Bazyli Zygan on 14.12.2013.
//  Copyright (c) 2013 Nova Project. All rights reserved.
//

#import "NPCooleafClient.h"
#import "NPTagGroup.h"
#import "NPInterest.h"
#import "NPSeriesEvent.h"
#import <SSKeychain/SSKeychain.h>
#import "NSFileManager+ImageCaching.h"

static NPCooleafClient *_sharedClient = nil;
NSString *f_notificationUDID = nil;

NSString * const kNPCooleafClientRefreshNotification = @"kNPCooleafClientRefreshNotification";
NSString * const kNPCooleafClientRUDIDHarvestedNotification = @"kNPCooleafClientRUDIDHarvestedNotification";
NSString * const kNPCooleafClientSignOut = @"kNPCooleafClientSignOut";

static NSString * const kNPCooleafClientBaseURLString = @"http://api.staging.do.cooleaf.monterail.eu";
//static NSString * const kNPCooleafClientBaseURLString = @"http://testorg.staging.do.cooleaf.monterail.eu/api";
//static NSString * const kNPCooleafClientAPIPrefix = @"/v2";
//static NSString * const kNPCooleafClientAPIAuthLogin = @"cooleaf";
//static NSString * const kNPCooleafClientAPIAuthPassword = @"letmein";

//static NSString * const kNPCooleafClientBaseURLString = @"http://api.cooleaf.com";
static NSString * const kNPCooleafClientAPIPrefix = @"/v2";
static NSString * const kNPCooleafClientAPIAuthLogin = @"";
static NSString * const kNPCooleafClientAPIAuthPassword = @"";

@interface NPCooleafClient ()
{
    NSMutableDictionary *_downloadedImages;
    NSMutableDictionary *_imageRequests;
    void (^_loginCallbackWaiting)(NSError *error);
    NSDictionary *_loginCredentialsWaiting;
}

@property (nonatomic, copy) NSString *apiPrefix;

- (void)synchronizeImageIndex;
@end

@implementation NPCooleafClient


+ (NPCooleafClient *)sharedClient
{

    if (!_sharedClient)
    {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"staging_environment"])
//            _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kNPStagingClientBaseURLString]];
//        else
            _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kNPCooleafClientBaseURLString]];
    }
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        AFHTTPRequestSerializer *reqSerializer = [AFHTTPRequestSerializer serializer];
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"staging_environment"])
//        {
//            _apiPrefix = kNPStagingClientAPIPrefix;
//            if (kNPStagingClientAPIAuthLogin.length > 0)
//                [reqSerializer setAuthorizationHeaderFieldWithUsername:kNPStagingClientAPIAuthLogin password:kNPStagingClientAPIAuthPassword];
//        }
//        else
//        {
            _apiPrefix = kNPCooleafClientAPIPrefix;
            if (kNPCooleafClientAPIAuthLogin.length > 0)
                [reqSerializer setAuthorizationHeaderFieldWithUsername:kNPCooleafClientAPIAuthLogin password:kNPCooleafClientAPIAuthPassword];
            
//        }

        self.requestSerializer = reqSerializer;
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        NSMutableDictionary *imageIndex = [[NSKeyedUnarchiver unarchiveObjectWithFile:[[[[NSFileManager defaultManager] cacheDirectory] URLByAppendingPathComponent:@"index.dat"] path]] mutableCopy];
        if (!imageIndex)
            imageIndex = [NSMutableDictionary new];
        _downloadedImages = imageIndex;
        _imageRequests = [NSMutableDictionary new];
        
        if (f_notificationUDID)
            self.notificationUDID = f_notificationUDID;
    }
    
    return self;
    
}

- (void)checkEndpoints
{
//    // Check if endpoint has changed
//    NSString *urlString = ([[NSUserDefaults standardUserDefaults] boolForKey:@"staging_environment"]) ? kNPStagingClientBaseURLString : kNPCooleafClientBaseURLString;
//    
//    if ([urlString isEqualToString:self.baseURL.absoluteString])
//        return;
//    
//    // Well - we need to change the endpoint
//    _sharedClient = nil;
//    [SSKeychain deletePasswordForService:@"cooleaf" account:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNPCooleafClientSignOut object:nil];
//    });
}

- (void)setNotificationUDID:(NSString *)notificationUDID
{
    _notificationUDID = [notificationUDID copy];
    f_notificationUDID = [notificationUDID copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNPCooleafClientRUDIDHarvestedNotification object:_notificationUDID];
}

#pragma mark - Login handling

- (AFHTTPRequestOperation *)loginWithUsername:(NSString *)username password:(NSString *)password  completion:(void(^)(NSError *error))completion
{
    NSString *path = @"/authorize.json";
    
    if (_apiPrefix.length > 0)
        path = [_apiPrefix stringByAppendingString:path];
    
    NSDictionary *params = nil;
    
    if (_notificationUDID.length > 0)
#ifdef DEBUG
        params = @{@"email": username, @"password": password, @"device_id": _notificationUDID, @"sandbox": @YES};
#else
        params = @{@"email": username, @"password": password, @"device_id": _notificationUDID, @"sandbox": @NO};
#endif //DEBUG
    else
        params = @{@"email": username, @"password": password};
    
    return [self POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _userData = [responseObject copy];
        [self.requestSerializer setValue:_userData[@"role"][@"organization"][@"subdomain"] forHTTPHeaderField:@"X-Organization"];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        [SSKeychain setPassword:password forService:@"cooleaf" account:username];
        if (completion)
            completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SSKeychain deletePasswordForService:@"cooleaf" account:username];
        if (completion)
            completion(error);
    }];
}

- (void)logout
{
    [SSKeychain deletePasswordForService:@"cooleaf" account:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    _userData = nil;
    NSString *path = @"/deauthorize.json";
    
    if (_apiPrefix.length > 0)
        path = [_apiPrefix stringByAppendingString:path];
    
    NSDictionary *params = nil;
    if (_notificationUDID.length > 0)
#ifdef DEBUG
        params = @{@"device_id": _notificationUDID, @"sandbox": @YES};
#else
        params = @{@"device_id": _notificationUDID, @"sandbox": @NO};
#endif //DEBUG
    [self POST:path parameters:params success:nil failure:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNPCooleafClientSignOut object:nil];
}

#pragma mark - User handling

- (AFHTTPRequestOperation *)updateUserData
{
    NSString *path = @"/users/me.json";
    
    if (_apiPrefix.length > 0)
        path = [_apiPrefix stringByAppendingString:path];
    
    return [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _userData = [responseObject copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:kNPCooleafClientRefreshNotification object:nil];
    } failure:nil];
}

- (AFHTTPRequestOperation *)updateProfileDataAllFields:(NSString *)name email:(NSString *)email password:(NSString *)password tags:(NSArray *)tags removed_picture:(BOOL)removed_picture file_cache:(NSString *)file_cache role_structure_required:(NSArray *)role_structure_required profileDailyDigest:(BOOL)profileDailyDigest profileWeeklyDigest:(BOOL)profileWeeklyDigest profile:(NSArray *)profile completion:(void(^)())completion
{
	NSString *path = @"/users/edit.json";
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	if (name !=nil) {
		[params setValue:name forKey:@"name"];
	}
	if (email != nil) {
		[params setValue:email forKey:@"email"];
	}
	if (password != nil) {
		[params setValue:password forKey:@"password"];
	}
	if (tags != nil) {
		[params setValue:tags forKey:@"category_ids"];
		DLog(@"The tags passed are %@",tags);
	}
	if (removed_picture) {
		[params setValue:@(TRUE) forKey:@"removed_picture"];
	}
	if (file_cache != nil) {
		[params setValue:file_cache forKey:@"file_cache"];
		DLog(@"The File Cashe == %@", file_cache);
	}
    NSDictionary *role_structure = [NSDictionary dictionaryWithObjectsAndKeys:role_structure_required, @"structures", nil];
	if (role_structure_required != nil) {
		[params setValue:role_structure forKey:@"role"];
	}
	if (profileDailyDigest) {
		[params setValue:@(TRUE) forKey:@"profile[settings][send_daily_digest]"];
	}
	if (profileWeeklyDigest) {
		[params setValue:@(TRUE) forKey:@"profile[settings][send_weekly_digest]"];
	}
	if (profile != nil) {
		[params setValue:profile forKey:@"profile"];
	}

	
	if (_notificationUDID.length > 0)
#ifdef DEBUG
		[params setValue:@(TRUE) forKey:@"sandbox"];
#else
		[params setValue:@(FALSE) forKey:@"sandbox"];
#endif //DEBUG
	
	DLog(@"baseUrl = %@", self.baseURL);
	DLog(@"path    = %@", path);
//	DLog(@"params  = %@", params);
//	NSLog(@"%@", [[NSString alloc] initWithUTF8String:[NSJSONSerialization dataWithJSONObject:params options:0 error:nil].bytes]);
//	DLog(@"The parameters being pass are %@",params);
	return [self PUT:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		_userData = [responseObject copy];
		[self.requestSerializer setValue:_userData[@"role"][@"organization"][@"subdomain"] forHTTPHeaderField:@"X-Organization"];
		if (completion) {
			DLog("response = %@", responseObject);
			completion();
//			[self updateUserData];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Operation failed because, %@", error.localizedDescription);
		if (completion)
			completion();
	}];
}

- (void)getUserData:(void(^)(NSDictionary *profile))completion
{
	NSString *path = @"/users/me.json";
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	[self GET:path parameters:@{@"scope": @"ongoing"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (completion)
			completion(responseObject);
//		[self updateUserData];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"error = %@", error.localizedDescription);
		if (completion)
			completion(nil);
	}];
}





#pragma mark - Event handling

- (AFHTTPRequestOperation *)fetchEventWithId:(NSNumber *)eventId completion:(void(^)(NSDictionary *eventDetails))completion
{
	NSString *path = [NSString stringWithFormat:@"/events/%@.json", eventId];
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	return [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}

- (AFHTTPRequestOperation *)fetchParticipantsForEventWithId:(NSNumber *)eventId completion:(void(^)(NSArray *participants))completion
{
	NSString *path = [NSString stringWithFormat:@"/participations/%@.json", eventId];
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	return [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}

- (AFHTTPRequestOperation *)joinEventWithId:(NSNumber *)eventId completion:(void(^)(NSError *error))completion
{
	NSString *path = [NSString stringWithFormat:@"/events/%@/join.json", eventId];
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	return [self POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self updateUserData];
		if (completion)
			completion(nil);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self updateUserData];
		if (completion)
			completion(error);
	}];
}

- (AFHTTPRequestOperation *)leaveEventWithId:(NSNumber *)eventId completion:(void(^)(NSError *error))completion
{
	NSString *path = [NSString stringWithFormat:@"/events/%@/join.json", eventId];
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	return [self DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self updateUserData];
		if (completion)
			completion(nil);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self updateUserData];
		if (completion)
			completion(error);
	}];
}

- (void)fetchSeriesEventsForEventWithId:(NSNumber *)eventId completion:(void (^)(NSArray *npSeriesEvents))completion
{
	NSString *path = [NSString stringWithFormat:@"/events/%@/series.json", eventId];
	//	NSLog(@"path %@, myID %@", path, myID);
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	[self GET:path parameters:@{@"scope": @"ongoing"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSMutableArray *npSeriesEvents = [[NSMutableArray alloc] init];
		[(NSArray *)responseObject enumerateObjectsUsingBlock:^(NSDictionary *event, NSUInteger index, BOOL *stop) {
			[npSeriesEvents addObject:[[NPSeriesEvent alloc]initWithDictionary:event]];
		}];
		if (completion)
			completion(npSeriesEvents);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}

- (AFHTTPRequestOperation *)joinSeriesIDWithEventIdsArray:(NSNumber *)seriesID eventIdsArray:(NSArray *)eventIdsArray completion:(void(^)(NSError *error))completion
{
	NSString *path = [NSString stringWithFormat:@"/participations/%@.json", seriesID];
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setValue:eventIdsArray forKey:@"ids"];

	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	DLog(@"Set Events Path = %@",path);
	DLog(@"Set Events Params = %@",params);
	return [self POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		[self updateUserData];
		if (completion)
			completion(nil);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		[self updateUserData];
		if (completion)
			completion(error);
	}];
}



- (void)fetchEventList:(void(^)(NSArray *events))completion
{
	NSString *path = @"/events.json";
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	[self GET:path parameters:@{@"scope": @"ongoing"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}

- (AFHTTPRequestOperation *)fetchMyEventsList:(NSNumber *)myID completion:(void (^)(NSArray *))completion
{
	NSString *path = [NSString stringWithFormat:@"/events/user/%@.json", myID];
	//	NSLog(@"path %@, myID %@", path, myID);
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	return [self GET:path parameters:@{@"scope": @"ongoing"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}


- (AFHTTPRequestOperation *)fetchGroupEventsList:(NSNumber *)groupID completion:(void (^)(NSArray *))completion
{
	NSString *path = [NSString stringWithFormat:@"/interests/%@/events.json", groupID];
	//	NSLog(@"path %@, myID %@", path, myID);
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	return [self GET:path parameters:@{@"scope": @"ongoing"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}

- (AFHTTPRequestOperation *)fetchEventsListOfType:(NSString *)eventType refID:(NSNumber *)refID myID:(NSNumber *)myID completion:(void (^)(NSArray *))completion
{
	NSString *path = [NSString stringWithFormat:@""];
	if ([eventType  isEqualToString:@"groupEvents"]) {
		path = [NSString stringWithFormat:@"/interests/%@/events.json", refID];
	}
	
	else
	{
		path = [NSString stringWithFormat:@"/events/user/%@.json", myID];
	}
		NSLog(@"path %@, myID %@, refID %@", path, myID, refID);
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	if ([eventType  isEqualToString:@"pastEvents"]) {
		[params setValue:@"past" forKey:@"scope"];
	}
	else {
		[params setValue:@"ongoing" forKey:@"scope"];
	}
	
	
	return [self GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}



#pragma mark - Image handling

- (void)synchronizeImageIndex
{
    [NSKeyedArchiver archiveRootObject:_downloadedImages toFile:[[[[NSFileManager defaultManager] cacheDirectory] URLByAppendingPathComponent:@"index.dat"] path]];
}

- (void)fetchImage:(NSString *)imagePath completion:(void(^)(NSString *imagePath, UIImage *image))completion
{
    // Check if the image is already downloaded
    if (_downloadedImages[imagePath])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[[[[NSFileManager defaultManager] cacheDirectory] URLByAppendingPathComponent:_downloadedImages[imagePath]] path]];
        if (completion)
            completion(imagePath, image);
    }
    else
    {
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:imagePath parameters:nil];
        AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Save the image information first
            NSData *data = (NSData *)responseObject;
            NSString *filename = [[NSFileManager defaultManager] temporaryFilenameWithExtension:@"jpg"];
            [data writeToURL:[[[NSFileManager defaultManager] cacheDirectory] URLByAppendingPathComponent:filename] atomically:NO];
            _downloadedImages[imagePath] = filename;
            [self synchronizeImageIndex];
            UIImage *image = [UIImage imageWithData:data];
            
            // For all saved actions - trigger
            for (id block in _imageRequests[imagePath])
            {
                void (^completionBlock)(NSString *imagePath, UIImage *image) = block;
                
                completionBlock(imagePath, image);
            }
            [_imageRequests removeObjectForKey:imagePath];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            for (id block in _imageRequests[imagePath])
            {
                void (^completionBlock)(NSString *imagePath, UIImage *image) = block;
                
                completionBlock(imagePath, nil);
            }
            [_imageRequests removeObjectForKey:imagePath];
            
        }];
        
        if (_imageRequests[imagePath])
        {
            [_imageRequests[imagePath] addObject:[completion copy]];
        }
        else
        {
            _imageRequests[imagePath] = [NSMutableArray arrayWithObject:[completion copy]];
        }
        
        operation.responseSerializer = [AFHTTPResponseSerializer new];
        [self.operationQueue addOperation:operation];
    }
}

#pragma mark - Todos handling

- (AFHTTPRequestOperation *)addTodoForWidget:(NSNumber *)widgetId name:(NSString *)name completion:(void(^)(NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:@"/widgets/todos/%@.json", widgetId];
    
    if (_apiPrefix.length > 0)
        path = [_apiPrefix stringByAppendingString:path];
    return [self POST:path parameters:@{@"name": name} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion)
            completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion)
            completion(error);
    }];
}

- (AFHTTPRequestOperation *)markTodo:(NSNumber *)todoId asDone:(BOOL)done completion:(void(^)(NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:@"/widgets/todos/%@.json", todoId];
    
    if (_apiPrefix.length > 0)
        path = [_apiPrefix stringByAppendingString:path];
    return [self PUT:path parameters:@{@"done": @(done)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion)
            completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion)
            completion(error);
    }];
}





#pragma mark - Registration Handling

- (AFHTTPRequestOperation *)registerWithUsername:(NSString *)username completion:(void(^)(NSString*, NSDictionary*, NSDictionary*))completion
{
	NSString *path = @"/registrations/check.json";
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	NSDictionary *params = nil;
	
	if (_notificationUDID.length > 0)
#ifdef DEBUG
		params = @{@"email": username, @"device_id": _notificationUDID, @"sandbox": @YES};
#else
		params = @{@"email": username, @"device_id": _notificationUDID, @"sandbox": @NO};
#endif //DEBUG
	else
		params = @{@"email": username};
	
	DLog(@"baseUrl = %@", self.baseURL);
	DLog(@"path    = %@", path);
	DLog(@"params  = %@", params);
	
	return [self POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"responseObject = %@", responseObject);
		_userData = [responseObject copy];
		[self.requestSerializer setValue:_userData[@"role"][@"organization"][@"subdomain"] forHTTPHeaderField:@"X-Organization"];
		[[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
		if (completion) {
			NSMutableDictionary *tagGroups = [[NSMutableDictionary alloc] init];
			NSMutableDictionary *presets = [[NSMutableDictionary alloc] initWithDictionary:responseObject[@"chosen_structure_ids"]];
			
			NSString *gender = responseObject[@"gender"];
			if (gender != nil) {
				if ([gender isEqualToString:@"m"])
					presets[@"Gender"] = @"Male";
				else if ([gender isEqualToString:@"f"])
					presets[@"Gender"] = @"Female";
			}
			
			[presets setValue:responseObject[@"name"] forKey:@"Full Name"];
			
			[(NSArray *)responseObject[@"all_structures"] enumerateObjectsUsingBlock:^ (NSDictionary *structure, NSUInteger index, BOOL *stop) {
				NPTagGroup *tagGroup = [[NPTagGroup alloc] initWithDictionary:structure];
				tagGroups[tagGroup.name] = tagGroup;
			}];
			
			completion(responseObject[@"token"], tagGroups, presets);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Operation failed because, %@", error.localizedDescription);
		if (completion)
			completion(nil, nil, nil);
	}];
}

- (AFHTTPRequestOperation *)updateRegistrationWithToken:(NSString *)token name:(NSString *)name gender:(NSString *)gender password:(NSString *)password tags:(NSArray *)tags completion:(void(^)(BOOL, NSString*))completion
{
	NSString *path = @"/registrations.json";
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setValue:_notificationUDID forKey:@"device_id"];
	[params setValue:token forKey:@"token"];
	[params setValue:name forKey:@"name"];
	[params setValue:gender.length == 0 ? nil : [[gender lowercaseString] substringToIndex:1] forKey:@"gender"];
	[params setValue:password forKey:@"password"];
	[params setValue:tags forKey:@"tag_ids"];
	
	if (_notificationUDID.length > 0)
#ifdef DEBUG
		[params setValue:@(TRUE) forKey:@"sandbox"];
#else
		[params setValue:@(FALSE) forKey:@"sandbox"];
#endif //DEBUG
	
	DLog(@"baseUrl = %@", self.baseURL);
	DLog(@"path    = %@", path);
	DLog(@"params  = %@", params);
	
	return [self POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		_userData = [responseObject copy];
		[self.requestSerializer setValue:_userData[@"role"][@"organization"][@"subdomain"] forHTTPHeaderField:@"X-Organization"];
//	[[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
		if (completion) {
			DLog("response = %@", responseObject);
//			NSMutableDictionary *tagGroups = [[NSMutableDictionary alloc] init];
//			[(NSArray *)responseObject[@"all_structure_tags"] enumerateObjectsUsingBlock:^ (NSDictionary *structure, NSUInteger index, BOOL *stop) {
//				NPTagGroup *tagGroup = [[NPTagGroup alloc] initWithDictionary:structure];
//				tagGroups[tagGroup.name] = tagGroup;
//			}];
//			completion(responseObject[@"token"], tagGroups);
			completion(TRUE, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Operation failed because, %@", error.localizedDescription);
		if (completion)
			completion(FALSE, error.localizedDescription);
	}];
}

- (AFHTTPRequestOperation *)updatePictureWithImage:(UIImage *)image completion:(void(^)(NSDictionary *))completion
{
	NSString *path = @"/file_previews.json";
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
//	DLog(@"baseUrl = %@", self.baseURL);
//	DLog(@"path    = %@", path);
	
	NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
	int file = arc4random_uniform(742904857);
	NSString *fileNameString = [NSString stringWithFormat:@"%d.jpg", file];
	return [self POST:path parameters:nil constructingBodyWithBlock:^ (id<AFMultipartFormData> formData) {
		DLog(@"appending file data");
		[formData appendPartWithFormData:[NSData dataWithBytes:"profile_picture" length:15] name:@"uploader"];
		[formData appendPartWithFileData:imageData name:@"file" fileName:fileNameString mimeType:@"image/jpeg"];
	} success:^ (AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"responseObject = %@", responseObject);
		completion(responseObject);
	} failure:^ (AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"failed to upload profile pictures because, %@", error.localizedDescription);
		completion(nil);
	}];
}





#pragma mark - Interests

- (void)getInterests:(BOOL)userEnabled completion:(void(^)(NSArray *npinterests))completion
{
	NSString *path = userEnabled ? @"/interests/profile.json" : @"/interests.json";
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	[self GET:path parameters:@{@"scope": @"ongoing"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSMutableArray *npinterests = [[NSMutableArray alloc] init];
		[(NSArray *)responseObject enumerateObjectsUsingBlock:^ (NSDictionary *interest, NSUInteger index, BOOL *stop) {
			[npinterests addObject:[[NPInterest alloc] initWithDictionary:interest]];
		}];
		if (completion)
			completion(npinterests);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"error = %@", error.localizedDescription);
		if (completion)
			completion(nil);
	}];
}

- (void)getAllInterests:(void(^)(NSArray *npinterests))completion
{
	return [self getInterests:FALSE completion:completion];
}

- (void)getUserInterests:(void(^)(NSArray *npinterests))completion
{
	return [self getInterests:TRUE completion:completion];
}


- (AFHTTPRequestOperation *)fetchGroupWithId:(NSNumber *)groupId completion:(void(^)(NSDictionary *groupDetails))completion
{
	NSString *path = [NSString stringWithFormat:@"/interests/%@.json", groupId];
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	return [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}

- (AFHTTPRequestOperation *)fetchMembersForGroupWithId:(NSNumber *)groupId completion:(void(^)(NSArray *members))completion
{
	NSString *path = [NSString stringWithFormat:@"/interests/%@/memberlist.json", groupId];
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	DLog(@"the group member path is = %@", path);
	return [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		DLog(@"Group Member respone = %@",responseObject);
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (completion)
			completion(nil);
	}];
}

- (AFHTTPRequestOperation *)joinGroupWithId:(NSNumber *)groupId completion:(void(^)(NSError *error))completion
{
	NSString *path = [NSString stringWithFormat:@"/interests/%@/join.json", groupId];
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	return [self POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self updateUserData];
		if (completion)
			completion(nil);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self updateUserData];
		if (completion)
			completion(error);
	}];
}

- (AFHTTPRequestOperation *)leaveGroupWithId:(NSNumber *)groupId completion:(void(^)(NSError *error))completion
{
	NSString *path = [NSString stringWithFormat:@"/interests/%@/join.json", groupId];
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	return [self DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self updateUserData];
		if (completion)
			completion(nil);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self updateUserData];
		if (completion)
			completion(error);
	}];
}


- (void)fetchInterestList:(void(^)(NSArray *events))completion
{
	NSString *path = @"/interests.json";
	
	if (_apiPrefix.length > 0)
		path = [_apiPrefix stringByAppendingString:path];
	
	[self GET:path parameters:@{@"scope": @"ongoing"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		//DLog(@"responseObject = %@", responseObject);
		if (completion)
			completion(responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"error = %@", error.localizedDescription);
		if (completion)
			completion(nil);
	}];
}


/**
 * To edit just the interests for a user, we must first fetch the entire user profile, and then
 * return some of it, along with our new set of interests.
 */
- (void)setUserInterests:(NSArray *)npinterests completion:(void (^)(BOOL))completion
{
	NSMutableArray *interestIds = [[NSMutableArray alloc] init];
	
	[npinterests enumerateObjectsUsingBlock:^ (NPInterest *npinterest, NSUInteger index, BOOL *stop) {
		[interestIds addObject:@(npinterest.objectId)];
	}];
	
	[[NPCooleafClient sharedClient] getUserData:^ (NSDictionary *profile) {
		[self updateProfileDataAllFields:nil email:nil password:nil tags:interestIds removed_picture:FALSE file_cache:nil role_structure_required:profile[@"role"] profileDailyDigest:nil profileWeeklyDigest:nil profile:profile[@"profile"] completion:^{
			completion(TRUE);
		}];
	}];
}

@end
