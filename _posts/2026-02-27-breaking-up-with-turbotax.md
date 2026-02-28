---
title: "Breaking Up with TurboTax: How I Used Claude to File My Taxes for Free"
date: 2026-02-27
categories: [taxes, ai, personal-finance]
tags: [claude, turbotax, intuit, irs, free-file, ai-assistant]
description: "A journey from a decade of paid tax software to AI-assisted free filing using Claude and IRS Free File Fillable Forms."
---

*A journey from a decade of paid tax software to AI-assisted free filing*

---

After more than a decade of TurboTax, I filed my 2025 federal return for free using Claude. My tax situation isn't simple: married filing jointly, two children, inherited IRA distributions across two brokerages, a Roth conversion, HSA contributions and distributions, capital loss carryforwards, foreign tax credits, and Section 199A REIT dividends. The completed return ran 42 pages—Form 1040 plus Schedules 1, 3, B, and D, plus Forms 8949, 8889, 8995, and 1116. Cost: $0.

I paired Claude with IRS Free File Fillable Forms, which was unnecessary friction. Skip FFFF. Have Claude fill out the PDFs directly and mail them in. The rest of this post explains why I left TurboTax, what worked, and what to do instead.

## Why I Left Intuit

Intuit has spent over $45 million on federal lobbying since 1998, including $3.5 million in 2022. Their SEC filings list fighting "governmental encroachment" as an explicit corporate goal—their term for initiatives that would make tax filing easier or free for Americans. When the IRS launched Direct File, Intuit contributed to lawmakers pushing for its elimination and donated $1 million to Trump's 2025 inaugural committee. Direct File is now gone.

