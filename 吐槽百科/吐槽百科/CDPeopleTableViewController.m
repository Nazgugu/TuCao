//
//  CDPeopleTableViewController.m
//  PeerChina
//
//  Created by Liu Zhe on 7/24/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDPeopleTableViewController.h"
#import "CDSingleton.h"
#import "CDPeople.h"
#import "CDTableViewCell.h"
#import "UIColor+FlatUI.h"

@interface CDPeopleTableViewController ()

@end

@implementation CDPeopleTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CDTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"peopleCell"];
    self.view.backgroundColor = [[UIColor colorFromHexCode:@"59BAF3"] colorWithAlphaComponent:0.8f];
    self.tableView.backgroundColor = [[UIColor colorFromHexCode:@"59BAF3"] colorWithAlphaComponent:0.8f];
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [CDSingleton globalData].people.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peopleCell" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[CDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"peopleCell"];
    }
    cell.backgroundColor = [[UIColor colorFromHexCode:@"59BAF3"] colorWithAlphaComponent:0.8f];
    CDPeople *person = [[CDSingleton globalData].people objectAtIndex:indexPath.row];
    NSString *nameString = [[NSString stringWithFormat:@"%ld",(long)person.avatarNumber] stringByAppendingString:@"a"];
    // Configure the cell...
    cell.image.image = [UIImage imageNamed:nameString];
    cell.name.text = person.name;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
