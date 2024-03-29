//
//  AppDelegate.h
//  BaiduRadarScan
//
//  Created by zhanglei on 15/11/17.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> 
#import <BaiduMapAPI/BMapKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

