//
//  ListViewController.m
//  ClassTest
//
//  Created by rafica on 4/2/14.
//  Copyright (c) 2014 COMS. All rights reserved.
//

#import "ListViewController.h"
#import <CoreData/CoreData.h>
@interface ListViewController (){
    NSMutableArray *tableData;
    NSMutableArray *distanceList;
    UIAlertView *alert;

    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong) NSMutableArray *favorites;


@end

@implementation ListViewController

- (NSManagedObjectContext *) managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    
    }
    
    return context;

}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}




-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ClassTest"];
    self.favorites = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];


    
    
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
        
        
    }
    //NSLog(@"tabledata");
   // NSLog(@"%@",tableData);
    [[self tableView]reloadData];
    //NSLog(@"%@",self.sortedResults);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.sortedResults = appDelegate.sharedProperty;

    

   // NSLog(@"%@",self.sortedResults);


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

    static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //NSManagedObject *favorite =[self.favorites objectAtIndex:indexPath.row];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Like" forState:UIControlStateNormal];
    
    
   // button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"heart_love_favorite_outline-512.png"];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"favorite-98441_640.png"];
    
    [button setImage:buttonImageNormal forState:UIControlStateNormal];
   
    
    
    button.frame = CGRectMake(270.0f,5.0f,30.0f,30.0f);
    [cell addSubview:button];
    

    NSManagedObjectContext *moc = [self managedObjectContext];
    NSString *testEntityId = [[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSLog(@"entity id %@",testEntityId);
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"ClassTest" inManagedObjectContext:moc];
    fetch.predicate = [NSPredicate predicateWithFormat:@"id == %@", testEntityId];
    // NSArray *array = [moc executeFetchRequest:fetch error:nil];
    
    [fetch setPredicate:fetch.predicate];
    
    NSError *error;
    
    NSArray *objects = [moc executeFetchRequest:fetch error:&error];
    [button setSelected:NO];
    for(NSManagedObject *obj in objects){
        NSLog(@"matching id %@", obj);
        [button setSelected:YES];
        
        [button setImage:buttonImagePressed forState:UIControlStateSelected];
    }
    
    


    // Configure the cell...
    /*if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    */
    //double myDouble = [[distanceList objectAtIndex:indexPath.row] doubleValue];
   // int myInt = (int)(myDouble + (myDouble>0 ? 0.5 : -0.5));
    [cell.textLabel setText:[tableData objectAtIndex:indexPath.row]];
     
    //[cell.detailTextLabel setText:[NSString stringWithFormat:@"%d",myInt]];
    return cell;
}



- (void)aMethod:(id)sender
{
    
   
    
     NSManagedObjectContext *context = [self managedObjectContext];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];;

    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    UIButton *button = (UIButton*)sender;
    
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"heart_love_favorite_outline-512.png"];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"favorite-98441_640.png"];
    
    
    NSLog(@" %s", button.selected ? "true" : "false");
    if(!button.selected){
        
    
   [button setSelected:YES];
    [button setImage:buttonImagePressed forState:UIControlStateSelected];
        
    NSManagedObject *newFavorite = [NSEntityDescription insertNewObjectForEntityForName:@"ClassTest" inManagedObjectContext:context];
    
    [newFavorite setValue:[tableData objectAtIndex:indexPath.row] forKey:@"name"];
    [newFavorite setValue:[[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"vicinity"] forKey:@"vicinity"];
    [newFavorite setValue:[[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"id"];
    [newFavorite setValue:[[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"rating"] forKey:@"rating"];
    [newFavorite setValue:[[[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"types"] objectAtIndex:0] forKey:@"type"] ;
    
    
    NSDictionary *photoDict = [[[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"photos"] objectAtIndex:0];
    NSString *photoRef = [photoDict objectForKey:@"photo_reference"];
    NSString *url;
    if(photoRef){
        url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?photoreference=%@&key=%@&sensor=false&maxwidth=320", photoRef, @"AIzaSyDTxgToUPNt4Jm0yafQPaAXP_fiYXyMKiQ"];
    }
    else{
        url = NULL;
    }
    [newFavorite setValue:url forKey:@"url"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
    
    }
    else{
        
        /*
        [context deleteObject:[self.favorites objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Cant delete %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.favorites removeObjectAtIndex:indexPath.row];
        */
        
        
        
        NSManagedObjectContext *moc = [self managedObjectContext];
        NSString *testEntityId = [[self.sortedResults objectAtIndex:indexPath.row] objectForKey:@"id"];
        NSLog(@"entity id %@",testEntityId);
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        fetch.entity = [NSEntityDescription entityForName:@"ClassTest" inManagedObjectContext:moc];
        fetch.predicate = [NSPredicate predicateWithFormat:@"id == %@", testEntityId];
        // NSArray *array = [moc executeFetchRequest:fetch error:nil];
        
        [fetch setPredicate:fetch.predicate];
        
        NSError *error;
        
        NSArray *objects = [moc executeFetchRequest:fetch error:&error];

        for(NSManagedObject *obj in objects){
            NSLog(@"matching id %@", obj);
            [moc deleteObject:obj];
        }

        [button setSelected:NO];
        [button setImage:buttonImageNormal forState:UIControlStateNormal];
    
    }
    
    NSLog(@"Button clicked.");
    
    
    
    
    NSLog(@"changed state is..");
    
    NSLog(@" %s", button.selected ? "true" : "false");
        
    
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
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [context deleteObject:[self.favorites objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Cant delete %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.favorites removeObjectAtIndex:indexPath.row];
        
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
