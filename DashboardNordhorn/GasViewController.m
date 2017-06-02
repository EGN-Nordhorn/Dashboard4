//
//  GasViewController.m
//  Dashboard4
//
//  Created by Hu, Hao on 01.06.17.
//  Copyright © 2017 SAP SE. All rights reserved.
//

#import "GasViewController.h"
#import "CircleView.h"
#import "BluetoothSearchViewController.h"


@interface GasViewController ()<BTSmartSensorDelegate>
@property (weak, nonatomic) IBOutlet CircleView *weakView;
@property (weak, nonatomic) IBOutlet CircleView *midView;
@property (weak, nonatomic) IBOutlet CircleView *strongView;


@property (strong, nonatomic) SerialGATT* serialGatt;
@property(strong, nonatomic) NSMutableData* receivedData;
@property(strong, nonatomic) CBPeripheral* remoteSender;

@end

@implementation GasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBluetooth];
    _receivedData =  [[NSMutableData alloc] init];
    
    // Do any additional setup after loading the view.
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

-(void) setViewStatusWithValue:(int) value {
    if (value >= 0 && value <= 40) {
        _weakView.alpha = 1.0;
        _midView.alpha = 0.2;
        _strongView.alpha = 0.2;
    } else if (value > 40 && value <= 85) {
        _weakView.alpha = 0.2;
        _midView.alpha = 0.1;
        _strongView.alpha = 0.2;
    } else if (value > 85) {
        _weakView.alpha = 0.2;
        _midView.alpha = 0.2;
        _strongView.alpha = 0.1;
    } else {
        NSLog(@"value is out of range. Wrong %d", value);
        _weakView.alpha = 0.2;
        _midView.alpha = 0.2;
        _strongView.alpha = 0.2;
    }
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
    
    [self.receivedData appendData:data];
    
    UInt8 bytes_to_find[] = { 0x0D, 0x0A };
    NSData *dataToFind = [NSData dataWithBytes:bytes_to_find
                                        length:sizeof(bytes_to_find)];
    
    NSRange rangeOfData = [data rangeOfData:dataToFind options:0 range:NSMakeRange(0, data.length)];
    
    if (rangeOfData.location != NSNotFound) {
        NSLog(@"Find the end");
        NSString* stringData = [[NSString alloc] initWithData:[self.receivedData copy] encoding:NSUTF8StringEncoding];
        [self.receivedData setLength:0];
        NSLog(@" I got the string data is %@", stringData);
    }
    
}
- (void) setConnect{
    NSLog(@"Bluetooth connected");
}
- (void) setDisconnect{
    NSLog(@"Bluetooth disconnected!");
    
}

@end
