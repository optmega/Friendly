//
//  FRInformationTableViewCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewInfoCell.h"
#import "FRStyleKit.h"
#import <MapKit/MapKit.h>
#import "UIImageHelper.h"
#import "FRDateManager.h"

@interface FREventPreviewInfoCell() <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIButton *distanceLabel;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lon;
@property (assign, nonatomic) CLLocationCoordinate2D eventCoordinate;
@property (strong, nonatomic) UIImageView* overMapView;
@property (assign, nonatomic) BOOL isExpanding;

@end

@implementation FREventPreviewInfoCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       [self setBackgroundColor:[UIColor whiteColor]];
        [self icon];
        [self questionText];
        [self answerText];
        [self separator];
        self.autoresizesSubviews = YES;
        self.isExpanding = NO;

    }
    return self;
}

- (void) updateWithModel:(FREventPreviewInfoCellViewModel*)model
{
    if ([model.subtitle isEqualToString:@""]) {
        self.questionText.hidden = YES;
        self.answerText.hidden = YES;
        self.icon.hidden = YES;
    }
    else
    {
        self.questionText.hidden = NO;
        self.answerText.hidden = NO;
        self.icon.hidden = NO;
    }
    self.questionText.text = model.title;
    self.answerText.text = model.subtitle;
//    if ([model.subtitle isEqual: @"Yes"])
//    {
//        self.answerText.textColor = [UIColor bs_colorWithHexString:kGreenColor];
//    }
    self.icon.image = model.icon;
}

- (void)expandMap
{
//    if (self.isExpanding)
//    {
//        float spanX = 0.010;
//        float spanY = 0.010;
//        MKCoordinateRegion region;
//        region.center.latitude = self.lat;
//        region.center.longitude = self.lon;
//        region.span.latitudeDelta = spanX;
//        region.span.longitudeDelta = spanY;
//        [self.mapView setRegion:region animated:YES];
//    }
    [self.delegate expandMap:self.isExpanding];
    self.mapView.scrollEnabled = !self.isExpanding;
    self.mapView.zoomEnabled = !self.isExpanding;
    self.mapView.pitchEnabled = !self.isExpanding;

    self.isExpanding = !self.isExpanding;
}

- (void) updateWhereInfoCellWithAttendingStatus:(NSString*)name lat:(NSString*)lat lon:(NSString*)lon
{
    [self mapView];
    [self overMapView];
    [self distanceLabel];
    self.answerText.text = name;
    self.lat = [lat doubleValue];
    self.lon = [lon doubleValue];
    self.questionText.text = @"Where";
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    [self.icon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
    }];
//    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    MKPointAnnotation *eventAnnotation = [[MKPointAnnotation alloc] init];
    eventAnnotation.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    self.eventCoordinate = eventAnnotation.coordinate;
    [self.mapView addAnnotation:eventAnnotation];
    float spanX = 0.010;
    float spanY = 0.010;
    MKCoordinateRegion region;
    region.center.latitude = [lat doubleValue];
    region.center.longitude = [lon doubleValue];
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
//    self.mapView.showsCompass = YES;
    self.separator.hidden = YES;
}

- (void) updateTimeInfoCellWithAttendingStatus:(NSDate*)event_start
{
    NSString* stringTime = [FRDateManager timeStringFromServerDate:event_start];
    self.answerText.text = stringTime;
}

- (void) updateMapWithOffset:(CGFloat)offset
{
    float offset1 = fabs(offset);
    float diff = (1.0 - ((offset1/2) / 550));
    
    MKMapRect r = [self.mapView visibleMapRect];
    MKMapPoint pt = MKMapPointForCoordinate(self.eventCoordinate);
    
    r.origin.x = pt.x - r.size.width * 0.50;
    r.origin.y = pt.y - r.size.height / diff * 0.30;
    [self.mapView setVisibleMapRect:r animated:NO];
    
    MKCoordinateRegion region = self.mapView.region;
    
    MKCoordinateSpan span;
    span.latitudeDelta=.010;
    span.longitudeDelta=.010;
    
    region.span=span;
    
    [self.mapView setRegion:region animated:NO];
    
//    
//    if (scrollView.isDragging) {
//        if (self.tableView.contentOffset.y < kMapContentInset-((self.view.bounds.size.height/3)*2))
//        {
//            NSLog(@"Halfway there!");
//        }
//    }
}


