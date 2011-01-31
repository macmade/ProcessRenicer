/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ProcessInfos.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       ProcessInfos
 * @abstract    ...
 */
@interface ProcessInfos: NSObject
{
@protected
    
    NSMutableDictionary * processes;
    NSLock              * lock;
    
@private
    
    id r1;
    id r2;
}

@property( readonly ) NSArray * processes;
@property( readonly ) NSLock  * lock;

@end
