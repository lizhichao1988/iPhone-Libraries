/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

extern const char * class_getName(Class cls);

#define _NIF_LOG(fmt, ...) NSLog(fmt, class_getName([self class]), ##__VA_ARGS__)
 
#ifdef DEBUG
#define NIF_TRACE(fmt, ...) _NIF_LOG(@"  %s: " fmt, ##__VA_ARGS__)
#else
#define NIF_TRACE(fmt, ...)
#endif

#define NIF_INFO(fmt, ...)  _NIF_LOG(@"- %s: " fmt, ##__VA_ARGS__)

#define NIF_ERROR(fmt, ...) _NIF_LOG(@"! %s: " fmt, ##__VA_ARGS__)
