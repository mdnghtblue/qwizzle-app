//
//  QWZViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZQwizzleViewController.h"

#import "QWZQuiz.h"
#import "QWZQuizSet.h"
#import "QWZAnsweredQuizSet.h"
#import "QWZCreateQwizzleViewController.h"
#import "QWZTakeQwizzleViewController.h"
#import "QWZViewQwizzleViewController.h"

// To get all Core Data Related Stuffs
#import "QWZAppDelegate.h"

// All Core Data entities
#import "QWZAnsweredQuizEntity.h"
#import "QWZAnsweredQuizSetEntity.h"
#import "QWZQuizEntity.h"
#import "QWZQuizSetEntity.h"

@interface QWZQwizzleViewController ()

@end

@implementation QWZQwizzleViewController

#pragma mark - Default App's Behavior
// Implement this method if there is anything needed to be configured before the view is loaded for the first time
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Loading sample data
    // Initialize the 2 quiz sets here
    allQuizSets = [[NSMutableArray alloc] init];
    allAnsweredQuizSets = [[NSMutableArray alloc] init];
    
    // Add hard-coded question set here
    QWZQuiz *q1 = [[QWZQuiz alloc] initWithQuestion:@"What is your name?"];
    QWZQuiz *q2 = [[QWZQuiz alloc] initWithQuestion:@"What is your lastname?"];
    
    QWZQuizSet *qs1 = [[QWZQuizSet alloc] initWithTitle:@"Identity Quiz Set"];
    [qs1 addQuiz:q1];
    [qs1 addQuiz:q2];
    
    QWZQuizSet *qs2 = [[QWZQuizSet alloc] initWithTitle:@"Identity Quiz Set 2"];
    [qs2 addQuiz:q1];
    
    QWZQuiz *q3 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite color?" answer:@"Green"];
    QWZQuiz *q4 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite food?" answer:@"Fried Rice"];
    QWZQuiz *q5 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite sport?" answer:@"Table Tennis"];
    QWZAnsweredQuizSet *aqs1 = [[QWZAnsweredQuizSet alloc] initWithTitle:@"Favourite Quiz Set"];
    [aqs1 addQuiz:q3];
    [aqs1 addQuiz:q5];
    [aqs1 addQuiz:q4];
    
    
    [allQuizSets addObject:qs1];
    [allQuizSets addObject:qs2];
    [allAnsweredQuizSets addObject:aqs1];
    
    // Core Data Stuffs
    /* Create the fetch request first */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    /* Here is the entity whose contents we want to read */
    NSEntityDescription *quizSetEntity = [NSEntityDescription entityForName:@"QWZQuizSetEntity"
                                              inManagedObjectContext:[self managedObjectContext]];
    
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
    //NSSortDescriptor *titleSort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dateSort, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    /* Tell the request that we want to read the contents of the Person entity */
    [fetchRequest setEntity:quizSetEntity];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *fetchingError = nil;
    if ([self.fetchedResultsController performFetch:&fetchingError]) {
        NSLog(@"Successfully fetched.");
    } else {
        NSLog(@"Failed to fetch.");
    }
    
}

- (void)loadQuizSet
{
    /* Create the fetch request first */
    // a fetch request is similar to a SELECT statement
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    /* Here is the entity whose contents we want to read */
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QWZQuizSetEntity"
                                              inManagedObjectContext:[self managedObjectContext]];
    
    /* Tell the request that we want to read the contents of the Person entity */
    [fetchRequest setEntity:entity];
    
    // Adding sort descriptor to sort the fetched data
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
    //NSSortDescriptor *titleSort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dateSort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *requestError = nil;
    
    /* And execute the fetch request on the context */
    NSArray *quizSet = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&requestError];
    
    if ([quizSet count] > 0) {
        NSLog(@"Successfully loaded all quizSet...");
        NSLog(@"There are %d quizSet inside the core data", [quizSet count]);
        
        NSUInteger counter = 1;
        for (QWZQuizSetEntity *thisQuizSet in quizSet) {
            NSLog(@"%d) QuizSet's title: %@", counter, [thisQuizSet title]);
            
            NSLog(@"There are %d quiz inside this quizSet!", [[[thisQuizSet contains] allObjects] count]);
            
            counter++;
        }
    } else {
        NSLog(@"Could not find any Person entities in the context.");
    }

}

// Implement this method if there is anything needed to be configure before the view appear on-screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
    
    [self loadQuizSet];
}

