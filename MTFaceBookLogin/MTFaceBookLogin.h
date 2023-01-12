//
//  MTFaceBookLogin.h
//  MTFaceBookLogin
//
//  Created by tong on 2023/1/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^BBLAuthHandler)(LoginModel *_Nullable result,NSError *_Nullable error);

@interface MTFaceBookLogin : NSObject
@property (class, nonatomic, assign, readonly) BOOL isLogin;
@property (class, nonatomic, copy, readonly) NSString *userID;
@property (class, nonatomic, copy, readonly, nullable) NSString *userName;
@property (class, nonatomic, strong, readonly, nullable) NSURL *imageUrl;

+ (void)requestAuthFromViewController:(UIViewController *)controller handler:(nonnull BBLAuthHandler)handler;
+ (void)loadProfileNameWithCompletion:(void(^)(NSString *__nullable name,NSError *__nullable error))completion;
+ (void)imageURLForPictureWithSize:(CGSize)size completion:(void(^)(NSURL *url, NSError *error))completion;

+ (void)logout;
@end

NS_ASSUME_NONNULL_END
