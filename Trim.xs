#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#ifndef PERL_ARGS_ASSERT_CROAK_XS_USAGE
#define PERL_ARGS_ASSERT_CROAK_XS_USAGE assert(cv); assert(params)

/* prototype to pass -Wmissing-prototypes */
STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params);

STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params)
{
    const GV *const gv = CvGV(cv);

    PERL_ARGS_ASSERT_CROAK_XS_USAGE;

    if (gv) {
        const char *const gvname = GvNAME(gv);
        const HV *const stash = GvSTASH(gv);
        const char *const hvname = stash ? HvNAME(stash) : NULL;

        if (hvname)
            Perl_croak_nocontext("Usage: %s::%s(%s)", hvname, gvname, params);
        else
            Perl_croak_nocontext("Usage: %s(%s)", gvname, params);
    } else {
        /* Pants. I don't think that it should be possible to get here. */
        Perl_croak_nocontext("Usage: CODE(0x%"UVxf")(%s)", PTR2UV(cv), params);
    }
}

#ifdef PERL_IMPLICIT_CONTEXT
#define croak_xs_usage(a,b)     S_croak_xs_usage(aTHX_ a,b)
#else
#define croak_xs_usage          S_croak_xs_usage
#endif

#endif


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

const uint16_t latin1_ws[256]= { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0,
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

#if defined(cv_set_call_checker) && defined(XopENTRY_set)
# define USE_CUSTOM_OPS 1
#else
# define USE_CUSTOM_OPS 0
#endif

#define OPOPT_FAST_TRIMMED       (1<<0)
#define OPOPT_FAST_LTRIMMED       (1<<1)
#define OPOPT_FAST_RTRIMMED       (1<<2)

#define pp1_fast_trimmed() THX_pp1_fast_trimmed(aTHX)
static void
THX_pp1_fast_trimmed(pTHX)
{
    dSP;
    SV *str_sv= TOPs;
    if (SvPOK(str_sv)) {
        SV *res;
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
            res= newSVpvn(lpos,rpos-lpos);
            if (SvUTF8(str_sv)) 
                SvUTF8_on(res);
        } else {
            res = newSVpvs("");
        }
        SETs(sv_2mortal(res));
    } else {
        SETs(str_sv);
    }
}

#define pp1_fast_ltrimmed() THX_pp1_fast_ltrimmed(aTHX)
static void
THX_pp1_fast_ltrimmed(pTHX)
{
    dSP;
    SV *str_sv= TOPs;
    if (SvPOK(str_sv)) {
        SV *res;
        STRLEN str_len;
        char *str_pv= SvPV(str_sv,str_len);
        char *end_pv= str_pv + str_len;
        char *lpos= SvUTF8(str_sv) ? find_ltrim_pos_utf8(str_pv,end_pv) 
                                   : find_ltrim_pos_latin1(str_pv,end_pv);
        res = newSVpvn(lpos,end_pv - lpos );
        if (SvUTF8(str_sv)) 
            SvUTF8_on(res);
        SETs(sv_2mortal(res));
    } else {
        SETs(str_sv);
    }
}

#define pp1_fast_rtrimmed() THX_pp1_fast_rtrimmed(aTHX)
static void
THX_pp1_fast_rtrimmed(pTHX)
{
    dSP;
    SV *str_sv= TOPs;
    if (SvPOK(str_sv)) {
        SV *res;
        STRLEN str_len;
        char *str_pv= SvPV(str_sv,str_len);
        char *end_pv= str_pv + str_len;
        char *rpos= SvUTF8(str_sv) ? find_rtrim_pos_utf8(str_pv,end_pv) 
                                   : find_rtrim_pos_latin1(str_pv,end_pv);
        if ( rpos >= str_pv ) {
            res = newSVpvn(str_pv,rpos-str_pv );
        } else {
            res = newSVpvs("");
        }
        if (SvUTF8(str_sv)) 
            SvUTF8_on(res);
        SETs(sv_2mortal(res));
    } else {
        SETs(str_sv);
    }
}

#if USE_CUSTOM_OPS

static OP *
THX_pp_fast_trimmed(pTHX)
{
    pp1_fast_trimmed();
    return NORMAL;
}

static OP *
THX_pp_fast_ltrimmed(pTHX)
{
    pp1_fast_ltrimmed();
    return NORMAL;
}

static OP *
THX_pp_fast_rtrimmed(pTHX)
{
    pp1_fast_rtrimmed();
    return NORMAL;
}


