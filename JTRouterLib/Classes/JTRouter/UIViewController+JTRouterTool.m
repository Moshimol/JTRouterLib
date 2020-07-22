//
//  UIViewController+JTRouterTool.m
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/7/22.
//

#import "UIViewController+JTRouterTool.h"

@implementation UIViewController (JTRouterTool)

+ (UIViewController *)jt_rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (UIViewController *)jt_findVisibleViewController {
    
    UIViewController* currentViewController = [self jt_rootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

@end
