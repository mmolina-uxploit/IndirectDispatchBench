import Foundation

// ======================================
// Any vs Generics Benchmark (Swift)
// ======================================

// Protocol
protocol Operation {
    func execute(_ value: Int) -> Int
}

// Implementation
struct Multiplier: Operation {
    let factor: Int
    func execute(_ value: Int) -> Int {
        value * factor
    }
}

// --------------------------------------
// Functions to measure
// --------------------------------------

// Static Dispatch with forced inlining
@inline(__always)
func processStatic<T: Operation>(_ operation: T, _ input: Int) -> Int {
    operation.execute(input)
}

// Dynamic Dispatch (any)
func processDynamic(_ operation: any Operation, _ input: Int) -> Int {
    operation.execute(input)
}

// Dynamic Dispatch with inlining disabled
@inline(never)
func processDynamicNoInline(_ operation: any Operation, _ input: Int) -> Int {
    operation.execute(input)
}

// --------------------------------------
// Benchmark utility
// --------------------------------------
func benchmark(label: String, iterations: Int, block: () -> Int) -> (time: Double, result: Int) {
    var lastResult = 0
    let start = DispatchTime.now()
    for _ in 0..<iterations {
        lastResult = block()
    }
    let end = DispatchTime.now()
    let elapsed = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
    return (elapsed, lastResult)
}

// --------------------------------------
// Run benchmarks
// --------------------------------------
let iterations = 100_000
let multiplier = Multiplier(factor: 3)

let staticResult = benchmark(label: "Static (Generics, @inline(__always))", iterations: iterations) {
    processStatic(multiplier, 10)
}

let dynamicResult = benchmark(label: "Dynamic (any)", iterations: iterations) {
    processDynamic(multiplier, 10)
}

let dynamicNoInlineResult = benchmark(label: "Dynamic (any, @inline(never))", iterations: iterations) {
    processDynamicNoInline(multiplier, 10)
}

// --------------------------------------
// Display results
// --------------------------------------
print("--- Performance Comparison (\(iterations) ops) ---")
print("Result: \(staticResult.result)\n")
print("Static (Generics, @inline(__always)): \(String(format: "%.6f", staticResult.time)) seconds")
print("Dynamic (any):                          \(String(format: "%.6f", dynamicResult.time)) seconds")
print("Dynamic (any, @inline(never)):         \(String(format: "%.6f", dynamicNoInlineResult.time)) seconds")

let ratio = dynamicResult.time / staticResult.time
print("\nConclusion:")
print("Dynamic calls incur overhead; inlining can reduce static call time.")

// --------------------------------------
// Notes
// --------------------------------------
// - Static Dispatch elimina overhead de llamadas.
// - Dynamic Dispatch introduce indirect cost por Witness Table.
// - Inlining permite ver el máximo rendimiento estático.
// - Iteraciones moderadas evitan bloqueos en Playgrounds.
// - No se usan variables globales; resultados retornan desde la función benchmark.
