//
//  HTmAlert.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/4/15.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//

#import "HTmAlert.h"


#define IS_IOS_8_OR_LATER     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface HTmAlert () <UIAlertViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSMutableArray<__kindof HTmAlertAction*>  *actions;

//@property (nonatomic, strong) UIWindow *alertWindow;

/**
 保证delegate的方法调用前self不被释放掉
 */
@property (nonatomic, strong) id holder;
/**
 弹窗控制器 或者 弹窗视图，代码控制 使得弹窗消失 by OYXJ on 15/5/20
 */
@property (nonatomic, strong) id alertControllerOrAlertView;

@end



@implementation HTmAlert


#pragma mark - life cycle

- (void)dealloc
{
    /**
     保证alert自身被释放
     */
    [self p_dimiss];
}

/**
 *  初始化方法
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = [title copy];
        _message = [message copy];
    }
    return self;
}



#pragma mark - PUBLIC


/**
 工厂方法
 */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[HTmAlert alloc] initWithTitle:title message:message];
}


/**
 添加事件
 */
- (void)addActions:(HTmAlertAction *)action
{
    if (!_actions) {
        _actions = [[NSMutableArray alloc] init];
    }
    
    if (action && action.title.length > 0) {
        
        [_actions addObject:action];
    }
    
}


/**
 弹出显示alert
 */
- (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //<---- 在主线程，显示弹窗 ----> begin //
        
        
        if (IS_IOS_8_OR_LATER) {//iOS8以及之后
            
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:_title
                                                                               message:_message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            
            __weak __typeof(self) weakSelf = self;
            [_actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                
                HTmAlertAction *action = obj;
                
                if (action.title.length <= 0) {
                    
                    return;
                };
                
                [alertCtrl addAction:[UIAlertAction actionWithTitle:action.title
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *alertAction)
                                      {
                                          [strongSelf p_processForButtonClickAction:action];
                                          
                                          [strongSelf p_dimiss];
                                      }]];
            }];
            
            
            /*
            _alertWindow = ({


                alertWindow;
            });
            
            UIWindow *mainAppWindow = [self p_getTopMostVisableWindow];
            UIViewController *placeController = mainAppWindow.rootViewController;
            while (placeController.presentedViewController) {
                placeController = placeController.presentedViewController; // 如果当前视图已经弹出了视图， 获取更上一层的试图控制器
            }
            
            [self setAlertControllerOrAlertView:alertCtrl];//弹窗控制器 或者 弹窗视图 by OYXJ on 15/5/20
            
            alertCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [placeController presentViewController:alertCtrl animated:NO completion:nil];
            */

            
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [[UIViewController alloc] init];
            alertWindow.windowLevel = UIWindowLevelAlert;
            [alertWindow makeKeyAndVisible];
            
            [self setAlertControllerOrAlertView:alertCtrl];//弹窗控制器 或者 弹窗视图 by OYXJ on 15/5/20
            
            alertCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [alertWindow.rootViewController presentViewController:alertCtrl animated:NO completion:nil];
            
            
        } else {//iOS8之前
            
            self.holder = self; // 保证delegate的方法调用前self不被释放掉
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_title
                                                                message:_message
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil, nil];
            
            [_actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                HTmAlertAction *action = obj;
                
                if (action.title) {
                    [alertView addButtonWithTitle:action.title];
                }
            }];
            
            [self setAlertControllerOrAlertView:alertView];//弹窗控制器 或者 弹窗视图 by OYXJ on 15/5/20
            
            [alertView show];
        }
    

    });//<---- 在主线程，显示弹窗 ----> end //
    
}


/**
 *  代码控制 使得弹窗消失 by OYXJ on 15/5/20
 *  @note   该方法 不调用按钮对应的SEL。
 *
 *  @param buttonIndex 按钮的index，从0算起。
 *  @param animated    动画
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //<---- 在主线程，消失弹窗 ----> begin //
        
        if (IS_IOS_8_OR_LATER) {//iOS8以及之后
                
                if ([[self alertControllerOrAlertView] isKindOfClass:[UIAlertController class]]) {//UIAlertController
                    
                    UIAlertController * alertCtl = [self alertControllerOrAlertView];
                    
                    [alertCtl dismissViewControllerAnimated:animated completion:nil];
                    
                    
                    [self p_dimiss]; // 保证alert消失后自身被释放干净
                }
            
        } else {//iOS8之前
            
                if ([[self alertControllerOrAlertView] isKindOfClass:[UIAlertView class]]) {//UIAlertView
                    
                    UIAlertView * alertView = [self alertControllerOrAlertView];
                    
                    if (buttonIndex >= 0 && buttonIndex < _actions.count) {
                        //避免越界
                        [alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
                    }
                    
                    [self p_dimiss]; // 保证alert消失后自身被释放干净
                }
            
        }
        
    });//<---- 在主线程，消失弹窗 ----> end //
    
}




#pragma mark - private

/**
 执行点击事件
 */
- (void)p_processForButtonClickAction:(HTmAlertAction *)action
{
    HTmAlertActionHandler handler = action.handler;
    
    if (handler) {
        
        handler(action);
    }
    
}


/*
- (UIWindow *)p_getTopMostVisableWindow
{
    __block UIWindow *topMostVisableWindow = nil;
    [[[UIApplication sharedApplication] windows] enumerateObjectsWithOptions:NSEnumerationReverse
                                                                  usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        UIWindow *window = obj;
        if (!window.hidden) {
            
            topMostVisableWindow = window;
            *stop = YES;
        }
    }];
    
    return topMostVisableWindow;
}
*/



/**
 保证alert自身被释放
 */
- (void)p_dimiss
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window makeKeyAndVisible];
    
    self.alertControllerOrAlertView = nil;//弹窗控制器 或者 弹窗视图 by OYXJ on 15/5/20
    self.holder = nil;// 保证alert自身被释放
}


#pragma mark - <UIAlertViewDelegate> for iOS < 8.0
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0 && buttonIndex < _actions.count) {
        
        HTmAlertAction *action = [_actions objectAtIndex:buttonIndex];
        [self p_processForButtonClickAction:action];
    }
    
    [self p_dimiss]; // 保证alert消失后自身被释放干净
}


@end
