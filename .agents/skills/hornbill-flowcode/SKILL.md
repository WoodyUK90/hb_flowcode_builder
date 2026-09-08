---
name: hornbill-flowcode
description: >-
  Provides guidelines, syntax patterns, and testing procedures for generating,
  modifying, and validating Hornbill Flowcode script expressions and automations.
---

# Hornbill Flowcode Expression Guide

Use this skill when constructing or debugging expressions for Hornbill Business Process (BPM) and Flowcode automations.

## Expression Patterns

| Goal | Pattern | Notes |
| :--- | :--- | :--- |
| Arithmetic | `&[(Number(a) + Number(b))]` | Wrap in parentheses for operator precedence |
| Interval Routing | `&[Number(counter) % 5 === 0]` | Returns boolean true every 5th execution |
| Safe Fallback | `&[token || "Default Value"]` | Guards against empty/null/undefined outputs |
| Title Case | `&[String(str).split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')]` | Safe capitalization of words |
| Zero-Padding | `&[String(val).padStart(6, '0')]` | Formats numbers to fixed-width ticket references |
| PII Masking | `&[String(val).slice(-4).padStart(String(val).length, '*')]` | Masks all but the last 4 characters |
| REST API URL Encoding | `&[encodeURIComponent(val)]` | Standard URI encoding |
| Double URL Encoding | `&[encodeURIComponent(encodeURIComponent(val))]` | For external gateways like VirusTotal |
| Current Date (Custom Field) | `&[new Date().toISOString().slice(0, 10)]` | Strict `YYYY-MM-DD` (no time) |
| Current DateTime (SQL) | `&[new Date().toISOString().replace('T', ' ').slice(0, 19)]` | `YYYY-MM-DD HH:mm:ss` |
| Add N Days (Custom Field) | `&[new Date(new Date(String(val).replace(' ', 'T')).getTime() + (N * 86400000)).toISOString().slice(0, 10)]` | Strict `YYYY-MM-DD` (no time) |
| Format to UK Standard | `&[(() => { const d = new Date(String(val).replace(' ', 'T')); const p = n => String(n).padStart(2, '0'); return p(d.getUTCDate()) + '/' + p(d.getUTCMonth() + 1) + '/' + d.getUTCFullYear(); })()]` | Outputs `DD/MM/YYYY` |
| Custom Pattern Replacer | `&[(() => { const d = new Date(String(val).replace(' ', 'T')); const p = n => String(n).padStart(2, '0'); return "PATTERN".replace(/YYYY/g, d.getUTCFullYear()).replace(/YY/g, String(d.getUTCFullYear()).slice(-2)).replace(/MM/g, p(d.getUTCMonth() + 1)).replace(/DD/g, p(d.getUTCDate())).replace(/HH/g, p(d.getUTCHours())).replace(/mm/g, p(d.getUTCMinutes())).replace(/ss/g, p(d.getUTCSeconds())); })()]` | Token replacer supporting arbitrary patterns (`YYYY`, `YY`, `MM`, `DD`, `HH`, `mm`, `ss`) |
| Ticket Age in Days | `&[Math.floor((Date.now() - new Date(String(val).replace(' ', 'T')).getTime()) / 86400000)]` | Returns integer elapsed days |
| Is Overdue? (Decision) | `&[new Date(String(val).replace(' ', 'T')).getTime() < Date.now()]` | Boolean `true`/`false` for decision nodes |

## Validation & Testing Checklist
1. Ensure outer `&[...]` wrapper is present exactly once.
2. Confirm variables are cast using base-10 radix for integers: `parseInt(var, 10)`.
3. Check that string comparison operands are properly quoted.
4. For Hornbill Custom Date fields, verify the output is strictly `YYYY-MM-DD` with no time attached.
5. Strictly adhere to UK conventions: human-readable date strings must be formatted as `DD/MM/YYYY`. Never use or generate US `MM/DD/YYYY` date formats.
6. Support arbitrary user-defined custom format strings with token replacement (`YYYY`, `YY`, `MM`, `DD`, `HH`, `mm`, `ss`).
7. Verify edge cases (e.g., empty string, null token, or divide-by-zero).
