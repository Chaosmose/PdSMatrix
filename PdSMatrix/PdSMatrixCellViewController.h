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
//  PdSMatrixCellViewController.h
//
//  Created by Benoit Pereira da Silva on 20/10/13.
//  Copyright (c) 2013 http://pereira-da-Silva.com All rights reserved.

#import <UIKit/UIKit.h>
#import "PdSMatrixViewController.h"

#define PdS_MATRIX_CELL_TAPPED_ACTION_IDENTIFIER 0

/**
 *  You matrix cell must inheritate from PdSMatrixCellViewController 
 *  and conforms PdSMatrixCellDataProtocol
 */
@class PdSMatrixCellViewController;


@interface PdSMatrixCellViewController : UIViewController

/**
 *  This property is automatically set by the PdSMatrixViewController
 */
@property (weak,nonatomic) PdSMatrixViewController<PdSMatrixCellDelegateProtocol> *matrix;

@property (readonly,nonatomic) BOOL selected;

/**
 *  This property is automatically set by the PdSMatrixViewController
 */
@property (nonatomic)NSInteger matrixIndex;

/**
 *  You should call this method to pass actions to the delegate matrix
 *
 *  @param identifier of the action to relay to the matrix
 */
- (void)didPerformActionWithIdentifier:(NSInteger)identifier;

/**
 *  You should call this method to pass actions to the delegate matrix
 *
 *  @param identifier identifier of the action to relay to the matrix
 *  @param infos      optional informations
 */
- (void)didPerformActionWithIdentifier:(NSInteger)identifier withInfos:(NSDictionary*)infos;


/**
 *  Called on selection
 *
 *  @param selected the selection status
 *  @param animated should we animate
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
