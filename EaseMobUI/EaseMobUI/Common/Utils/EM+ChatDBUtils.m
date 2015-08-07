//
//  EM+ChatDBUtils.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/7.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatDBUtils.h"
#import "EM+ChatFileUtils.h"
#import "EM_ChatConversation.h"
#import "EM_ChatEmoji.h"

#import <CoreData/CoreData.h>

@interface EM_ChatDBUtils()

@property (nonatomic, strong) NSManagedObjectModel *chatManagedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *chatManagedObjectContext;

@property (nonatomic, strong) NSManagedObjectModel *fileManagedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *fileManagedObjectContext;

@end

@implementation EM_ChatDBUtils

+ (instancetype)shared{
    static EM_ChatDBUtils *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EM_ChatDBUtils alloc] init];
    });
    return _sharedClient;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                 nil];
        
        self.chatManagedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"EM_ChatModel" withExtension:@"momd"]];
        
        NSError *error = nil;
        NSPersistentStoreCoordinator *chatPsc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.chatManagedObjectModel];
        NSPersistentStore *store = [chatPsc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:kChatDBChatPath] options:options error:&error];
        if (!store) {
            [NSException raise:@"添加聊天数据库错误" format:@"%@", [error localizedDescription]];
        }
        self.chatManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        self.chatManagedObjectContext.persistentStoreCoordinator = chatPsc;
        
    }
    return self;
}

- (EM_ChatConversation *)insertNewConversation{
    EM_ChatConversation *conversation = [NSEntityDescription insertNewObjectForEntityForName:[EM_ChatConversation entityForName] inManagedObjectContext:self.chatManagedObjectContext];
    return conversation;
}

- (void)deleteConversationWithChatter:(EM_ChatConversation *)conversation{
    if (!conversation) {
        return;
    }
    [self.chatManagedObjectContext deleteObject:conversation];
}

- (EM_ChatConversation *)queryConversationWithChatter:(NSString *)chatter{
    NSEntityDescription *entity = [NSEntityDescription entityForName:[EM_ChatConversation entityForName] inManagedObjectContext:self.chatManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%@'",FIELD_NAME_CHATTER,chatter]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs[0];
}

- (EM_ChatEmoji *)insertNewEmoji{
    EM_ChatEmoji *emoji = [NSEntityDescription insertNewObjectForEntityForName:[EM_ChatEmoji entityForName] inManagedObjectContext:self.chatManagedObjectContext];
    return emoji;
}

- (void)deleteEmoji:(EM_ChatEmoji *)emoji{
    if (!emoji) {
        return;
    }
    [self.chatManagedObjectContext deleteObject:emoji];
}

- (NSArray *)queryEmoji{
    NSEntityDescription *entity = [NSEntityDescription entityForName:[EM_ChatEmoji entityForName] inManagedObjectContext:self.chatManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs;
}

- (EM_ChatEmoji *)queryEmoji:(NSString *)emoji{
    NSEntityDescription *entity = [NSEntityDescription entityForName:[EM_ChatEmoji entityForName] inManagedObjectContext:self.chatManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%@'",FIELD_NAME_EMOJI,emoji]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs[0];
}

- (void)processPendingChangesChat{
    [self.chatManagedObjectContext processPendingChanges];
}

- (BOOL)saveChat{
    __block NSError *error = nil;
    __block BOOL save = NO;
    if (self.chatManagedObjectContext.hasChanges) {
        [self.chatManagedObjectContext performBlock:^{
            save = [self.chatManagedObjectContext save:&error];
        }];
    }
    return save && !error;
}

@end