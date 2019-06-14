//
//  UITextField+LKExpand.h
//  83
//
//  Created by 83 on 2019/5/24.
//  Copyright © 2019年 83. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UITextFieldLimitBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (LKExpand)

// 编辑代理回调
@property (nonatomic, copy) UITextFieldLimitBlock limitBlock;

/// 最长字数
@property (nonatomic, assign) int maxLength;

/**
 字数限制-不自动裁剪

 @param limitBlock UITextFieldLimitBlock
 */
- (void)lengthLimit:(UITextFieldLimitBlock)limitBlock;

/**
 字数限制-自动裁剪

 @param maxLength 最大长度
 @param limitBlock UITextFieldLimitBlock
 */
- (void)lengthLimitWithMaxLength:(int)maxLength limitBlock:(UITextFieldLimitBlock)limitBlock;

@end

NS_ASSUME_NONNULL_END
