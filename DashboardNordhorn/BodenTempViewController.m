//
//  BodenTempViewController.m
//  Dashboard4
//
//  Created by Hu, Hao on 01.06.17.
//  Copyright © 2017 SAP SE. All rights reserved.
//

#import "BodenTempViewController.h"
#import "KNCirclePercentView.h"

#define GREEN_COLOR [UIColor colorWithRed:0.14 green:0.73 blue:0.41 alpha:1]
#define RED_COLOR   [UIColor colorWithRed:0.87 green:0.18 blue:0.28 alpha:1]
#define YELLOW_COLOR [UIColor colorWithRed:0.87 green:0.82 blue:0.16 alpha:1]

@interface BodenTempViewController ()
@property (weak, nonatomic) IBOutlet KNCirclePercentView *percentView;

@end

@implementation BodenTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewStatus:20];
}


-(void) setViewStatus:(float) temperatur {
    
    UIColor* color = GREEN_COLOR;
    
    float percentage = temperatur / 45.0;
    if (temperatur >= 0 && temperatur <= 15) {
        color = GREEN_COLOR;
    } else if (temperatur > 15 && temperatur < 30 ) {
        color = YELLOW_COLOR;
    } else if (temperatur >= 30) {
        color = RED_COLOR;
        
    }
    self.percentView.backgroundColor = [UIColor clearColor];
    [self.percentView drawCircleWithPercent:(percentage * 100)
                                   duration:2
                                  lineWidth:40
                                  clockwise:YES
                                    lineCap:kCALineCapRound
                                  fillColor:[UIColor clearColor]
                                strokeColor:color
                             animatedColors:nil];
    
    self.percentView.percentLabel.font = [UIFont systemFontOfSize:50];
    self.percentView.percentLabel.textColor = [UIColor whiteColor];
    
    NSString* display = [NSString stringWithFormat:@"%d °C", (int)temperatur];
    self.percentView.percentLabel.text = display;
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
