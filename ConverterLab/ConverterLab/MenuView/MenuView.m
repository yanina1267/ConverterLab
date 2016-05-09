//
//  MenuView.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/8/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "MenuView.h"

#import "UIColor+ApplicationColors.h"

static CGFloat const ExpandedConstraintsConstant = 20.0;
static CGFloat const CollapsedButtonConstraintsConstant = -40.0;
static CGFloat const CollapsedLabelConstraintsConstant = -60.0;

@interface MenuView ()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *views;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *buttonConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *labelConstraints;
@end

@implementation MenuView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self rasterizeLayers];
    [self setupDefaults];
}

#pragma mark - IBActions

- (IBAction)menuButtonPressed:(UIButton *)sender
{
    self.menuButton.selected = !self.menuButton.selected;
    self.menuButton.backgroundColor = self.menuButton.selected ? [UIColor lightPinkColor] : [UIColor darkPinkColor];
    [self animateAppearance];
}

- (IBAction)callButtonPressed:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(menuViewDidAskForCall:)]) {
        [self.delegate menuViewDidAskForCall:self];
    }
}

- (IBAction)linkButtonPressed:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(menuViewDidAskToOpenLink:)]) {
        [self.delegate menuViewDidAskToOpenLink:self];
    }
}

- (IBAction)mapButtonPressed:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(menuViewDidAskToOpenMap:)]) {
        [self.delegate menuViewDidAskToOpenMap:self];
    }
}

#pragma mark - Private

- (void)setupDefaults
{
    for (NSLayoutConstraint *constraint in self.buttonConstraints) {
        constraint.constant = CollapsedButtonConstraintsConstant;
    }
    for (NSLayoutConstraint *constraint in self.labelConstraints) {
        constraint.constant = CollapsedLabelConstraintsConstant;
    }
    for (UIView *view in self.views) {
        view.layer.opacity = 0.0;
    }
}

#pragma mark - UIViewAnimations

- (void)animateAppearance
{
    CGFloat opacity = self.menuButton.selected ? 1.0 : 0.0;
    CGFloat buttonConstraintSize = self.menuButton.selected ? ExpandedConstraintsConstant : CollapsedButtonConstraintsConstant;
    CGFloat labelConstraintSize = self.menuButton.selected ? ExpandedConstraintsConstant : CollapsedLabelConstraintsConstant;
    
    for (NSLayoutConstraint *constraint in self.buttonConstraints) {
        constraint.constant = buttonConstraintSize;
    }
    for (NSLayoutConstraint *constraint in self.labelConstraints) {
        constraint.constant = labelConstraintSize;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *view in self.views) {
            view.layer.opacity = opacity;
        }
        self.backgroundColor = self.menuButton.selected ? [UIColor menuBackgroundColor] : [UIColor clearColor];
        if (!self.menuButton.selected) {
            [self layoutIfNeeded];
        }
    }];
    
    if (self.menuButton.selected) {
            [UIView animateWithDuration:0.5
                          delay:0.f
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self layoutIfNeeded];
                     } completion:nil];
    }
}

#pragma mark - Touches

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (self.menuButton.selected && [view isKindOfClass:[MenuView class]]) {
        return self;
    } else if (!self.menuButton.selected && [view isKindOfClass:[MenuView class]]) {
        return nil;
    } else {
        return view;
    }
}

#pragma mark - Optimizations

- (void)rasterizeLayers
{
    for (UIView *view in self.views) {
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
}

@end
