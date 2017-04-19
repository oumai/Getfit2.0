/*
 * Copyright (c) 2015, Nordic Semiconductor
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "Utility.h"
#import "UnzipFirmware.h"

@implementation Utility

int  PACKETS_NOTIFICATION_INTERVAL = 10;
int const PACKET_SIZE = 20;

+ (NSArray *)getUpdateFirmWarePath
{
    NSURL *url = [[NSURL alloc] initFileURLWithPath:nil];
    
    return [Utility unzipFiles:url];
}


+ (BOOL)isFileExtension:(NSString *)fileName fileExtension:(enumFileExtension)fileExtension
{
    if ([[fileName pathExtension] isEqualToString:[Utility stringFileExtension:fileExtension]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSArray *)unzipFiles:(NSURL *)zipFileURL
{
    UnzipFirmware *unzipFiles = [[UnzipFirmware alloc]init];
    NSArray *firmwareFilesURL = [unzipFiles unzipFirmwareFiles:zipFileURL];
    // if manifest file exist inside then parse it and retrieve the files from the given path
    
    NSURL *applicationURL = nil;
    NSURL *applicationMetaDataURL = nil;
    
    for (NSURL *firmwareURL in firmwareFilesURL)
    {
        if ([[[firmwareURL path] lastPathComponent] isEqualToString:@"application.hex"])
        {
            applicationURL = firmwareURL;
            NSLog(@".applicationURL = .%@", applicationURL);

        }
        else if ([[[firmwareURL path] lastPathComponent] isEqualToString:@"application.dat"])
        {
            applicationMetaDataURL = firmwareURL;
            NSLog(@"applicationMetaDataURL = ..%@", applicationMetaDataURL);
        }
    }
    
    return @[applicationURL, applicationMetaDataURL];
}

+ (NSString *)stringFileExtension:(enumFileExtension)fileExtension
{
    switch (fileExtension)
    {
        case HEX:
            return @"hex";
        case BIN:
            return @"bin";
        case ZIP:
            return @"zip";
            
        default:
            return nil;
    }
}

+ (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DFU" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)showBackgroundNotification:(NSString *)message
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertAction = @"Show";
    notification.alertBody = message;
    notification.hasAction = NO;
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    notification.timeZone = [NSTimeZone  defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
}

+ (BOOL)isApplicationStateInactiveORBackground
{
    UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState];
    if (applicationState == UIApplicationStateInactive || applicationState == UIApplicationStateBackground)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
