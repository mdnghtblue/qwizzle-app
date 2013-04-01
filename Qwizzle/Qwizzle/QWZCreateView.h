//
//  QWZCreateView.h
//  QWZ-App
//
//  Created by Oun AL Sayed on 3/25/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QWZCreateView : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)createQuiz:(id)sender;

@end
