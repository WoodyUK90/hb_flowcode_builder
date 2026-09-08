# Hornbill Flowcode Advanced Builder

A lightweight, standalone web application designed for Hornbill administrators, workflow designers, and developers to easily construct, test, and preview Hornbill Flowcode script evaluation expressions.

---

## 📌 Overview

In Hornbill Business Process (BPM) and Flowcode automations, dynamic values and data manipulations often require JavaScript expressions wrapped inside the `&[...]` evaluation syntax. Writing these expressions manually can lead to syntax errors, type-mismatch bugs (such as string concatenation occurring during mathematical addition), or unexpected runtime behavior.

The **Hornbill Flowcode Advanced Builder** provides an interactive interface to:
- Select and clean Hornbill token paths (e.g. `global['flowcoderefs']['node']['result']`).
- Apply explicit type conversions (`Number()`, `parseInt()`, `parseFloat()`, `String()`).
- Configure complex mathematical, routing, string formatting, and conditional logic.
- Preview the generated Flowcode expression with an interactive, client-side live simulation engine using smart mock data.
- Copy production-ready expressions directly to the clipboard with one click.

---

## 🚀 Key Features

### 1. Token Cleaning & Variable Normalization
- Automatically strips any accidental leading `&[` and trailing `]` wrappers if tokens are pasted with them included.
- Provides default fallback token names (`PRIMARY_VARIABLE`, `SECONDARY_VARIABLE`) if fields are left blank.

### 2. Explicit Type Casting & Category Guardrails
Hornbill variables are frequently passed as string types across workflow stages. The builder offers safe casting:
- `None` (raw variable)
- `Number(var)`
- `parseInt(var, 10)` (with explicit base-10 radix)
- `parseFloat(var)`
- `String(var)`

**Category-Based Guardrails:**
- Selecting **Mathematics** or **Routing** automatically disables and dims the `String()` option to prevent runtime calculation issues.
- Selecting **Specialised Formatting** dims numeric conversions (with dynamic exception handling for the `currency` operation).

### 3. Comprehensive Operation Categories

| Category | Operation / Function | Generated Hornbill Expression Pattern | Description |
| :--- | :--- | :--- | :--- |
| **Math** | Add (`+`), Subtract (`-`), Multiply (`*`), Divide (`/`) | `&[(<var1> <op> <modifier>)]` | Performs arithmetic with parenthesized precedence. Modifier can be a static value or a secondary Hornbill token with its own casting. |
| **Routing** | Modulus (`%`) Decision | `&[<var1> % <divisor> === 0]` | Returns boolean `true`/`false` for counter/interval branching (e.g. every 5th ticket). |
| **Routing** | Modulus (`%`) Remainder | `&[<var1> % <divisor>]` | Returns the raw remainder after integer division. |
| **String** | Capitalise First (InitCap) | `&[<var1>.charAt(0).toUpperCase() + <var1>.slice(1)]` | Capitalises the first character, keeping remaining characters unchanged. |
| **String** | Capitalise All (Title Case) | `&[<var1>.split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')]` | Converts multi-word strings into Title Case format. |
| **String** | Zero-Pad Reference | `&[<var1>.padStart(<len>, '0')]` | Left-pads strings/numbers to a target length (e.g., `123` &rarr; `000123`). |
| **String** | Mask Sensitive Data | `&[String(<rawVar>).slice(-4).padStart(String(<rawVar>).length, '*')]` | Obfuscates sensitive identifiers (GDPR/PII), preserving only the last 4 characters. |
| **String** | Strict Currency Format | `&[Number(<var>).toFixed(2)]` | Enforces two decimal places (e.g. `15` &rarr; `15.00`). |
| **String** | Single URL Encode | `&[encodeURIComponent(<var>)]` | Encodes URL parameters for external HTTP requests. |
| **String** | Double URL Encode | `&[encodeURIComponent(encodeURIComponent(<var>))]` | Twice-encoded URL parameters for APIs requiring nested encoding (e.g., VirusTotal lookup endpoints). |
| **String** | Single / Double URL Decode | `&[decodeURIComponent(<var>)]` / nested | Decodes single- or double-encoded URI components. |
| **Logic** | Ternary (Inline IF/ELSE) | `&[<var1> <cond> <compare> ? "<trueVal>" : "<falseVal>"]` | Evaluates `===`, `!==`, `>`, `<` comparisons with smart quotation of strings vs numeric/boolean values. |
| **Logic** | Null / Undefined Fallback | `&[<var1> \|\| "<fallbackVal>"]` | Provides a default value if the token evaluates to null, undefined, or empty. |
| **Date** | Format / Convert Variable Date | *Varies by format selection (optimized one-liner or universal IIFE)* | Converts and re-formats variable date tokens into any supported standard or user-defined custom pattern. |
| **Date** | Current Date / Time (`Now`) | `&[new Date().toISOString().slice(0, 10)]` *(or custom format)* | Current timestamp in UTC or Local time. Strict `YYYY-MM-DD` for Hornbill Custom Fields. |
| **Date** | Today / Now &plusmn; Relative Offset | `&[new Date(Date.now() + (<offset>)).toISOString().slice(0, 10)]` | Offsets current date/time by Days, Hours, or Minutes in any chosen format. |
| **Date** | Variable Date &plusmn; Relative Offset | `&[new Date(new Date(String(<var>).replace(' ', 'T')).getTime() + (<offset>))...]` | Offsets an incoming variable date/time token by Days, Hours, or Minutes. |
| **Date** | Fast Extract Date | `&[String(<var>).split(' ')[0]]` | Ultra-fast extraction of `YYYY-MM-DD` by splitting on space, stripping time. |
| **Date** | Ticket Age in Days | `&[Math.floor((Date.now() - new Date(String(<var>).replace(' ', 'T')).getTime()) / 86400000)]` | Integer elapsed days since the date was logged. |
| **Date** | Days Between Two Dates | `&[Math.round(Math.abs(new Date(String(<var2>).replace(' ', 'T')) - new Date(String(<var1>).replace(' ', 'T'))) / 86400000)]` | Absolute difference in days between two date tokens. |
| **Date** | Hours Elapsed | `&[Math.floor((Date.now() - new Date(String(<var>).replace(' ', 'T')).getTime()) / 3600000)]` | Integer elapsed hours since the date was logged. |
| **Date** | Is Past / Overdue? (Decision) | `&[new Date(String(<var>).replace(' ', 'T')).getTime() < Date.now()]` | Boolean decision (`true`/`false`) if target/SLA date has passed. |
| **Date** | Is Future Date? (Decision) | `&[new Date(String(<var>).replace(' ', 'T')).getTime() > Date.now()]` | Boolean decision (`true`/`false`) if date is in the future. |
| **Date** | Expires within N Days? | `&[(() => { const d = new Date(String(<var>).replace(' ', 'T')).getTime() - Date.now(); return d > 0 && d <= (<N> * 86400000); })()]` | Boolean decision if target date falls within the next N days. |
| **Date** | Is Weekend? | `&[[0, 6].includes(new Date(String(<var>).replace(' ', 'T')).getDay())]` | Boolean decision (`true`/`false`) if date falls on Saturday or Sunday. |

