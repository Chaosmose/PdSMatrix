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
//  PdSMatrixProtocol.h
//
//  Created by Benoit Pereira da Silva on 20/10/13.
//  Copyright (c) 2013 http://pereira-da-Silva.com All rights reserved.

#import <Foundation/Foundation.h>

// The  PdSMatrixViewController is a controller container
// that arrange cell view controllers (PdSMatrixCellViewController) on one "screen"
// It adjust the cells according to the number of elements to fit the whole screen.

// Your matrix controller need to inheritate from PdSMatrixViewController
// and conform to PdSMatrixCellDelegateProtocol

//  You matrix cells must inheritate from PdSMatrixCellViewController
//  and conforms PdSMatrixCellDataProtocol


@class PdSMatrixCellViewController;
@class PdSMatrixViewController;


#pragma mark - PdSMatrixCellDataProtocol

/**
 *  Your matrix cells view controller must adopt this protocol
 */
@protocol  PdSMatrixCellDataProtocol
@required
/**
 *  The model is passed to the controller for configuration
 *
 *  @param model the reference to the model
 */
- (void)configureViewControllerWith:(id)model;

@end


#pragma mark - PdSMatrixCellDelegateProtocol


/**
 *  The matrix must implement the PdSMatrixCellDelegateProtocol
 */
@protocol PdSMatrixCellDelegateProtocol

@required

/**
 *  Returns view controller for the given index
 *
 *  This selector should  :
 *  1- Instantiate the <PdSMatrixCellViewController Class>*matrixCell=...;
 *  2- Reference the matriox  matrixCell.matrix=self;
 *  3- call id model=[self modelForIndex:index];
 *  4- configure the cell with : [cell configureViewControllerWith:model];
 *  You configureViewControllerWith:model may need to call if (self.view) to force the view loading
 *
 *  @param index of the viewController
 *
 *  @return return the viewController reference
 */
- (PdSMatrixCellViewController<PdSMatrixCellDataProtocol>*)viewControllerForIndex:(NSUInteger)index;

/**
 *  The number of view controller
 *
 *  @return NSUInteger
 */
- (NSUInteger)viewControllersCount;

/**
 *  The method should be used in the selector viewControllerForIndex:
 *  @param index the cell index
 *
 *  @return the model
 */
- (id)modelForIndex:(NSUInteger)index;

/**
 *  The desired size for landscape orientation
 *
 *  @return the size
 */
- (CGSize)cellDesiredSizeForLandscapeOrientation;


/**
 *  The desired size for portrait orientation
 *
 *  @return the size
 */
- (CGSize)cellDesiredSizeForPortraitOrientation;

/**
 *  The minimum vertical spacing between cells
 *
 *  @return the width
 */
- (CGFloat)cellMinimumVerticalSpacing;


/**
 *  The minimum horizontal spacing between cells
 *
 *  @return the height
 */
- (CGFloat)cellMinimumHorizontalSpacing;



@optional

/**
 *  This selector is call to pass actions to the matrix
 *
 *  @param identifier identifier of the action to relay to the matrix
 *  @param infos      optional informations
 */
- (void)matrixCell:(PdSMatrixCellViewController*)cell didPerformActionWithIdentifier:(NSInteger)identifier withInfos:(NSDictionary*)infos;

/**
 *  The matrix header view controller
 *
 *  @return the header view controller;
 */
- (UIViewController*)headerViewController;

/**
 *  The matrix header view controller
 *
 *  @return the footer view controller;
 */
- (UIViewController*)footerViewController;


/**
 *  The height of the header
 *
 *  @return return the height
 */
- (CGFloat)headerHeightForLandscapeOrientation;

/**
 *  The height of the footer
 *
 *  @return return the height
 */
- (CGFloat)footerHeightForLandscapeOrientation;


/**
 *  The height of the header
 *
 *  @return return the height
 */
- (CGFloat)headerHeightForPortraitOrientation;

/**
 *  The height of the footer
 *
 *  @return return the height
 */
- (CGFloat)footerHeightForPortraitOrientation;


@end
