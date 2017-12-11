//
//  PopularPlacesCViewModel.m
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/12/06.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

#import "PopularPlacesCViewModel.h"

@implementation PopularPlacesCViewModel

@synthesize test;
@synthesize currentLocation;

- (instancetype) initWithLocation:(CLLocation *)currentLocation{
    self = [super init];
    if(self){
        self.currentLocation = currentLocation;
    }
    return self;
}

@end
