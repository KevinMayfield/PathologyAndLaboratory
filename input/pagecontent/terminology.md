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
| Test / panel ordered or reported | OBR-4 | `ServiceRequest.code`, `DiagnosticReport.code` | SNOMED CT procedure | Example: `26604007` Complete blood count. **To confirm** - the PaLM code set for requestable tests |
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
The NHS England <a href="https://digital.nhs.uk/data-and-information/information-standards/governance/latest-activity/standards-and-collections/dapb4101-pathology-and-laboratory-medicine-reporting-information-standard">DAPB4101</a>
standard defines the PaLM SNOMED CT codes and their use. Laboratories map their local test
codes to them (the PaLM mapping project). Where a local code has no PaLM code yet, send the
local code with coding system <code>L</code> and flag the gap.
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
