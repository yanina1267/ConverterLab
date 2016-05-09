//
//  MenuView.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/8/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuView;

@protocol MenuViewDelegate <NSObject>

- (void)menuViewDidAskForCall:(MenuView *)menuView;
- (void)menuViewDidAskToOpenLink:(MenuView *)menuView;
- (void)menuViewDidAskToOpenMap:(MenuView *)menuView;

@end

@interface MenuView : UIView

@property (weak, nonatomic) IBOutlet id<MenuViewDelegate> delegate;

@end

