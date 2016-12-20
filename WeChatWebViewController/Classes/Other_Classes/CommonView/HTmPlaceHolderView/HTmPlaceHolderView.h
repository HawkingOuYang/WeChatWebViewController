//
//  HTmPlaceHolderView.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 16/04/01.
//  Copyright © 2016年 [OYXJlucky@163.com] . All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/*! @brief 当前视图的placeholder视图，效果类似于UITextField的placeholder。
 *  @author OuYangXiaoJin on 2016.04.01
 */
@interface HTmPlaceHolderView : UIView

/**
 *  显示：当前视图的placeholder视图，效果类似于UITextField的placeholder。
 *
 *  @param view          当前placeholder视图的父视图
 *  @param viewOffset    当前placeholder视图的offset(当对于view)；若为负数，则使用默认。
 *  @param image         当前placeholder视图中的图片展示
 *  @param imageOffset   当前image的offset(当对于view)；若为负数，则使用默认。
 *  @param imageSize     当前image的size
 *  @param description   当前placeholder视图中的文字表述
 *  @param detail        当前placeholder视图中的详细描述
 *  @param bottomInfo    当前placeholder视图中的底部文字
 *  @param actionTitle   当前placeholder视图中的按钮标题
 *  @param actionHandler 当前placeholder视图中的按钮block
 */
+ (void)showPlaceHolderOnView:(UIView *)view
                   viewOffset:(CGFloat)viewOffset
                        image:(UIImage *)image
                  imageOffset:(CGFloat)imageOffset
                    imageSize:(CGSize)imageSize
                  description:(NSString * _Nullable)description
                       detail:(NSString * _Nullable)detail
                   bottomInfo:(NSString * _Nullable)bottomInfo
                  actionTitle:(NSString * _Nullable)actionTitle
                actionHandler:(nullable void(^)())actionHandler;


/**
 *  显示：当前视图的placeholder视图，效果类似于UITextField的placeholder。
 *
 *  @param view          当前placeholder视图的父视图
 *  @param viewOffset    当前placeholder视图的offset(当对于view)；若为负数，则使用默认。
 *  @param image         当前placeholder视图中的图片展示
 *  @param imageOffset   当前image的offset(当对于view)；若为负数，则使用默认。
 *  @param imageSize     当前image的size
 *  @param description   当前placeholder视图中的文字表述
 *  @param detail        当前placeholder视图中的详细描述
 *  @param bottomInfo    当前placeholder视图中的底部文字
 *  @param actionTitle   当前placeholder视图中的按钮标题
 *  @param actionHandler 当前placeholder视图中的按钮block
 */
+ (void)showPlaceHolderOnView:(UIView *)view
                   viewOffset:(CGFloat)viewOffset
                        image:(UIImage *)image
                  imageOffset:(CGFloat)imageOffset
                    imageSize:(CGSize)imageSize
                  description:(NSString * _Nullable)description
             attributedDetail:(NSAttributedString * _Nullable)detail
                   bottomInfo:(NSString * _Nullable)bottomInfo
                  actionTitle:(NSString * _Nullable)actionTitle
                actionHandler:(nullable void(^)())actionHandler;


/**
 *  显示：当前视图的placeholder视图，效果类似于UITextField的placeholder。
 *
 *  @param view          当前placeholder视图的父视图
 *  @param viewOffset    当前placeholder视图的offset(当对于view)；若为负数，则使用默认。
 *  @param image         当前placeholder视图中的图片展示
 *  @param imageOffset   当前image的offset(当对于view)；若为负数，则使用默认。
 *  @param imageSize     当前image的size
 *  @param description   当前placeholder视图中的文字表述
 *  @param detail        当前placeholder视图中的详细描述
 *  @param bottomInfo    当前placeholder视图中的底部文字
 *  @param actionTitle   当前placeholder视图中的按钮标题
 *  @param actionHandler 当前placeholder视图中的按钮block
 */
+ (void)showPlaceHolderOnView:(UIView *)view
                   viewOffset:(CGFloat)viewOffset
                        image:(UIImage *)image
                  imageOffset:(CGFloat)imageOffset
                    imageSize:(CGSize)imageSize
        attributedDescription:(NSAttributedString * _Nullable)description
             attributedDetail:(NSAttributedString * _Nullable)detail
                   bottomInfo:(NSString * _Nullable)bottomInfo
                  actionTitle:(NSString * _Nullable)actionTitle
                actionHandler:(nullable void(^)())actionHandler;


/**
 *  隐藏：当前视图的placeholder视图。
 *
 *  @param view 当前placeholder视图的父视图。
 */
+ (void)hidePlaceHolderOnView:(UIView *)view;

@end


NS_ASSUME_NONNULL_END
