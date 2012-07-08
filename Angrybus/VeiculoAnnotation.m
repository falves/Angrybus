//
//  VeiculoAnnotation.m
//  Angrybus
//
//  Created by Felipe Alves on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VeiculoAnnotation.h"

@implementation VeiculoAnnotation

@synthesize coordinate;
@synthesize place;

-(id) initWithPlace: (Place*) p
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = p.latitude;
		coordinate.longitude = p.longitude;
		self.place = p;
	}
	return self;
}

- (NSString *)subtitle
{
	return self.place.description;
}
- (NSString *)title
{
	return self.place.name;
}

@end
