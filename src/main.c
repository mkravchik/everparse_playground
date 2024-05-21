#include <stdio.h>
#include "HelloWorldWrapper.h"
#include <assert.h>

void
HelloWorldEverParseError(
    const char *StructName,
    const char *FieldName,
    const char *Reason){
    printf("Validation failed in HelloWorld, struct %s, field %s. Reason: %s\n", StructName, FieldName, Reason);   
}

// I expect these will be generated from the 3d files
typedef struct _smoker {
  uint32_t age;
  uint8_t cigarettesConsumed;
} smoker;

int main(int argc, char *argv[]) {
    // Your code here
    printf("Hello, EverParse World!\n");
    uint8_t small[2] = {0x01, 0x02};
    BOOLEAN res = HelloWorldCheckPoint(small, sizeof(small));
    assert(res == FALSE);

    uint16_t point[2] = {12, 13};
    res = HelloWorldCheckPoint((uint8_t*)point, sizeof(point));
    assert(res == TRUE);

    uint16_t points[4] = {12, 13, 14, 15};
    res = HelloWorldCheckPoint((uint8_t*)points, 
        sizeof(point)); // NOTE: sizeof(point) is INcorrect here, but this does not fail the test
    assert(res == TRUE);

    uint8_t smokerData[5] = {0x01, 0x02, 0x03, 0x04, 0x05};
    res = HelloWorldCheckSmoker(smokerData, sizeof(smokerData));
    assert(res == TRUE);

    smoker s = {22, 13};
    res = HelloWorldCheckSmoker((uint8_t*)&s, sizeof(s));
    assert(res == TRUE);

    smoker young_s = {2, 13};
    res = HelloWorldCheckSmoker((uint8_t*)&young_s, sizeof(young_s));
    assert(res == FALSE);

    printf("All tests passed OK\n");
    return 0;
}
