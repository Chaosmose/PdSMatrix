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
//  PdSMatrixCellViewController.m
//
//  Created by Benoit Pereira da Silva on 20/10/13.
//  Copyright (c) 2013 http://pereira-da-Silva.com All rights reserved.


#import "PdSMatrixCellViewController.h"

@interface PdSMatrixCellViewController (){
    UITapGestureRecognizer *_tapRecognizer;
}

@end

@implementation PdSMatrixCellViewController


#pragma mark -view life cycle and UIGesture tap management


- (BOOL)selected{
    if(!self.matrix || self.matrixIndex==NSNotFound)
        return NO;
    else
        return (self.matrixIndex==self.matrix.selectedIndex);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // We add the UITapGestureRecognizer
    _tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(_handleTap:)];
    [_tapRecognizer setNumberOfTapsRequired:1];
    [_tapRecognizer setNumberOfTouchesRequired:1];
    [_tapRecognizer setDelegate:self.matrix];
    [self.view addGestureRecognizer:_tapRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_tapRecognizer removeTarget:self action:@selector(_handleTap:)];
    [self.view removeGestureRecognizer:_tapRecognizer];
    _tapRecognizer=nil;
}


- (void)_handleTap:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){
        if(self.selected==NO)
            self.matrix.selectedIndex=self.matrixIndex;
        [self didPerformActionWithIdentifier:PdS_MATRIX_CELL_TAPPED_ACTION_IDENTIFIER];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    // Currently no default implementation
}

#pragma mark  PdSMatrixCellViewControllerProtocol


/**
 *  You should call this method to pass actions to the delegate matrix
 *
 *  @param identifier of the action to relay to the matrix
 */
- (void)didPerformActionWithIdentifier:(NSInteger)identifier{
    [self.matrix matrixCell:self didPerformActionWithIdentifier:identifier withInfos:nil];

}

/**
 *  You should call this method to pass actions to the delegate matrix
 *
 *  @param identifier identifier of the action to relay to the matrix
 *  @param infos      optional informations
 */
- (void)didPerformActionWithIdentifier:(NSInteger)identifier withInfos:(NSDictionary*)infos{
    [self.matrix matrixCell:self didPerformActionWithIdentifier:identifier withInfos:infos];
}


/**
 *  The model is passed to the controller for configuration
 *
 *  @param model the reference to the model
 */
- (void)configureViewControllerFor:(id)model{
}



@end
