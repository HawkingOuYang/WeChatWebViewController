//
//  HTmReachabilityManager.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/4/20.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//

#import "HTmReachabilityManager.h"
#import <Reachability.h>
#import <AFNetworkReachabilityManager.h>


@interface HTmReachabilityManager ()
@property (nonatomic, strong) id <NSObject> afNetworkStatusObserver;//Observer AFNetworkReachabilityStatus
@property (nonatomic, strong) NSNumber *afNetworkStatus;//@(AFNetworkReachabilityStatus)

@property (nonatomic, strong) Reachability *reachability;

@end



@implementation HTmReachabilityManager

#pragma mark - PUBLIC

+ (HTmReachabilityManager *_Nonnull)sharedManager
{
    static HTmReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

+ (BOOL)isReachable
{
    if ([[self sharedManager] afNetworkStatus]) {//fix bug：时序
        AFNetworkReachabilityStatus curStatus = [[[self sharedManager] afNetworkStatus] integerValue];
        return  curStatus == AFNetworkReachabilityStatusReachableViaWWAN
                ||
                curStatus == AFNetworkReachabilityStatusReachableViaWiFi;
    }else{
        return [[[self sharedManager] reachability] isReachable];
    }
}

+ (BOOL)isUnreachable
{
    if ([[self sharedManager] afNetworkStatus]) {//fix bug：时序
        AFNetworkReachabilityStatus curStatus = [[[self sharedManager] afNetworkStatus] integerValue];
        return  curStatus == AFNetworkReachabilityStatusUnknown
                ||
                curStatus == AFNetworkReachabilityStatusNotReachable;
    }else{
        return ![[[self sharedManager] reachability] isReachable];
    }
}

+ (BOOL)isReachableViaWWAN
{
    if ([[self sharedManager] afNetworkStatus]) {//fix bug：时序
        AFNetworkReachabilityStatus curStatus = [[[self sharedManager] afNetworkStatus] integerValue];
        return  curStatus == AFNetworkReachabilityStatusReachableViaWWAN;
    }else{
        return [[[self sharedManager] reachability] isReachableViaWWAN];
    }
}

+ (BOOL)isReachableViaWiFi
{
    if ([[self sharedManager] afNetworkStatus]) {//fix bug：时序
        AFNetworkReachabilityStatus curStatus = [[[self sharedManager] afNetworkStatus] integerValue];
        return  curStatus == AFNetworkReachabilityStatusReachableViaWiFi;
    }else{
        return [[[self sharedManager] reachability] isReachableViaWiFi];
    }
}

//! 返回字符串，这些之一： @"Unreachable"  @"WWAN"  @"WiFi"  @"unknow"
+ (NSString *_Nonnull)currentNetwork
{
    if ([self isUnreachable]) {
        return @"Unreachable";
    }else{
        
        if ([self isReachableViaWWAN]) {
            return @"WWAN";
        }else if ([self isReachableViaWiFi]) {
            return @"WiFi";
        }else{
            return @"unknow";
        }
    }
}


#pragma mark - life cycle

- (void)dealloc
{
    if (_reachability) {
        [_reachability stopNotifier];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_afNetworkStatusObserver];
    _afNetworkStatusObserver = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        {//fix bug： AFNetworking 与 Reachability 通知的 时序
            __weak __typeof(self) weakSelf = self;
            id <NSObject> observerNetworkStatus = [[NSNotificationCenter defaultCenter]
                                               addObserverForName:AppNetworkStatusDidChangeNotificationUI  //网络状态改变
                                               object:nil
                                               queue:[NSOperationQueue mainQueue]
                                               usingBlock:^(NSNotification * _Nonnull note) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    
                    NSLog(@"AFNetworking通知 AppNetworkStatusDidChangeNotificationUI 的网络状态：%@", note);
                                                                                                
                    NSNumber *curStatusNUM = [note object];
                    
                                                                                                
                    [strongSelf setAfNetworkStatus:curStatusNUM];
                }];//<---- 通知的block 结束 ---->//
            [self setAfNetworkStatusObserver:observerNetworkStatus];
        }//fix bug： AFNetworking 与 Reachability 通知的 时序
        
        
        {//fix bug： AFNetworking 与 Reachability 通知的 时序
            _reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reachabilityChanged:)
                                                         name:kReachabilityChangedNotification
                                                       object:nil];
            
            [_reachability startNotifier];
        }//fix bug： AFNetworking 与 Reachability 通知的 时序
    }
    
    return self;
}


#pragma mark - notification response
- (void)reachabilityChanged:(NSNotification *)notify
{
    NSLog(@"Reachability通知 kReachabilityChangedNotification 的网络状态：%@", notify);
}


@end
