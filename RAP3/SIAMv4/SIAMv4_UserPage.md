# SIAMv4 User Page

This page needs to be updated for PF_Roles (in `session(Active|Allowed)Roles`)
This should also be added to the readme/changelog

The purpose of this chapter is to acquaint people with version 3
of the Sessions, Identity and Access Management (SIAMv4) module.
It introduces its basic functionalities
and the ways in which they can be operationalized in an Ampersand script.

The expected audience is a person that knows how to write an Ampersand script,
compile a script into a prototype, and run that prototype. The SIAMv4 module
makes it easy to add Accounts, Roles, people, and organizations to your script.
Also, interfaces are available that allows users to login, logout or register themselves.

## INTRODUCTION

The purpose of this section is to explain the main concepts that we build on.

The system, of which the SIAMv4 module is a part, is seen to act as a server
that is being used by possibly many users (that operate clients,such as web browsers)
at any point in time. A `SESSION` is a timeframe within which our server
and (the web browser of) a user interact with one another.

two parties communicate with one another.
Typically, that would be client software (e.g. web browser)
and server software (e.g. the IT system/web service)
At any point in time, clients and servers can have multiple sessions,
each of which being a communication channel with some other party.

A Session is associated with so-called session variables,
that together specify the context within which the communication takes place.
An example of such a variables is `sessionActiveRoles`, which says which roles
have been activated in a session. Another example is `sessionAccount`,
which has the Account with which a user has logged in.

An Account is a registration of attributes of people, organizations or persona
from a (web)Service Provider's perspective.
Examples of such attributes are (user)names, passwords, or roles.

One purpose of such attributes is to configure the context of a session
(by (de)populating the 'session variables' that define such contexts).
The session context (session-variables) allow us to personalize the way
that a user is given access to the system.
Examples of session variables are: `sessionPerson`, `sessionAllowedRoles`.

With respect to roles, the following ideas apply:

- An account can be assigned:
  - `accAllowedRoles`, i.e. roles that can be activated in a session with that account.
  - `accDefaultRoles`, i.e. roles that are by default activated in a session with that account.
  and obviously, `accDefaultRoles` must be a subset of `accAllowedRoles`.
  An account can NOT be assigned a `systemRole`, which by definition are roles that cannot be assigend to an account.
- A session can be assigned any role; however:
  - in a user session, i.e. a session that has a `sessionAccount`,
    only those roles can be activated that are in `accAllowedRoles`.
    Activated roles are in `sessionActiveRoles`.
    In such a session, the default roles are specifed by `accDefaultRoles`
  - in an anonymous session, i.e. a session where `sessionAccount` is not populated,
    the role `Anonymous` is a session role (i.e. in `sessionActiveRoles`).
