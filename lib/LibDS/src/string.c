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

int DS_StrLen (const DS_String* string)
{
    assert (string);
    return string->len;
}

int DS_StrEmpty (const DS_String* string)
{
    assert (string);
    return DS_StrLen (string) == 0;
}

int DS_StrCompare (const DS_String* a, const DS_String* b)
{
    /* Check arguments */
    assert (a);
    assert (b);

    /* Get length of both strings */
    int lenA = DS_StrLen (a);
    int lenB = DS_StrLen (b);

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

int DS_StrRmBuf (DS_String* string)
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

int DS_StrResize (DS_String* string, size_t size)
{
    /* Check arguments */
    assert (string);
    assert (string->buf);

    /* Initialize variables */
    int i;
    int oldSize = (int) string->len;

    /* Copy old buffer */
    char* copy = calloc (oldSize, sizeof (char));
    for (i = 0; i < oldSize; ++i)
        copy [i] = string->buf [i];

    /* Re-initialize the buffer */
    free (string->buf);
    string->buf = calloc (size, sizeof (char));

    /* Copy old buffer into start of new buffer */
    if (string->buf) {
        string->len = size;
        for (i = 0; i < oldSize; ++i)
            string->buf [i] = copy [i];

        free (copy);
        return DS_STR_SUCCESS;
    }

    /* Could not initialize the buffer, restore data */
    string->buf = copy;
    return DS_STR_FAILURE;
}

int DS_StrAppend (DS_String* string, const uint8_t byte)
{
    /* Check arguments */
    assert (string);
    assert (string->buf);

    /* Resize string and add extra character */
    if (DS_StrResize (string, string->len + 1)) {
        string->buf [string->len - 1] = byte;
        return DS_STR_SUCCESS;
    }

    /* String cannot be resized */
    return DS_STR_FAILURE;
}

int DS_StrJoin (DS_String* string, const DS_String* last)
{
    /* Check arguments */
    assert (last);
    assert (string);
    assert (last->buf);
    assert (string->buf);

    /* Get length of initial string */
    int append_len = (int) last->len;
    int original_len = (int) string->len;

    /* Resize the string and append the other string */
    if (DS_StrResize (string, original_len + append_len)) {
        int i;
        for (i = 0; i < append_len; ++i)
            string->buf [original_len + i] = last->buf [i];

        return DS_STR_SUCCESS;
    }

    /* String cannot be resized */
    return DS_STR_FAILURE;
}

int DS_StrSetChar (DS_String* string, const int pos, const char byte)
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

char* DS_StrToChar (const DS_String* string)
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

char DS_StrCharAt (const DS_String* string, const int pos)
{
    /* Check arguments */
    assert (string);

    /* Get the character at the given position */
    if ((int) string->len > abs (pos))
        return string->buf [abs (pos)];

    /* Position invalid */
    return '\0';
}

DS_String DS_StrNew (const char* string)
{
    /* Check arguments */
    assert (string);

    /* Create new empty string */
    DS_String str = DS_StrNewLen (strlen (string));

    /* Copy c-string data into buffer */
    int i;
    for (i = 0; i < (int) str.len; ++i)
        str.buf [i] = string [i];

    /* Return obtained string */
    return str;
}

DS_String DS_StrNewLen (const int length)
{
    DS_String string;
    string.len = abs (length);
    string.buf = (char*) calloc (string.len, sizeof (char));
    return string;
}

DS_String DS_StrCopy (const DS_String* source)
{
    /* Check arguments */
    assert (source);

    /* Create new empty string */
    DS_String string = DS_StrNewLen (source->len);

    /* Copy each character to the new string */
    int i;
    for (i = 0; i < (int) string.len; ++i)
        string.buf [i] = source->buf [i];

    /* Return the copy */
    return string;
}

DS_String DS_StrFormat (const char* format, ...)
{
    /* Check arguments */
    assert (format);
    return DS_StrNew (format);
}

