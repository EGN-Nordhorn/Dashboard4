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
@property(strong, nonatomic) CBPeripheral* remoteSender;

@end

@implementation MetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBluetooth];
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
    
    NSLog(@"Value to set is %d", value);
    if (value == 1) {
        //Ja View should be alert.
        _jaView.alpha = 1.0;
        _neinView.alpha = 0.2;
    } else if (value == 0) {
        //Nein View should be alert.
        _neinView.alpha = 1.0;
        _jaView.alpha = 0.2;
    } else {
        _neinView.alpha = 0.2;
        _jaView.alpha = 0.2;
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
    
    
    NSString* receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"receivedString is %@", receivedString);
    
    
    NSRange range = [receivedString rangeOfString:@"/"];
    if (range.location == NSNotFound) {
        NSLog(@"Invalid format.");
    } else {
        NSString* str = [receivedString substringToIndex:(receivedString.length -1)];
        [self setStatusView:str.intValue];
    }

}
- (void) setConnect{
    NSLog(@"Bluetooth connected");
}
- (void) setDisconnect{
    NSLog(@"Bluetooth disconnected!");
    [self setStatusView:-1];
    
}



@end