#pragma mark - DelegateMethods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            return nil;
        }
        else
        {
            MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
            if (!pinView)
            {
                // If an existing pin view was not available, create one.
                pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
                pinView.image = [FRStyleKit imageOfEventPreviewMapPin];
            }
            return pinView;
        }
}

-(void)updateDistanceToAnnotationWithLat:(double)lat lon:(double)lon{

    CLLocation *pinLocation = [[CLLocation alloc]
        initWithLatitude:lat
               longitude:lon];

    CLLocation *userLocation = [[CLLocation alloc] 
        initWithLatitude:self.mapView.userLocation.coordinate.latitude
               longitude:self.mapView.userLocation.coordinate.longitude];

    CLLocationDistance distance = [pinLocation distanceFromLocation:userLocation] / 1000;
    
    [self.distanceLabel setTitle:[NSString stringWithFormat:@"  %.2fkm ", distance] forState:UIControlStateNormal];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self updateDistanceToAnnotationWithLat:self.lat lon:self.lon];
}


#pragma mark - LazyLoad

-(UIImageView*)overMapView
{
    if (!_overMapView)
    {
        _overMapView = [UIImageView new];
        [_overMapView setImage:[UIImage imageNamed:@"overMapView1"]];
               [self.mapView addSubview:_overMapView];
        [_overMapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.mapView);
        }];
    }
    return _overMapView;
}

-(MKMapView*) mapView
{
    if (!_mapView)
    {
        _mapView = [MKMapView new];
        _mapView.scrollEnabled = NO;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandMap)];
        [_mapView addGestureRecognizer:tap];
        _mapView.userInteractionEnabled = YES;

        [self.contentView addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.questionText.mas_bottom).offset(15);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _mapView;
}

-(UIButton*) distanceLabel
{
    if (!_distanceLabel)
    {
        _distanceLabel = [UIButton new];
        _distanceLabel.layer.cornerRadius = 5;
        _distanceLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_distanceLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _distanceLabel.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        [_distanceLabel setTitle:@"  Load..." forState:UIControlStateNormal];
        [_distanceLabel setImage:[UIImageHelper image:[FRStyleKit imageOfEventPreviewLocationMapIcon] color:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_distanceLabel setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [self.mapView addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mapView).offset(5);
            make.right.equalTo(self.mapView).offset(-5);
            make.height.equalTo(@30);
            make.width.lessThanOrEqualTo(@150);
        }];
    }
    return _distanceLabel;
}
-(UIImageView*) icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView.mas_centerY).offset(-9);
            make.height.width.equalTo(@18);
        }];
    }
    return _icon;
}

-(UILabel*) questionText
{
    if (!_questionText)
    {
        _questionText = [UILabel new];
        [_questionText setFont:FONT_SF_DISPLAY_REGULAR(17)];
        [_questionText setText:@"Where"];
        [_questionText setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
        [self.contentView addSubview:_questionText];
        [_questionText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.icon);
            make.left.equalTo(self.icon.mas_right).offset(15);
        }];
    }
    return _questionText;
}

-(UILabel*) answerText
{
    if (!_answerText)
    {
        _answerText = [UILabel new];
        [_answerText setFont:FONT_SF_DISPLAY_MEDIUM(17)];
        [_answerText setTextColor:[UIColor bs_colorWithHexString:@"#263345"]];
        _answerText.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_answerText];
        [_answerText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.icon);
            make.right.equalTo(self.contentView).offset(-15);
            make.left.equalTo(self.questionText.mas_right).offset(5);
        }];
    }
    return _answerText;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.layer.cornerRadius = 2;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E6E8EC"];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.answerText);
            make.left.equalTo(self.questionText);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

@end