[ProPublica documented](https://www.propublica.org/series/the-turbotax-trap) how Intuit deliberately hid free filing options from search engines while marketing paid products as "free," resulting in a $141 million settlement with state attorneys general. The FTC has separately accused them of deceptive advertising.

I stopped paying them.

## The Free Filing Landscape in 2026

The IRS offers two free filing paths. If your AGI is under $89,000, eight private partners offer guided software through the IRS Free File program. My income disqualified me.

The other option is Free File Fillable Forms (FFFF), available to everyone regardless of income. It's the electronic equivalent of blank paper forms: you select forms, fill in values, do the math, and e-file. FFFF was added to the Free File Alliance in 2009—part of the agreement under which the IRS pledged not to build its own competing system. It offers no guidance, no interview questions, no imports. As the IRS warns: "If you are not comfortable with completing a paper return, using only the forms and instructions as a guide to file a correct return, this program is not for you."

I used it anyway. I shouldn't have—and I'll explain why in the practical tips below.

## Enter Claude

I created a dedicated Claude project and uploaded all my source documents: W-2s, 1099-Rs from multiple inherited IRAs, 1099-DIV and 1099-INT statements, HSA documents, and my prior year's return.

I started with Claude Opus 4.5. From my prior year return, it generated a checklist of every form I should expect to receive—a useful starting point I updated as documents arrived.

Claude was my preparation assistant, not my preparer. FFFF doesn't support any import or automation, so every value required manual entry into the web interface. Claude served as reference and verification; I did the data entry.

Here's what Claude handled:

**Document Analysis and Organization**: Claude extracted values from all uploaded documents, organized them by form type and source institution, and mapped them to the appropriate IRS forms. With six 1099-R forms carrying different distribution codes—inherited IRA distributions, a Roth conversion, and a rollover—Claude tracked each separately and identified which codes produced taxable income.

**Form Field Mapping**: Claude generated worksheets showing which source document values mapped to which form lines. For Schedule B, this included every payer, their EIN, and exact amounts. For Form 8949 and Schedule D, it handled the capital loss carryforward.

**Calculation Verification**: Claude walked through the Qualified Dividends and Capital Gain Tax Worksheet, the Credit Limit Worksheet for the Child Tax Credit, and the HSA contribution limits.

**Error Detection**: Covered in the next section.

One limitation: Claude's knowledge of IRS forms is not current. The IRS updates forms annually, and Claude's training data didn't reflect the current year's versions. Multiple times I had to explain changed line numbers, revised worksheets, or new requirements. The IRS also blocks Claude from downloading forms directly from irs.gov. The workaround: upload current form PDFs yourself.

## The Audit

After completing my FFFF entries, I downloaded the return as a PDF and uploaded it to a fresh Opus 4.6 instance—a new conversation on a newer model, to avoid confirmation bias from the preparation session.

Opus 4.6 found four categories of errors:

**Misread Source Documents**: Opus 4.5 had confused which box on a 1099 contained federal withholding versus a different tax category, which would have misstated my refund.

**Incomplete Worksheets**: FFFF doesn't auto-calculate supporting worksheets. Several lines requiring manual worksheet calculations had been left blank.

**Reconciliation Mismatches**: FFFF rounds each withholding entry before summing. This created discrepancies between my entries and Form 1040's expected totals. Claude identified which entries to adjust.

**Form Version Confusion**: Some preparation work used outdated line references or missed new requirements. The audit caught these against current form versions.

Each error required re-entry in FFFF, re-export, and re-verification. But the deeper problem with FFFF is structural: it requires a human to transcribe every value manually, which introduces a whole class of errors that wouldn't exist if Claude were writing directly to the forms.

## The 1041 Contrast

I also needed Form 1041 (Fiduciary Income Tax Return) for two irrevocable trusts. FFFF doesn't support Form 1041, which forced a different workflow.

I provided Opus 4.6 with blank Form 1041 PDFs, trust documents, EIN assignment letters, and the trusts' 1099-DIV statements. Claude filled out the forms directly, handling distributable net income rules, compressed trust tax brackets, and the allocation between tax-exempt and taxable income.

Opus 4.6 caught its own errors mid-process, double-checked calculations against source documents, and flagged uncertainties before I asked. The self-correction that required a separate audit session for my 1040 happened within the same 1041 session.

For the 1040: I entered data into FFFF while Claude assisted, then needed a separate audit session to verify. For the 1041s: Claude prepared complete returns that I reviewed, printed, signed, and mailed. (E-filing isn't available for trust returns.)

The 1041 workflow is the right model for both.

## What This Means

Claude isn't a replacement for TurboTax—it's a replacement for the expertise required to navigate tax forms without guidance.

TurboTax asks questions in plain English, handles form selection and calculations automatically, imports prior year data, and explains edge cases. If you want to file without understanding taxes, TurboTax works—provided you're comfortable funding the reason it's necessary in the first place.

The IRS already has your W-2s, your 1099s, your brokerage statements. It knows the tax rules. For most Americans, the government could calculate their tax bill, send them a pre-filled return, and let them approve or dispute the result. This is how it works in the UK, Japan, Germany, and dozens of other countries. The reason it doesn't work that way here is that Intuit and H&R Block have spent decades and hundreds of millions of dollars ensuring it doesn't. Their business model depends on tax filing being a problem Americans need help solving. So they lobby against pre-filled returns, against Direct File, against anything that would make their products unnecessary. They have succeeded. Americans collectively spend around 6 billion hours per year on tax compliance. TurboTax is a solution to a problem that shouldn't exist.

Claude explains why things work the way they do, catches errors through analysis rather than validation rules, and adapts to specific questions. It requires engaging with the process, not clicking through it.

The workflow I'd use now: upload all source documents to Claude, have it identify every required form, download current PDFs from irs.gov, and have Claude fill them out completely before auditing. Skip FFFF entirely. That replicates what worked for the 1041 returns.

## Practical Tips

To make this workflow easier to replicate, I've packaged the prompting approach as a [Claude skill](https://github.com/calef/us-federal-tax-assistant-skill). Install it into your Claude project and it will guide you through document collection, form identification, and PDF preparation without starting from scratch each time.

If you prefer to set things up manually, here's what I learned:

**1. Have Claude fill out the PDFs directly.** Skip FFFF. Download current blank forms from irs.gov, upload them to your Claude project, and have Claude complete them. Print, sign, and mail. Every extra step FFFF adds—manual entry, rounding quirks, no import support—creates room for errors that cost time to correct.

**2. Start with your prior year return.** Upload it and ask Claude to generate a checklist of all forms you should expect to receive. This gives you a document collection roadmap.

**3. Upload current year IRS forms.** Claude's knowledge of form layouts may be outdated. Have Claude list the forms needed, download current versions from irs.gov, and upload them to your project.

**4. Work form by form.** Complete Schedule B and verify it before moving to Schedule D. Don't try to prepare everything at once.

**5. Use a separate Claude conversation for audit.** Upload your completed return to a new session on the latest available model.

**6. Verify visually.** Have Claude examine images of source documents, not just extracted text. This catches transcription errors.

**7. Budget time for iteration.** The audit process is where value gets created. Plan for multiple passes.

## The Bottom Line

My 2025 federal return filed successfully. Total cost: ~150,000 tokens.

Time spent was comparable to past TurboTax years. The bottleneck wasn't Claude—it was FFFF. The audit iterations added time, but each one found real errors.

I stopped funding a company that spends millions lobbying against free tax filing. I learned more about my own tax situation. AI-assisted preparation works for complex returns—42 pages, nine forms, multiple inherited IRAs, trust filings—without commercial software.
