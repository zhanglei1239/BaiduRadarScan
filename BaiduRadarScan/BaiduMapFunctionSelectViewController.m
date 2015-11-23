//
//  BaiduMapFunctionSelectViewController.m
//  BaiduRadarScan
//
//  Created by zhanglei on 15/11/23.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import "BaiduMapFunctionSelectViewController.h"
#import "RadarViewController.h"
#import "POISearcghViewController.h"
@interface BaiduMapFunctionSelectViewController ()
{
    UILabel * lblTitle;
    UITableView * functionTableView;
    NSMutableArray * functionArray;
}
@end

@implementation BaiduMapFunctionSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    functionArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 40)];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setText:@"百度地图功能选择"];
    [self.view addSubview:lblTitle];
    
    [self initFunctionWithFunctionName];
    
    functionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-60)];
    [functionTableView.layer setBorderWidth:.5];
    [functionTableView.layer setBorderColor:[UIColor grayColor].CGColor];
    functionTableView.dataSource = self;
    functionTableView.delegate = self;
    functionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:functionTableView];
}

-(void)initFunctionWithFunctionName{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"poi" forKey:@"key"];
    [dic setObject:@"POI搜索" forKey:@"functionName"];
    [functionArray addObject:dic];
    
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"radar" forKey:@"key"];
    [dic1 setObject:@"Radar扫描" forKey:@"functionName"];
    [functionArray addObject:dic1];
}

#pragma mark -- Function TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary * dic = [functionArray objectAtIndex:indexPath.row];
    NSString * key = [dic objectForKey:@"key"];
    if ([key isEqualToString:@"poi"]) {
        POISearcghViewController * poi = [[POISearcghViewController alloc] init];
        [self presentViewController:poi animated:YES completion:^{
            
        }];
    }else if([key isEqualToString:@"radar"]){
        RadarViewController * radar = [[RadarViewController alloc] init];
        [self presentViewController:radar animated:YES completion:^{
            
        }];
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
        NSMutableDictionary * dic = [functionArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:[dic objectForKey:@"functionName"]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, tableView.frame.size.width, .5)];
        [line setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:line];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [functionArray count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
