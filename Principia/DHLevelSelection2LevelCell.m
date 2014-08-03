//
//  DHLevelSelection2LevelCell.m
//  Euclid
//
//  Created by David Hallgren on 2014-08-02.
//  Copyright (c) 2014 David Hallgren. All rights reserved.
//

#import "DHLevelSelection2LevelCell.h"
#import "DHGeometryView.h"

@implementation DHLevelSelection2LevelCell {
    BOOL _selected;
    id _target;
    SEL _action;
    
    UILabel* _titleLabel;
    DHGeometryView* _geometryView;
    UIImageView* _checkmarkView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selected = NO;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 6.0;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [[UIApplication sharedApplication] delegate].window.tintColor;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _geometryView = [[DHGeometryView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_geometryView];
        _geometryView.translatesAutoresizingMaskIntoConstraints = NO;
        _geometryView.geometricObjects = [[NSMutableArray alloc] init];
        _geometryView.hideBorder = YES;
        _geometryView.keepContentCenteredAndZoomedIn = YES;
        
        UIImage* checkmark = [[UIImage imageNamed:@"Checkbox"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _checkmarkView = [[UIImageView alloc] initWithImage:checkmark];
        [self addSubview:_checkmarkView];
        _checkmarkView.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:5]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_geometryView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_geometryView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_titleLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_geometryView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_geometryView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:-10]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_checkmarkView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_checkmarkView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:-5]];
}

- (void)setTouchActionWithTarget:(id)target andAction:(SEL)action
{
    _target = target;
    _action = action;
}

#pragma mark - Override property getters/setters
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = _title;
    [_titleLabel sizeToFit];
    [self updateConstraints];
    
}

- (void)setLevel:(DHLevel<DHLevel>*)level
{
    _level = level;
    [_geometryView.geometricObjects removeAllObjects];
    [_geometryView.geoViewTransform setScale:1];
    [_geometryView.geoViewTransform setOffset:CGPointMake(0, 0)];
    [_level createInitialObjects:_geometryView.geometricObjects];
    [_level createSolutionPreviewObjects:_geometryView.geometricObjects];
    for (DHGeometricObject* object in _geometryView.geometricObjects) {
        object.drawScale = 0.6;
    }
    [_geometryView setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    if (_enabled) {
        self.userInteractionEnabled = YES;
        _titleLabel.textColor = [[UIApplication sharedApplication] delegate].window.tintColor;
        _geometryView.alpha = 1;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowOpacity = 0.5;
        
    } else {
        self.userInteractionEnabled = NO;
        _titleLabel.textColor = [UIColor lightGrayColor];
        _geometryView.alpha = 0.3;

        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.2;
    
    }
}

- (void)setLevelCompleted:(BOOL)levelCompleted
{
    _levelCompleted = levelCompleted;
    if (_levelCompleted) {
        _checkmarkView.hidden = NO;
    } else {
        _checkmarkView.hidden = YES;
    }
}

#pragma mark - Manage touch input
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self select];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if(!CGRectContainsPoint(self.bounds, touchPoint)) {
        [self deselect];
    } else {
        if (!_selected) [self select];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self deselect];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_selected && _target && _action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
    [self deselect];
}
- (void)select
{
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 2.0;
    _selected = YES;
}
- (void)deselect
{
    if (!_selected) return;
    
    _selected = NO;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:2.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:6.0];
    fadeAnim.duration = 0.5;
    [self.layer addAnimation:fadeAnim forKey:@"shadowRadius"];
    
    // Change the actual data value in the layer to the final value.
    self.layer.shadowRadius = 6.0;
}

@end