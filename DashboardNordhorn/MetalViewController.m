//
//  MetalViewController.m
//  Dashboard4
//
//  Created by Hu, Hao on 01.06.17.
//  Copyright © 2017 SAP SE. All rights reserved.
//

#import "MetalViewController.h"
#import "CircleView.h"
#import "BluetoothSearchViewController.h"



@interface MetalViewController ()<BTSmartSensorDelegate>
@property (weak, nonatomic) IBOutlet CircleView *jaView;
@property (weak, nonatomic) IBOutlet CircleView *neinView;



@property (strong, nonatomic) SerialGATT* serialGatt;
@property(strong, nonatomic) NSMutableData* receivedData;
@property(strong, nonatomic) CBPeripheral* remoteSender;

@end

@implementation MetalViewController

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


- (void) setStatusView: (int) value {
    
    if (value == 1) {
        //Ja View should be alert.
        _jaView.alpha = 1.0;
        _neinView.alpha = 0.2;
    } else {
        //Nein View should be alert.
        _neinView.alpha = 0.2;
        _jaView.alpha = 1.0;
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
