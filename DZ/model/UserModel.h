//
//  LoginModel.h
//  DZ
//
//  Created by Nonato on 14-4-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee.h"
#import "user.h"
#import "logout.h"
#import "registeruser.h"
#import "profile.h"
#pragma mark - 
#undef	PER_PAGE
#define PER_PAGE	(30)

@interface UserModel : BeeStreamViewModel

AS_SINGLETON(UserModel)
AS_SIGNAL(LOGIN_RELOADED)
AS_SIGNAL(LOGIN_FAILED)
AS_SIGNAL(LOGIN_LOADING)

AS_SIGNAL(LOGOUT_RELOADED)
AS_SIGNAL(LOGOUT_FAILED)
AS_SIGNAL(LOGOUT_LOADING)

AS_SIGNAL(REGIST_RELOADED)
AS_SIGNAL(REGIST_FAILED)
AS_SIGNAL(REGIST_LOADING)

AS_SIGNAL(PROFILE_RELOADED)
AS_SIGNAL(PROFILE_FAILED)
AS_SIGNAL(PROFILE_LOADING)

@property (nonatomic, retain) NSString      *username;
@property (nonatomic, retain) NSString      *password;
@property (nonatomic, retain) NSString      *messageCount;
@property (nonatomic, retain) LOGIN2        *login;
@property (nonatomic, retain) REGISTERUSER  *regist;
@property (nonatomic, retain) PROFILE       *profile;
@property (nonatomic, retain) PROFILE       *friendProfile;
@property (nonatomic, assign) BOOL           firstUse;
@property (nonatomic, assign) BOOL           saveUser;
@property (nonatomic, retain) SESSION2      *session;

- (void)signinWithUser:(NSString *)username
			  password:(NSString *)password;

- (void)signupWithUser:(NSString *)username
			  password:(NSString *)password
				 email:(NSString *)email;

- (void)updateFriendProfile:(NSString *)frienduid;//获取好友信息

-(NSString *)readsessionForKey:(NSString *)key;

-(SESSION2 *)readsession:(NSString *)key;

//- (void)signout:(NSString *)uid;

- (void)updateProfile;

//- (void)setOnline:(BOOL)flag;

//- (void)setOffline:(BOOL)flag;
-(SESSION2 *)defaultSession;
+ (BOOL)online;

- (void)reload;

-(void)kickout;

@end
