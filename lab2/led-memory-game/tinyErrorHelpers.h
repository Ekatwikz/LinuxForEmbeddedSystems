#pragma once

// Stripped down version of my beauty: https://github.com/Ekatwikz/katwikOpsys/blob/main/errorHelpers.h#L97-L112

#include <errno.h>

// TODO: fix cleanup tho
#define ERR_(source) do {\
	fprintf(stderr, "[errno=%d] %s:%d in %s\n",\
			errno, __FILE__, __LINE__, __func__);\
	perror(source);\
	exit(EXIT_FAILURE);\
} while(0)

#define ERR_IF(expr, condition) (__extension__({\
	errno = 0;/* sus? when the amnogu? */\
	typeof(expr) exprVal = (expr);\
	if ( condition exprVal )\
	{ERR_(#condition " ( " #expr " ) ");}\
	exprVal;\
}))

#define ERR_NEG1(expr) ERR_IF(expr, -1 ==)
#define ERR_NEG(expr) ERR_IF(expr, 0 >)
#define ERR_NON_ZERO(expr) ERR_IF(expr, 0 !=)
#define ERR_NULL(expr) ERR_IF(expr, NULL ==)
