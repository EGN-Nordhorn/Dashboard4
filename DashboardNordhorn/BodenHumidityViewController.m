//
//  BodenHumidityViewController.m
//  Dashboard4
//
//  Created by Hu, Hao on 01.06.17.
//  Copyright © 2017 SAP SE. All rights reserved.
//

#import "BodenHumidityViewController.h"
#import "KNCirclePercentView.h"

@interface BodenHumidityViewController ()
@property (weak, nonatomic) IBOutlet KNCirclePercentView *percentView;

@end

@implementation BodenHumidityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.percentView drawCircleWithPercent:67
                                    duration:2
                                   lineWidth:40
                                   clockwise:YES
                                     lineCap:kCALineCapRound
                                   fillColor:[UIColor clearColor]
                                 strokeColor:[UIColor colorWithRed:0.13f green:0.6f blue:0.83f alpha:1]
                              animatedColors:nil];
    
    self.percentView.percentLabel.font = [UIFont systemFontOfSize:50];
    self.percentView.percentLabel.textColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
