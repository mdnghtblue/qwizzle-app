//
//  QWZQuizEntity.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/5/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QWZQuizSetEntity;

@interface QWZQuizEntity : NSManagedObject

@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) QWZQuizSetEntity *containedBy;

@end
