//
//  UITableView+Wave.m
//  TableViewWaveDemo
//
//  Created by jason on 14-4-23.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "UITableView+Wave.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITableView (Wave)


- (void)reloadDataAnimateWithWave
{
    
    [self setContentOffset:self.contentOffset animated:NO];
    //连续点击问题修复：cell复位已经确保之前动画被取消
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [UIView transitionWithView:self
                      duration:.1
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        [self setHidden:YES];
                        [self reloadData];
                    } completion:^(BOOL finished) {
                        if(finished){
                            [self setHidden:NO];
                            [self visibleRowsBeginAnimation];
                        }
                    }
     ];
}


- (void)visibleRowsBeginAnimation
{
    NSArray *array = [self visibleCells];
    for (int i=0 ; i < [array count]; i++) {
        //NSIndexPath *path = [array objectAtIndex:i];
        UITableViewCell *cell = [array objectAtIndex:i];
        //cell.frame = [self rectForRowAtIndexPath:path];
        cell.hidden = YES;
        [cell.layer removeAllAnimations];
        //NSArray *array = @[path,[NSNumber numberWithInt:animation]];
        [self performSelector:@selector(animationStart:) withObject:cell afterDelay:.12*i];
        //NSLog(@"%@",array);
    }
}


- (void)animationStart:(UITableViewCell *)cell
{
    cell.hidden = NO;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.6];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.autoreverses = NO;
    
    
    CABasicAnimation *opaAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    opaAnimation.fromValue = @(0.f);
    opaAnimation.toValue = @(1.f);
    opaAnimation.autoreverses = NO;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scaleAnimation,opaAnimation];
    group.duration = kWAVE_DURATION;
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeForwards;
    
    [cell.layer addAnimation:group forKey:nil];
    
}

@end
