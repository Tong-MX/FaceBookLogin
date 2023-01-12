//
//  LoginModel.h
//  MTFaceBookLogin
//
//  Created by tong on 2023/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject
@property (nonatomic, copy) NSString *tokenString;
@property (nonatomic, copy) NSString *userID;
@end

NS_ASSUME_NONNULL_END
