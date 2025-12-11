# Any vs Generics (Swift)

Comparación rápida de **Static (`some`)** vs **Dynamic (`any`)** dispatch.

---

## Conceptos

- `some` → código concreto, rápido.  
- `any`  → indirect call, overhead.  
- `@inline(__always)` / `@inline(never)` → guía al compilador.

⚠️ Playgrounds puede mostrar resultados inconsistentes; Xcode Release da mediciones reales.

---

## Uso

```bash
git clone https://github.com/tu-repo/swift-polymorphism.git
```
- open Benchmark.playground
- Ejecutar y revisar tiempos y ratio.

---

### Nota
Discrepancias en Playgrounds son normales; Static suele ser más rápido en proyectos reales.
