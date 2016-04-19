   /*******************************************************/   /*      "C" Language Integrated Production System      */   /*                                                     */   /*             CLIPS Version 6.05  04/09/97            */   /*                                                     */   /*                 ROUTER HEADER FILE                  */   /*******************************************************//*************************************************************//* Purpose: Provides a centralized mechanism for handling    *//*   input and output requests.                              *//*                                                           *//* Principal Programmer(s):                                  *//*      Gary D. Riley                                        *//*                                                           *//* Contributing Programmer(s):                               *//*                                                           *//* Revision History:                                         *//*                                                           *//*************************************************************/#ifndef _H_router#define _H_router#ifndef _H_prntutil#include "prntutil.h"#endif#ifndef _CLIPS_STDIO_#define _CLIPS_STDIO_#include <stdio.h>#endif#ifdef LOCALE#undef LOCALE#endif#ifdef _ROUTER_SOURCE_#define LOCALE#else#define LOCALE extern#endif#if ANSI_COMPILER   LOCALE VOID                           InitializeDefaultRouters(void);   LOCALE int                            PrintCLIPS(char *,char *);   LOCALE int                            GetcCLIPS(char *);   LOCALE int                            UngetcCLIPS(int,char *);   LOCALE VOID                           ExitCLIPS(int);    LOCALE VOID                           AbortExit(void);   LOCALE BOOLEAN                        AddRouter(char *,int,int (*)(char *),                                                              int (*)(char *,char *),                                                              int (*)(char *),                                                              int (*)(int,char *),                                                              int (*)(int));   LOCALE int                            DeleteRouter(char *);   LOCALE int                            QueryRouters(char *);   LOCALE int                            DeactivateRouter(char *);   LOCALE int                            ActivateRouter(char *);   LOCALE VOID                           SetFastLoad(FILE *);   LOCALE VOID                           SetFastSave(FILE *);   LOCALE FILE                          *GetFastLoad(void);   LOCALE FILE                          *GetFastSave(void);   LOCALE VOID                           UnrecognizedRouterMessage(char *);   LOCALE VOID                           ExitCommand(void);   LOCALE int                            PrintNCLIPS(char *,char *,long);#else   LOCALE VOID                           InitializeDefaultRouters();   LOCALE int                            PrintCLIPS();   LOCALE int                            GetcCLIPS();   LOCALE int                            UngetcCLIPS();   LOCALE VOID                           ExitCLIPS();    LOCALE VOID                           AbortExit();   LOCALE BOOLEAN                        AddRouter();   LOCALE int                            DeleteRouter();   LOCALE int                            QueryRouters();   LOCALE int                            DeactivateRouter();   LOCALE int                            ActivateRouter();   LOCALE VOID                           SetFastLoad();   LOCALE VOID                           SetFastSave();   LOCALE FILE                          *GetFastLoad();   LOCALE FILE                          *GetFastSave();   LOCALE VOID                           UnrecognizedRouterMessage();   LOCALE VOID                           ExitCommand();   LOCALE int                            PrintNCLIPS();#endif    #ifndef _ROUTER_SOURCE_   extern char                       *WWARNING;    extern char                       *WERROR;    extern char                       *WTRACE;   extern char                       *WDIALOG;   extern char                       *WCLIPS;   extern char                       *WDISPLAY;   extern int                         CLIPSInputCount;   extern char                       *LineCountRouter;   extern char                       *FastCharGetRouter;   extern char                       *FastCharGetString;   extern long                        FastCharGetIndex; #endif#endif