   /*******************************************************/   /*      "C" Language Integrated Production System      */   /*                                                     */   /*             CLIPS Version 6.05  04/09/97            */   /*                                                     */   /*       DEFGLOBAL CONSTRUCT COMPILER HEADER FILE      */   /*******************************************************//*************************************************************//* Purpose:                                                  *//*                                                           *//* Principal Programmer(s):                                  *//*      Gary D. Riley                                        *//*                                                           *//* Contributing Programmer(s):                               *//*                                                           *//* Revision History:                                         *//*                                                           *//*************************************************************/#ifndef _H_globlcmp#define _H_globlcmp#ifdef LOCALE#undef LOCALE#endif  #ifdef _GLOBLCMP_SOURCE_#define LOCALE#else#define LOCALE extern#endif#if ANSI_COMPILER   LOCALE VOID                           DefglobalCompilerSetup(void);   LOCALE VOID                           DefglobalCModuleReference(FILE *,int,int,int);   LOCALE VOID                           DefglobalCConstructReference(FILE *,VOID *,int,int);#else   LOCALE VOID                           DefglobalCompilerSetup();   LOCALE VOID                           DefglobalCModuleReference();   LOCALE VOID                           DefglobalCConstructReference();#endif#endif