//
//  JTRouter+Handle.m
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/7/22.
//

#import "JTRouter+Handle.h"

#import "JTRouterConfig.h"
#import "UIViewController+JTRouterTool.h"

// 判断是不是String
#define QKIsString(s) !((s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0)))

// 当前默认的Scheme
#define JTDefaultScheme  @"jtRouter"

#define JTRootTabScheme @"/qkRootTab/:index"


@implementation JTRouter (Handle)


// 注册路由
+ (void)load {
    [self performSelectorOnMainThread:@selector(registerSchemRouter) withObject:nil waitUntilDone:NO];
}

+ (void)registerSchemRouter {
    // 注册路由
    // jtRouter:// +  模块名 + 跳转类型 + 是否需要动画 + 控制器名称 (jtRouter://search/push/animated/SearchVC)
    
    [[JLRoutes routesForScheme:JTDefaultScheme] addRoute:@"/:module/:segue/:animated/:viewController" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        // 当前控制器的名字
        NSString *className = parameters[JTRouterViewController];
        
        // 当前模块的名称 暂时未做限制 后续版本做处理
        // NSString *moduleName = parameters[JTRouterModule];
        
        return [self executeRouterClassName:className routerMap:nil parameters:parameters];
    }];
    
    // 默认不使用动画
    [[JLRoutes routesForScheme:JTDefaultScheme] addRoute:@"/:module/:segue/:viewController" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        // 当前控制器的名字
        NSString *className = parameters[JTRouterViewController];
        // 当前模块的名称 暂时未做限制 后续版本做处理
        // NSString *moduleName = parameters[JTRouterModule];
        
        return [self executeRouterClassName:className routerMap:nil parameters:parameters];
    }];
    
    
    // 切换Tabbar的方法
    [[JLRoutes routesForScheme:JTRootTabScheme] addRoute:JTRootTabScheme handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        NSInteger index = [parameters[@"index"] integerValue];
        
        // 处理 UITabBarControllerIndex
        
        UITabBarController* tabBarVC = (UITabBarController* )[UIViewController jt_rootViewController];
        if ([tabBarVC isKindOfClass:[UITabBarController class]] && index >= 0 && tabBarVC.viewControllers.count >= index) {
            UIViewController* indexVC = tabBarVC.viewControllers[index];
            if ([indexVC isKindOfClass:[UINavigationController class]]) {
                indexVC = ((UINavigationController *)indexVC).topViewController;
            }
            // 参数传递
            [self setupParameters:parameters forViewController:indexVC];
            
            tabBarVC.selectedIndex = index;
            
            return YES;
        } else {
            return NO;
        }
    }];
    
    // 注册返回上层页面 Router, 使用 [JTRouter openURL:QKRouterBack] 返回上一页 或 [JTRouter openURL:@"jtRouter://back" parameters:@{kQKRouterBackIndex: @(2)}]  返回前两页
    // 注册返回上册页面Router ，返回上一页面
    
    [[JLRoutes routesForScheme:JTDefaultScheme] addRoute:JTRouterBack handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        return [self executeBackRouterParameters:parameters];
    }];
    
}

#pragma mark - execute Router VC

// 当查找到指定 Router 时, 触发路由回调逻辑; 找不到已注册 Router 则直接返回 NO; 如需要的话, 也可以在这里注册一个全局未匹配到 Router 执行的回调进行异常处理;
+ (BOOL)executeRouterClassName:(NSString *)className routerMap:(NSDictionary* )routerMap parameters:(NSDictionary* )parameters {
    /*
     1、是否需要登录 由外面的控制器进行判断
     2、参数化处理
     3、在跳转的时候进行判断，统一初始化控制器,传参和跳转
     */
    
    UIViewController *pushVC = [self viewControllerWithClassName:className routerMap:routerMap parameters: parameters];
    
    if (pushVC) {
        [self gotoViewController:pushVC parameters:parameters];
        return YES;
    } else {
        return NO;
    }
}

// 根据 Router 映射到的类名实例化控制器;

+ (UIViewController *)viewControllerWithClassName:(NSString *)className routerMap:(NSDictionary *)routerMap parameters:(NSDictionary* )parameters {
    
    //  取当前的pushVC
    id pushVC = [[NSClassFromString(className) alloc] init];
    
    if (![pushVC isKindOfClass:[UIViewController class]]) {
        pushVC = nil;
    }
    
#if DEBUG
    //vc不是UIViewController
    NSAssert(pushVC, @"%s: %@ is not kind of UIViewController class, routerMap: %@",__func__ ,className, routerMap);
#endif
    //参数赋值
    [self setupParameters:parameters forViewController:pushVC];
    
    return pushVC;
}

// 对 VC 参数赋值
+ (void)setupParameters:(NSDictionary *)params forViewController:(UIViewController* )vc {
    
    for (NSString *key in params.allKeys) {
        BOOL hasKey = [vc respondsToSelector:NSSelectorFromString(key)];
        BOOL notNil = params[key] != nil;
        if (hasKey && notNil) {
            [vc setValue:params[key] forKey:key];
        }
        
#if DEBUG
    //vc没有相应属性，但却传了值
        if ([key hasPrefix:@"JLRoute"] == NO && [params[@"JLRoutePattern"] rangeOfString:[NSString stringWithFormat:@":%@",key]].location == NSNotFound) {
            NSAssert(hasKey == YES, @"%s: %@ is not property for the key %@",__func__ ,vc,key);
        }
#endif
    };
}

