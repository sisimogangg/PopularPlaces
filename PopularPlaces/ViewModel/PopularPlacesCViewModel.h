//
//  PopularPlacesCViewModel.h
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/12/06.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PopularPlacesCViewModel : NSObject

@property (nonatomic, retain) NSString * test;
@property (atomic, retain) CLLocation *currentLocation;


-(instancetype) initWithLocation: (CLLocation *) currentLocation;


@end
