#import "remind_birthdays.h"

/* birthdayreminders.m
 *
 * Uses OS X's AddressBook API to schedule birthday reminders for
 * Remind, the Unix calendaring program. 
 */

void printHelpMessage()
{
  const char *copyright = "Copyright (c) 2007 Mark Shroyer\n\
This program comes with ABSOLUTELY NO WARRANTY.\n\
This is free software, and you are welcome to redistribute it\n\
under certain conditions. See the file COPYING for details.\n\n";

  const char *syntax = "Syntax: %s [options]\n\n";

  const char *options = "Options:\n\
\n\
 -a     Show people's ages on each calendar birthday (default)\n\
 -A     Opposite of -a; don't display ages\n\
 -r N   Remind of upcoming birthdays N days in advance (default = 0)\n\
 -h     Display this help message\n\
\n\
See %s(1) for details.\n";

  printf("%s %s\n", PACKAGE_NAME, PACKAGE_VERSION);
  printf(copyright);
  printf(syntax, PACKAGE_NAME);
  printf(options, PACKAGE_NAME);
  
  return;
}

OptSet *parseArguments(argc, argv)
int argc;
const char *argv[];
{
  OptSet *options = malloc(sizeof(OptSet));

  options->numbered = YES;
  options->advanceNotice = 0;

  int ch;
  char *cvalue;
  while ((ch = getopt(argc, (char **) argv, "aAr:h")) != -1) {
    switch (ch) {
      case 'a':
        options->numbered = YES;
        break;

      case 'A':
        options->numbered = NO;
        break;

      case 'r':
        cvalue = optarg;
        options->advanceNotice = atoi(optarg);
        break;

      case 'h':
        printHelpMessage();
        exit(0);

      case '?':
      default:
        printf("\n");
        printHelpMessage();
        exit(1);
    }
  }

  return options;
}

void printReminders(options)
OptSet *options;
{
  NSArray *everyone = [[ABAddressBook sharedAddressBook] people];

  /* Header */
  if (options->numbered)
    printf("FSET _bday_num(yr) ORD(YEAR(TRIGDATE())-yr)\n\n");
  
  /* Write an entry for each person in the address book who has a
   * known birthday. */
  int i;
  for (i=0; i<[everyone count]; i++) {
    ABPerson *p = [everyone objectAtIndex:i];
    
    NSString *fName = [p valueForProperty:kABFirstNameProperty];
    NSString *lName = [p valueForProperty:kABLastNameProperty];
    NSCalendarDate *bday = [p valueForProperty:kABBirthdayProperty];
    
    if (bday != nil && fName != nil) {
      /* I have some Address Book entries where I don't know the
       * person's last name. Sad, but true. */
      NSString *name;
      if (lName != nil)
        name = [NSString stringWithFormat:@"%@ %@", fName, lName];
      else
        name = fName;

      printf("REM %s", [[bday descriptionWithCalendarFormat:@"%e %B"] UTF8String]);
      if (options->advanceNotice > 0)
        printf(" +%d", options->advanceNotice);
      printf(" MSG ");
      if (options->advanceNotice > 0)
        printf("%%\"");
      printf("%s's", [name UTF8String]);
      if (options->numbered)
        printf(" [_bday_num(%d)]", [bday yearOfCommonEra]);
      printf(" birthday");
      if (options->advanceNotice > 0)
        printf("%%\"");
      if (options->advanceNotice > 0)
        printf(" is %%b");
      printf("\n");
    }
  }
}

int main(argc, argv)
int argc;
const char *argv[];
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  OptSet *options = parseArguments(argc, argv);
  printReminders(options);
  free(options);

  [pool release];
  return 0;
}
