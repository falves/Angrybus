//
//  VeiculoAnnotation.h
//  Angrybus
//
//  Created by Felipe Alves on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface VeiculoAnnotation : MKAnnotationView <MKAnnotation> {
    
	CLLocationCoordinate2D coordinate;
	Place* place;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) Place* place;

-(id) initWithPlace: (Place*) p;
@end
