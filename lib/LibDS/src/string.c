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

#include "DS_String.h"

#include <assert.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

int DS_StringLen (const DS_String* string)
{
    assert (string);
    return string->len;
}

int DS_StringIsEmpty (const DS_String* string)
{
    assert (string);
    return DS_StringLen (string) == 0;
}

int DS_StringCompare (const DS_String* a, const DS_String* b)
{
    /* Check arguments */
    assert (a);
    assert (b);

    /* Get length of both strings */
    int lenA = DS_StringLen (a);
    int lenB = DS_StringLen (b);

    /* Lengths are different */
    if (lenA != lenB) {
        if (lenA > lenB)
            return 1;
        else
            return -1;
    }

    /* Get the largest length */
    int minL = lenA > lenB ? lenA : lenB;

    /* Compare the buffers of both strings */
    int cmp = memcmp (a->buf, b->buf, minL);
    return cmp;
}

int DS_StringFreeBuffer (DS_String* string)
{
    /* Check parameters */
    assert (string);

    /* Delete the buffer */
    if (string->buf != NULL) {
        free (string->buf);
        string->buf = NULL;
        return DS_STR_SUCCESS;
    }

    /* Buffer already freed */
    return DS_STR_FAILURE;
}

int DS_StringResize (DS_String* string, size_t size)
{
    /* Check arguments */
    assert (string);
    assert (string->buf);

    /* Change size of the string */
    string->len = size;
    string->buf = (char*) realloc (string->buf, size);

    /* Return SUCCESS if buffer is not NULL */
    return (string->buf != NULL) ? DS_STR_SUCCESS : DS_STR_FAILURE;
}

int DS_StringAppend (DS_String* string, const char byte)
{
    /* Check arguments */
    assert (string);
    assert (string->buf);

    /* Resize string and add extra character */
    if (DS_StringResize (string, ++string->len)) {
        string->buf [string->len - 1] = byte;
        return DS_STR_SUCCESS;
    }

    /* String cannot be resized */
    return DS_STR_FAILURE;
}

int DS_StringJoin (DS_String* string, const DS_String* last)
{
    /* Check arguments */
    assert (last);
    assert (string);
    assert (last->buf);
    assert (string->buf);

    /* Get length of initial string */
    int original_len = (int) string->len;

    /* Resize the string and append the other string */
    if (DS_StringResize (string, original_len + (int) last->len)) {
        int i;
        for (i = 0; i < (int) string->len; ++i)
            string->buf [original_len + i] = last->buf [i];

        return DS_STR_SUCCESS;
    }

    /* String cannot be resized */
    return DS_STR_FAILURE;
}

int DS_StringSetChar (DS_String* string, const int pos, const char byte)
{
    /* Check arguments */
    assert (string);
    assert (string->buf);

    /* Change the character at the given position */
    if (abs (pos) < (int) string->len) {
        string->buf [abs (pos)] = byte;
        return DS_STR_SUCCESS;
    }

    /* The position was invalid */
    return DS_STR_FAILURE;
}

char* DS_StringToCString (const DS_String* string)
{
    /* Check arguments */
    assert (string);
    assert (string->buf);

    /* Initialize the c-string */
    char* cstr = (char*) calloc (string->len, sizeof (char));

    /* Copy buffer data into c-string */
    int i;
    for (i = 0; i < (int) string->len; ++i)
        cstr [i] = string->buf [i];

    /* Return obtained string */
    return cstr;
}

char DS_StringCharAt (const DS_String* string, const int pos)
{
    /* Check arguments */
    assert (string);

    /* Get the character at the given position */
    if ((int) string->len > abs (pos))
        return string->buf [abs (pos)];

    /* Position invalid */
    return '\0';
}

DS_String DS_StringEmpty (const int length)
{
    DS_String string;
    string.len = abs (length);
    string.buf = (char*) calloc (string.len, sizeof (char));
    return string;
}

DS_String DS_StringCopy (const DS_String* source)
{
    /* Check arguments */
    assert (source);

    /* Create new empty string */
    DS_String string = DS_StringEmpty (source->len);

    /* Copy each character to the new string */
    int i;
    for (i = 0; i < (int) string.len; ++i)
        string.buf [i] = source->buf [i];

    /* Return the copy */
    return string;
}

DS_String DS_StringFormat (const char* format, ...)
{
    /* Check arguments */
    assert (format);
    return DS_StringFromCString (format);
}

DS_String DS_StringFromCString (const char* string)
{
    /* Check arguments */
    assert (string);

    /* Create new empty string */
    DS_String str = DS_StringEmpty (strlen (string));

    /* Copy c-string data into buffer */
    int i;
    for (i = 0; i < (int) str.len; ++i)
        str.buf [i] = string [i];

    /* Return obtained string */
    return str;
}

