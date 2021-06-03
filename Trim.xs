#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

const uint16_t lr_offset[9]= { 0, 0, 0, 0, 1, 3, 0, 14, 15 };
const uint16_t lr_owner[271]= { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 4, 5, 5, 5,
    5, 5, 5, 5, 5, 5, 5, 5, 7, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
    0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 0, 0, 5, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
const uint16_t lr_trans[271]= { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 5, 6, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 8, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 7, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
const uint16_t rl_offset[33]= { 0, 0, 11, 0, 0, 12, 2, 13, 3, 14, 4, 15, 5,
    16, 6, 17, 7, 18, 8, 19, 9, 20, 10, 21, 11, 21, 12, 23, 13, 24, 14, 25,
    15 };
const uint16_t rl_owner[281]= { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 2, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31,
    0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
    3, 3, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
const uint16_t rl_trans[281]= { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 5, 7, 9, 11,
    13, 15, 17, 19, 21, 23, 3, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26,
    28, 30, 32, 0, 0, 0, 0, 0, 25, 0, 0, 0, 0, 0, 4, 0, 0, 27, 29, 0, 0, 0,
    0, 0, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

const uint8_t latin1_ws[256]= { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0 };

PERL_STATIC_INLINE
char * 
find_ltrim_pos_utf8(char *start, char *end) {
    uint16_t state=1;
    char *ptr= start;
    char *ret= start;
    uint8_t ch;
    uint16_t base;
    
    while (ptr < end ) {
        uint8_t ch= (uint8_t)*ptr;
        base= lr_offset[state];
        if (lr_owner[base+ch] != state || !(state= lr_trans[base+ch])) {
            return ret;
        }
        ptr++;
        if (state == 1) {
            ret= ptr;
        }
    }
    return end;
}

PERL_STATIC_INLINE
char *
find_rtrim_pos_utf8(char *start, char *end) {
    uint16_t state=1;
    char *ret= end;
    char *ptr= end;
    uint8_t ch;
    uint16_t base;
    
    while (start < ptr) {
        ptr--;
        ch= (uint8_t)*ptr;
        base= rl_offset[state];
        if (rl_owner[base+ch] != state || !(state= rl_trans[base+ch])) {
            return ret;
        }
        if (state == 1) {
            ret= ptr;
        }
    }
    return ptr;
}

PERL_STATIC_INLINE
char * 
find_ltrim_pos_latin1(char *ptr, char *end) {
    while (ptr < end ) {
        if (!latin1_ws[(U8)*ptr]) break;
        ptr++;
    }
    return ptr;
}

/* .|xxxxx|. 
 *  ^
 *  start
 *         ^
 *         end 
 */

PERL_STATIC_INLINE
char *
find_rtrim_pos_latin1(char *start, char *ptr) {
    while (start < ptr) {
        ptr--;
        if (!latin1_ws[(U8)*ptr]) return ptr+1;
    }
    return ptr;
}

MODULE = DFA::Trim		PACKAGE = DFA::Trim		


SV *
ltrimmed(str_sv)
SV *str_sv
PROTOTYPE: $
CODE:
    if (SvPOK(str_sv)) {
        STRLEN str_len;
        char *str_pv= SvPV(str_sv,str_len);
        char *end_pv= str_pv + str_len;
        char *lpos= SvUTF8(str_sv) ? find_ltrim_pos_utf8(str_pv,end_pv) 
                                   : find_ltrim_pos_latin1(str_pv,end_pv);
        RETVAL = newSVpvn(lpos,end_pv - lpos );
        if (SvUTF8(str_sv)) 
            SvUTF8_on(RETVAL);
        
    } else {
        RETVAL= str_sv;
    }
OUTPUT:
    RETVAL

SV *
rtrimmed(str_sv)
SV *str_sv
PROTOTYPE: $
CODE:
    if (SvPOK(str_sv)) {
        STRLEN str_len;
        char *str_pv= SvPV(str_sv,str_len);
        char *end_pv= str_pv + str_len;
        char *rpos= SvUTF8(str_sv) ? find_rtrim_pos_utf8(str_pv,end_pv)
                                   : find_rtrim_pos_latin1(str_pv,end_pv);
        if (rpos<str_pv) {
            RETVAL = newSVpvs("");
        } else {
            RETVAL = newSVpvn(str_pv,rpos-str_pv);
            if (SvUTF8(str_sv)) 
                SvUTF8_on(RETVAL);
        }
    } else {
        RETVAL= str_sv;
    }
OUTPUT:
    RETVAL

SV *
trimmed(str_sv)
SV *str_sv
PROTOTYPE: $
CODE:
    if (SvPOK(str_sv)) {
        STRLEN str_len;
        char *str_pv= SvPV(str_sv,str_len);
        char *end_pv= str_pv + str_len;
        char *rpos; 
        char *lpos; 
        if (SvUTF8(str_sv)) {
            lpos= find_ltrim_pos_utf8(str_pv,end_pv);
            rpos= find_rtrim_pos_utf8(lpos,end_pv);
        } else {
            lpos= find_ltrim_pos_latin1(str_pv,end_pv);
            rpos= find_rtrim_pos_latin1(lpos,end_pv);
        }
        if ( lpos <= rpos ) {
            RETVAL = newSVpvn(lpos,rpos-lpos);
            if (SvUTF8(str_sv)) 
                SvUTF8_on(RETVAL);
        } else {
            RETVAL = newSVpvs("");
        }
    } else {
        RETVAL= str_sv;
    }
OUTPUT:
    RETVAL

