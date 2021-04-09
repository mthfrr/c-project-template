#include <criterion/criterion.h>
#include "helloworld.h"

Test(misc, passing) {
    cr_assert(1);
}

Test(helloworld, returns1_eq) {
    cr_assert_eq(returns1(), 1);
}

Test(helloworld, returns1_noteq) {
    cr_assert_neq(returns1(), 0);
}