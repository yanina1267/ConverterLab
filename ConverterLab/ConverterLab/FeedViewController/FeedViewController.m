//
//  FeedViewController.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/2/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "FeedViewController.h"
#import "DetailsViewController.h"
#import "MapViewController.h"

#import "FeedTableViewCell.h"

#import "NetworkManager.h"
#import "CoreDataManager.h"

static NSString *const BaseURLString = @"http://resources.finance.ua/ru/public/currency-cash.json";
static CGFloat const TopInset = 32.0;

@interface FeedViewController () <UISearchResultsUpdating, FeedTableViewCellDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NetworkManager *networkManager;
@property (strong, nonatomic) CoreDataManager *coreDataManager;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) Organization *selectedOrganization;

@end

@implementation FeedViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.coreDataManager = [CoreDataManager sharedInstance];
    
    [self addActivityIndicator];
    [self configureFetchResultController];
    [self loadDataFromServer];
    [self configureTableView];
    [self addSearchController];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FeedTableViewCell class]) forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - Server API

- (void)loadDataFromServer
{
    [self.activityIndicator startAnimating];
    self.networkManager = [[NetworkManager alloc] initWithBaseURLString:BaseURLString];
    [self.networkManager getDataWithComplitionHandler:^(NSDictionary *response) {
        [self.coreDataManager deleteObjects:self.fetchedResultsController.fetchedObjects];
        [self.coreDataManager createOrganizationsWithServerResponse:response];
        [self.coreDataManager saveContext];
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.searchBar.text.length) {
        [self.fetchedResultsController.fetchRequest  setPredicate:nil];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchController.searchBar.text];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    NSError *fetchError;
    [self.fetchedResultsController performFetch:&fetchError];
    if (fetchError) {
        NSLog(@"Can't fetch = %@", fetchError.localizedDescription);
    } else {
        NSLog(@"Fetched %lu objects", self.fetchedResultsController.fetchedObjects.count);
    }
    [self.tableView reloadData];
}

#pragma mark - FeedTableViewCellDelegate

- (void)feedCell:(FeedTableViewCell *)cell didAskToOpenLink:(NSString *)link
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (void)feedCell:(FeedTableViewCell *)cell didAskToOpenMapForAddress:(NSString *)address
{
    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MapViewController class])];
    controller.address = address;
    [self.navigationController showViewController:controller sender:self];
}

- (void)feedCell:(FeedTableViewCell *)cell didAskToCallToNumber:(NSString *)number
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)feedCell:(FeedTableViewCell *)cell didAskToShowDetailsForOrganization:(Organization *)organization
{
    self.selectedOrganization = organization;
    [self performSegueWithIdentifier:NSStringFromClass([DetailsViewController class]) sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DetailsViewController class]]) {
        DetailsViewController *controller = segue.destinationViewController;
        controller.organization = self.selectedOrganization;
    }
}

#pragma mark - Private

- (void)configureTableView
{
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
}

- (void)configureCell:(FeedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    Organization *organization = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [cell configureCellWithOrganization:organization];
}

- (void)configureFetchResultController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Organization"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.coreDataManager.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *fetchError;
    [self.fetchedResultsController performFetch:&fetchError];
    NSLog(@"Array");
    if (fetchError) {
        NSLog(@"Can't fetch = %@", fetchError.localizedDescription);
    } else {
        NSLog(@"Fetched %lu objects", self.fetchedResultsController.fetchedObjects.count);
    }
}

- (void)addActivityIndicator
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.tableView addSubview:self.activityIndicator];

    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-TopInset]];
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    self.activityIndicator.color = [UIColor grayColor];
    [self.tableView addSubview:self.activityIndicator];
}

- (void)addSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.definesPresentationContext = true;
}

- (IBAction)searchButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.tableView.tableHeaderView = sender.selected ? self.searchController.searchBar : nil;
}

@end
