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
    NSString            * orderingField;
    NSComparisonResult    ordering;
    NSString            * filter;
    
@private
    
    id r1;
    id r2;
}

@property(       readonly  ) NSArray  * processes;
@property(       readonly  ) NSLock   * lock;
@property( copy, readwrite ) NSString * filter;

- ( void )setOrderingField: ( NSString * )field order: ( NSComparisonResult )order;

@end
