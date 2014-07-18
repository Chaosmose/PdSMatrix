// This file is part of "PdSMatrix"
//
// "PdSMatrix" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// "PdSMatrix" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "PdSMatrix"  If not, see <http://www.gnu.org/licenses/>
//
//  PdSMatrixViewController.h
//
//  Created by Benoit Pereira da Silva on 20/10/13.
//  Copyright (c) 2013 http://pereira-da-Silva.com All rights reserved.

#import <UIKit/UIKit.h>
#import "PdSMatrixProtocol.h"

/**
 *  Your matrix controller need to inheritate from PdSMatrixViewController 
 *  and conform to PdSMatrixCellDelegateProtocol
 */
@interface PdSMatrixViewController : UIViewController<UIGestureRecognizerDelegate>


@property (nonatomic) NSUInteger selectedIndex;

@property (strong,nonatomic) UIColor* matrixBackgroundColor;
@property (strong,nonatomic) UIImage* matrixBackgroundImage;

/**
 *  Reloads and displays the cells animated or not
 *
 *  @param animated should the cell transition be animated
 */
- (void)reloadCellsAnimated:(BOOL)animated;

/**
*  Reloads and displays the cells animated or not with animations options
*
*  @param animated should the cell transition be animated
*  @param options  check UIViewAnimationOptions
*/
- (void)reloadCellsAnimated:(BOOL)animated withAnimationOptions:(NSUInteger)options;


/**
 *  Displays the celles according to the current geometry (without reloading)
 *
 *  @param animated  should the transition be animated
 */
- (void)displayCellsAnimated:(BOOL)animated;

/**
 *  Displays the celles according to the current geometry (without reloading)
 *
 *  @param animated hould the cell transition be animated
 *  @param options  check UIViewAnimationOptions
 */
- (void)displayCellsAnimated:(BOOL)animated withAnimationOptions:(NSUInteger)options;


/**
 *  Enumerates the cells
 *
 *  @param block                 the block
 *  @param useReverseEnumeration reverse the enumeration or not
 */
- (void)enumerateCellsWithBlock:(void (^)(id cell, NSUInteger idx, BOOL *stop))block reverse:(BOOL)useReverseEnumeration;

@end