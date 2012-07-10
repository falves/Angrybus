//
//  os4MapsViewController.m
//  os4Maps
//
//  Created by Craig Spitzkoff on 7/4/10.
//  Copyright Craig Spitzkoff 2010. All rights reserved.
//

#import "RotaViewController.h"

@interface RotaViewController()

-(NSArray*) calcularRotasDe:(CLLocationCoordinate2D)pontoOrigem ate: (CLLocationCoordinate2D)pontoDestino;
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded;

@end

@implementation RotaViewController
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;
@synthesize rotas = _rotas;
@synthesize pontos = _pontos;
@synthesize numeroRota = _numeroRota;



- (void)viewDidLoad {
    [super viewDidLoad];
	
	// create the overlay
	[self loadRoute];
	
	// add the overlay to the map
	if (nil != self.routeLine) {
		[self.mapView addOverlay:self.routeLine];
	}
    
	[self zoomInOnRoute];
    
    [self posicionaVeiculos];
	
}

-(void) loadRoute
{
    
    NSArray * waypoints = self.pontos; //[self.pontos objectAtIndex:0];
    
    NSMutableArray * pontos = [NSMutableArray new];
    
    for (int n=0; n<[waypoints count]-1; n++) {
        
        
        
        NSDictionary * pontoOrigem = [waypoints objectAtIndex:n];
        NSDictionary * pontoDestino = [waypoints objectAtIndex:n+1];
        
        double latOrigem = [[pontoOrigem objectForKey:@"lat"] doubleValue];
        double lonOrigem = [[pontoOrigem objectForKey:@"lon"] doubleValue];
        double latDestino = [[pontoDestino objectForKey:@"lat"] doubleValue];
        double lonDestino = [[pontoDestino objectForKey:@"lon"] doubleValue];
        
        Place * ponto = [Place new];
        ponto.latitude = latOrigem;
        ponto.longitude = lonOrigem;
        PlaceMark * pontoAnnot = [[PlaceMark alloc] initWithPlace:ponto];
        
        if (n == [waypoints count]-2) {
            Place * dest = [Place new];
            dest.latitude = latDestino;
            dest.longitude = lonDestino;
            PlaceMark * destAnnot = [[PlaceMark alloc] initWithPlace:dest];
            [self.mapView addAnnotation:destAnnot];
        }
        
        [self.mapView addAnnotation:pontoAnnot];
        
        CLLocationCoordinate2D origem = CLLocationCoordinate2DMake(latOrigem, lonOrigem);
        CLLocationCoordinate2D destino = CLLocationCoordinate2DMake(latDestino, lonDestino);
        
        [pontos addObjectsFromArray:[self calcularRotasDe:origem ate:destino]];
        
    }
    
	MKMapPoint northEastPoint; 
	MKMapPoint southWestPoint; 
	
	// create a c array of points. 
	MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * pontos.count);
	
	for(int idx = 0; idx < pontos.count; idx++)
	{
        
        CLLocation * loc = (CLLocation*) [pontos objectAtIndex:idx];
        
        
		MKMapPoint point = MKMapPointForCoordinate(loc.coordinate);
        
		
		//
		// adjust the bounding box
		//
		
		// if it is the first point, just use them, since we have nothing to compare to yet. 
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		}
		else 
		{
			if (point.x > northEastPoint.x) 
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x) 
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y) 
				southWestPoint.y = point.y;
		}
        
		pointArr[idx] = point;
        
	}
	
	// create the polyline based on the array of points. 
	self.routeLine = [MKPolyline polylineWithPoints:pointArr count:pontos.count];
    
	_routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    
	// clear the memory allocated earlier for the points
	free(pointArr);
	
}

-(void) zoomInOnRoute
{
	[self.mapView setVisibleMapRect:_routeRect];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}



#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now. 
		if(nil == self.routeLineView)
		{
			self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
			self.routeLineView.fillColor = [UIColor colorWithRed:60./255. green:140./255. blue:255./255. alpha:0.7];
			self.routeLineView.strokeColor = [UIColor colorWithRed:60./255. green:140./255. blue:255./255. alpha:0.7];
			self.routeLineView.lineWidth = 8;
		}
		
		overlayView = self.routeLineView;
		
	}
	
	return overlayView;
	
}

