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
//  PdSMatrixViewController.m
//
//  Created by Benoit Pereira da Silva on 20/10/13.
//  Copyright (c) 2013 http://pereira-da-Silva.com All rights reserved.

#import "PdSMatrixViewController.h"
#import "PdSMatrixCellViewController.h"

@interface PdSMatrixViewController(){
}
@property (strong,nonatomic)UIViewController *header;
@property (strong,nonatomic)UIViewController *footer;
@property (strong,nonatomic)NSMutableArray* matrixCellViewControllers;
@property (strong,nonatomic)NSMutableArray* positions;
@property (strong,nonatomic)UIImageView*matrixBackgroundImageView;
@end

@implementation PdSMatrixViewController

@synthesize matrixCellViewControllers = _matrixCellViewControllers;
@synthesize positions = _positions;
@synthesize selectedIndex = _selectedIndex;
@synthesize header = _header;
@synthesize footer = _footer;

@synthesize matrixBackgroundImage = _matrixBackgroundImage;
@synthesize matrixBackgroundImageView = _matrixBackgroundImageView;


- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex=selectedIndex;
    for (PdSMatrixCellViewController  *cellViewController in self.matrixCellViewControllers) {
        if(cellViewController.matrixIndex!=selectedIndex){
            [cellViewController setSelected:NO animated:YES];
        }
        if(cellViewController.matrixIndex==selectedIndex){
            [cellViewController setSelected:YES animated:YES];
        }
    }
}


- (NSUInteger)selectedIndex{
    return _selectedIndex;
}


/**
 *  Display the cells animated or not
 *
 *  @param animated should the cell transition be animated
 */
- (void)reloadCellsAnimated:(BOOL)animated{
    [self reloadCellsAnimated:animated
         withAnimationOptions:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCurlUp];
}

/**
 *   Display the cells animated or not with animations options
 *
 *  @param animated should the cell transition be animated
 *  @param options  check UIViewAnimationOptions
 */
- (void)reloadCellsAnimated:(BOOL)animated withAnimationOptions:(NSUInteger)options{
    if([self _isConform]){
        PdSMatrixViewController *__weak weakSelf=self;
        [self _loadMatrixCellViewControllersWith:^{
            [weakSelf displayCellsAnimated:animated withAnimationOptions:options];
        }animated:animated withAnimationOptions:options];
    }
}


/**
 *  Displays the celles according to the current geometry (without reloading)
 *
 *  @param animated  should the transition be animated
 */
- (void)displayCellsAnimated:(BOOL)animated{
    [self displayCellsAnimated:animated
          withAnimationOptions:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCurlUp];
}

/**
 *  Displays the celles according to the current geometry (without reloading)
 *
 *  @param animated hould the cell transition be animated
 *  @param options  check UIViewAnimationOptions
 */
