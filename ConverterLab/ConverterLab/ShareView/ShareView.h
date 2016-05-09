//
//  ShareView.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/9/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Organization;

@interface ShareView : UIView

@property (copy, nonatomic) void(^shareBlock)();

- (instancetype)initWithParentView:(UIView *)parentView organization:(Organization *)organization;
- (void)removeFromParentViewWithCompletion:(void(^)())completion;

@end
