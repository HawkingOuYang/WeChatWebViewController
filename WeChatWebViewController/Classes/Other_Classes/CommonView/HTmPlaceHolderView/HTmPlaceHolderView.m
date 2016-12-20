//
//  HTmPlaceHolderView.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 16/04/01.
//  Copyright © 2016年 [OYXJlucky@163.com] . All rights reserved.
//

#import "HTmPlaceHolderView.h"

#import "Masonry.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - Types
typedef void(^HandlerBlock)();


#pragma mark - CLASS HTmPlaceHolderView
@interface HTmPlaceHolderView ()

@property (nonatomic, strong) UIScrollView  *baseScrollView;
@property (nonatomic, strong) UIImageView   *placeHolderImageView;
@property (nonatomic, strong) UIButton      *placeHolderButton;
@property (nonatomic, strong) UILabel       *descriptionLabel;
@property (nonatomic, strong) UILabel       *detailLabel;
@property (nonatomic, strong) UILabel       *bottomInfoLabel;
@property (nonatomic, copy) HandlerBlock    handlerBlock;

@end



@implementation HTmPlaceHolderView

#pragma mark PUBLIC Method

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
                actionHandler:(nullable void(^)())actionHandler
{
    [self hidePlaceHolderOnView:view];
    
    
    //! 当前视图，是ScrollView的子视图。
    BOOL isSelfAddedOntoScrollView = NO;
    if ([view isKindOfClass:[UIScrollView class]]) {
        isSelfAddedOntoScrollView = YES;
    }
    
    CGRect selfRect = view.bounds;
    if (viewOffset > 0) {
        selfRect.origin.y    += viewOffset;
        selfRect.size.height -= viewOffset;
    }
    
    
    HTmPlaceHolderView *placeHolderView = [[[self class] alloc] initWithFrame: selfRect
                                                    isSelfAddedOntoScrollView: isSelfAddedOntoScrollView
                                                                        image: image
                                                                  imageOffset: imageOffset
                                                                    imageSize: imageSize
                                                                  description: description
                                                                       detail: detail
                                                                   bottomInfo: bottomInfo
                                                                  actionTitle: actionTitle
                                                                actionHandler: actionHandler];
    [view addSubview:placeHolderView];
}


/**
 *  显示：当前视图的placeholder视图，效果类似于UITextField的placeholder。
 *
 *  @param view          当前placeholder视图的父视图
 *  @param viewOffset    当前placeholder视图的offset(当对于view)
 *  @param image         当前placeholder视图中的图片展示
 *  @param imageOffset   当前image的offset(当对于view)
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
                actionHandler:(nullable void(^)())actionHandler
{
    [self hidePlaceHolderOnView:view];
    
    
    //! 当前视图，是ScrollView的子视图。
    BOOL isSelfAddedOntoScrollView = NO;
    if ([view isKindOfClass:[UIScrollView class]]) {
        isSelfAddedOntoScrollView = YES;
    }
    
    CGRect selfRect = view.bounds;
    if (viewOffset > 0) {
        selfRect.origin.y    += viewOffset;
        selfRect.size.height -= viewOffset;
    }
    
    HTmPlaceHolderView *placeHolderView = [[[self class] alloc] initWithFrame: selfRect
                                                    isSelfAddedOntoScrollView: isSelfAddedOntoScrollView
                                                                        image: image
                                                                  imageOffset: imageOffset
                                                                    imageSize: imageSize
                                                                  description: description
                                                                       detail: detail
                                                                   bottomInfo: bottomInfo
                                                                  actionTitle: actionTitle
                                                                actionHandler: actionHandler];
    [view addSubview:placeHolderView];
    [view bringSubviewToFront:placeHolderView];//占位view 前置
}

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
                actionHandler:(nullable void(^)())actionHandler
{
    [self hidePlaceHolderOnView:view];
    
    
    //! 当前视图，是ScrollView的子视图。
    BOOL isSelfAddedOntoScrollView = NO;
    if ([view isKindOfClass:[UIScrollView class]]) {
        isSelfAddedOntoScrollView = YES;
    }
    
    CGRect selfRect = view.bounds;
    if (viewOffset > 0) {
        selfRect.origin.y    += viewOffset;
        selfRect.size.height -= viewOffset;
    }
    
    HTmPlaceHolderView *placeHolderView = [[[self class] alloc] initWithFrame: selfRect
                                                    isSelfAddedOntoScrollView: isSelfAddedOntoScrollView
                                                                        image: image
                                                                  imageOffset: imageOffset
                                                                    imageSize: imageSize
                                                                  description: description
                                                                       detail: detail
                                                                   bottomInfo: bottomInfo
                                                                  actionTitle: actionTitle
                                                                actionHandler: actionHandler];
    [view addSubview:placeHolderView];
}


/**
 *  隐藏：当前视图的placeholder视图。
 *
 *  @param view 当前placeholder视图的父视图。
 */
+ (void)hidePlaceHolderOnView:(UIView *)view
{
    HTmPlaceHolderView *placeHolder = [self placeHolderForView:view];
    if (placeHolder) {
        [placeHolder removeFromSuperview];
    }
}



