//
//  YPChatMapController.m
//  YPChatView
//
//  Created by soldoros on 2019/10/19.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "YPChatMapController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Define.h"


@interface YPChatMapController ()<CLLocationManagerDelegate,MKMapViewDelegate>

//地图
@property (nonatomic, strong)MKMapView *mMapView;
//定位
@property (nonatomic, strong)CLLocationManager *locationManager;


@end

@implementation YPChatMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"位置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _mMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, Height_NavBar , YPSCREEN_Width, YPSCREEN_Height-Height_NavBar)];
    _mMapView.delegate = self;
    _mMapView.mapType = MKMapTypeStandard;
    _mMapView.showsUserLocation = YES;
    _mMapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:_mMapView];
    
    CLLocationCoordinate2D coord = (CLLocationCoordinate2D){_latitude, _longitude};
    [_mMapView setCenterCoordinate:coord animated:YES];
 
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ) {
        pinView = [[MKPinAnnotationView alloc]  initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    pinView.pinTintColor = [UIColor redColor];
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    [mapView.userLocation setTitle:@"欧陆经典"];
    [mapView.userLocation setSubtitle:@"vsp"];
    return pinView;
    
}


@end
