# Hornbill Flowcode Development Rules

## 1. Expression Syntax & Token Hygiene
- All dynamic expressions evaluated by Hornbill Flowcode must be wrapped in `&[...]`.
- When sanitizing or ingesting Hornbill token strings (e.g., `global['flowcoderefs']['node']['result']`), strip any leading `&[` and trailing `]` before constructing or nesting expressions.
- Never output nested enclosures like `&[&[...]]`.

## 2. Type Casting & Calculation Safety
- Hornbill workflow tokens frequently yield string data types even for numbers.
- Always enforce explicit casting before arithmetic operations or strict comparisons:
  - For general numeric calculation: `Number(val)`
  - For decimals / currency: `parseFloat(val)`
  - For whole numbers: `parseInt(val, 10)` (always provide radix `10`)
- When formatting currency, format with `.toFixed(2)`.

## 3. Standalone Application Architecture
- `Hornbill Flowcode Advanced Builder.html` is a zero-dependency, single-file HTML/CSS/JavaScript application.
- Do not introduce external CDN dependencies, build steps, or server-side requirements.
- Ensure all live simulation and preview features run purely in-memory in the browser.

## 4. Date Formatting for Hornbill Custom Fields
- When outputting dates for Hornbill Custom Fields, always enforce strict `YYYY-MM-DD` format without any time component (`HH:MM:SS` stripped or omitted via `.toISOString().slice(0, 10)` or `.split(' ')[0]`).
- For date arithmetic or current timestamps targeting custom fields, format the resulting Date object via `.toISOString().slice(0, 10)`.
- When normalizing UK date strings (`DD/MM/YYYY`) for custom fields, reverse parts to `YYYY-MM-DD` via `val.slice(0, 10).split('/').reverse().join('-')`.

## 5. UK Locale Standards
- This project and environment strictly adhere to UK standards.
- Never generate, display, or suggest US date formats (`MM/DD/YYYY`). Human-readable display dates must always follow UK convention (`DD/MM/YYYY`).
- Hornbill custom field dates must strictly use `YYYY-MM-DD` without time.
