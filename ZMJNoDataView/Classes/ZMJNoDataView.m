//
//  ZMJNoDataView.m
//  ZMJNoDataView_Example
//
//  Created by qx on 2019/12/21.
//  Copyright © 2019 zmjie. All rights reserved.
//

#import "ZMJNoDataView.h"

#import "ZMJMacro.h"

#import "UIColor+ZMJNoDataView.h"
#import "UIView+ZMJNoDataView.h"

#import <Masonry/Masonry.h>

@interface ZMJNoDataView ()

@property (strong, nonatomic) UIView *zmj_contentView;
@property (strong, nonatomic) UIImageView *zmj_ndvImageView;
@property (strong, nonatomic) UILabel *zmj_ndvLabel;
@property (strong, nonatomic) UIButton *zmj_ndvBtn;

@property (assign, nonatomic) ZMJNoDataViewStyle zmj_style;

@end

@implementation ZMJNoDataView

- (instancetype)initWithFrame:(CGRect)frame zmj_style:(ZMJNoDataViewStyle)style zmj_delegate:(nullable id<zmj_ndvDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor zmj_dynamicColor:[UIColor whiteColor] zmj_darkColor:[UIColor whiteColor]];
        
        self.alpha = 0.0f;
        self.frame = frame;
        _zmj_style = style;
        _zmj_delegate = delegate;
        
        [self zmj_initView];
        [self zmj_makeSubViewsConstraints];
        
        switch (_zmj_style) {
                
            case ZMJNoDataViewStyleNone:break;
            case ZMJNoDataViewStyleBtn:break;
                
            case ZMJNoDataViewStyleGesture: {
                
                [self zmj_initGesture];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

+ (instancetype)zmj_showNDVAddedTo:(UIView *)view zmj_style:(ZMJNoDataViewStyle)style zmj_delegate:(nullable id<zmj_ndvDelegate>)delegate {
    
    return [self zmj_showNDVAddedTo:view zmj_frame:view.bounds zmj_style:style zmj_delegate:delegate];
}

+ (instancetype)zmj_showNDVAddedTo:(UIView *)view zmj_frame:(CGRect)frame zmj_style:(ZMJNoDataViewStyle)style zmj_delegate:(nullable id<zmj_ndvDelegate>)delegate {
    
    ZMJNoDataView *zmj_ndv = [[self alloc] initWithFrame:frame zmj_style:style zmj_delegate:delegate];
    [view addSubview:zmj_ndv];
    
    [UIView animateWithDuration:0.25f animations:^{
        
        zmj_ndv.alpha = 1.0f;
        
    }completion:^(BOOL finished) {
    }];
    
    return zmj_ndv;
}

+ (BOOL)zmj_hideNDVForToView:(UIView *)view {
    
    ZMJNoDataView *zmj_ndv = [self zmj_ndvForView:view];
    
    if (zmj_ndv) {
        
        [UIView animateWithDuration:0.25f animations:^{
            
            zmj_ndv.alpha = 0.0f;
            
        }completion:^(BOOL finished) {
            
            [zmj_ndv removeFromSuperview];
        }];
        return YES;
    }
    return NO;
}

+ (ZMJNoDataView *)zmj_ndvForView:(UIView *)view {
    
    NSEnumerator *zmj_enumerator = [view.subviews reverseObjectEnumerator];
    
    for (UIView *zmj_view in zmj_enumerator) {
        
        if ([zmj_view isKindOfClass:self]) {
            
            return (ZMJNoDataView *)zmj_view;
        }
    }
    return nil;
}

- (void)zmj_initView {
    
    [self addSubview:self.zmj_contentView];
    [self addSubview:self.zmj_ndvImageView];
    [self addSubview:self.zmj_ndvLabel];
    [self addSubview:self.zmj_ndvBtn];
    
    switch (_zmj_style) {
            
        case ZMJNoDataViewStyleNone:
        case ZMJNoDataViewStyleGesture: {
            
            _zmj_ndvBtn.hidden = YES;
        }
            break;
        
        case ZMJNoDataViewStyleBtn: {
            
            _zmj_ndvBtn.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)zmj_makeSubViewsConstraints {
    
    [_zmj_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-zmj_size(10));
        make.leading.trailing.equalTo(self);
    }];

    [_zmj_ndvImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.zmj_contentView);
    }];
    
    [_zmj_ndvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zmj_ndvImageView.mas_bottom).offset(zmj_size(15));
        make.leading.trailing.equalTo(self.zmj_ndvImageView);
    }];
    
    switch (_zmj_style) {
            
        case ZMJNoDataViewStyleNone:
        case ZMJNoDataViewStyleGesture: {
            
            [_zmj_ndvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.zmj_ndvLabel.mas_bottom).offset(zmj_size(25));
                make.centerX.equalTo(self.mas_centerX);
                make.bottom.equalTo(self.zmj_contentView);
                make.width.mas_equalTo(zmj_screenWidth / 2);
                make.height.mas_equalTo(0);
            }];
        }
            break;
            
        case ZMJNoDataViewStyleBtn: {
            
            [_zmj_ndvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.zmj_ndvLabel.mas_bottom).offset(zmj_size(25));
                make.centerX.equalTo(self.mas_centerX);
                make.bottom.equalTo(self.zmj_contentView);
                make.width.mas_equalTo(zmj_screenWidth / 2.5);
                make.height.mas_equalTo(zmj_size(40));
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)zmj_initGesture {
    
    UITapGestureRecognizer *dyt_tap = [[UITapGestureRecognizer alloc] init];
    [dyt_tap addTarget:self action:@selector(dyt_m_tap:)];
    [self addGestureRecognizer:dyt_tap];
}