#### Supported Date & DateTime Formats

The builder provides a curated suite of standard formats and a custom pattern engine:
- **Hornbill Custom Field (Date Only)**: `YYYY-MM-DD` (strictly strips time for Hornbill date fields)
- **Hornbill Custom Field / SQL DateTime**: `YYYY-MM-DD HH:mm:ss`
- **UK Standards**:
  - `DD/MM/YYYY` (Standard UK date)
  - `DD/MM/YYYY HH:mm` (UK short date and time)
  - `DD/MM/YYYY HH:mm:ss` (UK full date and time)
  - `DD-MM-YYYY` (UK hyphenated date)
- **Other Standard Formats**:
  - `YYYY/MM/DD` (Slash ISO)
  - `YYYYMMDD_HHmmss` (Compact timestamp / file or reference slug)
  - `HH:mm:ss` (Time only - 24-hour)
  - `HH:mm` (Time only - Short 24-hour)
- **User-Defined Custom Format**:
  - Allows typing any pattern string using tokens: `YYYY` (4-digit year), `YY` (2-digit year), `MM` (2-digit month), `DD` (2-digit day), `HH` (2-digit hour), `mm` (2-digit minute), `ss` (2-digit second).
  - All delimiters (e.g. `-`, `/`, `.`, space, commas, or letters) are preserved.
  - Automatically compiles into a standalone Hornbill IIFE token replacer:
    ```javascript
    &[(() => { const d = new Date(String(token).replace(' ', 'T')); const p = n => String(n).padStart(2, '0'); return "DD-MM-YYYY HH:mm".replace(/YYYY/g, d.getUTCFullYear()).replace(/YY/g, String(d.getUTCFullYear()).slice(-2)).replace(/MM/g, p(d.getUTCMonth() + 1)).replace(/DD/g, p(d.getUTCDate())).replace(/HH/g, p(d.getUTCHours())).replace(/mm/g, p(d.getUTCMinutes())).replace(/ss/g, p(d.getUTCSeconds())); })()]
    ```
- **Timezone Basis**: Supports **UTC** (Hornbill server standard) or **Local Time** (regional browser/client time).

---