- (void)displayCellsAnimated:(BOOL)animated withAnimationOptions:(NSUInteger)options{
    PdSMatrixViewController *__weak weakSelf=self;
    NSInteger n=[[weakSelf _casted] viewControllersCount];
    if(n>0){
        [UIView animateWithDuration:animated?0.2f:0.f
                              delay:0.f
                            options:options
                         animations:^{
                             BOOL isLandscapeOrientation= UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
                             
                             CGSize viewSize=weakSelf.view.bounds.size;
                             
                             if(weakSelf.matrixBackgroundColor && ![weakSelf.view.backgroundColor isEqual:weakSelf.matrixBackgroundColor]){
                                 [weakSelf.view setBackgroundColor:weakSelf.matrixBackgroundColor];
                             }// Else we keep the previous value
                             
                             if(weakSelf.matrixBackgroundImage){
                                 if(!weakSelf.matrixBackgroundImageView){
                                     weakSelf.matrixBackgroundImageView=[[UIImageView alloc] initWithFrame:weakSelf.view.bounds];
                                     [weakSelf.matrixBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
                                     [_matrixBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                                     [_matrixBackgroundImageView setImage:_matrixBackgroundImage];
                                 }else{
                                     [_matrixBackgroundImageView setImage:_matrixBackgroundImage];
                                 }
                                 if(!_matrixBackgroundImageView.superview){
                                     [weakSelf.view addSubview:_matrixBackgroundImageView];
                                 }
                             }else{
                                 [weakSelf.matrixBackgroundImageView removeFromSuperview];
                             }
                             
                             
                             CGFloat minHSP=[[weakSelf _casted] cellMinimumHorizontalSpacing];
                             CGFloat minVSP=[[weakSelf _casted] cellMinimumVerticalSpacing];
                             
                             CGFloat headerHeight=isLandscapeOrientation?[weakSelf headerHeightForLandscapeOrientation]:[weakSelf headerHeightForPortraitOrientation];
                             CGFloat footerHeight=isLandscapeOrientation?[weakSelf footerHeightForLandscapeOrientation]:[weakSelf footerHeightForPortraitOrientation];
                             
                             
                             _positions=[NSMutableArray array];
                             
                             // HEADER
                             
                             if(!weakSelf.header){
                                 weakSelf.header=[[weakSelf _casted] headerViewController];
                             }
                             if(weakSelf.header.view){
                                 [weakSelf _addSupplementaryViewController:weakSelf.header
                                                                       atY:0.f
                                                                withHeight:headerHeight];
                             }
                             
                             // FOOTER
                             if(!weakSelf.footer){
                                 weakSelf.footer=[[weakSelf _casted] footerViewController];
                             }
                             if(weakSelf.footer){
                                 [weakSelf _addSupplementaryViewController:weakSelf.footer
                                                                       atY:viewSize.height-footerHeight
                                                                withHeight:footerHeight];
                             }
                             
                             // CELLS
                             
                             CGSize containerSize=[weakSelf _containerSize];
                             CGSize cellSize=[weakSelf _computeCellSize];
                             
                             NSInteger numberOfCellPerLine=(containerSize.width-(minHSP*2))/cellSize.width;
                             
                             NSUInteger nb=[[weakSelf _casted] viewControllersCount];
                             NSInteger lineNumber=0;
                             NSInteger columnNumber=0;
                             
                             CGFloat maxX=0.f;
                             CGFloat maxY=0.f;
                             
                             // WTLog( @"numberOfCellPerLine:%i for %i items",numberOfCellPerLine,nb);
                             
                             for (int i=0; i<nb; i++) {
                                 
                                 PdSMatrixCellViewController*cellViewController=[[weakSelf _casted] viewControllerForIndex:i];
                                 
                                 // We register the view controller
                                 [weakSelf _registerViewController:cellViewController];
                                 
                                 CGRect destination=[weakSelf _destinationAtLineNumber:lineNumber
                                                                       andColumnNumber:columnNumber
                                                                          withCellSize:cellSize];
                                 
                                 // We store the raw position
                                 [_positions addObject:[NSValue valueWithCGRect:destination]];
                                 
                                 if(columnNumber>=numberOfCellPerLine-1){
                                     maxX=destination.origin.x+destination.size.width+minHSP;
                                     columnNumber=0;
                                     lineNumber++;
                                 }else{
                                     columnNumber++;
                                 }
                                 maxY=destination.origin.y+destination.size.height+minVSP;
                             }
                             
                             
                             CGFloat deltaX=viewSize.width-maxX;
                             CGFloat deltaY=(viewSize.height-maxY);
                             deltaY+=headerHeight;
                             deltaY-=footerHeight;
                             for (int i=0; i<nb; i++) {
                                 
                                 // We do proceed to adjustement Vertical an horizontal of the box.
                                 CGRect destination=[[_positions objectAtIndex:i] CGRectValue];
                                 
                                 // Centering of the block
                                 destination.origin.x+= roundf(deltaX/2.f);
                                 destination.origin.y+= roundf(deltaY/2.f);
                                 
                                 PdSMatrixCellViewController*cellViewController=[_matrixCellViewControllers objectAtIndex:i];
                                 [weakSelf _addViewController:cellViewController
                                                atDestination:destination];
                                 
                             }
                             
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        
    }
}

- (void)_loadMatrixCellViewControllersWith:(void (^)(void))displayBlock
                                  animated:(BOOL)animated
                      withAnimationOptions:(NSUInteger)options{
    PdSMatrixViewController *__weak weakSelf=self;
    [UIView animateWithDuration:animated?0.2f:0.f
                          delay:0.f
                        options:options
                     animations:^{
                         [weakSelf _removeMatrixCells];
                     }
                     completion:^(BOOL finished) {
                         [weakSelf _postCellRemoval];
                         displayBlock();
                     }];
}


- (void)_removeMatrixCells{
    NSMutableArray *toBeRemoved=[NSMutableArray arrayWithArray:self.matrixCellViewControllers];
    if(self.header){
        [toBeRemoved addObject:self.header];
    }
    if(self.footer){
        [toBeRemoved addObject:self.footer];
    }
    for (UIViewController  *vc in toBeRemoved) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
}


- (void)_postCellRemoval{
    [self.matrixCellViewControllers removeAllObjects];
    self.matrixCellViewControllers=[NSMutableArray array];
    self.header=nil;
    self.footer=nil;
}



- (void)_registerViewController:(PdSMatrixCellViewController*)cellViewController{
    // We reference the matrix controller
    cellViewController.matrix=[self _casted];
    [_matrixCellViewControllers addObject:cellViewController];
    // And its index
    cellViewController.matrixIndex=[_matrixCellViewControllers count]-1;
}




- (void)_addViewController:(UIViewController*)cellViewController
             atDestination:(CGRect)destination{
    
    // We add the view controller.
    [self addChildViewController:cellViewController];
    // We setup the frame
    [cellViewController.view setFrame:destination];
    // We add its subview
    [self.view addSubview:cellViewController.view];
    
    //[cellViewController.view setAlpha:0.3f];
    
    // We notify the move to parent.
    [cellViewController didMoveToParentViewController:self];
}



- (void)_addSupplementaryViewController:(UIViewController*)viewController
                                    atY:(CGFloat)y
                             withHeight:(CGFloat)height{
    
    CGRect destination=CGRectMake(0, roundf(y), [self _containerSize].width, roundf(height));
    
    [self _addViewController:viewController
               atDestination:destination];
}



- (CGRect)_destinationAtLineNumber:(NSInteger)lineNumber
                   andColumnNumber:(NSInteger)columnNumber
                      withCellSize:(CGSize)cellSize{
    
    CGFloat hSpace=[[self _casted] cellMinimumHorizontalSpacing];
    CGFloat vSpace=[[self _casted] cellMinimumVerticalSpacing];
    CGFloat x=columnNumber*(cellSize.width+hSpace)+hSpace;
    CGFloat y=lineNumber*(cellSize.height+vSpace)+vSpace;
    CGRect destination=CGRectMake(x,y, cellSize.width, cellSize.height);
    
    return destination;
    
}



#pragma mark - Cell size computation

- (CGSize)_computeCellSize{
    NSInteger n=[[self _casted] viewControllersCount];
    CGSize cellSize=CGSizeZero;
    if(n>0){
        // We try to find a solution to arrange the cells in the matrix
        CGSize containerSize=[self _containerSize];
        CGFloat containerSurface=(CGFloat)containerSize.width*containerSize.height;
        CGFloat surfacePerCell=(containerSurface/(CGFloat)n); // WE should remove padding surface for a more accurate approximation
        
        BOOL isLandscapeOrientation= UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
        CGSize desiredCellSize=isLandscapeOrientation?  [[self _casted] cellDesiredSizeForLandscapeOrientation]:\
        [[self _casted] cellDesiredSizeForPortraitOrientation];
        
        CGFloat ratioHW=desiredCellSize.height/desiredCellSize.width;
        CGFloat cellWidth= sqrtf(surfacePerCell/ratioHW);
        CGFloat cellHeight=cellWidth*ratioHW;
        
        CGSize spacerSize=CGSizeMake([[self _casted] cellMinimumHorizontalSpacing], [[self _casted] cellMinimumVerticalSpacing]);
        cellSize=CGSizeMake(cellWidth, cellHeight);
        BOOL fits=NO;
        while (!fits) {
            fits=[self _anEnsembleOfCellNumber:n
                                  cellWithSize:cellSize
                         fitsContainerWithSize:containerSize
                                withSpacerSize:spacerSize];
            cellSize.width--;
            cellSize.height= cellSize.width*ratioHW;
        }
    }
    cellSize=CGSizeMake(floorf(cellSize.width), floorf(cellSize.height));
    return cellSize;
}

- (CGSize)_containerSize{
    CGSize containerSize=self.view.bounds.size;
    BOOL isLandscapeOrientation= UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    CGFloat footerHeight=isLandscapeOrientation?[self footerHeightForLandscapeOrientation]:[self footerHeightForPortraitOrientation];
    CGFloat headerHeight=isLandscapeOrientation?[self headerHeightForLandscapeOrientation]:[self headerHeightForPortraitOrientation];
    containerSize.height=containerSize.height-(headerHeight+footerHeight);
    return containerSize;
}


- (BOOL)_anEnsembleOfCellNumber:(NSInteger)n
                   cellWithSize:(CGSize)cellSize
          fitsContainerWithSize:(CGSize)containerSize
                 withSpacerSize:(CGSize)spacerSize{
    CGFloat line=1;
    CGFloat rowCumulatedWidth=spacerSize.width;
    for (int i=0; i<n; i++) {
        if(rowCumulatedWidth+spacerSize.width+cellSize.width>=containerSize.width){
            rowCumulatedWidth=spacerSize.width;//We reinitialize the row cumulated width
            line++;//we increment the line number.
        }
        rowCumulatedWidth=rowCumulatedWidth+spacerSize.width+cellSize.width;
        CGFloat cumulatedHeight=(line*(cellSize.height+spacerSize.height*2.f))-spacerSize.height;
        if(cumulatedHeight>containerSize.height){
            return NO;
        }
    }
    return YES;
}


#pragma mark - facilities


- (PdSMatrixViewController<PdSMatrixCellDelegateProtocol>*)_casted{
    return (PdSMatrixViewController<PdSMatrixCellDelegateProtocol>*)self;
}


- (BOOL)_isConform{
    if([self conformsToProtocol:@protocol(PdSMatrixCellDelegateProtocol)]){
        return YES;
    }else{
        [NSException raise:NSStringFromClass([self class])
                    format:@"%@ must conforms to @protocol(PdSMatrixCellDelegateProtocol)",NSStringFromClass([self class])];
    }
    return NO;
}



#pragma  mark - UIGestureRecognizerDelegatew

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma  mark -



// Default placeholder implementation


/**
 *  The matrix header view controller
 *
 *  @return the header view controller;
 */
- (UIViewController*)headerViewController{
    return nil;
}

/**
 *  The matrix header view controller
 *
 *  @return the footer view controller;
 */
- (UIViewController*)footerViewController{
    return nil;
}


/**
 *  The height of the header
 *
 *  @return return the height
 */
- (CGFloat)headerHeightForLandscapeOrientation{
    return 0.f;
}

/**
 *  The height of the footer
 *
 *  @return return the height
 */
- (CGFloat)footerHeightForLandscapeOrientation{
    return 0.f;
}

/**
 *  The height of the header
 *
 *  @return return the height
 */
- (CGFloat)headerHeightForPortraitOrientation{
    return 0.f;
}
/**
 *  The height of the footer
 *
 *  @return return the height
 */
- (CGFloat)footerHeightForPortraitOrientation{
    return 0.f;
}



- (NSString*)description{
    NSMutableString *s=[NSMutableString string];
    [s appendString:[super description]];
    [s appendString:@"\n"];
    [s appendFormat:@"navigation controller : %@ \n",self.navigationController.navigationBar];
    [s appendFormat:@"header : %@ %@\n",self.header,self.header.view];
    [s appendFormat:@"footer : %@ %@\n",self.footer,self.footer.view];
    int i=0;
    for (PdSMatrixCellViewController  *vc in self.matrixCellViewControllers) {
        [s appendFormat:@"Cell %i : %@ %@ \n",i,vc,vc.view];
        i++;
    }
    [s appendFormat:@"toolbar : %@ %@\n",self.navigationController.toolbar,self.navigationController.toolbar];
    return s;
}

@end
