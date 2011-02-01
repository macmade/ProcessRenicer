/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      Execution.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       Execution
 * @abstract    ...
 */
@interface Execution: NSObject
{
@protected
    
    BOOL             canExecuteWithPrivilege;
    AuthorizationRef authorizationRef;
    
@private
    
    id r1;
    id r2;
}

@property( readonly ) BOOL             canExecuteWithPrivilege;
@property( readonly ) AuthorizationRef authorizationRef;

- ( OSStatus )authorizeExecute;
- ( OSStatus )executeWithPrivileges: ( char * )command arguments: ( char * [] )arguments io: ( FILE ** )io;
- ( NSFileHandle * )execute: ( NSString * )command arguments: ( NSArray * )arguments;
- ( NSFileHandle * )open: ( NSString * )target;

@end
