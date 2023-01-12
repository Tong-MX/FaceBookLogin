//
//  MTFaceBookLogin.m
//  MTFaceBookLogin
//
//  Created by tong on 2023/1/12.
//

#import "MTFaceBookLogin.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

static NSString *AuthorizationErrorDomin = @"AuthorizationErrorDomin";
typedef NS_ENUM(NSInteger, AuthorizationErrorCode) {
    AuthorizationErrorCancelCode = -1000,
};

@implementation MTFaceBookLogin
+ (void)requestAuthFromViewController:(UIViewController *)controller handler:(nonnull BBLAuthHandler)handler {
    if (!self.isLogin) {
        NSArray *scope = @[@"public_profile",
                           @"email",
                           @"pages_manage_posts",
                           @"pages_read_engagement",
                           @"pages_read_user_content",
                           @"pages_show_list",
        ];
        FBSDKLoginManager *fbLoginManager = [[FBSDKLoginManager alloc] init];
        fbLoginManager.defaultAudience = FBSDKDefaultAudienceEveryone;
        FBSDKLoginConfiguration *configuration = [[FBSDKLoginConfiguration alloc] initWithPermissions:scope tracking:FBSDKLoginTrackingEnabled];
        [fbLoginManager logInFromViewController:controller
                                  configuration:configuration
                                     completion:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {

            if (error) {
                handler(nil,error);
            }else if(result){
                if (!result.isCancelled) {
                    LoginModel *authResult = [[LoginModel alloc] init];
                    authResult.tokenString = result.token.tokenString;
                    authResult.userID = result.token.userID;
                    handler(authResult,nil);
                }else{
                    NSError *error = [NSError errorWithDomain:AuthorizationErrorDomin code:AuthorizationErrorCancelCode userInfo:nil];
                    handler(nil,error);
                }
            }

        }];

    }else{
        FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
        LoginModel *authResult = [[LoginModel alloc] init];
        authResult.tokenString = accessToken.tokenString;
        authResult.userID = accessToken.userID;
        handler(authResult, nil);
    }
}

+ (BOOL)isLogin {
    return [FBSDKAccessToken isCurrentAccessTokenActive];
}

+ (NSString *)userID {
    return [FBSDKAccessToken currentAccessToken].userID;
}

+ (NSString *)userName {
    return [FBSDKProfile currentProfile].name;
}

+ (NSURL *)imageUrl {
    return [FBSDKProfile currentProfile].imageURL;
}

/// 根据自己情况使用
/// @param completion completion
+ (void)loadProfileNameWithCompletion:(void (^)(NSString *__nullable name, NSError *__nullable error))completion {
    [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *_Nullable profile, NSError *_Nullable error) {
        if (profile) {
            if (completion) completion(profile.name, nil);
        } else {
            if (completion) completion(nil, error);
        }
    }];
}

/// 根据自己情况使用
/// @param completion completion
+ (void)imageURLForPictureWithSize:(CGSize)size completion:(void (^)(NSURL *url, NSError *error))completion {
    FBSDKProfile *currentProfile = [FBSDKProfile currentProfile];
    if (currentProfile) {
        NSURL *url = [currentProfile imageURLForPictureMode:FBSDKProfilePictureModeSmall size:size];
        completion(url, nil);
    } else {
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *_Nullable profile, NSError *_Nullable error) {
            if (profile) {
                NSURL *url = [profile imageURLForPictureMode:FBSDKProfilePictureModeSmall size:size];
                completion(url, nil);
            } else {
                completion(nil, error);
            }
        }];
    }
}

+ (void)logout {
    [[[FBSDKLoginManager alloc] init] logOut];
}
@end
