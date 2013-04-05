//
//  QWZViewController.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class QWZQuizSet;
@class QWZAnsweredQuizSet;

// QWZViewController can fill all 3 roles: view controller, data source, and delegate
// by implementing the following protocol: UITableViewDataSource and UITableViewDelegate.

// Implement UITableViewDelegate to set the label of the delete button
// Optional methods of the protocol allow the delegate to manage selections,
// configure section headings and footers, help to delete and reorder cells, and perform other actions...
@interface QWZQwizzleViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
    // This array stores all quiz sets
    NSMutableArray *allQuizSets;
    
    // This array stores all answered quiz sets
    NSMutableArray *allAnsweredQuizSets;
    
    // Handle the selected quiz tapped by the user
    QWZQuizSet *selectedQuiz;
}

- (void)submitAQwizzle:(QWZQuizSet *)qz;

- (void)fillOutAQwizzle:(QWZAnsweredQuizSet *)qzAnswers;

// A fetched results controller can read managed objects
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)loadQuizSet;

@end
