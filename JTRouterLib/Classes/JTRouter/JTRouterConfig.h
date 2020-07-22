//
//  JTRouterConfig.h
//  CocoaLumberjack
//
//  Created by lushitong on 2020/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//路由处理
extern NSString *const JTRouterViewController;
extern NSString *const JTRouterModule;

//内部主要的控制器材
extern NSString *const JTRouterLogin;

//控制器跳转相关参数配置

//处理同级导航栏返回层级 Index
extern NSString *const kJTRouterBackIndex;
//指定同级导航栏到此页面
extern NSString *const kJTRouterBackPage;
//指定
extern NSString *const kJTRouterBackPageOffset;
//处理外部跳转到App
extern NSString *const kJTRouteFromOutside;
//Modal 时需要导航控制器;
extern NSString *const kJTRouterSegueNeedNavigation;


// 跳转的类型
extern NSString *const kJTRouterSegue;
extern NSString *const kJTRouterAnimated;

// 跳转
extern NSString *const JTRouterPushType;
extern NSString *const JTRouterIndexRoot;
extern NSString *const JTRouterModal;
extern NSString *const JTRouterBack;


// 跳转对应的tabbar
extern NSString *const JTRouteHomeTab;
extern NSString *const JTRouteLiveTab;
extern NSString *const JTRouteMessageTab;
extern NSString *const JTRouteMyMeTab;

@interface JTRouterConfig : NSObject


@end

NS_ASSUME_NONNULL_END
