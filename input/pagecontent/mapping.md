<div class="alert alert-danger" role="alert">
<b>Draft.</b> This implementation guide is a draft for discussion. It is <b>not</b> an
authoritative source and is not endorsed by NHS England, IHE or HL7. Check the cited
sources before using it for implementation.
</div>

This page describes how to convert between the HL7 v2.5.1 messages and the FHIR R4
resources in this guide, in both directions. It follows the
[HL7 Version 2 to FHIR](https://build.fhir.org/ig/HL7/v2-to-fhir/) IG (message, segment,
data type and vocabulary maps) and adds the England rules. The mappings are
**indicative**: test them against your own interfaces.

There are four levels:

1. [Message](#message-level) - which FHIR container and which resources
2. [Segment and field](#segment-and-field-level) - which element each field goes to
3. [Data type](#data-type-level) - how each HL7 v2 data type becomes a FHIR data type
4. [Vocabulary](#vocabulary-level) - how HL7 v2 table codes become FHIR codes

### Message Level

| HL7 v2.5.1 | FHIR container | MessageHeader.eventCoding | Focus | HL7 v2-to-FHIR |
|---|---|---|---|---|
| `OML^O21^OML_O21` | [Bundle Message](StructureDefinition-BundleMessage.html), [Laboratory Order (O21)](MessageDefinition-laboratory-order.html) | v2-0003 `O21` | ServiceRequest | [OML_O21 to Bundle](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-message-oml-o21-to-bundle.html) |
| `ORL^O22^ORL_O22` | Bundle Message (response) | v2-0003 `O21` | - | - |
| `ORU^R01^ORU_R01` | [Bundle Message](StructureDefinition-BundleMessage.html), [Laboratory Result (R01)](MessageDefinition-laboratory-result.html) | v2-0003 `R01` | DiagnosticReport | [ORU_R01 to Bundle](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-message-oru-r01-to-bundle.html) |
| `ORU^R01^ORU_R01` (to NHS England) | [Bundle - Laboratory Report Document](StructureDefinition-BundleLaboratoryReportDocument.html) | - | Composition | see [FHIR Message to FHIR Document](#fhir-message-to-fhir-document) |
| `ACK^R01^ACK` | Bundle Message (response) | v2-0003 `R01` | - | - |
{:.grid}

The Bundle `identifier` is MSH-10 and `timestamp` is MSH-7. Each HL7 v2 message becomes
**one** FHIR Message; resources referenced from several segments (the Patient, the
requesting clinician, the laboratory) appear once in the Bundle.

### Segment and Field Level

| Segment | FHIR resource | Profile | HL7 v2-to-FHIR |
|---|---|---|---|
| MSH | MessageHeader, Bundle | [MessageHeader](StructureDefinition-MessageHeader.html) | [MSH to MessageHeader](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-msh-to-messageheader.html) |
| PID | Patient | [Patient](StructureDefinition-Patient.html) | [PID to Patient](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-pid-to-patient.html) |
| PV1 | Encounter, and the requester (PV1-3, PV1-8) | [PractitionerRole](StructureDefinition-PractitionerRole.html), [Organization](StructureDefinition-Organization.html) | [PV1 to Encounter](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-pv1-to-encounter.html) |
| ORC | ServiceRequest | [Laboratory Order](StructureDefinition-LaboratoryOrder.html) | [ORC to ServiceRequest](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-orc-to-servicerequest.html) |
| TQ1 | ServiceRequest.priority, occurrence | [Laboratory Order](StructureDefinition-LaboratoryOrder.html) | [TQ1 to ServiceRequest](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-tq1-to-servicerequest.html) |
| OBR (OML) | ServiceRequest | [Laboratory Order](StructureDefinition-LaboratoryOrder.html) | [OBR to ServiceRequest](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-obr-to-servicerequest.html) |
| OBR (ORU) | DiagnosticReport (and the ServiceRequest it is basedOn) | [Laboratory Report](StructureDefinition-LaboratoryReport.html) | [OBR to DiagnosticReport](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-obr-to-diagnosticreport.html) |
| NTE | Annotation on the parent resource, or `DiagnosticReport.conclusion` | | [NTE to ServiceRequest](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-nte-to-servicerequest.html), [NTE to Observation](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-nte-to-observation.html) |
| DG1 | ServiceRequest.reasonCode (or Condition) | | [DG1 to Condition](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-dg1-to-condition.html) |
| OBX (results) | Observation | [Laboratory Result](StructureDefinition-LaboratoryResult.html) | [OBX to Observation](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-obx-to-observation.html) |
| OBX (`ED`, `RP`) | DiagnosticReport.presentedForm (or DocumentReference + Binary) | [Laboratory Report](StructureDefinition-LaboratoryReport.html) | [OBX to DocumentReference](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-obx-to-documentreference.html) |
| SPM | Specimen | [Specimen](StructureDefinition-Specimen.html) | [SPM to Specimen](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-spm-to-specimen.html) |
| MSA | MessageHeader.response | [MessageHeader](StructureDefinition-MessageHeader.html) | [MSA to MessageHeader](https://build.fhir.org/ig/HL7/v2-to-fhir/ConceptMap-segment-msa-to-messageheader.html) |
{:.grid}

Field by field mappings are on [HL7 v2.5.1 Segments](hl7v2.html) (FHIR column) and on
each profile's **Mappings** tab.

#### Rules

- **One DiagnosticReport per OBR** (in ORU_R01). Each OBR's OBX become the
  `DiagnosticReport.result` Observations
- **One ServiceRequest per ORC/OBR pair**. In ORU_R01 the ServiceRequest carries the
  order identifiers (ORC-2, ORC-3, ORC-4) and the requester; `DiagnosticReport.basedOn`
  references it
- **Placer and filler numbers keep their meaning**. Do not copy ORC-3 into a `PLAC`
  identifier or ORC-2 into a `FILL` identifier
- **Fixed resource identity**. A corrected result (OBR-25 / OBX-11 = `C`) **SHALL**
  update the same DiagnosticReport and Observations. Use stable identifiers - the
  DiagnosticReport by OBR-3, each Observation by OBR-3 + OBX-3 (+ OBX-4) - and make the
  FHIR `id` deterministic from them, not from OBX-1, which can change between versions of
  a report
- **Report comments**. NTE after an OBR in ORU_R01 become `DiagnosticReport.conclusion`
  (several NTE are joined with new lines); NTE after an OBX become `Observation.note`
- **Text-only reports**. Where a laboratory sends the whole report as OBX of type `TX` /
  `FT` (one line per OBX, as in many microbiology reports), join them into
  `DiagnosticReport.presentedForm` (`text/plain`) or `conclusion` rather than one
  Observation per line
- **MSH is not clinical**. Do not derive the patient's assigning authority, the
  requester or the performer from MSH-4 / MSH-6 alone

#### OBX-2 Value Type

| OBX-2 | Meaning | FHIR `Observation.value[x]` | Notes |
|---|---|---|---|
| `NM` | Numeric | `valueQuantity` | `value` = OBX-5, units from OBX-6 (UCUM `system` `http://unitsofmeasure.org`) |
| `SN` | Structured numeric | `valueQuantity` with `comparator` (`<^10`), or `valueRange` (`^10^-^20`), or `valueRatio` (`^1^:^128`) | `<` `<=` `>` `>=` go in `Quantity.comparator` |
| `CWE` / `CE` | Coded | `valueCodeableConcept` | For example organism or `Positive` / `Negative` (SNOMED CT) |
| `ST` | String | `valueString` | |
| `TX` / `FT` | Text / formatted text | `valueString` (or `DiagnosticReport.presentedForm` - see Rules) | `\.br\` becomes a new line |
| `DT` | Date | `valueDateTime` | |
| `TS` / `DTM` | Date and time | `valueDateTime` | |
| `TM` | Time | `valueTime` | |
| `ED` | Encapsulated data | not an Observation - see [Embedded Documents](#embedded-documents) | |
| `RP` | Reference pointer | not an Observation - see [Embedded Documents](#embedded-documents) | |
{:.grid}

An empty OBX-5 with OBX-11 = `X` (cannot be obtained) or `N` (not asked) becomes an
Observation with no value and `dataAbsentReason` (`error` / `not-asked`).

#### Reference Ranges

OBX-7 is a string. Parse the common forms; otherwise keep the text.

| OBX-7 | `Observation.referenceRange` |
|---|---|
| `115-165` | `low` 115, `high` 165 (units from OBX-6) |
| `<48` | `high` 48 (**Open** - `<` vs `<=`; EU Laboratory has `highComparator` modifier extensions) |
| `>4.0` | `low` 4.0 (as above) |
| anything else | `text` |
{:.grid}

#### Embedded Documents

| OBX field | FHIR |
|---|---|
| OBX-2 `ED` | `DiagnosticReport.presentedForm` (`Attachment`) |
| OBX-5 ED-2 / ED-3 (for example `application` / `pdf`) | `presentedForm.contentType` = `application/pdf` |
| OBX-5 ED-5 (Base64) | `presentedForm.data`, or a Binary referenced by `presentedForm.url` (NW GMSA convention - prefer the url) |
| OBX-2 `RP`, OBX-5 URL | `presentedForm.url` |
| OBX-3 | `presentedForm.title` (display text) |
{:.grid}

Join split `ED` OBX (same OBX-3, consecutive) before decoding.

### Data Type Level

| HL7 v2 | FHIR | Notes |
|---|---|---|
| CX | Identifier | [CX](hl7v2.html#cx). CX-4 `NHS` → `system` `https://fhir.nhs.uk/Id/nhs-number`; CX-5 → `type` (v2-0203) |
| EI | Identifier | [EI](hl7v2.html#ei). EI-2 → `system` (one URI per assigning application, agreed per interface) |
| XCN | Reference(Practitioner) / PractitionerRole | [XCN](hl7v2.html#xcn). XCN-9 → `identifier.system` |
| XON | Reference(Organization) | [XON](hl7v2.html#xon). XON-10 → ODS `identifier` |
| XPN | HumanName | |
| XAD | Address | XAD-5 → `postalCode` |
| XTN | ContactPoint | XTN-2 → `use`, XTN-3 → `system` |
| CWE / CE / CNE | CodeableConcept / Coding | CWE-1/2/3 and CWE-4/5/6 → two `coding`; CWE-3 → `system` - see [Terminology](terminology.html#coding-systems-in-hl7-v2); CWE-9 → `text` |
| TS / DTM | dateTime / instant | `YYYYMMDDHHMMSS[+ZZZZ]` → `YYYY-MM-DDThh:mm:ss+zz:zz`. With no time zone, assume UK local time (Europe/London) |
| DR | Period | SPM-17 |
| NM + CWE (OBX-5 + OBX-6) | Quantity | |
| SN | Quantity / Range / Ratio | see OBX-2 |
| ED | Attachment | |
{:.grid}

### Vocabulary Level

The HL7 v2 tables that change meaning between HL7 v2 and FHIR are mapped by
ConceptMaps in this guide:

| HL7 v2 table | Field | FHIR element | ConceptMap |
|---|---|---|---|
| 0001 Administrative Sex | PID-8 | `Patient.gender` | [v2-0001-to-administrative-gender](ConceptMap-v2-0001-to-administrative-gender.html) |
| 0119 Order Control | ORC-1 | `ServiceRequest.status` | [v2-0119-to-request-status](ConceptMap-v2-0119-to-request-status.html) |
| 0485 Extended Priority | TQ1-9 | `ServiceRequest.priority` | [v2-0485-to-request-priority](ConceptMap-v2-0485-to-request-priority.html) |
| 0123 Result Status | OBR-25 | `DiagnosticReport.status` | [v2-0123-to-diagnostic-report-status](ConceptMap-v2-0123-to-diagnostic-report-status.html) |
| 0085 Observation Result Status | OBX-11 | `Observation.status` | [v2-0085-to-observation-status](ConceptMap-v2-0085-to-observation-status.html) |
| 0078 Interpretation Codes | OBX-8 | `Observation.interpretation` | [v2-0078-to-observation-interpretation](ConceptMap-v2-0078-to-observation-interpretation.html) |
{:.grid}

Tables used as-is (the FHIR code system is the HL7 v2 table): 0203 Identifier Type
(`Identifier.type`), 0074 Diagnostic Service Section ID (`DiagnosticReport.category`),
0003 Event Type (`MessageHeader.eventCoding`).

### FHIR to HL7 v2

The same tables read right to left. Points to watch:

- **Several FHIR codes map to one v2 code, or none**. Use the ConceptMap rows with
  `equivalence` `equivalent` first; `registered` → OBR-25 `I` (not `O`), `partial` → `A`,
  `preliminary` → `P`, `amended` → `C`, `entered-in-error` → OBX-11 `W`
- **One DiagnosticReport → one OBR** with its `result` Observations as OBX in order;
  OBX-1 numbered from 1 for each OBR
- **Identifiers**. `ServiceRequest.identifier` (`PLAC`) → ORC-2 / OBR-2, (`FILL`) → ORC-3 /
  OBR-3; `Patient.identifier` → PID-3 repeats; an NHS Number **SHALL** be sent as
  `<number>^^^NHS^NH`
- **Codes**. First `coding` (SNOMED CT) → CWE-1/2/3, second (LOINC) → CWE-4/5/6
- **Quantity with comparator** → OBX-2 `SN`, otherwise `NM`; `valueString` → `ST`
  (or `TX` / `FT` for multi-line text); `valueCodeableConcept` → `CWE`
- **presentedForm** (PDF) → an OBX of type `ED`, split into chunks if the receiver
  requires it
- **MessageHeader** → MSH: `sender` / `destination.receiver` ODS codes → MSH-4 / MSH-6,
  `source.name` / `destination.name` → MSH-3 / MSH-5, `Bundle.identifier` → MSH-10

### FHIR Message to FHIR Document

The [NHS England Pathology Laboratory Reporting API](PathologyReportingAPI.html) needs a
FHIR Document. From a [Laboratory Result (R01)](MessageDefinition-laboratory-result.html)
message (or directly from an ORU_R01), for **each** DiagnosticReport:

1. Create a [Laboratory Report Composition](StructureDefinition-LaboratoryReportComposition.html):
   `subject` = the Patient, with `subject.identifier` = the NHS Number; `identifier` =
   the DiagnosticReport's Filler Order Number (OBR-3); `type` LOINC `11502-2` Laboratory
   report **and** the DiagnosticReport's code (OBR-4) - HL7 Europe requires the
   Composition and DiagnosticReport to share an identifier and a code; `date` = `DiagnosticReport.issued`; `author` and
   `custodian` = the performing laboratory; one `section` with a narrative and an entry
   for the DiagnosticReport (its code from OBR-24, for example LOINC `18723-7` Hematology
   studies for `HM`)
2. Link the DiagnosticReport to the Composition with the R5 `DiagnosticReport.composition`
   extension (HL7 Europe DiagnosticReport-eu-lab)
3. Add a [Laboratory Report Provenance](StructureDefinition-LaboratoryReportProvenance.html)
   targeting the Composition, naming the sending product
4. Put the Composition first, then the DiagnosticReport and every resource it references
   (Patient, ServiceRequest, PractitionerRole, Practitioner, Organization, Specimen,
   Observations) and the Provenance, in a Bundle of `type` `document` with a new
   `identifier` and `timestamp`
5. Drop the MessageHeader

### Worked Example

The [LAB-3 example](LAB-3.html#example) `ORU^R01` and its FHIR equivalents:

| HL7 v2 | FHIR Message | FHIR Document |
|---|---|---|
| MSH | [MessageHeader](Bundle-LaboratoryResultMessage.html) (inline) | - |
| PID | [Patient](Patient-PatientOctaviaCHISLETT.html) | the same Patient |
| PV1-3, PV1-8, ORC-12, ORC-21 | [PractitionerRole](PractitionerRole-PractitionerRoleGP.html), [Practitioner](Practitioner-PractitionerGP.html), [Organization](Organization-OrganizationExampleSurgery.html) | the same |
| ORC | [Laboratory Order](ServiceRequest-LaboratoryOrderFBC.html) | the same |
| OBR, NTE | [Laboratory Report](DiagnosticReport-LaboratoryReportFBC.html) | the same report, plus the Composition link |
| OBR-32 | [PractitionerRole](PractitionerRole-PractitionerRoleHaematologist.html) | the same |
| OBX-1 to OBX-7 | [White cell count](Observation-ResultFBCWhiteCellCount.html), [Haemoglobin](Observation-ResultFBCHaemoglobin.html), [Platelets](Observation-ResultFBCPlateletCount.html), [Red cell count](Observation-ResultFBCRedCellCount.html), [Haematocrit](Observation-ResultFBCHaematocrit.html), [MCV](Observation-ResultFBCMeanCellVolume.html), [MCH](Observation-ResultFBCMeanCellHaemoglobin.html) | the same |
| OBX-23 | [Organization - MFT](Organization-OrganizationMFT.html) | the same |
| SPM | [Specimen](Specimen-SpecimenFBC.html) | the same |
| - | - | Composition, Provenance |
{:.grid}

Bundles: [FHIR Message](Bundle-LaboratoryResultMessage.html) and
[FHIR Document](Bundle-LaboratoryReportDocumentFBC.html).

For one result, OBX-2:

```
OBX|2|NM|1022431000000105^Haemoglobin estimation^SCT^718-7^Hemoglobin [Mass/volume] in Blood^LN||112|g/L^^UCUM|115-165|L|||F|||20261103091500|||||||||Manchester University NHS Foundation Trust^^^^^^^^^R0A
```

| Field | Value | FHIR ([Observation](Observation-ResultFBCHaemoglobin.html)) |
|---|---|---|
| OBX-2 | `NM` | `valueQuantity` |
| OBX-3 | `1022431000000105^Haemoglobin estimation^SCT^718-7^...^LN` | `code.coding[0]` = SNOMED CT 1022431000000105, `code.coding[1]` = LOINC 718-7 |
| OBX-5, OBX-6 | `112`, `g/L^^UCUM` | `valueQuantity` = 112 `g/L` (UCUM) |
| OBX-7 | `115-165` | `referenceRange.low` 115 g/L, `high` 165 g/L |
| OBX-8 | `L` | `interpretation` = v3-ObservationInterpretation `L` |
| OBX-11 | `F` | `status` = `final` |
| OBX-14 | `20261103091500` | `effectiveDateTime` = 2026-11-03T09:15:00Z |
| OBX-23 | `...^R0A` | `performer` = Organization R0A |
| OBR-22 | `20261103160500` | `issued` |
| OBR-2, SPM | | `basedOn`, `specimen` |
{:.grid}