- (UIView *)zmj_contentView {
    if (!_zmj_contentView) {
        _zmj_contentView = [[UIView alloc] init];
    }
    return _zmj_contentView;
}

- (UIImageView *)zmj_ndvImageView {
    if (!_zmj_ndvImageView) {
        _zmj_ndvImageView = [[UIImageView alloc] init];
        _zmj_ndvImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _zmj_ndvImageView;
}

- (UILabel *)zmj_ndvLabel{
    if (!_zmj_ndvLabel) {
        _zmj_ndvLabel = [[UILabel alloc] init];
        _zmj_ndvLabel.textColor = [UIColor zmj_dynamicColor:zmj_color(51, 51, 51) zmj_darkColor:zmj_color(51, 51, 51)];
        _zmj_ndvLabel.font = zmj_pingFangSCRegularSize((zmj_defaultFontSize + 2));
        _zmj_ndvLabel.textAlignment = NSTextAlignmentCenter;
        _zmj_ndvLabel.numberOfLines = 0;
    }
    return _zmj_ndvLabel;
}

- (UIButton *)zmj_ndvBtn {
    if (!_zmj_ndvBtn) {
        _zmj_ndvBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _zmj_ndvBtn.titleLabel.font = zmj_pingFangSCRegularSize((zmj_defaultFontSize + 2));
        [_zmj_ndvBtn addTarget:self action:@selector(zmj_btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _zmj_ndvBtn.layer.borderWidth = 1;
        _zmj_ndvBtn.layer.cornerRadius = 5;
    }
    return _zmj_ndvBtn;
}

- (void)zmj_btnAction:(UIButton *)btn {
    
    if ([self.zmj_delegate respondsToSelector:@selector(zmj_ndvBtnAction:)]) {
        
        [self.zmj_delegate zmj_ndvBtnAction:btn];
        return;
    }
    
    [self zmj_btnActionBlock:btn];
}

- (void)dyt_m_tap:(UITapGestureRecognizer *)tap {
    
    if ([self.zmj_delegate respondsToSelector:@selector(zmj_ndvTapAction:)]) {

        [self.zmj_delegate zmj_ndvTapAction:tap];
        return;
    }

    [self zmj_tapActionBlock:tap];
}

- (void)zmj_tapActionBlock:(UITapGestureRecognizer *)tap {}
- (void)zmj_btnActionBlock:(UIButton *)btn {}

@end