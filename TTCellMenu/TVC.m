//
//  TVC.m
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/9/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import "TVC.h"


@interface TVC ()
@end

@implementation TVC
@synthesize topMenu = _topMenu;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)topItemSelected:(id)sender
{
    TTMenuItem *item = (TTMenuItem *)sender;
    [[[UIAlertView alloc] initWithTitle:@"Action triggered"
                                message:[NSString stringWithFormat:@"Triggered item %d", item.offset ]
                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
- (void)cellItemSelected:(id)sender
{
    TTMenuItem *item = (TTMenuItem *)sender;
    [[[UIAlertView alloc] initWithTitle:@"Action triggered"
                                message:[NSString stringWithFormat:@"Triggered item %d at row %d", item.offset, item.indexPath.row ]
                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (TTMenuItems *)setupTopMenuItems
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *args = [[NSArray alloc] initWithObjects:
                     @"black_cogs_icon&16", @"white_cogs_icon&16",@"Settings",
                     @"black_refresh_icon&16", @"white_refresh_icon&16",@"Refresh",
                     @"black_on-off_icon&16", @"white_on-off_icon&16",@"Logout",
                     nil];
    
    for( int i = 0; i < [args count]; i+=3 ){
        TTMenuItem *item = [[TTMenuItem alloc] init];
        UIImage *image = [UIImage imageNamed:[args objectAtIndex:i]];
        UIImage *imageHighlighted = [UIImage imageNamed:[args objectAtIndex:i+1]];
        [item setImage:image forState:UIControlStateNormal];
        [item setImage:imageHighlighted forState:UIControlStateHighlighted];
        [item setFrame:CGRectMake(0,0,100,image.size.height)];
        [item setOriginalSize:CGSizeMake(100, image.size.height)];
        item.offset = floor(i/3);
        //text
        [item setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [item.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [item setTitle:[args objectAtIndex:i+2] forState:UIControlStateNormal];
        [item setTitle:[args objectAtIndex:i+2] forState:UIControlStateHighlighted];
        item.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [item addTarget:self action:@selector(topItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:item];
    }
    TTMenuItems *items = [[TTMenuItems alloc]
                          initWithArrayOfButtons:array
                          withItemSize:CGSizeMake(100.0f,30.0f)
                          withItemMargins:CGSizeMake(0.0f,10.0f)];
    items.shouldHideOnDeselect = NO;
    return items;
}

//create the buttons for the cell menu
- (TTMenuItems *)setupCellItemsforIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *args = [[NSArray alloc] initWithObjects:
                     @"black_spechbubble_sq_icon&24", @"white_spechbubble_sq_icon&24",[UIColor colorWithRed:(236.0/255.0) green:(220.0/255.0) blue:0 alpha:1],
                     @"black_phone_1_icon&24", @"white_phone_1_icon&24",[UIColor orangeColor],
                     @"black_mail_2_icon&24", @"white_mail_2_icon&24",[UIColor redColor],
                     @"black_checkmark_icon&24", @"white_checkmark_icon&24",[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1],
                     nil];
    for( int i = 0; i < [args count]; i+=3 ){
        TTMenuItem *item = [[TTMenuItem alloc] init];
        UIImage *image = [UIImage imageNamed:[args objectAtIndex:i]];
        UIImage *imageHighlighted = [UIImage imageNamed:[args objectAtIndex:i+1]];
        [item setImage:image forState:UIControlStateNormal];
        [item setImage:imageHighlighted forState:UIControlStateHighlighted];
        [item setFrame:CGRectMake(0,0,image.size.width,image.size.height)];
        [item addTarget:self action:@selector(cellItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [item setOriginalSize:CGSizeMake(image.size.width, image.size.height)];
        item.offset = floor(i/2);
        item.indexPath = indexPath;
        item.backColor = (UIColor *)[args objectAtIndex:i+2];
        [array addObject:item];
    }
    TTMenuItems *items = [[TTMenuItems alloc]
                          initWithArrayOfButtons:array
                          withItemSize:CGSizeMake(50.0f,0)
                          withItemMargins:CGSizeMake(20.0f,0)];
    return items;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setup top menu and items
    self.topMenu = [[TTTopMenu alloc] init];
    self.topMenu.startThreshold = 90.0f;

   [self.topMenu setFrame:CGRectMake(0, -60.0f, self.tableView.frame.size.width, 60.0f)];//need the height
    self.topMenu.menuItems = [self setupTopMenuItems];    
    self.topMenu.backgroundColor = [UIColor blackColor];
    [self.tableView addSubview:self.topMenu];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(parentDidPan:)];
    pan.delegate = self;
    pan.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:pan];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//so you can pull and pan simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)parentDidPan:(UIPanGestureRecognizer *)recognizer
{
    [self.topMenu parentDidPan:recognizer];
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

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TTCell";
    TTCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TTMenuItems *items = [self setupCellItemsforIndexPath:indexPath];
    [cell setupWithItems:items];
    // Configure the cell...
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"Ended with velocity %@", NSStringFromCGPoint(velocity));
    //negative y means pulling down. Don't activate if pulled down too fast. Don't activate on up-push, unless very slight
    if( velocity.y < 0.1 && velocity.y > -0.3 )
        [self.topMenu.menuItems triggerActiveItem];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.topMenu TTMenuScrollViewDidScroll:scrollView];
}
@end
