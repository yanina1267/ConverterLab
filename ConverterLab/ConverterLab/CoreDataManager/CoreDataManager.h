//
//  CoreDataManager.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/2/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)createOrganizationsWithServerResponse:(NSDictionary *)response;
- (void)deleteObjects:(NSArray<NSManagedObject *> *)objects;

@end