### 4. Action Templates (Quick Presets)
One-click presets instantly configure the variable, type conversions, operation mode, and mock test values:
- **Cost * VAT**: Multiplies a primary value by static `1.20`.
- **Ternary Status IF/ELSE**: Compares numeric status code `1` &rarr; `"Active"` / `"Inactive"`.
- **Title Case**: Converts `"john doe"` &rarr; `"John Doe"`.
- **Zero-Pad Reference**: Pads `"123"` to length `6` &rarr; `"000123"`.
- **Mask PII**: Masks phone/account numbers &rarr; `"*******0461"`.
- **Format to Currency**: Formats numeric values to strict `.00` representation.
- **Double Encode URL**: Encodes a full URL parameter for complex REST APIs.
- **Today (YYYY-MM-DD)**: Outputs current date for Hornbill Custom Fields without time.
- **Now (SQL DateTime)**: Current timestamp in `YYYY-MM-DD HH:mm:ss`.
- **Now (UK DD/MM/YYYY HH:mm)**: Current timestamp in UK date and time format.
- **Due in 5 Days (Custom Field)**: Offsets date by 5 days in strict `YYYY-MM-DD` format.
- **Custom (DD-MM-YYYY HH:mm)**: Configures custom pattern template with live preview.
- **Ticket Age (Days)**: Calculates elapsed days since date logged.
- **Is Overdue? (Boolean)**: Evaluates whether date has passed.

### 5. Live Simulation Engine
- Runs a client-side execution sandbox simulating Hornbill's evaluation engine against mock input data.
- Features **Smart Mock Defaults**: updates mock inputs to contextually relevant defaults (e.g., sample URLs, sample phone numbers, or numeric values) unless explicitly modified by the user.
- Emits real-time live preview results alongside the generated expression.

---

## 🛠️ Architecture & Implementation

The application is structured as a single, self-contained file (`Hornbill Flowcode Advanced Builder.html`):
- **HTML5**: Semantic layout with form groups, dynamic panels, and action preset buttons.
- **CSS3**: Responsive container layout with modern custom properties (`:root`), card elevation, dynamic disabled state opacity transitions, and responsive grid columns (`.grid-2`).
- **SVG Favicon**: Embedded data URI favicon styled with Hornbill-inspired branch/flow iconography.
- **Vanilla JavaScript (ES6+)**:
  - `cleanToken()`: Token string sanitizer.
  - `wrapVariable()`: Conditional type-wrapper.
  - `switchCategory()`: Dynamic DOM section visibility and conversion radio state management.
  - `simulateExpression()`: Safe calculation engine displaying preview outputs.
  - `generateFlowcode()`: Expression builder and explanation generator.
  - `copyToClipboard()`: Clipboard API integration with temporary visual confirmation.

---

## 🔍 Code Review & Observations

### Strengths
1. **Zero External Dependencies**: Operates 100% client-side with no CDN dependencies or build steps; can run offline or directly from any shared filesystem or portal.
2. **Context-Sensitive Validation**: Restricts conversion choices based on operation category, preventing invalid configurations (e.g., applying `String()` to mathematical arithmetic).
3. **Smart Mock Feedback Loop**: Automatically updates test data as users switch operations without overwriting user-customized inputs (`isMock1ModifiedByUser`, `isMock2ModifiedByUser`).

### Edge Cases & Improvement Opportunities
1. **Empty String Comparison in Ternary**:
   - In JavaScript, `isNaN("")` evaluates to `false` (as `Number("") === 0`). In `generateFlowcode()`:
     ```javascript
     if (isNaN(compareVal) && compareVal !== "true" && compareVal !== "false") {
         compareVal = `"${compareVal}"`;
     }
     ```
     If a user compares against an empty string `""`, `compareVal` is not quoted, resulting in `=== 0`. Adding an explicit check for empty string (`compareVal.trim() === ""`) ensures empty string literals are properly quoted (`""`).
2. **PII Masking for Strings Shorter than 4 Characters**:
   - `strM1.slice(-4).padStart(strM1.length, '*')` works well for strings longer than 4 characters. For inputs under 4 characters, the slice captures the entire string, resulting in no masking asterisks.
3. **Radix in Secondary Conversion**:
   - `convType2` for secondary variables currently outputs `parseInt(${rawVar2})` without specifying `10`, whereas primary conversion outputs `parseInt(${rawVar1}, 10)`. Standardizing both to explicit base-10 improves consistency.
4. **HTML Escaping in Explanations**:
   - The explanation string is set via `innerHTML`. While currently safe because values are internally constructed or simple numbers, escaping user inputs prior to rendering in HTML notes is a best practice.

---

## 💻 How to Use

1. Double-click or open `Hornbill Flowcode Advanced Builder.html` in any modern web browser (Chrome, Edge, Firefox, Safari).
2. Paste your Hornbill variable reference into field **1. Primary Base Variable / Token String** (or pick an **Action Template**).
3. Select your **Operation Category** (Math, Routing, String, or Logic).
4. Configure the relevant parameters (operator, modifier, padding length, or condition).
5. Review the **Live Preview Result** using mock data to verify output correctness.
6. Click **Copy Code** to copy the formatted `&[...]` expression and paste it directly into your Hornbill workflow node.
