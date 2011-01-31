/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      Process.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       Process
 * @abstract    ...
 */
@interface Process: NSObject
{
@protected
    
    NSInteger   pid;        /* Process ID */
    NSString  * name;       /* Process name */
    NSInteger   cpu;        /* CPU usage */
    NSInteger   mem;        /* Memory usage */
    NSString  * command;    /* Launch command */
    NSInteger   gid;        /* Effective group ID */
    NSString  * lstart;     /* Start time */
    NSInteger   nice;       /* Nice value */
    NSString  * paddr;      /* Swap address */
    NSInteger   pgid;       /* Process group ID */
    NSInteger   ppid;       /* Parent process ID */
    NSInteger   pri;        /* Scheduling priority */
    NSInteger   rss;        /* Real memory / KB */
    NSInteger   uid;        /* Effective UID */
    NSString  * user;       /* User name */
    NSInteger   vsz;        /* Virtual size / KB */
    
@private
    
    id r1;
    id r2;
}

@property( assign, readwrite ) NSInteger  pid;
@property( copy,   readwrite ) NSString * name;
@property( assign, readwrite ) NSInteger  cpu;
@property( assign, readwrite ) NSInteger  mem;
@property( copy,   readwrite ) NSString * command;
@property( assign, readwrite ) NSInteger  gid;
@property( copy,   readwrite ) NSString * lstart;
@property( assign, readwrite ) NSInteger  nice;
@property( copy,   readwrite ) NSString * paddr;
@property( assign, readwrite ) NSInteger  pgid;
@property( assign, readwrite ) NSInteger  ppid;
@property( assign, readwrite ) NSInteger  pri;
@property( assign, readwrite ) NSInteger  rss;
@property( assign, readwrite ) NSInteger  uid;
@property( copy,   readwrite ) NSString * user;
@property( assign, readwrite ) NSInteger  vsz;

+ ( Process * )processWithPid: ( NSUInteger )processId name: processName;

@end
