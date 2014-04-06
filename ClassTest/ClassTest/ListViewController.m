//
//  ListViewController.m
//  ClassTest
//
//  Created by rafica on 4/2/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController (){
    NSMutableArray *tableData;
    NSMutableArray *distanceList;
    UIAlertView *alert;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ListViewController

    


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated{
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    
    if(!self.sortedResults||!self.sortedResults.count){
        alert= [[UIAlertView alloc] initWithTitle:@"No search made" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
 
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.sortedResults = appDelegate.sharedProperty;
    tableData =  [[NSMutableArray alloc] init];
    distanceList = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[self.sortedResults count];i++)
    {
        
        [tableData addObject:[[self.sortedResults objectAtIndex:i] valueForKey:@"name"]];
        
        [distanceList addObject:[[self.sortedResults objectAtIndex:i] valueForKey:@"distance"]];
        NSLog(@"%@", [[self.sortedResults objectAtIndex:i] valueForKey:@"distance"]);
        
        
        
    }
    NSLog(@"tabledata");
    NSLog(@"%@",tableData);
    [[self tableView]reloadData];
    NSLog(@"%@",self.sortedResults);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.sortedResults = appDelegate.sharedProperty;
    NSLog(@"didload");
    

   // NSLog(@"%@",self.sortedResults);

   


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
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",tableData);
    static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    /*if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    */
    double myDouble = [[distanceList objectAtIndex:indexPath.row] doubleValue];
    int myInt = (int)(myDouble + (myDouble>0 ? 0.5 : -0.5));
    [cell.textLabel setText:[tableData objectAtIndex:indexPath.row]];
     
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d",myInt]];
    return cell;
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    dvc.name = [[self.sortedResults objectAtIndex:indexPath.row] valueForKey:@"name"];
    dvc.vicinity = [[self.sortedResults objectAtIndex:indexPath.row] valueForKey:@"vicinity"];
    NSArray *typeArray = [[self.sortedResults objectAtIndex:indexPath.row] valueForKey:@"types"];
    dvc.type = typeArray[0];
    NSNumber *ratingn = [[self.sortedResults objectAtIndex:indexPath.row] valueForKey:@"rating"];
    dvc.rating = [ratingn stringValue];
    NSDictionary *photoDict = [[[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"photos"] objectAtIndex:0];
    NSString *photoRef = [photoDict objectForKey:@"photo_reference"];
    if(photoRef){
        dvc.url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?photoreference=%@&key=%@&sensor=false&maxwidth=320", photoRef, @"AIzaSyDTxgToUPNt4Jm0yafQPaAXP_fiYXyMKiQ"];
    }
    else{
        dvc.url = NULL;
    }
    
   // [self.navigationController pushViewController:dvc animated:YES];
    
    
    //[self performSegueWithIdentifier:@"Details1" sender:tableView];
} */

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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *dvc = segue.destinationViewController;
       
        
        dvc.name = [[self.sortedResults objectAtIndex:indexPath.row] valueForKey:@"name"];
        dvc.vicinity = [[self.sortedResults objectAtIndex:indexPath.row] valueForKey:@"vicinity"];
        NSArray *typeArray = [[self.sortedResults objectAtIndex:indexPath.row] valueForKey:@"types"];
        dvc.type = typeArray[0];
        NSNumber *ratingn = [[self.sortedResults objectAtIndex:indexPath.row] valueForKey:@"rating"];
        dvc.rating = [ratingn stringValue];
        NSDictionary *photoDict = [[[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"photos"] objectAtIndex:0];
        NSString *photoRef = [photoDict objectForKey:@"photo_reference"];
        if(photoRef){
            dvc.url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?photoreference=%@&key=%@&sensor=false&maxwidth=320", photoRef, @"AIzaSyDTxgToUPNt4Jm0yafQPaAXP_fiYXyMKiQ"];
        }
        else{
            dvc.url = NULL;
        }
        NSLog(@"%@",dvc.name);
        NSLog(@"%@",dvc.vicinity);
    }
}



@end
