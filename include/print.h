#define DISP(arg)\
    do {char fmt[256];\
        char base[] = "%s:%d %s() " #arg " = ";\
        snprintf(fmt, sizeof(fmt), "%s%s\n", base, type_fmt(arg));\
        fprintf(stderr, fmt, __FILE__, \
         __LINE__, __func__, arg);\
        } while (0)

#define type_fmt(a) (\
    ((__typeof__(a))0.5 > 0) ? /* float ? */\
        "%f"\
    :\
        ((__typeof__(a))-1 > 0) ? /* unsigned ? */\
            (sizeof(a) == sizeof(int)) ? /* is int sized ? */\
                "%u":"%lu"\
        :\
            (sizeof(a) == sizeof(int)) ? /* is int sized ? */\
                "%d":"%ld"\
)
