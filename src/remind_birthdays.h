#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>

/* Where we keep program options after parsing them from the command
 * line */
typedef struct _OptSet {
  int advanceNotice;
  BOOL numbered;
} OptSet;