- (void)submitAQwizzle:(QWZQuizSet *)qz
{
    NSLog(@"a qwizzle has been submitted!! %@", qz);
    NSLog(@"There are %d questions for %@", [[qz allQuizzes] count], [qz title]);
    [allQuizSets addObject:qz];
    
    // Adding new Qwizzle (unanswer qwizzle) into the table, this set reside in the section 0
    NSInteger lastRow = [allQuizSets indexOfObject:qz];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert this Qwizzle into the table
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
    
    // Updating Core Data
    // Getting the App's delegate from the singleton application instance
    QWZAppDelegate *appDelegate = (QWZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Getting the managedObjectContext
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    // Creating new QuizSetEntity and save it into the context
    QWZQuizSetEntity *newQuizSet = [NSEntityDescription insertNewObjectForEntityForName:@"QWZQuizSetEntity" inManagedObjectContext:managedObjectContext];
    
    if (newQuizSet != nil) {
        [newQuizSet setTitle:[qz title]];
        [newQuizSet setCreator:[qz creator]];
        [newQuizSet setDateCreated:[qz dateCreated]];
        
        NSError *savingError = nil;
        if ([managedObjectContext save:&savingError]) {
            NSLog(@"Successfully add a new quizset: %@", newQuizSet);
        } else {
            NSLog(@"Failed to save the managed object context");
        }
    }
    else {
        NSLog(@"Failed to create the new person object");
    }
    
    // Adding quizzes into the QuizSetEntity
    QWZQuizEntity *newQuiz = nil;
    //[newQuiz setQuestion:[qz]]
    NSArray *allQuizzes = [qz allQuizzes];
    for (NSInteger i = 0; i < [allQuizzes count]; i++) {
        newQuiz = [NSEntityDescription insertNewObjectForEntityForName:@"QWZQuizEntity" inManagedObjectContext:managedObjectContext];
        [newQuiz setQuestion:[[allQuizzes objectAtIndex:i] question]];
        [newQuiz setDateCreated:[[allQuizzes objectAtIndex:i] dateCreated]];
        [newQuiz setContainedBy:newQuizSet];
        
        NSError *savingError = nil;
        if ([managedObjectContext save:&savingError]) {
            NSLog(@"Successfully add a new quiz: %@ into %@", newQuiz, newQuizSet);
        } else {
            NSLog(@"Failed to save the managed object context");
        }
    }
}

- (void)fillOutAQwizzle:(QWZAnsweredQuizSet *)qzAnswers
{
    NSLog(@"submitting qwizzle answers!");
    [allAnsweredQuizSets addObject:qzAnswers];
    
    NSInteger lastRow = [allAnsweredQuizSets indexOfObject:qzAnswers];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:1];
    
    // Insert the new Qwizzle answers into the table
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                            withRowAnimation:UITableViewRowAnimationTop];
    
    // Remove the quizset from the your Qwizzle section
    NSInteger selectedRow = [allQuizSets indexOfObject:selectedQuiz];
    NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:selectedRow inSection:0]; 
    [allQuizSets removeObjectIdenticalTo:selectedQuiz];
    
    // Remove the cell from the table
    [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Handle table view datasource
// One of the required method needed to be implemented to use UITableViewController
// - return a cell at the given index
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // We can ignore this stuff, it's just that everybody is doing this when they use UITableView
    static NSString *QWizzleCellIdentifier = @"QWizzleCell";
    
    // Check for a reusable cell first, use that if it exists
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:QWizzleCellIdentifier];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:QWizzleCellIdentifier];
    }
    
    
    // Set the text on the cell with the desciption of the item
    // We need to get the cell from the correct section here
    NSInteger section = [indexPath section];
    if (section == 0) { 
        QWZQuizSet *qs = [allQuizSets objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
    }
    else {
        QWZAnsweredQuizSet *qs = [allAnsweredQuizSets objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
    }
    
    return cell;
}

// Krissada: One of the required method needed to be implemented to use UITableViewController
// return the number rows given a section number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Krissada: we need to get the correct number associated with the given section here
    NSInteger row = 0;
    if (section == 0) {
        row = [allQuizSets count];
    }
    else {
        row = [allAnsweredQuizSets count];
    }

    // Return the number of rows in the section.
    return row;
}

#pragma mark handling multiple section
// The table view needs to know how many sections it should expect.
// Krissada: we have exactly 2 sections here - an unanswer set and an answered quiz set
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// We have to get the correct title for each section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Your Qwizzles";
    }
    else {
        return @"Qwizzles You've Taken";
    }
}

#pragma mark - Table view delegate
// Implement this method to response when the user is tapping any row
// Basically it should switch to another view and load all the corresponding information
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here.
    NSInteger section = [indexPath section];
    if (section == 0) {
        selectedQuiz = [allQuizSets objectAtIndex:[indexPath row]];
        
        // Perform a segue (a view's transition) given a storyboard segue's ID that we specified in storyboard
        // We need to do it this way because our data cells are dynamically generated, so we can't pre-wire them.
        // Note: (A segue is a path between each screen, we can click at the path to see its ID)
        [self performSegueWithIdentifier:@"SEGUETakeQwizzle" sender:self];
    }
    else if (section == 1) {
        selectedQuiz = [allAnsweredQuizSets objectAtIndex:[indexPath row]];
        
        [self performSegueWithIdentifier:@"SEGUEViewQwizzle" sender:self];
    }
    else {
        
    }
}

// This method get called automatically when we're moving to the other view in the storyboard
// All we have to do is the implement it.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"SEGUETakeQwizzle"])
    {
        // Get the destination's view controller (User is taking a Qwizzle)
        QWZTakeQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setQuizSet:selectedQuiz];
        [destinationViewController setOrigin:self];
    }
    else if ([segue.identifier isEqualToString:@"SEGUEViewQwizzle"]){
        // Get the destination's view controller (User is viewing a Qwizzle)
        QWZViewQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setQuizSet:selectedQuiz];
    }
    else if ([segue.identifier isEqualToString:@"SEGUECreateQwizzle"]) {
        QWZCreateQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setOrigin:self];
    }
    else {
        NSLog(@"Unidentifiable Segue");
    }
}

// Krissada: implement this method if there is anything needed to be done if receive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark managedObjectContext stuffs
// Get the managedObjectContext from the app delegate
- (NSManagedObjectContext *)managedObjectContext
{
    QWZAppDelegate *appDelegate = (QWZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    return managedObjectContext;
}

@end
