//
//  MapViewController.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/8/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getLocation];
}

- (void)getLocation
{
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(MKMapRectWorld);
    
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    searchRequest.naturalLanguageQuery = self.address;
    searchRequest.region = region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        MKPlacemark *placemark = [response mapItems].firstObject.placemark;
        
        MKCoordinateRegion region = self.mapView.region;
        region.center = placemark.location.coordinate;
        region.span.longitudeDelta /= 8.0;
        region.span.latitudeDelta /= 8.0;
        
        [self.mapView setRegion:region animated:YES];
        [self.mapView addAnnotation:placemark];
    }];
}

@end
