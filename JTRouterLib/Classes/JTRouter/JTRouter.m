//
//  JTRouter.m
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/7/22.
//

#import "JTRouter.h"

@implementation JTRouter

+ (BOOL)openURL:(NSString *)url {
    return [self openURL:url parameters:nil];
}

+ (BOOL)openURL:(NSString *)url parameters:(NSDictionary *)parameters {
    return [self routerURL:url parameters:parameters];
}

#pragma mark QKRouter

+ (void)addRouter:(NSString *)router handler:(BOOL (^)(NSDictionary * _Nonnull))handlerBlock {
    [JLRoutes addRoute:router handler:handlerBlock];
}

+ (BOOL)routerURL:(NSString *)url parameters:(NSDictionary *)parameters {
    return [[JLRoutes routesForScheme:@"jtRouter"] routeURL:[NSURL URLWithString:url] withParameters:parameters];
}

@end
