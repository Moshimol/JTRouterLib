//
//  JTRouterConfig.m
//  CocoaLumberjack
//
//  Created by lushitong on 2020/7/20.
//

#import "JTRouterConfig.h"


NSString *const kJTRouterBackIndex = @"kJTRouterBackIndex";
NSString *const kJTRouterBackPage = @"kJTRouterBackPage";
NSString *const kJTRouterBackPageOffset = @"kJTRouterBackPageOffset";
NSString *const kJTRouteFromOutside = @"kJTRouteFromOutside";
NSString *const kJTRouterSegueNeedNavigation = @"kJTRouterSegueNeedNavigation";

NSString *const JSDVCRouteHomeTab = @"/rootTab/0";
NSString *const JSDVCRouteCafeTab = @"/rootTab/1";
NSString *const JSDVCRouteCoffeeTab = @"/rootTab/2";
NSString *const JSDVCRouteMyCenterTab = @"/rootTab/3";

// 路由参数设计

// 当前控制器名称
NSString *const JTRouterViewController = @"viewController";

// 当前模块的名称
NSString *const JTRouterModule = @"module";

// 跳转类型

NSString *const kJTRouterSegue = @"segue";
NSString *const kJTRouterAnimated = @"animated";

NSString *const JTRouterPushType = @"push";
NSString *const JTRouterIndexRoot = @"root";
NSString *const JTRouterModal = @"modal";
NSString *const JTRouterBack = @"/back";

// 主要跳转类型
NSString *const JTRouterLogin = @"LoginVC";

// 跳转对应的tabbar
NSString *const JTRouteHomeTab = @"/qkRootTab/0";
NSString *const JTRouteLiveTab = @"/qkRootTab/1";
NSString *const JTRouteMessageTab = @"/qkRootTab/2";
NSString *const JTRouteMyMeTab = @"/qkRootTab/3";

@implementation JTRouterConfig


@end
