//
//  BSHelperFunctions.h
//
//  Created by Sergey Borichev on 30.11.15.
//  Copyright © 2015 TecSynt. All rights reserved.
//

#import "BSDefines.h"

/**
 *  Execute block on main thread
 *
 *  @param BSCodeBlock block for execution
 */
void BSDispatchBlockToMainQueue(BSCodeBlock);


/**
 *  Creates new block instance with execution on main thread
 */
BSCodeBlock BSMainQueueBlockFromCompletion(BSCodeBlock);


/**
 *  Execute block on main thread
 *
 *  @param BSCompletionBlock block to execute
 *
 *  @return BSCompletionBlock returns new block with adding dispatch_main_queue
 */
BSCompletionBlock BSMainQueueCompletionFromCompletion(BSCompletionBlock);

/**
 *  Execute block on block on background thread
 *
 *  @param BSCompletionBlock block to execute
 *  @param NSError*          instance for handling any blocks errors
 */
void BSDispatchCompletionBlockToMainQueue(BSCompletionBlock, NSError *);

/**
 *  Executes the block after specified time
 *
 *  @param time Time to after
 *  @param block Block to execute
 */
void BSDispatchBlockAfter(CGFloat, BSCodeBlock);

void BSDispatchBlockToBackgroundQueue(BSCodeBlock);

#pragma Objects

BOOL BSIsEmpty(id);
BOOL BSIsEmptyStringByTrimmingWhitespaces(NSString*);


