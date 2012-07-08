//
//  PontosViewController.h
//  Angrybus
//
//  Created by Felipe Alves on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LinhasNoPontoViewController.h"

@interface PontosViewController : UIViewController <MKMapViewDelegate>
{
    
    __weak IBOutlet MKMapView *mapViewCentral;
}

@property (nonatomic,assign) BOOL primeiraLocalizacao;

@end