#pragma Mark - Felipe
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
    
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
    
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        //		printf("[%f,", [latitude doubleValue]);
        //		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
	
	return array;
}



-(NSArray*) calcularRotasDe:(CLLocationCoordinate2D)pontoOrigem ate: (CLLocationCoordinate2D)pontoDestino {
    
    NSString * stringOrigem = [NSString stringWithFormat:@"%f,%f", pontoOrigem.latitude, pontoOrigem.longitude];
    NSString * stringDestino = [NSString stringWithFormat:@"%f,%f", pontoDestino.latitude, pontoDestino.longitude];
    
    NSString * urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&dirflg=r&sensor=true&language=pt-BR",stringOrigem,stringDestino];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSURL * urlApi = [NSURL URLWithString:urlString];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:urlApi];
    
    NSError * erro = nil;
    
    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&erro];
    
    if (erro) {
        NSLog(@"Erro: %@",erro);
        return nil;
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&erro];
    id pontosEncodedObject;
    NSString * pontosEncoded;
    
    if ([json respondsToSelector:@selector(objectForKey:)]) {
        //        NSLog(@"Json - %@",json);
        id rotas = [json objectForKey:@"routes"];
        
        if ([rotas respondsToSelector:@selector(objectForKey:)]) {
            
            pontosEncodedObject = [rotas objectForKey:@"overview_polyline"];
            
        } else if ([rotas respondsToSelector:@selector(objectAtIndex:)]) {
            
            pontosEncodedObject = [[rotas objectAtIndex:0] objectForKey:@"overview_polyline"];
            
        }
        
        if ([pontosEncodedObject respondsToSelector:@selector(objectForKey:)]) {
            pontosEncoded = [pontosEncodedObject objectForKey:@"points"];
        }
        
    }
    
	return [self decodePolyLine:[pontosEncoded mutableCopy]];
}

- (void) posicionaVeiculos {
    
    NSString * rotasRequestString = [NSString stringWithFormat:@"%@/Angryadmin/ListaPosicoesDaRota?idrota=%@",SERVIDOR,self.numeroRota];
    NSURLRequest * rotasRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:rotasRequestString]];
    NSError * erro;
    NSURLResponse * response;
    
    NSArray * posicoesAtuais;
    
    NSData * dataRotas = [NSURLConnection sendSynchronousRequest:rotasRequest returningResponse:&response error:&erro];
    
    posicoesAtuais = [NSJSONSerialization JSONObjectWithData:dataRotas options:NSJSONReadingAllowFragments error:&erro];
    
    for (NSDictionary * posicao in posicoesAtuais) {
        
        double latitude = [[posicao objectForKey:@"latitude"] doubleValue];
        double longitude = [[posicao objectForKey:@"longitude"] doubleValue];
        
        Place * veiculoPlace = [Place new];
        veiculoPlace.latitude = latitude;
        veiculoPlace.longitude = longitude;
        veiculoPlace.description = [posicao objectForKey:@"placa"];
        
        VeiculoAnnotation * veiculoAnnot = [[VeiculoAnnotation alloc] initWithPlace:veiculoPlace];
        [self.mapView addAnnotation:veiculoAnnot];
        
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation      {
    
    MKAnnotationView *pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    if (annotation == self.mapView.userLocation){
        return nil; 
    }
    
    if (!pinView) {
        
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        
        pinView.canShowCallout = NO;

        if ([annotation isKindOfClass:[PlaceMark class]]) {
            pinView.image = [UIImage imageNamed:@"ponto"];
            pinView.frame = CGRectMake(0, 0, 20, 60);
            
        } else {
            pinView.image = [UIImage imageNamed:@"onibus"];
            pinView.frame = CGRectMake(0, 0, 17, 20);
        }
         
     
    } else {
        pinView.annotation = annotation;
    }

    return pinView;
}

@end
