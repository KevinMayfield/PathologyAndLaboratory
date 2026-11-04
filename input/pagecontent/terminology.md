<div class="alert alert-danger" role="alert">
<b>Draft.</b> This implementation guide is a draft for discussion. It is <b>not</b> an
authoritative source and is not endorsed by NHS England, IHE or HL7. Check the cited
sources before using it for implementation.
</div>

### Tests and Results

| Item | HL7 v2 | FHIR | Code system | Notes |
|---|---|---|---|---|
| Result (what was measured) | OBX-3 | `Observation.code` | SNOMED CT UK Edition - PaLM observable entities | The DAPB4101 / NHS England PaLM codes. Example: `1022431000000105` Haemoglobin estimation |
| | | | LOINC (second coding) | Optional, where known. Example: `718-7` |
| Test group / test ordered or reported | OBR-4 | `ServiceRequest.code`, test group `Observation.code`, `DiagnosticReport.code` (one test) | SNOMED CT UK - [PaLM Requestable Tests](ValueSet-palm-procedure.html) (refset `1853561000000109`) | The England equivalent of the National Genomic Test Directory and NICIP - see below |
| Report type | - | `DiagnosticReport.code`, `Composition.type` | SNOMED CT, LOINC | `721981007` Diagnostic studies report (NHS England), LOINC `11502-2` Laboratory report |
| Units | OBX-6 | `valueQuantity.code` | UCUM | Example: `10*9/L`, `g/L`, `mmol/mol` |
| Coded result | OBX-5 (`CWE`) | `valueCodeableConcept` | SNOMED CT | Organisms, qualifiers (`Positive`, `Not detected`) |
| Specimen type | SPM-4 | `Specimen.type` | SNOMED CT specimen | Example: `119297000` Blood specimen |
| Body site | SPM-8 | `Specimen.collection.bodySite` | SNOMED CT body structure | |
| Discipline | OBR-24 | `DiagnosticReport.category` | HL7 v2 table 0074 | Example: `HM` haematology, `CH` chemistry, `MB` microbiology |
{:.grid}

The SNOMED CT codes in this guide were checked against the UK Edition on tx.fhir.org
(4 November 2026). Validation in this guide uses the SNOMED CT UK Edition
(`http://snomed.info/sct/83821000000107`), set in the expansion parameters.

<div class="alert alert-info" role="alert">
<b>Recommendation:</b> use the DAPB4101 codes on every route in England, not only to GP
systems - see <a href="PaLM.html#what-england-adds">IHE PaLM in England</a>.
The NHS England <a href="https://digital.nhs.uk/data-and-information/information-standards/governance/latest-activity/standards-and-collections/dapb4101-pathology-and-laboratory-medicine-reporting-information-standard">DAPB4101</a>
standard defines the PaLM SNOMED CT codes and their use. Laboratories map their local test
codes to them (the PaLM mapping project). Where a local code has no PaLM code yet, send the
local code with coding system <code>L</code> and flag the gap.
</div>

### Requestable Tests (PaLM Procedures)

