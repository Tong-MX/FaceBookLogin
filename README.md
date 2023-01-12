# FaceBookLogin
FaceBook 登录总结


由于当前项目需要有Facebook 、Line 、Twitter、Apple 三方登录我一一介绍他们的集成步骤和踩的坑
首先是Facebook登录
1.申请facebook账号
2.创建应用
3.获取应用编号
4.配置相关信息
5.xcode配置
6.代码集成

一、创建应用
1.首先需要登录facebook开发者平台（https://developers.facebook.com/apps）去构建自己的应用，你需要有一个facebook的账号，没有的话需要去注册一个.

2.然后添加iOS平台 - 填写应用名称 - 创建应用编号 - 为应用添加产品（facebook登录），然后到设置中完善相关信息，然后保存，配置Bundle ID，这些都是按照流程一步步填写

3.配置完成之后你就可以得到xcode中info.plist文件中的配置信息
info.plist填写分成三部分
第一部分填写
 URL types 填写自己对应的ID
  ![image.png](https://upload-images.jianshu.io/upload_images/1954867-dce02c95dc0f684f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第二部分填写
![image.png](https://upload-images.jianshu.io/upload_images/1954867-193ca2cf746c2153.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第三部分填写
![image.png](https://upload-images.jianshu.io/upload_images/1954867-038afb02125b321f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

二、xcode配置（接入SDK）
新项目一般推荐Swift package 去添加地址是 https://github.com/facebook/facebook-ios-sdk

去添加
![image.png](https://upload-images.jianshu.io/upload_images/1954867-c89a7c09c5e84d6e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

把地址copy进去 add
![image.png](https://upload-images.jianshu.io/upload_images/1954867-8730e5929a70b04b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

根据自己实际情况添加对应的库 如果不清楚选哪个都选上也没问题就是包会大点 
![image.png](https://upload-images.jianshu.io/upload_images/1954867-81ba13d33b035273.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

添加成功会出现地址
![image.png](https://upload-images.jianshu.io/upload_images/1954867-393957db7b6af393.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
加载时间比较长耐心加载 如果加载失败可以开启翻墙或者修改host来更新

三、代码集成 
1.Appdelegate中
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ///在appdelegate 配置
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}
```
```
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme hasPrefix:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    return false;
}
```
管理一个Manager去维护Facebook登录登录逻辑
```
#import <FBSDKLoginKit/FBSDKLoginKit.h>
以下代码是登录逻辑
if (!self.isLogin) {
///public_profile email pages_manage_posts pages_read_engagement pages_read_user_content pages_show_list 对应的获取的权限这样才能
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
            } else if(result) {
                if (!result.isCancelled) {
                    BBLAuthResultModel *authResult = [[BBLAuthResultModel alloc] init];
                    authResult.tokenString = result.token.tokenString;
                    authResult.userID = result.token.userID;
                    handler(authResult,nil);
                } else {
                    NSError *error = [NSError errorWithDomain:AuthorizationErrorDomin code:AuthorizationErrorCancelCode userInfo:nil];
                    handler(nil,error);
                }
            }

        }];

    } else {
        FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
        BBLAuthResultModel *authResult = [[BBLAuthResultModel alloc] init];
        authResult.tokenString = accessToken.tokenString;
        authResult.userID = accessToken.userID;
        handler(authResult,nil);
    }
```