// 跳转和参数设置;
+ (void)gotoViewController:(UIViewController *)vc parameters:(NSDictionary *)parameters {
    
    UIViewController *currentVC = [UIViewController jt_findVisibleViewController];
    
    // 确定跳转类型
    NSString *segue = parameters[kJTRouterSegue] ? parameters[kJTRouterSegue] : JTRouterPushType; //  决定 present 或者 Push; 默认值 Push
   
    // 确定是否需要动画 默认需要转场动画
    
    BOOL animated = parameters[kJTRouterAnimated] ? [parameters[kJTRouterAnimated] boolValue] : YES;  // 转场动画;
    
    NSLog(@"%s 跳转: %@ %@ %@",__func__ ,currentVC, segue,vc);
    
    //PUSH的类型
    if ([[segue lowercaseString] isEqualToString:@"push"]) {
        if (currentVC.navigationController) {
            NSString *backIndexString = [NSString stringWithFormat:@"%@",parameters[kJTRouterBackIndex]];
            UINavigationController* nav = currentVC.navigationController;
            if ([backIndexString isEqualToString:JTRouterIndexRoot]) {
                NSMutableArray *vcs = [NSMutableArray arrayWithObject:nav.viewControllers.firstObject];
                [vcs addObject:vc];
                [nav setViewControllers:vcs animated:animated];
            } else if ([backIndexString integerValue] && [backIndexString integerValue] < nav.viewControllers.count) {
                //移除掉指定数量的 VC, 在Push;
                NSMutableArray *vcs = [nav.viewControllers mutableCopy];
                [vcs removeObjectsInRange:NSMakeRange(vcs.count - [backIndexString integerValue], [backIndexString integerValue])];
                nav.viewControllers = vcs;
                [nav pushViewController:vc animated:YES];
            } else {
                [nav pushViewController:vc animated:animated];
            }
        } else {
            //由于无导航栏, 直接执行 Modal 默认是全屏显示
            BOOL needNavigation = parameters[kJTRouterSegueNeedNavigation] ? NO : YES;
            if (needNavigation) {
                UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:vc];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [currentVC presentViewController:navigationVC animated:YES completion:nil];
            }
            else {
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [currentVC presentViewController:vc animated:animated completion:nil];
            }
        }
    } else { //直接执行 Modal 默认是全屏显示
        BOOL needNavigation = parameters[kJTRouterSegueNeedNavigation] ? parameters[kJTRouterSegueNeedNavigation] : NO;
        if (needNavigation) {
            UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVC presentViewController:navigationVC animated:animated completion:nil];
        }
        else {
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVC presentViewController:vc animated:animated completion:nil];
        }
    }
}

// 返回上层页面回调;
+ (BOOL)executeBackRouterParameters:(NSDictionary *)parameters {
    
    // 返回上层控制器
    BOOL animated = parameters[kJTRouterAnimated] ? [parameters[kJTRouterAnimated] boolValue] : YES;
    
    // 指定返回个数, 优先处理此参数;
    NSString *backIndexString = parameters[kJTRouterBackIndex] ? [NSString stringWithFormat:@"%@",parameters[kJTRouterBackIndex]] : nil;
    
    // 指定返回到某个页面
    id backPage = parameters[kJTRouterBackPage] ? parameters[kJTRouterBackPage] : nil;
    
    NSInteger backPageOffset = parameters[kJTRouterBackPageOffset] ? [parameters[kJTRouterBackPageOffset] integerValue] : 0; // 指定返回到的页面并进行偏移;
    
    UIViewController *visibleVC = [UIViewController jt_findVisibleViewController];
    
    UINavigationController* navigationVC = visibleVC.navigationController;
    
    if (navigationVC) {
        // 处理 pop 按索引值处理;
        if (QKIsString(backIndexString)) {
            if ([backIndexString isEqualToString:JTRouterIndexRoot]) {//返回根
                [navigationVC popToRootViewControllerAnimated:animated];
            }
            else {
                NSUInteger backIndex = backIndexString.integerValue;
                NSMutableArray* vcs = navigationVC.viewControllers.mutableCopy;
                if (vcs.count > backIndex) {
                    [vcs removeObjectsInRange:NSMakeRange(vcs.count - backIndex, backIndex)];
                    [navigationVC setViewControllers:vcs animated:animated];
                    return YES;
                }
                else {
                    return NO; //指定返回索引值超过当前导航控制器包含的子控制器;
                }
            }
        }
        else if (backPage) { //处理返回指定的控制器
            NSMutableArray *vcs = navigationVC.viewControllers.mutableCopy;
            NSInteger pageIndex = NSNotFound;
            //页面标识为字符串
            if ([backPage isKindOfClass:[NSString class]]) {
                for (int i=0; i<vcs.count; i++) {
                    if ([vcs[i] isKindOfClass:NSClassFromString(backPage)]) {
                        pageIndex = i;
                        break;
                    }
                }
            }
            //页面标识为vc实例
            else if ([backPage isKindOfClass:[UIViewController class]]) {
                for (int i=0; i<vcs.count; i++) {
                    if (vcs[i] == backPage) {
                        pageIndex = i;
                        break;
                    }
                }
            }
            //有指定页面，根据参数跳转
            if (pageIndex != NSNotFound) {
                NSUInteger backIndex = (vcs.count-1) - pageIndex + backPageOffset;
                if (vcs.count > backIndex) {
                    [vcs removeObjectsInRange:NSMakeRange(vcs.count-backIndex, backIndex)];
                    [navigationVC setViewControllers:vcs animated:animated];
                    return YES;
                }
            }
            //指定页面不存在，return NO，可用于判断当前vc栈里有没有当前页面。
        }
        else {
            [navigationVC popViewControllerAnimated:animated];
            return YES;
        }
    }
    else {
        [visibleVC dismissViewControllerAnimated:animated completion:nil];
        return YES;
    }
    return NO;
}

@end
