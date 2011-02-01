/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        ProcessInfos.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "ProcessInfos.h"
#import "Process.h"

@interface ProcessInfos( Private )

- ( void )getProcesses;

@end

@implementation ProcessInfos( Private )

- ( void )getProcesses
{
    NSTask              * task;
    NSPipe              * pipe;
    NSFileHandle        * fh;
    NSData              * data;
    NSString            * output;
    NSMutableArray      * lines;
    NSString            * line;
    NSString            * command;
    NSAutoreleasePool   * ap;
    NSMutableDictionary * threadDict;
    NSMutableDictionary * processDict;
    Process             * process;
    NSUInteger            pid;
    BOOL                  exitThread;
    
    ap         = [ NSAutoreleasePool new ];
    threadDict = [ [ NSThread currentThread ] threadDictionary ];
    exitThread = NO;
    
    [ threadDict setValue: [ NSNumber numberWithBool: exitThread ] forKey: @"ProcessesThreadShouldExit" ];
    
    while( exitThread == NO )
    {
        if( ap == nil )
        {
            ap = [ NSAutoreleasePool new ];
        }
        
        processDict = [ NSMutableDictionary dictionaryWithCapacity: 100 ];
        
        /***********************************************************************
         * 
         **********************************************************************/
        
        task = [ NSTask new ];
        pipe = [ NSPipe pipe ];
        
        [ task setLaunchPath: @"/bin/ps" ];
        [ task setArguments: [ NSArray arrayWithObjects: @"-ec", @"-o", @"pid,command", nil ] ];
        [ task setStandardOutput: pipe ];
        [ task launch ];
        
        while( [ task isRunning ] == YES )
        {
            usleep( 10 );
        }
        
        fh     = [ pipe fileHandleForReading ];
        data   = [ fh readDataToEndOfFile ];
        output = [ [ NSString alloc ] initWithData: data encoding: NSASCIIStringEncoding ];
        lines  = [ NSMutableArray arrayWithArray: [ output componentsSeparatedByString: @"\n" ] ];
        
        [ lines removeObjectAtIndex: 0 ];
        
        for( line in lines )
        {
            @try
            {
                pid     = [ [ line substringToIndex: 5 ] integerValue ];
                command = [ line substringFromIndex: 6 ];
            }
            @catch( NSException * e )
            {
                continue;
            }
            
            if( [ command isEqualToString: @"ps" ] )
            {
                continue;
            }
            
            process = [ Process processWithPid: pid name: command ];
            
            [ processDict setObject: process forKey: [ NSString stringWithFormat: @"%06u", ( unsigned int )pid ] ];
        }
        
        [ output release ];
        [ task release ];
        
        /***********************************************************************
         * 
         **********************************************************************/
        
        task = [ NSTask new ];
        pipe = [ NSPipe pipe ];
        
        [ task setLaunchPath: @"/bin/ps" ];
        [ task setArguments: [ NSArray arrayWithObjects: @"-e", @"-o", @"pid,command", nil ] ];
        [ task setStandardOutput: pipe ];
        [ task launch ];
        
        while( [ task isRunning ] == YES )
        {
            usleep( 10 );
        }
        
        fh     = [ pipe fileHandleForReading ];
        data   = [ fh readDataToEndOfFile ];
        output = [ [ NSString alloc ] initWithData: data encoding: NSASCIIStringEncoding ];
        lines  = [ NSMutableArray arrayWithArray: [ output componentsSeparatedByString: @"\n" ] ];
        
        [ lines removeObjectAtIndex: 0 ];
        
        for( line in lines )
        {
            @try
            {
                pid     = [ [ line substringToIndex: 5 ] integerValue ];
                command = [ line substringFromIndex: 6 ];
            }
            @catch( NSException * e )
            {
                continue;
            }
            
            if( [ command isEqualToString: @"ps -e -p pid,command" ] )
            {
                continue;
            }
            
            process = [ processDict objectForKey: [ NSString stringWithFormat: @"%06u", ( unsigned int )pid ] ];
            
            if( process == nil )
            {
                continue;
            }
            
            process.command = command;
        }
        
        [ output release ];
        [ task release ];
        
        /***********************************************************************
         * 
         **********************************************************************/
        
        task = [ NSTask new ];
        pipe = [ NSPipe pipe ];
        
        [ task setLaunchPath: @"/bin/ps" ];
        [ task setArguments: [ NSArray arrayWithObjects: @"-ax", @"-o", @"pid,ppid,uid,gid,nice,pri,paddr,rss,vsz,%cpu,%mem,lstart,user", nil ] ];
        [ task setStandardOutput: pipe ];
        [ task launch ];
        
        while( [ task isRunning ] == YES )
        {
            usleep( 10 );
        }
        
        fh     = [ pipe fileHandleForReading ];
        data   = [ fh readDataToEndOfFile ];
        output = [ [ NSString alloc ] initWithData: data encoding: NSASCIIStringEncoding ];
        lines  = [ NSMutableArray arrayWithArray: [ output componentsSeparatedByString: @"\n" ] ];
        
        [ lines removeObjectAtIndex: 0 ];
        
        for( line in lines )
        {
            @try
            {
                pid = [ [ line substringToIndex: 5 ] integerValue ];
            }
            @catch( NSException * e )
            {
                continue;
            }
            
            process = [ processDict objectForKey: [ NSString stringWithFormat: @"%06u", ( unsigned int )pid ] ];
            
            if( process == nil )
            {
                continue;
            }
            
            @try
            {
                process.ppid   = [ [ [ line substringFromIndex: 6  ] substringToIndex: 5 ] integerValue ];
                process.uid    = [ [ [ line substringFromIndex: 12 ] substringToIndex: 5 ] integerValue ];
                process.gid    = [ [ [ line substringFromIndex: 18 ] substringToIndex: 5 ] integerValue ];
                process.nice   = [ [ [ line substringFromIndex: 24 ] substringToIndex: 2 ] integerValue ];
                process.pri    = [ [ [ line substringFromIndex: 27 ] substringToIndex: 3 ] integerValue ];
                process.paddr  = [ NSString stringWithFormat: @"0x%@", [ [ [ line substringFromIndex: 32 ] substringToIndex: 7 ] uppercaseString ] ];
                process.rss    = [ [ [ line substringFromIndex: 40 ] substringToIndex: 6 ] integerValue ];
                process.vsz    = [ [ [ line substringFromIndex: 47 ] substringToIndex: 8 ] integerValue ];
                process.cpu    = [ [ [ line substringFromIndex: 56 ] substringToIndex: 5 ] floatValue ];
                process.mem    = [ [ [ line substringFromIndex: 62 ] substringToIndex: 4 ] floatValue ];
                process.lstart = [ NSString stringWithFormat: @"%@ %@ - %@", [ [ line substringFromIndex: 67 ] substringToIndex: 10 ], [ [ line substringFromIndex: 87 ] substringToIndex: 4 ], [ [ line substringFromIndex: 78 ] substringToIndex: 8 ] ];
                process.user   = [ [ line substringFromIndex: 96 ] substringToIndex: [ line length ] - 96 ];
            }
            @catch( NSException * e )
            {
                continue;
            }
        }
        
        while( [ self.lock tryLock ] == NO );
        
        [ processes removeAllObjects ];
        [ processes setValuesForKeysWithDictionary: processDict ];
        [ self.lock unlock ];
        
        exitThread = [ [ threadDict valueForKey: @"ASLThreadShouldExit" ] boolValue ];
        
        if( exitThread == NO )
        {
            [ NSThread sleepForTimeInterval: 5 ];
        }
        
        [ output release ];
        [ task release ];
        [ ap release ];
        
        ap = nil;
    }
}

@end

@implementation ProcessInfos

@synthesize lock;

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        processes = [ [ NSMutableDictionary dictionaryWithCapacity: 100 ] retain ];
        lock      = [ NSLock new ];
        
        [ self performSelectorInBackground: @selector( getProcesses ) withObject: nil ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ lock release ];
    [ processes release ];
    [ super dealloc ];
}

- ( NSArray * )processes
{
    NSArray * values;
    
    while( [ self.lock tryLock ] == NO );
    
    values = [ processes allValues ];
    
    values = [ values sortedArrayUsingComparator: ^( Process * obj1, Process * obj2 )
        {
            NSComparisonResult result;
            
            if( obj1.pid > obj2.pid )
            {
                result = ( NSComparisonResult )NSOrderedAscending;
            }
            else
            {
                result = ( NSComparisonResult )NSOrderedDescending;
            }
            
            return result;
        }
    ];
    
    [ self.lock unlock ];
    
    return values;
}

@end