Genomics has the [National Genomic Test Directory](https://www.england.nhs.uk/publication/national-genomic-test-directories/)
and imaging has NICIP. For laboratory medicine the national list of tests that can be requested
is the SNOMED CT UK Edition **Pathology and laboratory medicine procedure simple reference set**
(`1853561000000109`) - the PaLM *requestables*, modelled as SNOMED CT procedures. Results are the
PaLM *reportables*, the observables refset `1853551000000106` (and the older Pathology Bounded Code
List `999002881000000100`).

| | Genomics | Imaging | Laboratory medicine |
|---|---|---|---|
| National list of requestable tests | National Genomic Test Directory (code system, with eligibility criteria) | NICIP (code system, mapped to SNOMED CT and OPCS) | PaLM procedure refset `1853561000000109` (SNOMED CT subset - no national directory of who offers what, or eligibility) |
| In this guide | - | - | [PaLM Requestable Tests](ValueSet-palm-procedure.html), preferred for the `palmProcedure` slice of [Laboratory Order](StructureDefinition-LaboratoryOrder.html) `code` and the `snomedCT` slice of [Laboratory Report](StructureDefinition-LaboratoryReport.html) `code` ([Laboratory Report Codes](ValueSet-laboratory-report-snomedct.html)) |
| UK Core | - | - | `UKCore-PathologyAndLaboratoryMedicineProcedures` (same refset), preferred for `UKCore-ServiceRequest-Lab.code` and `UKCore-Observation-Group-Lab.code` |
{:.grid}

Each laboratory keeps its own test catalogue (local codes, profiles, eligibility) and maps it to
PaLM. In HL7 v2 send the PaLM code in OBR-4 CWE-1 to CWE-3 and the laboratory's code as the
alternate (CWE-4 to CWE-6).

Earlier national catalogues - the National Laboratory Medicine Catalogue (NLMC, Royal College of
Pathologists) and the UK Unified Test List (`44991000237108`, retired in UK Core) - are replaced by
PaLM.

The [PaLM Requestable Tests](ValueSet-palm-procedure.html) value set lists the 358 members of the
refset in the UK Edition of 2 July 2025. They are listed, rather than given as a refset rule, because
the UK Edition on tx.fhir.org (April 2023) does not yet contain the refset. They were expanded on
CSIRO's public Ontoserver by `scripts/palm_valueset.py`, which can be re-run for a new release.

<div class="alert alert-warning" role="alert">
<b>Open - example order codes.</b> The test group codes in the NHS England examples, which this guide's
examples and the <code>ORU^R01</code> versions use for OBR-4 and <code>ServiceRequest.code</code>, are
<b>results</b> codes, not PaLM requestables. For example <code>1022441000000101</code> FBC - full blood
count, Liver function tests, Urea and electrolytes level and Serum lipids level are in the Pathology
Bounded Code List; HbA1c and HPV are PaLM observables. The PaLM requestables for the same tests are,
for example, <code>26604007</code> Full blood count, <code>26958001</code> Hepatic function panel (LFT), <code>252167001</code> Urea and electrolytes,
<code>271244005</code> Measurement of serum lipid level, <code>135842001</code> Serum C reactive protein
level, <code>371981000000106</code> Hb A1c measurement - IFCC standardised, <code>47758006</code> Hepatitis
B surface antigen measurement, <code>700152009</code> Human papilloma virus screening,
<code>113076002</code> Glucose tolerance test and <code>401324008</code> Urinary microscopy, culture and
sensitivities.
</div>

### PaLM to LOINC (illustrative)

HL7 Europe Laboratory, which this guide's profiles derive from, prefers LOINC: `ServiceRequest.code`
is bound to `lab-orderCodes-eu-lab` (LOINC `ORDER_OBS` = Order or Both) and `Observation.code` to
`lab-obsCode-eu-lab`, which includes [`lab-obsCode-loinc-eu-lab`](https://hl7.eu/fhir/laboratory/2.1.0/ValueSet-lab-obsCode-loinc-eu-lab.html).
A map from PaLM to LOINC lets England orders and reports also carry the LOINC code, as a second
coding.

[palm-procedure-to-loinc](ConceptMap-palm-procedure-to-loinc.html) shows what a map from the PaLM
requestables to LOINC order codes could look like, for the tests in the NHS England examples:

| PaLM requestable (SNOMED CT UK) | LOINC | Equivalence | Why |
|---|---|---|---|
| `26604007` Full blood count | `57021-8` CBC W Auto Differential panel - Blood | inexact | Panel members differ |
| `252167001` Urea and electrolytes | `24321-2` Basic metabolic 2000 panel - Serum or Plasma | inexact | No LOINC U&E panel |
| `26958001` Hepatic function panel | `24325-3` Hepatic function 2000 panel - Serum or Plasma | inexact | Panel members differ |
| `271244005` Measurement of serum lipid level | `24331-1` Lipid 1996 panel - Serum or Plasma | inexact | Panel members differ |
| `135842001` Serum C reactive protein level | `1988-5` C reactive protein [Mass/volume] in Serum or Plasma | wider | LOINC is serum or plasma |
| `371981000000106` Hb A1c measurement - IFCC standardised | `59261-8` Hemoglobin A1c/Hemoglobin.total standardized per IFCC-RMP for CDT in Blood | equivalent | |
| `47758006` Hepatitis B surface antigen measurement | `5195-3` Hepatitis B virus surface Ag [Presence] in Serum | narrower | LOINC gives scale and specimen |
| `700152009` Human papilloma virus screening | `82675-0` HPV 16+18+31+...+68 DNA [Presence] in Cervix by NAA with probe detection | narrower | LOINC names the types and method |
| `113076002` Glucose tolerance test | `72171-2` Glucose tolerance 2 hours panel - Serum or Plasma | narrower | The 2 hour (75 g) test |
| `401324008` Urinary microscopy, culture and sensitivities | `50554-5` microscopy, `630-4` culture, `29576-6` susceptibility | narrower (each) | No single LOINC order code |
{:.grid}

Equivalence is the LOINC code relative to the PaLM code. LOINC codes were checked on tx.fhir.org
(LOINC 2.83, 4 November 2026).

<div class="alert alert-warning" role="alert">
<b>Open - national map.</b> This map is illustrative only. NHS England is understood to be producing the
national PaLM to LOINC map (<b>To confirm</b>); when it is published this guide should reference it and
drop this example. LOINC panels follow US practice, so most profile maps are <code>inexact</code>: the
LOINC panel does not say what an England laboratory's FBC or U&amp;E contains. A map for results (PaLM
observables to <code>lab-obsCode-loinc-eu-lab</code>) is not attempted.
</div>

### Coding Systems in HL7 v2

CWE-3 (and CWE-6) name the coding system. Map them to FHIR `Coding.system`:

| CWE-3 | Coding system | FHIR `system` |
|---|---|---|
| `SCT` | SNOMED CT | `http://snomed.info/sct` |
| `LN` | LOINC | `http://loinc.org` |
| `UCUM` | UCUM | `http://unitsofmeasure.org` |
| `I10` | ICD-10 | `http://hl7.org/fhir/sid/icd-10` |
| `HL7nnnn` | HL7 v2 table nnnn | `http://terminology.hl7.org/CodeSystem/v2-nnnn` |
| `L` (or a registered local name) | Local laboratory code | A URI agreed per laboratory, for example `https://fhir.<trust>.nhs.uk/CodeSystem/lims-test` |
{:.grid}

`SNM3` (used in some DHCW examples) is SNOMED 3 / SNOMED International in HL7 table 0396;
for SNOMED CT use `SCT`.

### Identifier Systems

| Identifier | HL7 v2 | FHIR `Identifier.system` |
|---|---|---|
| NHS Number | PID-3 `^^^NHS^NH` | `https://fhir.nhs.uk/Id/nhs-number` |
| ODS organisation code | MSH-4, MSH-6, XON-10 | `https://fhir.nhs.uk/Id/ods-organization-code` |
| ODS site code | PL, XON-10 | `https://fhir.nhs.uk/Id/ods-site-code` |
| GMC number | XCN-9 `GMC` | `https://fhir.hl7.org.uk/Id/gmc-number` |
| GP (GMP) code | XCN-9 `GMP` | `https://fhir.hl7.org.uk/Id/gmp-number` |
| NMC number | XCN-9 `NMC` | `https://fhir.hl7.org.uk/Id/nmc-number` |
| HCPC number | XCN-9 `HCPC` | `https://fhir.hl7.org.uk/Id/hcpc-number` |
{:.grid}

### HL7 v2 Tables

ConceptMaps from HL7 v2 tables to FHIR (indicative, based on the HL7 v2-to-FHIR IG):

- [v2-0001-to-administrative-gender](ConceptMap-v2-0001-to-administrative-gender.html) - PID-8
- [v2-0119-to-request-status](ConceptMap-v2-0119-to-request-status.html) - ORC-1
- [v2-0485-to-request-priority](ConceptMap-v2-0485-to-request-priority.html) - TQ1-9
- [v2-0123-to-diagnostic-report-status](ConceptMap-v2-0123-to-diagnostic-report-status.html) - OBR-25
- [v2-0085-to-observation-status](ConceptMap-v2-0085-to-observation-status.html) - OBX-11
- [v2-0078-to-observation-interpretation](ConceptMap-v2-0078-to-observation-interpretation.html) - OBX-8

### Units

UCUM **SHALL** be used in FHIR and **SHOULD** be used in HL7 v2 (OBX-6 CWE-1 the UCUM code,
CWE-3 `UCUM`). Common laboratory conversions:

| Written | UCUM |
|---|---|
| x10^9/L (HL7 v2 `x10\S\9/L`) | `10*9/L` |
| x10^12/L | `10*12/L` |
| g/L | `g/L` |
| L/L | `L/L` |
| fL | `fL` |
| pg | `pg` |
| mmol/L | `mmol/L` |
| mmol/mol (HbA1c) | `mmol/mol` |
| umol/L | `umol/L` |
| mL/min/1.73m2 (eGFR) | `mL/min/{1.73_m2}` |
| % | `%` |
{:.grid}