#pragma mark - Life Cycle

/**
 为了避免崩溃，请确保类型：
 (id _Nullable)description  为 NSString实例 或者 NSAttributedString实例
 (id _Nullable)detail   为 NSString实例 或者 NSAttributedString实例
 */
- (instancetype)initWithFrame:(CGRect)frame
    isSelfAddedOntoScrollView:(BOOL)isSelfAddedOntoScrollView
                        image:(UIImage *)image
                  imageOffset:(CGFloat)imageOffset
                    imageSize:(CGSize)imageSize
                  description:(id _Nullable)description
                       detail:(id _Nullable)detail
                   bottomInfo:(NSString * _Nullable)bottomInfo
                  actionTitle:(NSString * _Nullable)actionTitle
                actionHandler:(nullable void(^)())actionHandler
{
    if (self = [super initWithFrame:frame]) {
        
        //! 当前视图，是ScrollView的子视图。
        UIView *contentView = nil;
        if (isSelfAddedOntoScrollView==NO) {
            
            //part1 +
            [self addSubview:[self baseScrollView]];
            UIView *superView = self;
            [_baseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(superView);
            }];
            
            //part1.1 +
            contentView = [[UIView alloc] init];
            [_baseScrollView addSubview:contentView];
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_baseScrollView);
                make.width.equalTo(_baseScrollView);
                make.height.equalTo(_baseScrollView).offset(1);
            }];
            
        }else{
            
            contentView = [[UIView alloc] init];
            [self addSubview:contentView];
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.width.equalTo(self);
                make.height.equalTo(self).offset(1);
            }];
        }
        
        
        //part1.1.1 +
        [contentView addSubview:[self placeHolderImageView]];
        [_placeHolderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            if (imageOffset > 0) {
                make.top.equalTo(contentView).offset(R(imageOffset));
            }else{
                make.top.equalTo(contentView).offset(R(81));
            }
            if (CGSizeEqualToSize(imageSize, CGSizeZero)==NO) {
                make.size.mas_equalTo(imageSize);
            }else{
                make.width.equalTo(@(R(160)));
                make.height.equalTo(@(R(160)));
            }
        }];
        
        
        //part1.1.2 +
        CGFloat offsetToImageView = 0;
        if (CGSizeEqualToSize(imageSize, CGSizeZero)==NO) {
            offsetToImageView = 0;
        }else{
            offsetToImageView = R(6.f);
        }
        
        // 为了避免崩溃，请确保 description 的类型是：NSAttributedString 或者 NSString
        id descriptionTitle = description;
        if ([descriptionTitle isKindOfClass:[NSAttributedString class]]) {//NSAttributedString
            descriptionTitle = (NSAttributedString *)descriptionTitle;
            
            //part1.1.2 +
            if ([descriptionTitle length] > 0) {
                
                /**
                 How to calculate the height of an NSAttributedString with given width in iOS 6
                 http://stackoverflow.com/questions/14409897/how-to-calculate-the-height-of-an-nsattributedstring-with-given-width-in-ios-6
                 */
                //头标题headTitle可能是长文本
                CGFloat maxWidth = CGRectGetWidth(self.frame)-2*R(30);
                NSAttributedString *attrStr = (NSAttributedString *)descriptionTitle;
                CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(maxWidth, R(300))
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    context:nil];
                CGFloat txtHeight = MIN( rect.size.height, R(50) );
                
                
                [contentView addSubview:[self descriptionLabel]];
                [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                    make.centerX.equalTo(contentView);
                    make.top.equalTo(_placeHolderImageView.mas_bottom).offset(offsetToImageView);
                    
                    make.width.equalTo(contentView).offset(-2*R(55));
                    make.height.equalTo(@(txtHeight));
                }];
                
                offsetToImageView += ( txtHeight + R(3) );
            }
            
            
        }else if ([descriptionTitle isKindOfClass:[NSString class]]){//NSString
            
            descriptionTitle = (NSString *)descriptionTitle;
            
            //part1.1.2 +
            if ([descriptionTitle length] > 0) {
                
                [contentView addSubview:[self descriptionLabel]];
                [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(contentView);
                    make.top.equalTo(_placeHolderImageView.mas_bottom).offset(offsetToImageView);
                    
                    make.width.equalTo(contentView).offset(-2*R(55));
                    make.height.equalTo(@(R(16)));
                }];
                
                offsetToImageView += ( R(16) + R(6) );
            }
            
        }//处理 description//

        
        // 为了避免崩溃，请确保 detail 的类型是：NSAttributedString 或者 NSString
        id detailTitle = detail;
        if ([detailTitle isKindOfClass:[NSAttributedString class]]) {//NSAttributedString
            detailTitle = (NSAttributedString *)detailTitle;
            
            //part1.1.3 +
            if ([detailTitle length] > 0) {
                
                /**
                 How to calculate the height of an NSAttributedString with given width in iOS 6
                 http://stackoverflow.com/questions/14409897/how-to-calculate-the-height-of-an-nsattributedstring-with-given-width-in-ios-6
                 */
                //头标题headTitle可能是长文本
                CGFloat maxWidth = CGRectGetWidth(self.frame)-2*R(30);
                NSAttributedString *attrStr = (NSAttributedString *)detailTitle;
                CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(maxWidth, R(300))
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    context:nil];
                CGFloat txtHeight = MIN( rect.size.height, R(50) );
                
                
                [contentView addSubview:[self detailLabel]];
                [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(contentView);
                    make.top.equalTo(_placeHolderImageView.mas_bottom).offset(offsetToImageView);
                    
                    make.width.equalTo(contentView).offset(-2*R(30));
                    make.height.equalTo(@(txtHeight));
                }];
                
                offsetToImageView += ( txtHeight + R(3) );
            }
            
            
        }else{//NSString
            
            detailTitle = (NSString *)detailTitle;
            
            //part1.1.3 +
            if ([detailTitle length] > 0) {
                
                [contentView addSubview:[self detailLabel]];
                [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(contentView);
                    make.top.equalTo(_placeHolderImageView.mas_bottom).offset(offsetToImageView);
                    
                    make.width.equalTo(contentView).offset(-2*R(30));
                    make.height.equalTo(@(R(40)));
                }];
                
                offsetToImageView += ( R(40) + R(3) );
            }

        }//处理 detail//
        
        
        
        //part1.1.4 +
        if (bottomInfo.length > 0) {
            
            [contentView addSubview:[self bottomInfoLabel]];
            [_bottomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(contentView).offset(-40);
                make.height.equalTo(@30);
                make.centerX.equalTo(contentView);
                make.bottom.equalTo(contentView).offset(-40);
            }];
            
        }
            
        //part1.1.5 +
        if (actionTitle.length > 0) {
            
            [contentView addSubview:[self placeHolderButton]];
            [_placeHolderButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView);
                make.top.equalTo(_placeHolderImageView.mas_bottom).offset(offsetToImageView);
                make.size.mas_equalTo(CGSizeMake(150, 40));
            }];
            
        }
        
        
        contentView.userInteractionEnabled = YES;
        
        MASAttachKeys(self, self.baseScrollView, self.placeHolderImageView, self.placeHolderButton);
 
        
        [_placeHolderImageView setImage:image];
        
        // 为了避免崩溃，请确保 detail 的类型是：NSAttributedString 或者 NSString
        if ([descriptionTitle isKindOfClass:[NSAttributedString class]]) {//NSAttributedString
            _descriptionLabel.attributedText = (NSAttributedString *)descriptionTitle;
        }else{
            _descriptionLabel.text = descriptionTitle;
        }
        
        // 为了避免崩溃，请确保 detail 的类型是：NSAttributedString 或者 NSString
        if ([detailTitle isKindOfClass:[NSAttributedString class]]) {//NSAttributedString
            _detailLabel.attributedText = (NSAttributedString *)detailTitle;
        }else{
            _detailLabel.text = detailTitle;
        }
        
        
        
        _bottomInfoLabel.text = bottomInfo;
        [_placeHolderButton setTitle:actionTitle forState:UIControlStateNormal];
        _handlerBlock = [actionHandler copy];
        
        
    }
    
    return self;
}

