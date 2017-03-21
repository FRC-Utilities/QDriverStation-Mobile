/*
 * The Driver Station Library (LibDS)
 * Copyright (C) 2015-2016 Alex Spataru <alex_spataru@outlook>
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#ifndef _LIB_DS_STRING_H
#define _LIB_DS_STRING_H

#ifdef __cplusplus
extern "C" {
#endif

#define DS_STR_FAILURE 0
#define DS_STR_SUCCESS 1

#include <stdlib.h>

/**
 * Represents a string and its length
 */
typedef struct {
    char* buf;  /**< String data buffer */
    size_t len; /**< Length of the string */
} DS_String;

/*
 * Information functions
 */
extern int DS_StringLen (const DS_String* string);
extern int DS_StringIsEmpty (const DS_String* string);
extern int DS_StringCompare (const DS_String* a, const DS_String* b);

/*
 * String operations functions
 */
extern int DS_StringFreeBuffer (DS_String* string);
extern int DS_StringResize (DS_String* string, size_t size);
extern int DS_StringAppend (DS_String* string, const char byte);
extern int DS_StringJoin (DS_String* string, const DS_String* last);
extern int DS_StringSetChar (DS_String* string, const int pos, const char byte);

/*
 * DS_String to native string functions
 */
extern char* DS_StringToCString (const DS_String* string);
extern char DS_StringCharAt (const DS_String* string, const int pos);

/*
 * String creation functions
 */
extern DS_String DS_StringEmpty (const int length);
extern DS_String DS_StringCopy (const DS_String* source);
extern DS_String DS_StringFormat (const char* format, ...);
extern DS_String DS_StringFromCString (const char* string);

#ifdef __cplusplus
}
#endif

#endif
