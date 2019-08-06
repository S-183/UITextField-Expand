//
//  UITextField+LKExpand.m
//  83
//
//  Created by 83 on 2019/5/24.
//  Copyright © 2019年 83. All rights reserved.
//

#import "UITextField+LKExpand.h"
#import <objc/runtime.h>

static char limit;
static char length;

@implementation UITextField (LKExpand)

- (void)setLimitBlock:(UITextFieldLimitBlock)limitBlock
{
    objc_setAssociatedObject(self, &limit, limitBlock, OBJC_ASSOCIATION_COPY);
}

- (UITextFieldLimitBlock)limitBlock
{
    return objc_getAssociatedObject(self, &limit);
}

- (void)setMaxLength:(int)maxLength
{
    objc_setAssociatedObject(self, &length, @(maxLength), OBJC_ASSOCIATION_COPY);
}

- (int)maxLength
{
    NSNumber *maxLength = objc_getAssociatedObject(self, &length);
    return [maxLength intValue];
}

- (void)lengthLimit:(UITextFieldLimitBlock)limitBlock
{
    [self lengthLimitWithMaxLength:0 limitBlock:limitBlock];
}

- (void)lengthLimitWithMaxLength:(int)maxLength limitBlock:(UITextFieldLimitBlock)limitBlock
{
    [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.maxLength = maxLength;
    self.limitBlock = limitBlock;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position || !selectedRange)
    {
        // 全为空格
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [textField.text stringByTrimmingCharactersInSet:set];
        if (textField.text.length > 0 && trimedString.length == 0) {
            textField.text = nil;
            return;
        }
        
        if (self.maxLength) {
            // 裁剪字数
            NSString *toBeString = textField.text;
            if (toBeString.length > self.maxLength)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:self.maxLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                    NSInteger tempLenght = rangeRange.length > self.maxLength ? rangeRange.length - rangeIndex.length : rangeRange.length;
                    textField.text = [toBeString substringWithRange:NSMakeRange(0, tempLenght)];
                }
            }
        }
        
        // 回调
        if (self.limitBlock) {
            self.limitBlock();
        }
    }
}

@end
