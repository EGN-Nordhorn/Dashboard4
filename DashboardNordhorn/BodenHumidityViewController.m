//
//  BodenHumidityViewController.m
//  Dashboard4
//
//  Created by Hu, Hao on 01.06.17.
//  Copyright © 2017 SAP SE. All rights reserved.
//

#import "BodenHumidityViewController.h"
#import "KNCirclePercentView.h"

#import "BluetoothSearchViewController.h"

@interface BodenHumidityViewController ()<BTSmartSensorDelegate>
@property (weak, nonatomic) IBOutlet KNCirclePercentView *percentView;


@property (strong, nonatomic) SerialGATT* serialGatt;
@property(strong, nonatomic) CBPeripheral* remoteSender;
@end

@implementation BodenHumidityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self setupBluetooth];
    
    [self setViewStatus:20];
    
}


-(void) setViewStatus:(int) value{
    
    [self.percentView drawCircleWithPercent:value
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
        [self setViewStatus:str.intValue];        
    }
    
}
- (void) setConnect{
    NSLog(@"Bluetooth connected");
}
- (void) setDisconnect{
    NSLog(@"Bluetooth disconnected!");
    
    
}



@end
