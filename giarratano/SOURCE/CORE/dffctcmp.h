   /*******************************************************/   /*      "C" Language Integrated Production System      */   /*                                                     */   /*             CLIPS Version 6.05  04/09/97            */   /*                                                     */   /*        DEFFACTS CONSTRUCT COMPILER HEADER FILE      */   /*******************************************************//*************************************************************//* Purpose:                                                  *//*                                                           *//* Principal Programmer(s):                                  *//*      Gary D. Riley                                        *//*                                                           *//* Contributing Programmer(s):                               *//*                                                           *//* Revision History:                                         *//*                                                           *//*************************************************************/#ifndef _H_dffctcmp#define _H_dffctcmp#ifdef LOCALE#undef LOCALE#endif  #ifdef _DFFCTCMP_SOURCE_#define LOCALE#else#define LOCALE extern#endif#if ANSI_COMPILER   LOCALE VOID                           DeffactsCompilerSetup(void);   LOCALE VOID                           DeffactsCModuleReference(FILE *,int,int,int);#else   LOCALE VOID                           DeffactsCompilerSetup();   LOCALE VOID                           DeffactsCModuleReference();#endif#endif