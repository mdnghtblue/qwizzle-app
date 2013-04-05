//
//  QWZQuizSetEntity.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/5/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QWZQuizEntity;

@interface QWZQuizSetEntity : NSManagedObject

@property (nonatomic, retain) NSString *creator;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSSet *contains;
@end

@interface QWZQuizSetEntity (CoreDataGeneratedAccessors)

- (void)addContainsObject:(QWZQuizEntity *)value;
- (void)removeContainsObject:(QWZQuizEntity *)value;
- (void)addContains:(NSSet *)values;
- (void)removeContains:(NSSet *)values;

@end
