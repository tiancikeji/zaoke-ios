//
//  LocationPickerViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-22.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "LocationPickerViewController.h"
#import "UIImage+StackBlur.h"
@interface LocationPickerViewController ()

@end

@implementation LocationPickerViewController {
	NSMutableArray *locations;
	UIView *topView;
	UIButton *cancelBtn;
	UITableView *tableView;
	UIImageView *blurView;
}

- (LocationPickerViewController *)initWithImage:(UIImage *)img{
    self = [super init];
    if (self) {
		self.view.frame = [[UIApplication sharedApplication].delegate window].bounds;
		UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
		imgView.frame = [[UIApplication sharedApplication].delegate window].bounds;
		[self.view addSubview:imgView];

		blurView = [[UIImageView alloc] initWithImage:[img stackBlur:10]];
		blurView.frame = imgView.frame;
		blurView.alpha = 0;
		UIView *white = [[UIView alloc] initWithFrame:imgView.frame];
		white.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
		[blurView addSubview:white];
		[self.view addSubview:blurView];

		tableView = [[UITableView alloc] initWithFrame:imgView.frame style:UITableViewStylePlain];
		tableView.y = self.view.height;
		tableView.height = self.view.height-44+SIZE_FIXHEIGHT;
		tableView.dataSource = self;
		tableView.delegate = self;
		[self.view addSubview:tableView];

		locations = [[NSMutableArray alloc] init];
		__block NSMutableArray *blockArr = locations;
		[[ZaokeRequest sharedInstance] requestGETAPI:@"/client/pick/list"
											postData:nil success:^(id result) {
												for (NSDictionary *one in [result valueForKey:@"pick_locs"]) {
													for (NSDictionary *two in [one valueForKey:@"pick_loc_list"]) {
														for (NSDictionary *three in [two valueForKey:@"pick_loc_list"]) {
															[blockArr addObject:three];
														}
													}
												}
												[tableView reloadData];
											} failed:^(id result, NSError *error) {
												[AppUtil error:@"获取地址列表失败!"];
											}];
		[self addTopbar];
		topView.y = self.view.height;
		[UIView animateWithDuration:.3 animations:^{
			topView.y = 0;
			blurView.alpha = 1;
			tableView.y = 44+SIZE_FIXHEIGHT;
		}];
    }
    return self;
}

- (void)addTopbar{
	topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44+SIZE_FIXHEIGHT)];
	topView.backgroundColor = [COLOR_ORANGE colorWithAlphaComponent:.8];
	[self.view addSubview:topView];

	cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelBtn.frame = CGRectMake(320-44, SIZE_FIXHEIGHT, 44, 44);
	[cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
	[cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	[topView addSubview:cancelBtn];

	UILabel *cnNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, SIZE_FIXHEIGHT+9, 320-88, 23)];
	cnNameLabel.text = @"选择地址";
	cnNameLabel.textColor = [UIColor whiteColor];
	cnNameLabel.backgroundColor = [UIColor clearColor];
	cnNameLabel.textAlignment = NSTextAlignmentCenter;
	cnNameLabel.font = [UIFont systemFontOfSize:22];
	cnNameLabel.minimumScaleFactor = .1;
	cnNameLabel.adjustsFontSizeToFitWidth = YES;
	cnNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
	cnNameLabel.layer.shadowOffset = CGSizeMake(0, 1);
	cnNameLabel.layer.shadowOpacity = .3;
	cnNameLabel.layer.shadowRadius = 1;
	[topView addSubview:cnNameLabel];
}

- (void)cancel{
	[UIView animateWithDuration:.3 animations:^{
		blurView.alpha = 0;
		tableView.y = self.view.height;
		topView.y = self.view.height;
	} completion:^(BOOL finished) {
		[self dismissViewControllerAnimated:NO completion:nil];
	}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell==nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = [[locations objectAtIndex:indexPath.row] valueForKey:@"pick_loc_name"];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[_delegate selectLocation:[locations objectAtIndex:indexPath.row]];
	[self cancel];
}

@end
