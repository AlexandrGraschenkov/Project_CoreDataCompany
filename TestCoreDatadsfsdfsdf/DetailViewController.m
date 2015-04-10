//
//  DetailViewController.m
//  TestCoreDatadsfsdfsdf
//
//  Created by Alexander on 02.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "DetailViewController.h"
#import "EmployeDetailController.h"

@interface DetailViewController () <UITextFieldDelegate, NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *employerController;
}
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UILabel *employersCountLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employe"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:true], [NSSortDescriptor sortDescriptorWithKey:@"last_name" ascending:true]];
    request.predicate = [NSPredicate predicateWithFormat:@"organization == %@", self.org];
    request.fetchBatchSize = 20;
    employerController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[CoreDataManager shared].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    employerController.delegate = self;
    NSError *err = nil;
    [employerController performFetch:&err];
    if (err != nil) {
        NSLog(@"Error fetch %@", err);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.nameField.text = self.org.name;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.org.name = self.nameField.text;
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self.org.managedObjectContext save:nil];
    }
}

#pragma mark - Actions
- (IBAction)insertEmploye:(id)sender {
    NSManagedObjectContext *context = [employerController managedObjectContext];
    NSEntityDescription *entity = [[employerController fetchRequest] entity];
    Employe *emp = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [self.org addEmployersObject:emp];
    [self performSegueWithIdentifier:@"AddEmploye" sender:emp];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"ShowEmploye"] || [segue.identifier isEqual:@"AddEmploye"]) {
        EmployeDetailController *vc = segue.destinationViewController;
        if ([segue.identifier isEqual:@"AddEmploye"]) {
            vc.employe = sender;
        } else {
            vc.employe = [employerController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[employerController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [employerController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [employerController managedObjectContext];
        [context deleteObject:[employerController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Employe *object = [employerController objectAtIndexPath:indexPath];
    cell.textLabel.text = object.fullName;
    cell.imageView.image = object.avatar;
}

#pragma mark - Fetch controller
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    NSInteger count = [[[employerController sections] firstObject] numberOfObjects];
    self.employersCountLabel.text = [NSString stringWithFormat:@"Сотрудники: %ld", count];
}


#pragma mark - Text field delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
