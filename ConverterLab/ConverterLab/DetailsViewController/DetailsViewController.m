//
//  DetailsViewController.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/8/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "DetailsViewController.h"
#import "MapViewController.h"

#import "DetailsViewControllerDetailCell.h"
#import "DetailsViewControllerCurrencyCell.h"
#import "MenuView.h"
#import "ShareView.h"

#import "Organization.h"

static NSString *const Identifier = @"Cell";

@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate, MenuViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MenuView *menuView;

@property (strong, nonatomic) ShareView *shareView;

@end

@implementation DetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 2: {
            return self.organization.currencies.count;
        }
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            DetailsViewControllerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailsViewControllerDetailCell class]) forIndexPath:indexPath];
            [cell configureCellWithOrganization:self.organization];
            return cell;
        }
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
            return cell;
        }
        case 2: {
            DetailsViewControllerCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailsViewControllerCurrencyCell class]) forIndexPath:indexPath];
            [cell configureCellWithCurrency:self.organization.currencies.allObjects[indexPath.row]];
            return cell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == self.organization.currencies.count - 1) {
        DetailsViewControllerCurrencyCell *currencyCell = (DetailsViewControllerCurrencyCell *)cell;
        [currencyCell addShadow];
    }
}

#pragma mark - MenuViewDelegate

- (void)menuViewDidAskForCall:(MenuView *)menuView
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.organization.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)menuViewDidAskToOpenLink:(MenuView *)menuView
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.organization.link]];
}

- (void)menuViewDidAskToOpenMap:(MenuView *)menuView
{
    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MapViewController class])];
    controller.address = [self.organization fullAddress];
    [self.navigationController showViewController:controller sender:self];
}

#pragma mark - Private

- (void)configureTableView
{
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
}

- (IBAction)sharedButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.shareView = [[ShareView alloc] initWithParentView:self.view organization:self.organization];
        __weak typeof(self) weakSelf = self;
        self.shareView.shareBlock = ^{
            [weakSelf showActivityViewController];
        };
    } else {
        [self.shareView removeFromParentViewWithCompletion:^{
            self.shareView = nil;
        }];
    }
}

- (void)showActivityViewController
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.organization.link] applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityViewController animated:YES completion:nil];
}


@end
