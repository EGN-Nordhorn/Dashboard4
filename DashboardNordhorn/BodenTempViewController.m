//
//  BodenTempViewController.m
//  Dashboard4
//
//  Created by Hu, Hao on 01.06.17.
//  Copyright © 2017 SAP SE. All rights reserved.
//

#import "BodenTempViewController.h"
#import "KNCirclePercentView.h"

#import "BluetoothSearchViewController.h"

#define GREEN_COLOR [UIColor colorWithRed:0.14 green:0.73 blue:0.41 alpha:1]
#define RED_COLOR   [UIColor colorWithRed:0.87 green:0.18 blue:0.28 alpha:1]
#define YELLOW_COLOR [UIColor colorWithRed:0.87 green:0.82 blue:0.16 alpha:1]

@interface BodenTempViewController ()<BTSmartSensorDelegate>
@property (weak, nonatomic) IBOutlet KNCirclePercentView *percentView;


@property (strong, nonatomic) SerialGATT* serialGatt;
@property(strong, nonatomic) CBPeripheral* remoteSender;

@end

@implementation BodenTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBluetooth];
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


-(void) setupBluetooth {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidSelectDevice"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * note) {
                                                      
                                                      _serialGatt.delegate = self;
                                                      self.remoteSender = _serialGatt.activePeripheral;
                                                      [_serialGatt connect:self.remoteSender];
                                                      
                                                  }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    BluetoothSearchViewController* btVc = (BluetoothSearchViewController*)  segue.destinationViewController;
    self.serialGatt = [[SerialGATT alloc] init];
    [self.serialGatt setup];
    btVc.serialGatt = self.serialGatt;
}


#pragma - Bluetooth

- (void) serialGATTCharValueUpdated: (NSString *)UUID value: (NSData *)data{
    
    NSString* receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"receivedString is %@", receivedString);
    
    NSRange range = [receivedString rangeOfString:@"/"];
    if (range.location == NSNotFound) {
        NSLog(@"Invalid format.");
    } else {
        NSString* str = [receivedString substringToIndex:(receivedString.length -1)];
        [self setViewStatus:str.floatValue];
        
    }
    
}
- (void) setConnect{
    NSLog(@"Bluetooth connected");
}
- (void) setDisconnect{
    NSLog(@"Bluetooth disconnected!");
    
    
}



@end
