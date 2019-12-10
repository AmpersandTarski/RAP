This is the readme file for SIAM v 2.2
======================================

== Changes in SIAM v 2.2 ==

What you need to do to use the new features:
- You must include a rule that sets the property `accIsActive[Account*Account]`
  for all accounts that you want users to login with.
  The easiest way to do that is as follows:
~~~
  ROLE ExecEngine MAINTAINS "Account activation/initialization": 
  RULE "Account activation/initialization": I[Account] |- accIsActive
  VIOLATION (TXT "{EX} InsPair;accIsActive;Account;", SRC I, TXT ";Account;", TGT I)
~~~

New features/concepts
- Account (de)activation is now supported by means of the relation `accIsActive[Account*Account] [PROP]`
- Account initialization is now supported by means of the relation `accIsInitialized[Account*Account] [PROP]`

Changes/fixes
- UIDs that are not used are no longer automatically discarded.
  The reason is that extensions that want to use such UIDs should be facilitated rather than hindered,
  and extensions that want to discard such UIDs can do so freely.

== Changes in SIAM v 2.1 ==

What you need to do to use the new features:
- You must INCLUDE the SIAM_LoginUsingIdPs.adl in your SIAM-module loader file.

New features/concepts:
- A new concept UID (User ID object) has been introduced that allows identification of accounts by third party identifiers.
- The login facility has been enhanced to accommodate for user authentication by third parties.
- The loginWithAssistance*.ifc files allow for using third party logins 'by hand' (for debugging purposes).

Changes:
- ISOLevels now have representation type INTEGER (rather than being objects).


== Release notes for SIAM v 2.0 ==
This is the readme file for SIAM v 2.0
When upgrading from a previous version (i.e. the unversioned situation, which is considered to be SIAM v 1.0), you should:
- check the files that you imported from your own SIAM_Module import file, as v 2.0 has separated features that used to be embedded in other files, so that you may choose to include them or leave them out. See the SIAM_Module-example.adl files for details.
- ensure that you start use 'versioning' (i.e. include the versioning line of the SIAM_Module-example.adl file in your own loader file) 

The purpose of this module is to enable Ampersand engineers to quickly integrate their application with stuff for handling Sessions, Identities, and Access Management (SIAM). 
In particular this includes:
- a simple registration for Persons in terms of first- and last names.
- a simple registration for Organizations in terms of short and full names.
- an extension that defines Persona, i.e. a Person and Organization that have a particular relation.
- an extension that enables one account to be logged in automatically.
- an extension that allows sessions to be suspended.
- an extension that defines ISO authentication levels and comparisons between them.
- an extension that logs login times (this awaits resolution of issue #285 (https://github.com/AmpersandTarski/ampersand/issues/285)
- a simple Login facility (username, password)
- an assisted login facility (i.e. you can either do the simple login, or choose the account to use for login - this is particularly suited for developers)

The concepts and relations are defined such that it allows for expansion. In particular, `IDENT` statements are not used (except for Persona). Also, the concept `User` is not defined. The reason for this is that consensus about its meaning is notoriously lacking. Not defining this concept allows application developers to use their own ideas for this. Note, however, that there is a concept `UserID`, and there are relations `accUserid` and `sessionUserid` that use it.
