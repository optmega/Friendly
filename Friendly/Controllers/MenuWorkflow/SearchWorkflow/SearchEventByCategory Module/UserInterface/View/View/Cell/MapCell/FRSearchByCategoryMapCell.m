//
//  FRSearchByCategoryMapCell.m
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchByCategoryMapCell.h"
#import "FRLocationManager.h"
#import "FRSearchByCategoryMarkerView.h"

@import GoogleMaps;

@interface FRSearchByCategoryMapCell () <GMSMapViewDelegate, FRSearchByCategoryMarkerViewDelegate>

@property (nonatomic, strong) GMSMapView* mapView;
@property (nonatomic, strong) UIButton* showFullMapButton;
@property (nonatomic, strong) FRSearchByCategoryMapCellViewModel* model;

@end


@implementation FRSearchByCategoryMapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self mapView];
       
        [self.showFullMapButton addTarget:self action:@selector(showFullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showEventPreviewWithEvent:(FREvent *)event
{
    if (event){
        
        [self.model showEventPreviewWithEvent:[[NSManagedObjectContext MR_defaultContext] objectWithID:event.objectID]];
    }
    
    
}

- (void)showUserProfile:(UserEntity *)user {
    [self.model showUserProfile:user];
}

- (void)showFullScreenAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    NSLog(@"%d", sender.selected);
    [self.model pressShowFullScreen:sender.selected];
}

- (void)updateWithModel:(FRSearchByCategoryMapCellViewModel*)model
{
    [self.mapView clear];
    self.model = model;
    self.showFullMapButton.selected = self.model.isSelected;
    CLLocationCoordinate2D location = [FRLocationManager sharedInstance].location;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                            longitude:location.longitude
                                                                 zoom:12];
    [self.mapView setCamera:camera];
    
    [model.markersArray enumerateObjectsUsingBlock:^(GMSMarker* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.map = self.mapView;
    }];
}
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    FRSearchByCategoryMarkerView* markerView = [FRSearchByCategoryMarkerView new];
    
    UILabel* tempLabel = [UILabel new];
    tempLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
    
    if ([marker.userData isKindOfClass:[UserEntity class]]) {
        
        tempLabel.text = @"You";
    } else {
        
        FREvent* event = [[NSManagedObjectContext MR_defaultContext] objectWithID:((NSManagedObject*)marker.userData).objectID];
        tempLabel.text = event.title;
    }
    
    [tempLabel sizeToFit];
    CGFloat width = 12 + 26 + 7 + 12 + tempLabel.bounds.size.width;
    
    if (width > 200) {
        width = 200;
    } else if (width < 150) {
        width = 150;
    }
    
    
    [markerView setFrame:CGRectMake(0, 0, width, 54)];
    markerView.delegate = self;

    markerView.userInteractionEnabled = YES;
    [markerView updateWithModel:marker.userData];
    return markerView;
}

- (void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self showEventPreviewWithEvent:marker.userData];
}

- (GMSMapView*)mapView
{
    if (!_mapView)
    {
        CLLocationCoordinate2D location = [FRLocationManager sharedInstance].location;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                                longitude:location.longitude
                                                                     zoom:6];
        _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//        _mapView.myLocationEnabled = true;
        _mapView.delegate = self;
        [self.contentView addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _mapView;
}

- (UIButton*)showFullMapButton
{
    if (!_showFullMapButton)
    {
        _showFullMapButton = [UIButton new];
        _showFullMapButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _showFullMapButton.layer.cornerRadius = 17;
        [_showFullMapButton setImage:[UIImage imageNamed:@"map-open"] forState:UIControlStateNormal];
        [_showFullMapButton setImage:[UIImage imageNamed:@"map-close"] forState:UIControlStateSelected];
        [self.contentView addSubview:_showFullMapButton];
        [_showFullMapButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@34);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(10);
        }];
    }
    return _showFullMapButton;
}


@end
