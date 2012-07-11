//
//  RotaViewController.h
//  Angrybus
//
//  Created by Felipe Alves on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceMark.h"
#import "Place.h"
#import "VeiculoAnnotation.h"
#import "DejalActivityView.h"

@interface RotaViewController : UIViewController <MKMapViewDelegate>
{
    
    MKMapView *mapView;
	MKPolyline* _routeLine;
	MKPolylineView* _routeLineView;
    MKMapRect _routeRect;
    
}
@property (nonatomic) IBOutlet MKMapView* mapView;
@property (nonatomic) MKPolyline* routeLine;
@property (nonatomic,strong) MKPolylineView* routeLineView;
@property (nonatomic, strong) NSArray * rotas;
@property (nonatomic, strong) NSArray * pontos;
@property (nonatomic, strong) NSString * numeroRota;

// load the points of the route from the data source, in this case
// a CSV file. 
-(void) loadRoute;

// use the computed _routeRect to zoom in on the route. 
-(void) zoomInOnRoute;

- (void) posicionaVeiculos;

@end