+ (instancetype)placeHolderForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (HTmPlaceHolderView *)subview;
        }
    }
    
    return nil;
}


#pragma mark - Views
- (UIScrollView *)baseScrollView
{
    if (!_baseScrollView) {
        _baseScrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
            scrollView.backgroundColor = SystemBackGroundGray;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView;
        });
        
        

    }
    return _baseScrollView;
}

- (UIImageView *)placeHolderImageView
{
    if (!_placeHolderImageView) {
        _placeHolderImageView = [[UIImageView alloc] init];
        _placeHolderImageView.contentMode = UIViewContentModeScaleToFill;
        _placeHolderImageView.layer.masksToBounds = YES;
    }
    return _placeHolderImageView;
}

- (UIButton *)placeHolderButton
{
    if (!_placeHolderButton) {
        _placeHolderButton = [[UIButton alloc] init];
        _placeHolderButton.backgroundColor = [UIColor whiteColor];
        _placeHolderButton.layer.borderWidth = 1.0f;
        _placeHolderButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _placeHolderButton.layer.cornerRadius = 20;
        [_placeHolderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_placeHolderButton addTarget:self action:@selector(p_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placeHolderButton;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        
        _descriptionLabel.font = [UIFont boldSystemFontOfSize:R(15)];
        _descriptionLabel.textColor = [UIColor colorWithHex:0x000000 alpha:0.80];
    }
    return _descriptionLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        
        _detailLabel.font = [UIFont boldSystemFontOfSize:R(11)];
        _detailLabel.textColor = [UIColor colorWithHex:0x000000 alpha:0.60];
        
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}


- (UILabel *)bottomInfoLabel
{
    if (!_bottomInfoLabel) {
        _bottomInfoLabel = [[UILabel alloc] init];
        _bottomInfoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomInfoLabel;
}


#pragma mark - Private Method
- (void)p_buttonAction:(UIButton *)sender
{
    if (self.handlerBlock) {
        _handlerBlock();
    }
}

@end


NS_ASSUME_NONNULL_END
