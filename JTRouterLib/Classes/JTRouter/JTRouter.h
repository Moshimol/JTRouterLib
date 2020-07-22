//
//  JTRouter.h
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/7/22.
//

#import <Foundation/Foundation.h>

#import <JLRoutes/JLRoutes.h>
#import "JTRouterConfig.h"


/*
JT路由操作 情咖FM的scheme的key 是(jtRouter://) 该scheme主要用于路由跳转
Tips:登录的操作在外面进行判断，该路由不用来判断是否需要登录，建议在外面做是否登录的判断


// 跳转的参数
1、jtRouter:// +  模块名 + 跳转类型 + 控制器名称 (jtRouter://search/push/SearchVC)
2、jtRouter:// +  模块名 + 跳转类型 + 是否需要跳转动画 +  控制器名称 (jtRouter://search/push/SearchVC)

3、跳转有回调 在对用的VC 实现callback callBack

void (^callback)(void) = ^{
    DDLogDebug(@"执行回调函数");
};

void (^callback2)(NSString *) = ^(NSString *name) {
    DDLogDebug(@"执行回调函数2, 我是%@", name);
};

[JTRouter openURL:@"jtRouter://setting/push/SettingVC" parameters:@{@"callback": callback, @"callback2": callback2}];

4、需要返回 (默认返回只有一层，如果需要返回多层或者返回对用的VC 则使用参数)
// 默认返回一层
[JTRouter openURL:@"jtRouter://back];
// 返回两层
[JTRouter openURL:@"jtRouter://back" parameters:@{kQKRouterBackIndex: @(2)}];
// 返回指定控制器
[JTRouter openURL:@"jtRouter://back" parameters:@{kQKRouterBackPage: @"SettingVC"}];

*/

NS_ASSUME_NONNULL_BEGIN

@interface JTRouter : NSObject

// 调用Router
+ (BOOL)openURL:(NSString *)url;

// 调用路由跳转 需要添加参数 如果有参数的话
+ (BOOL)openURL:(NSString *)url parameters:(NSDictionary *)parameters;

//注册 Router,调用 Router 时会触发回调;
+ (void)addRouter:(NSString *)router handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;

@end

NS_ASSUME_NONNULL_END
