//
//  MDBlueToothCenter.m
//  single
//
//  Created by Ming-der Wang on 11/16/13.
//  Copyright (c) 2013 Kat Digital Corp. All rights reserved.
//

#import "MDBlueToothCenter.h"


@implementation MDBlueToothCenter

# define READ_RSSI_INTERVAL 0.33

static MDBlueToothCenter *instance = nil;
static NSTimer *timer;
static BOOL discoved = NO;
NSString * const kMDDiscoverPeripheralRSSINotification = @"com.katdc.bluetooth.discoverPeripheralRSSI";
NSString * const kObjectRSSI = @"objectRSSI";
#pragma mark - singleton

// a singleton
+ (MDBlueToothCenter *)getDefaultInstance{
    @synchronized(self) {
        if (instance == nil){
            instance = [[MDBlueToothCenter alloc] init];
        }
    }
    return instance;
}
- (id)init
{
    if ((self = [super init]))
    {
        self.dicoveredPeripherals = [NSMutableArray new];
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        supportBLE = NO;
        _isScanning = YES;
    }
    
    return self;
}


-(void) startScan {
    _isScanning = YES;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [manager scanForPeripheralsWithServices:nil options:options];
}

-(void) stopScan {
    _isScanning = NO;
}

#pragma mark - CBCentralManagerDelegate

/*!
 *  @method centralManagerDidUpdateState:
 *
 *  @param central  The central manager whose state has changed.
 *
 *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
 *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
 *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
 *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
 *                  manager become invalid and must be retrieved or discovered again.
 *
 *  @see            state
 *
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    supportBLE = [self checkSupportBLE];
    if (!supportBLE)
    {
//        @throw ([NSError errorWithDomain:@"Bluetooth LE is not supported on this device." code:404 userInfo:nil]);
    }
}

- (BOOL) checkSupportBLE {
    switch ([manager state])
    {
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnsupported:
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"This device does not support Bluetooth Low Energy.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil] show];
            return FALSE;
            break;
        default:
            return FALSE;
    }
}

#pragma mark - delegate
/*!
 *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
 *
 *  @param central              The central manager providing this update.
 *  @param peripheral           A <code>CBPeripheral</code> object.
 *  @param advertisementData    A dictionary containing any advertisement and scan response data.
 *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
 *								was not available.
 *
 *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
 *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
 *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
 *
 *  @seealso                    CBAdvertisementData.h
 *
 */

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@", peripheral.name);
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 RSSI, kObjectRSSI,
                                 nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMDDiscoverPeripheralRSSINotification
                                                        object:nil userInfo:userInfo];
    
   // When you have found a peripheral device that you’re interested in connecting to, stop scanning for other devices in order to save power.
    if (discoved) {
        [manager stopScan];
    }
//    NSLog(@"Scanning stopped");
    discoved = YES;
    firstPeripheral = peripheral;
    //
    
    if(![self.dicoveredPeripherals containsObject:peripheral]) {
        [self.dicoveredPeripherals addObject:peripheral];
    }
    
    NSString *uuidString = [NSString stringWithFormat:@"%@", [[peripheral identifier] UUIDString]];
    
    NSLog(@"%@", uuidString);
    [manager connectPeripheral:peripheral options:nil];
}

/*
 Invoked when the central manager retrieves the list of known peripherals.
 Automatically connect to first known peripheral
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Retrieved peripheral: %d - %@", [peripherals count], peripherals);
    
    [self stopScan];
    
    /* If there are any known devices, automatically connect to it.*/
    if([peripherals count] >= 1)
    {
        firstPeripheral = [peripherals objectAtIndex:0];
        
        [manager connectPeripheral:firstPeripheral
                           options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}

-(void) pingRSSI {
    if(firstPeripheral != nil) {
        [firstPeripheral readRSSI];
    }
}

- (void) startTimerAction {
    timer = [NSTimer scheduledTimerWithTimeInterval: READ_RSSI_INTERVAL
                                                 target: self
                                               selector: @selector(pingRSSI)
                                               userInfo: nil
                                                repeats: NO];
}

/*
 Invoked whenever a connection is succesfully created with the peripheral.
 Discover available services on the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect to peripheral: %@", peripheral);
    [peripheral setDelegate:self];
    [peripheral readRSSI];
//    [self startTimerAction];
}

/*!
 *  @method peripheralDidUpdateRSSI:error:
 *
 *  @param peripheral        The peripheral providing this update.
 *        @param error                If an error occurred, the cause of the failure.
 *
 *  @discussion                        This method returns the result of a @link readRSSI: @/link call.
 */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
//    NSLog(@"peripheralDidUpdateRSSI:%@ error:%@", peripheral, [error localizedDescription]);
    if(nil!=peripheral) {
        
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  peripheral.RSSI, kObjectRSSI,
                                  nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kMDDiscoverPeripheralRSSINotification
                                                            object:nil userInfo:userInfo];
    }
    if (_isScanning) {
        [self startTimerAction];
    }
}

@end