static OP *
THX_ck_entersub_args_dfa_trim(pTHX_ OP *entersubop, GV *namegv, SV *ckobj)
{

   /* pull apart a standard entersub op tree */

    CV *cv = (CV*)ckobj;
    I32 cv_private = CvXSUBANY(cv).any_i32;
    U8 opopt = cv_private & 0xff;
    U8 min_arity = (cv_private >> 8) & 0xff;
    U8 max_arity = (cv_private >> 16) & 0xff;
    OP *pushop, *firstargop, *cvop, *lastargop, *argop, *newop;
    int arity;

    /* Walk the OP structure under the "entersub" to validate that we
     * can use the custom OP implementation. */

    entersubop = ck_entersub_args_proto(entersubop, namegv, (SV*)cv);
    pushop = cUNOPx(entersubop)->op_first;
    if ( ! OpHAS_SIBLING(pushop) )
        pushop = cUNOPx(pushop)->op_first;
    firstargop = OpSIBLING(pushop);

    for (cvop = firstargop; OpHAS_SIBLING(cvop); cvop = OpSIBLING(cvop)) ;

    lastargop = pushop;
    for (
        arity = 0, lastargop = pushop, argop = firstargop;
        argop != cvop;
        lastargop = argop, argop = OpSIBLING(argop)
    ){
        arity++;
    }

    if (arity < min_arity || arity > max_arity)
        return entersubop;

    /* If we get here, we can replace the entersub with a suitable
     * custom OP. */

#ifdef op_sibling_splice
    /* op_sibling_splice is new in 5.31 and we have to do things differenly */

    /* cut out all ops between the pushmark and the RV2CV */
    op_sibling_splice(NULL, pushop, arity, NULL);
    /* then throw everything else out */
    op_free(entersubop);
    newop = newUNOP(OP_NULL, 0, NULL);

#else

    OpMORESIB_set(pushop, cvop);
    OpLASTSIB_set(lastargop, op_parent(lastargop));
    op_free(entersubop);
    newop = newUNOP(OP_NULL, 0, firstargop);

#endif

    newop->op_type    = OP_CUSTOM;
    newop->op_private = opopt;
    newop->op_ppaddr  = (opopt & OPOPT_FAST_LTRIMMED) ? THX_pp_fast_ltrimmed : 
                        (opopt & OPOPT_FAST_RTRIMMED) ? THX_pp_fast_rtrimmed :
                                                                        THX_pp_fast_trimmed;

#ifdef op_sibling_splice

    /* attach the spliced-out args as children of the custom op, while
     * deleting the stub op created by newUNOP() */
    op_sibling_splice(newop, NULL, 1, firstargop);

#endif

    return newop;
}

#endif /* USE_CUSTOM_OPS */

static void
THX_xsfunc_fast_trimmed(pTHX_ CV *cv)
{
    dMARK;
    dSP;
    SSize_t arity = SP - MARK;
    I32 cv_private = CvXSUBANY(cv).any_i32;

    if (arity != 1)
        croak_xs_usage(cv, "data");
    if (cv_private & OPOPT_FAST_LTRIMMED) {
        pp1_fast_trimmed();
    }
    else if (cv_private & OPOPT_FAST_RTRIMMED) {
        pp1_fast_ltrimmed();
    }
    else {
        pp1_fast_trimmed();
    }
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


BOOT:
{
#if USE_CUSTOM_OPS
    {
        XOP *xop;
        Newxz(xop, 1, XOP);
        XopENTRY_set(xop, xop_name, "fast_trimmed");
        XopENTRY_set(xop, xop_desc, "fast_trimmed");
        XopENTRY_set(xop, xop_class, OA_UNOP);
        Perl_custom_op_register(aTHX_ THX_pp_fast_trimmed, xop);
    }
    {
        XOP *xop;
        Newxz(xop, 1, XOP);
        XopENTRY_set(xop, xop_name, "fast_ltrimmed");
        XopENTRY_set(xop, xop_desc, "fast_ltrimmed");
        XopENTRY_set(xop, xop_class, OA_UNOP);
        Perl_custom_op_register(aTHX_ THX_pp_fast_ltrimmed, xop);
    }
    {
        XOP *xop;
        Newxz(xop, 1, XOP);
        XopENTRY_set(xop, xop_name, "fast_rtrimmed");
        XopENTRY_set(xop, xop_desc, "fast_rtrimmed");
        XopENTRY_set(xop, xop_class, OA_UNOP);
        Perl_custom_op_register(aTHX_ THX_pp_fast_rtrimmed, xop);
    }
#endif /* USE_CUSTOM_OPS */
    {
        CV *cv;
        cv = newXSproto_portable("DFA::Trim::fast_trimmed", THX_xsfunc_fast_trimmed, __FILE__, "$");
        CvXSUBANY(cv).any_i32 = 0x010100 | OPOPT_FAST_TRIMMED;
#if USE_CUSTOM_OPS
        cv_set_call_checker(cv, THX_ck_entersub_args_dfa_trim, (SV*)cv);
#endif /* USE_CUSTOM_OPS */
    }
    {
        CV *cv;
        cv = newXSproto_portable("DFA::Trim::fast_ltrimmed", THX_xsfunc_fast_trimmed, __FILE__, "$");
        CvXSUBANY(cv).any_i32 = 0x010100 | OPOPT_FAST_LTRIMMED;
#if USE_CUSTOM_OPS
        cv_set_call_checker(cv, THX_ck_entersub_args_dfa_trim, (SV*)cv);
#endif /* USE_CUSTOM_OPS */
    }
    {
        CV *cv;
        cv = newXSproto_portable("DFA::Trim::fast_rtrimmed", THX_xsfunc_fast_trimmed, __FILE__, "$");
        CvXSUBANY(cv).any_i32 = 0x010100 | OPOPT_FAST_LTRIMMED;
#if USE_CUSTOM_OPS
        cv_set_call_checker(cv, THX_ck_entersub_args_dfa_trim, (SV*)cv);
#endif /* USE_CUSTOM_OPS */
    }
}
