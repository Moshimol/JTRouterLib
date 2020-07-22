#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JTRouter+Handle.h"
#import "JTRouter.h"
#import "JTRouterConfig.h"
#import "JTRouterLib.h"
#import "UIViewController+JTRouterTool.h"

FOUNDATION_EXPORT double JTRouterLibVersionNumber;
FOUNDATION_EXPORT const unsigned char JTRouterLibVersionString[];

