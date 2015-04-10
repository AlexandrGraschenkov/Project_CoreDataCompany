//
//  ViewController.m
//  TestCoreDatadsfsdfsdf
//
//  Created by Alexander on 02.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"
#import "DetailViewController.h"

@interface ViewController ()
{
    NSArray *organizations;
    NSIndexPath *updateIdxPath;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (updateIdxPath) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[updateIdxPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        updateIdxPath = nil;
    }
}

#pragma mark -
- (void)reloadData {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Organization"];
    req.fetchBatchSize = 20;
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSManagedObjectContext *moc = [[CoreDataManager shared] managedObjectContext];
    organizations = [moc executeFetchRequest:req error:nil];
    [self.tableView reloadData];
}

#pragma mark - Actions
- (IBAction)addOrganization:(id)sender {
    NSManagedObjectContext *moc = [CoreDataManager shared].managedObjectContext;
    Organization *org = [NSEntityDescription insertNewObjectForEntityForName:@"Organization" inManagedObjectContext:moc];
    
    organizations = [organizations arrayByAddingObject:org];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:organizations.count - 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self performSegueWithIdentifier:@"Detail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"Detail"]) {
        DetailViewController *detail = [segue destinationViewController];
        updateIdxPath = [self.tableView indexPathForSelectedRow];
        detail.org = organizations[updateIdxPath.row];
    }
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return organizations.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrgCell"];
    
    Organization *org = organizations[indexPath.row];
    cell.textLabel.text = org.name;
    return cell;
}
@end
