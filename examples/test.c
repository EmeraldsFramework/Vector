#include "../export/Vector.h"

int double_item(int item) {
    return item * 2;
}

int positive_filter(int item) {
    return item > 0;
}

int adder(int accumulator, int current) {
    return accumulator + current;
}

int main(void) {
    vector *testv = NULL;
    vector *double_testv = NULL;
    vector *positive_double_testv = NULL;
    long sum;

    printf("TESTING VECTOR MAP FILTER REDUCE\n");
    testv = vector_new();

    vector_add(testv, (void*)1);
    vector_add(testv, (void*)2);
    vector_add(testv, (void*)-3);
    vector_add(testv, (void*)-4);
    vector_add(testv, (void*)5);
    vector_add(testv, (void*)-1);
    vector_add(testv, (void*)-2);
    vector_add(testv, (void*)3);
    vector_add(testv, (void*)4);
    vector_add(testv, (void*)-5);

    double_testv = vector_map(testv, (vector_lambda)double_item);
    positive_double_testv = vector_select(double_testv, (vector_lambda)positive_filter);
    sum = (long)vector_reduce(positive_double_testv, (vector_lambda)adder);
    printf("SUM: `%ld` should be `30`\n\n", sum);

    vector_free(testv);
    vector_free(double_testv);
    vector_free(positive_double_testv);

    return 0;
}
