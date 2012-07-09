//
//  PontosViewController.m
//  Angrybus
//
//  Created by Felipe Alves on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PontosViewController.h"
#import "PlaceMark.h"
#import "Place.h"

@interface PontosViewController ()

@end

@implementation PontosViewController
@synthesize primeiraLocalizacao = _primeiraLocalizacao;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES];
    self.title = @"AngryBus";
}

- (void) viewWillDisappear:(BOOL)animated {
    self.title = @"Voltar";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MKUserTrackingBarButtonItem *findMe = [[MKUserTrackingBarButtonItem alloc] initWithMapView:mapViewCentral];
    self.navigationItem.leftBarButtonItem = findMe;
    
    
    self.primeiraLocalizacao = YES;
    
//    self.title = @"AngryBus";
	
    NSString * requestString = [NSString stringWithFormat:@"%@/Angryadmin/ListaPontos",SERVIDOR];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
    
        NSError * erro;
        NSDictionary * pontosDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&erro];
        
        for (NSDictionary * ponto in pontosDict) {
            
            Place * pontoPlace = [Place new];
            [pontoPlace setDescription:[ponto objectForKey:@"idponto"]];
            [pontoPlace setLatitude:[[ponto objectForKey:@"latitude"] doubleValue]];
            [pontoPlace setLongitude:[[ponto objectForKey:@"longitude"] doubleValue]];
            
            PlaceMark * placemark = [[PlaceMark alloc] initWithPlace:pontoPlace];
            
            [mapViewCentral addAnnotation:placemark];
            
        }
        
    }];
    
}

- (void)viewDidUnload
{
    mapViewCentral = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    LinhasNoPontoViewController * proximo = (LinhasNoPontoViewController*) segue.destinationViewController;
    
    proximo.idPonto = sender;
    
    
}


#pragma mark - MKMapView Delegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation 
{
    if (self.primeiraLocalizacao) {
        
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapViewCentral.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.05;
        mapRegion.span.longitudeDelta = 0.05;
        
        [mapViewCentral setRegion:mapRegion animated: YES];
        
        self.primeiraLocalizacao = NO;
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation      {
  
    MKAnnotationView *pinView = (MKAnnotationView *)[mapViewCentral dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.image = [UIImage imageNamed:@"ponto"];
        pinView.frame = CGRectMake(0, 0, 20, 60);
        //pinView.animatesDrop = YES; can't animate with custom pin images
        pinView.canShowCallout = NO;
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        
    } else {
        pinView.annotation = annotation;
    }
    if (annotation == mapViewCentral.userLocation){
        return nil; //default to blue dot
    }
    return pinView;
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//    
//    static NSString *annotIdentifier = @"annot";
//    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotIdentifier];
//    if (!pav)
//    {
//        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotIdentifier];
//        pav.canShowCallout = NO;
//    }
//    else
//    {
//        pav.annotation = annotation;
//    }
//    
//    return pav;
//}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    PlaceMark * annot = (PlaceMark*) view.annotation;
    [self performSegueWithIdentifier:@"LinhasNoPonto" sender:[annot subtitle]];
}

@end
