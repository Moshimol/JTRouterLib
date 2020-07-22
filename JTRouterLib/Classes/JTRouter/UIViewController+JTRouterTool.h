//
//  UIViewController+JTRouterTool.h
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (JTRouterTool)

+ (UIViewController* )jt_rootViewController;
+ (UIViewController* )jt_findVisibleViewController;


@end

NS_ASSUME_NONNULL_END
