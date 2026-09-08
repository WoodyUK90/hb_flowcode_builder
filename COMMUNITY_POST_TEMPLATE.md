# Hornbill Community Forum Announcement Template

> **Tip:** You can copy and paste the markdown content below directly into a new topic on the [Hornbill Community Forum](https://community.hornbill.com/) (suggested category: **Integrations & Extensions**, **Tips & Tricks**, or **Flowcode**).

---

### **Title:**
Free Community Tool: Flowcode Advanced Builder (Interactive Expression Generator & In-Memory Simulator)

---

### **Post Body:**

Hi everyone,

Working with Hornbill Flowcode dynamic expressions (`&[...]`) in Business Processes and Autotasks is immensely powerful, but can often lead to subtle gotchas — string concatenation bugs when adding numbers, nested bracket syntax errors, or date arithmetic issues when populating Hornbill Custom Fields.

To help our team (and hopefully the wider Hornbill community and Hornbill's customer support/onboarding teams), I built a lightweight, interactive helper tool called **Hornbill Flowcode Advanced Builder**.

It is completely free, 100% client-side, zero-dependency, and open-source.

---

### 🌐 How to Use It
- **Live Web App (GitHub Pages):** [https://woodyuk90.github.io/hb_flowcode_builder/](https://woodyuk90.github.io/hb_flowcode_builder/)
- **Offline / Local Use:** You can also download the attached `Hornbill Flowcode Advanced Builder.html` file and simply double-click it. It runs locally in your browser (`file:///...`) with zero internet connection or server dependencies.
- **Source Code & Contributions (GitHub):** [https://github.com/WoodyUK90/hb_flowcode_builder](https://github.com/WoodyUK90/hb_flowcode_builder)

---

### ⚡ Key Features

1. **Top Token Command Bar**:
   - Cleanly input Hornbill variable tokens (e.g. `global['flowcoderefs']['myNode']['result']`).
   - Automatically sanitizes and strips any accidental `&[` or `]` delimiters to prevent nested bracket errors (`&[&[...]]`).

2. **14+ One-Click Quick Action Templates**:
   - Jump-start common enterprise patterns: Cost × VAT (1.20), Ternary Status Codes, Title Case, Left-Padding Reference Numbers, GDPR Data Masking, and Date Calculations.

3. **Human-Friendly Type Casting**:
   - Enforces safe type conversion (`Number()`, `parseInt(val, 10)`, `parseFloat()`, `String()`) with plain-English labels (**Raw / As-Is**, **Any Number**, **Whole Number**, **Decimal / £**, **Text**) to eliminate string-gluing bugs in calculations.

4. **Dedicated Hornbill Date & Time Studio (UK Standard)**:
   - Formats dates strictly for Hornbill Custom Fields (`YYYY-MM-DD` with time omitted).
   - Handles UK display standards (`DD/MM/YYYY HH:mm`) and custom pattern string tokens.
   - Built-in date arithmetic: SLA offsets (add/subtract days, hours, minutes), ticket age calculations, and boolean overdue checks (`target < Date.now()`).

5. **In-Memory Live Simulation Deck**:
   - Tests expressions instantly in your browser before committing them to a workflow.
   - Includes adaptive input selectors: a native **HTML5 Date/Time Calendar Picker** with quick condition chips (`[Now]`, `[-7d (Overdue)]`, `[+7d (Future)]`), integer steppers, and currency controls.

6. **Real-Time URL Sync & Shareable Links**:
   - Address bar automatically serializes your exact configuration and simulation outputs.
   - Use the **Share Link** button to send pre-configured Flowcode setups directly to colleagues.

---

### 🤝 For the Hornbill Product & Academy Team
All code is licensed under the permissive **MIT License**. If Hornbill would like to host this directly on the Hornbill website/wiki, reference it in documentation, or embed it as a native utility within the Hornbill administration interface, you are completely free and welcome to do so!

Hope you find this useful in your workflows, and feedback/suggestions are very welcome!

Cheers,  
**Samuel Wood**
