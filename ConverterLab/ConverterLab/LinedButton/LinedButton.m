//
//  LinedButton.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/2/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "LinedButton.h"

#import "UIColor+ApplicationColors.h"

@interface LinedButton ()

@property (strong, nonatomic) UIView *underline;

@end

@implementation LinedButton

#pragma mark - Life cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addUnderline];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.underline.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - CGRectGetHeight(self.underline.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 10.0);
}

#pragma mark - Accessors

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.underline.hidden = !highlighted;
}

#pragma mark - Private

- (void)addUnderline
{
    self.underline = [[UIView alloc] init];
    self.underline.backgroundColor = [UIColor applicationPinkColor];
    self.underline.hidden = YES;
    [self addSubview:self.underline];
}

@end
