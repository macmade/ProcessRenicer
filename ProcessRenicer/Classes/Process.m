/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        Process.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "Process.h"

@implementation Process

@synthesize pid;
@synthesize name;
@synthesize cpu;
@synthesize mem;
@synthesize command;
@synthesize gid;
@synthesize lstart;
@synthesize nice;
@synthesize paddr;
@synthesize pgid;
@synthesize ppid;
@synthesize pri;
@synthesize rss;
@synthesize uid;
@synthesize user;
@synthesize vsz;

+ ( Process * )processWithPid: ( NSUInteger )processId name: processName
{
    Process * process;
    
    process      = [ Process new ];
    process.pid  = processId;
    process.name = processName;
    
    return [ process autorelease ];
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {}
    
    return self;
}

- ( void )dealloc
{
    [ command release ];
    [ lstart  release ];
    [ paddr   release ];
    [ user    release ];
    [ super   dealloc ];
}

- ( NSString * )description
{
    return [ NSString stringWithFormat: @"%@ [%u] %@", [ super description ], ( unsigned int )pid, name ];
}

@end
