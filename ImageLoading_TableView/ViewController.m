//
//  ViewController.m
//  ImageLoading_TableView
//
//  Created by Urvashi Lathiya on 12/30/16.
//  Copyright © 2016 Tecksky Technologies. All rights reserved.
//

#import "ViewController.h"
#import "imageTableViewCell.h"
#import "ImageLoader.h"
#import "UIImageView+ImageLoader.h"

@interface ViewController ()
{
    NSMutableArray *dataList;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgsingle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *myUrl = [NSURL URLWithString:@"https://lh4.googleusercontent.com/-unwey0_0lco/AAAAAAAAAAI/AAAAAAAAABg/J7HtTNkDLGM/photo.jpg"];
    [_imgsingle il_setImageWithURL:myUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] completion:^(BOOL finished)
     {
         NSLog(@"%ld, finished %d", (long)index, finished);
     }];
    
    dataList = [[NSMutableArray alloc] init];
    [self Get_Datalist];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    imageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    NSString *imgUrl = [NSString stringWithFormat:@"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage%03ld.jpg", (long)indexPath.row];
    
    [cell.img il_setImageWithURL:[NSURL URLWithString:[dataList objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] completion:^(BOOL finished)
     {
         NSLog(@"%ld, finished %d", (long)index, finished);
     }];
    return cell;
}
-(void)Get_Datalist
{
    NSDictionary *jsondata = [[NSDictionary alloc] init];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSError *error2;
    NSData *jsondata2 = [NSJSONSerialization dataWithJSONObject:jsondata options:NSJSONWritingPrettyPrinted error:&error2];
    NSString *postLength = [NSString stringWithFormat:@"%d", [jsondata2 length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://runmile.com/api/web/v1/profile/search"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"VVb419EerxCnpQfGv0pkJsKa84Fj1WzngxPJRvce" forHTTPHeaderField:@"TeckskyAuth"];
    
    
    [request setHTTPBody:jsondata2];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSMutableDictionary *dic12 = [NSJSONSerialization JSONObjectWithData:POSTReply options:0 error:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSMutableArray *pagerList = [[dic12 valueForKey:@"data"] valueForKey:@"pager"];
    for (int i = 0; i<[pagerList count]; i++)
    {
        [dataList addObject:[[[pagerList objectAtIndex:i] valueForKey:@"profile"] valueForKey:@"avatar"]];
    }
}
@end
