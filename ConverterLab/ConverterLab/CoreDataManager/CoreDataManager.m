//
//  CoreDataManager.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/2/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "CoreDataManager.h"
#import "Organization.h"
#import "Currency.h"

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Life cycle

+ (instancetype)sharedInstance
{
    static CoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - Public

- (void)createOrganizationsWithServerResponse:(NSDictionary *)response
{
    NSArray *allOrganizations = response[@"organizations"];
    NSDictionary *cities = response[@"cities"];
    NSDictionary *regions = response[@"regions"];
    NSDictionary *currencyTitles = response[@"currencies"];
    
    for (NSDictionary *organiz in allOrganizations) {
        Organization *organization = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Organization class]) inManagedObjectContext:self.managedObjectContext];
        organization.title = organiz[@"title"];
        organization.address = organiz[@"address"];
        organization.link = organiz[@"link"];
        organization.phone = organiz[@"phone"];
        organization.city = cities[organiz[@"cityId"]];
        organization.region = regions[organiz[@"regionId"]];
        NSDictionary *currencies = organiz[@"currencies"];
        
        NSMutableSet *currenciesSet = [NSMutableSet setWithCapacity:currencies.count];
        [currencies enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            Currency *currency = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Currency class]) inManagedObjectContext:self.managedObjectContext];
            currency.title = currencyTitles[key];
            currency.isoCode = key;
            currency.ask = obj[@"ask"];
            currency.bid = obj[@"bid"];
            [currenciesSet addObject:currency];
        }];
        [organization addCurrencies:currenciesSet];
    }
}

- (void)deleteObjects:(NSArray<NSManagedObject *> *)objects
{
    for (NSManagedObject *object in objects) {
        [object.managedObjectContext deleteObject:object];
    }
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ConverterLab" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ConverterLab.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

@end
