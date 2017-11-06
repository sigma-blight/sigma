#include <benchmark/benchmark.h>

static void empty_test(benchmark::State & state)
{
    while (state.KeepRunning());
}

BENCHMARK(empty_test);