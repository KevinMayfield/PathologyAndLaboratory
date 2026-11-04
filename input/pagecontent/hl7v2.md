<div class="alert alert-danger" role="alert">
<b>Draft.</b> This implementation guide is a draft for discussion. It is <b>not</b> an
authoritative source and is not endorsed by NHS England, IHE or HL7. Check the cited
sources before using it for implementation.
</div>

This page defines the HL7 v2.5.1 segments used by the [LAB transactions](PaLM.html#transactions-used-in-this-guide),
localised for England. Each field lists its FHIR equivalent; the element-level
mappings are also on each profile's **Mappings** tab (*HL7 v2.5.1 (England PaLM)*).

### Conventions

- **Version** - HL7 v2.5.1. Messages **SHALL** follow the HL7 v2.5.1 standard; deprecated
  (`B`) fields **SHOULD NOT** be used where a 2.5.1 replacement exists (for example use
  SPM, not OBR-15; TQ1, not ORC-7 / OBR-27).
- **Optionality** - `R` required, `RE` required if known (send it if you have it),
  `C` conditional, `O` optional, `X` not used. This guide's optionality is for England
  and may be tighter than the HL7 base.
- **Sources** - the field rules follow the
  [Digital Health and Care Wales HL7 ORU_R01 2.5.1 IG](https://nw-gmsa.github.io/DHCW-HL7-v2-5-1-ORUR01-Specification.pdf)
  (DHCW) and the [NW GMSA HL7 v2 standards](https://nw-gmsa.github.io/en/hl7v2.html), with
  English identifiers in place of NHS Wales OIDs.
- **Escape characters** - `\F\` `\S\` `\T\` `\R\` `\E\` and `\.br\` (new line) **SHALL** be
  supported. HL7 null `""` means *delete this value*.
- **Codes** - every coded field (`CWE` / `CE`) **SHALL** have a code, display text and
  coding system (CWE-1, CWE-2, CWE-3). Local codes **SHALL** use coding system `L` (or a
  registered local system name) and **SHOULD** also carry a national code in CWE-4 to
  CWE-6 - see [Terminology](terminology.html#coding-systems-in-hl7-v2).
- **Transport** - MLLP over TLS within a network, or HTTPS (agreed per interface).

### MSH

Message Header. MSH **SHALL NOT** be used to derive patient, clinician or patient
identifier information (for example the assigning authority of PID-3).

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| MSH-1 | Field Separator | ST | R | &#124; | | - |
| MSH-2 | Encoding Characters | ST | R | `^~\&` | | - |
| MSH-3 | Sending Application | HD | R | `LIMS` | Agreed per interface | `MessageHeader.source.name` |
| MSH-4 | Sending Facility | HD | R | `R0A` | ODS code of the sending organisation | `MessageHeader.sender.identifier` |
| MSH-5 | Receiving Application | HD | R | `GPSYSTEM` | | `MessageHeader.destination.name` |
| MSH-6 | Receiving Facility | HD | R | `A12345` | ODS code of the receiving organisation | `MessageHeader.destination.receiver.identifier` |
| MSH-7 | Date/Time of Message | TS | R | `20261103160530` | Time of sending, not a clinical time | `Bundle.timestamp` |
| MSH-9 | Message Type | MSG | R | `ORU^R01^ORU_R01` | | `MessageHeader.eventCoding` (MSH-9.2) |
| MSH-10 | Message Control ID | ST | R | `LIMS-MSG-000987` | Unique per message (up to 20 characters) | `Bundle.identifier` |
| MSH-11 | Processing ID | PT | R | `P` | P production, T training, D debugging | - (environment) |
| MSH-12 | Version ID | VID | R | `2.5.1` | | - |
| MSH-15 | Accept Acknowledgment Type | ID | R | `AL` | `AL` - always acknowledge | `MessageDefinition.responseRequired` = `always` |
{:.grid}

### PID

Patient Identification.

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| PID-1 | Set ID | SI | O | `1` | | - |
| PID-3 | Patient Identifier List | [CX](#cx) | R | `633^^^R0A^MR~9449305552^^^NHS^NH` | NHS Number with CX-4 `NHS`, CX-5 `NH`. Local identifiers with CX-4 the ODS code of the assigning trust and CX-5 `MR`. Identifiers without an assigning authority **SHALL NOT** be sent. Only verified identifiers | `Patient.identifier` |
| PID-5 | Patient Name | XPN | R | `CHISLETT^Octavia^^^Miss` | Family and given name required | `Patient.name` |
| PID-7 | Date/Time of Birth | TS | R | `20080920` | | `Patient.birthDate` |
| PID-8 | Administrative Sex | IS | R | `F` | Table 0001 | `Patient.gender` - [ConceptMap](ConceptMap-v2-0001-to-administrative-gender.html) |
| PID-11 | Patient Address | XAD | RE | `1 RAVENSFIELD GARDENS^^EPSOM^SURREY^KT19 0ST` | First repeat is the home address | `Patient.address` |
| PID-13 | Phone Number - Home | XTN | O | `07700900123^PRN^CP` | XTN-2 and XTN-3 required on each repeat | `Patient.telecom` |
| PID-29 | Patient Death Date and Time | TS | O | | | `Patient.deceasedDateTime` |
| PID-32 | Identity Reliability Code | IS | RE | `01` | NHS Number verification status (`01` present and verified ... `08` trace postponed) | NHS Number verification status extension (UK Core) - not profiled here (**Open**) |
{:.grid}

### PV1

Patient Visit. Used to identify where the report goes and who requested it.

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| PV1-1 | Set ID | SI | O | `1` | | - |
| PV1-2 | Patient Class | IS | R | `O` | Table 0004 (`I`, `O`, `E`, `N` not applicable) | `Encounter.class` |
| PV1-3 | Assigned Patient Location | PL | R | `^^^^^^^^Example Surgery^A12345` | The requesting location - GP practice (ODS code) or ward / clinic. PL-9 description, PL-10 identifier | `ServiceRequest.requester` (Organization) or `Encounter.location` |
| PV1-8 | Referring Doctor | [XCN](#xcn) | R | `G1234567^GREEN^Alex^^^Dr^^^GMP^^^^DN` | The responsible clinician the report returns to | `ServiceRequest.requester` (PractitionerRole) |
| PV1-19 | Visit Number | CX | RE | | | `Encounter.identifier`, `DiagnosticReport.encounter.identifier` |
{:.grid}

### ORC

Common Order. **SHALL** be sent in OML_O21. In ORU_R01 it **SHOULD** be sent where there
was an electronic order.

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| ORC-1 | Order Control | ID | R | `NW` | Table 0119 | `ServiceRequest.status` - [ConceptMap](ConceptMap-v2-0119-to-request-status.html) |
| ORC-2 | Placer Order Number | [EI](#ei) | C | `GP-ORD-000123^GPSYSTEM` | Required for electronic orders | `ServiceRequest.identifier` (`PLAC`) |
| ORC-3 | Filler Order Number | [EI](#ei) | C | `26H012345^LIMS` | Required from the Order Filler | `ServiceRequest.identifier` (`FILL`) |
| ORC-4 | Placer Group Number | EI | RE | `GP-REQ-000045^GPSYSTEM` | All orders on one request | `ServiceRequest.requisition` |
| ORC-5 | Order Status | ID | O | `CM` | Table 0038 | `ServiceRequest.status` |
| ORC-8 | Parent | EIP | C | | Required for sub-orders [LAB-35] | `ServiceRequest.basedOn` |
| ORC-9 | Date/Time of Transaction | TS | R | `20261103091000` | When the order was placed | `ServiceRequest.authoredOn` |
| ORC-10 | Entered By | XCN | O | | The user who entered the order, not the clinician | `Provenance.agent` - not mapped |
| ORC-12 | Ordering Provider | [XCN](#xcn) | R | `G1234567^GREEN^Alex^^^Dr^^^GMP^^^^DN` | Same as OBR-16 | `ServiceRequest.requester` → PractitionerRole.practitioner |
| ORC-16 | Order Control Code Reason | CWE | O | | Reason for a cancellation | `ServiceRequest.note` (**Open**) |
| ORC-21 | Ordering Facility Name | [XON](#xon) | RE | `Example Surgery^^^^^^^^^A12345` | XON-10 the ODS code | `ServiceRequest.requester` → PractitionerRole.organization |
{:.grid}

### TQ1

Timing/Quantity. Send only for a non-routine priority (no TQ1 means routine).

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| TQ1-7 | Start Date/Time | TS | O | | Earliest time to perform | `ServiceRequest.occurrencePeriod.start` |
| TQ1-9 | Priority | CWE | R | `S^Stat^HL70485` | Table 0485 | `ServiceRequest.priority` - [ConceptMap](ConceptMap-v2-0485-to-request-priority.html) |
{:.grid}

### OBR

Observation Request. In OML_O21 it is the requested test; in ORU_R01 it is the report
header, populated by the Order Filler.

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| OBR-1 | Set ID | SI | R | `1` | | - |
| OBR-2 | Placer Order Number | [EI](#ei) | C | `GP-ORD-000123^GPSYSTEM` | Same as ORC-2. Required if the order was electronic | `ServiceRequest.identifier` (`PLAC`); `DiagnosticReport.basedOn` |
| OBR-3 | Filler Order Number | [EI](#ei) | C | `26H012345^LIMS` | Required in ORU_R01. The laboratory (report) number users quote - the same on every OBR of one report | `DiagnosticReport.identifier` |
| OBR-4 | Universal Service Identifier | CWE | R | `1022441000000101^FBC - full blood count^SCT` | The test group or test: SNOMED CT UK (PaLM) code, or the laboratory's code with the national code as the alternate | `ServiceRequest.code`; the test group `Observation.code` |
| OBR-7 | Observation Date/Time | TS | C | `20261103091500` | Required in ORU_R01 - the specimen collection time | `DiagnosticReport.effectiveDateTime` |
| OBR-13 | Relevant Clinical Information | ST | O | | Prefer NTE | `ServiceRequest.note` |
| OBR-16 | Ordering Provider | [XCN](#xcn) | R | `G1234567^GREEN^Alex^^^Dr^^^GMP^^^^DN` | Same as ORC-12 | `ServiceRequest.requester` |
| OBR-22 | Results Rpt/Status Chng - Date/Time | TS | C | `20261103160500` | Required in ORU_R01 - when the report was released. Used for alerts downstream | `DiagnosticReport.issued` |
| OBR-24 | Diagnostic Serv Sect ID | ID | RE | `HM` | Table 0074 (`CH`, `HM`, `MB`, `IMM`, `BLB`, `SR`, `VR`, ...) | `DiagnosticReport.category` |
| OBR-25 | Result Status | ID | C | `F` | Required in ORU_R01. Table 0123 | `DiagnosticReport.status` - [ConceptMap](ConceptMap-v2-0123-to-diagnostic-report-status.html) |
| OBR-29 | Parent | EIP | C | | Required for sub-order results [LAB-36] | `ServiceRequest.basedOn` |
| OBR-31 | Reason for Study | CWE | O | `^Tiredness` | | `ServiceRequest.reasonCode` |
| OBR-32 | Principal Result Interpreter | NDL | RE | `7654321&HUGHES&Sam&&&Dr&&&GMC` | The authorising clinician | `DiagnosticReport.resultsInterpreter` |
{:.grid}

### NTE

Notes and Comments. Position gives the meaning: after PID - patient comments; after
OBR - order or report comments; after OBX - result comments.

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| NTE-1 | Set ID | SI | O | `1` | | - |
| NTE-2 | Source of Comment | ID | RE | `L` | `L` filler (laboratory), `P` placer (for example clinical details), `O` other. Default `L` | Annotation author |
| NTE-3 | Comment | FT | R | `Mild anaemia ...` | One NTE per paragraph; `\.br\` for line breaks | `ServiceRequest.note` (after OBR in OML), `DiagnosticReport.conclusion` (after OBR in ORU), `Observation.note` (after OBX) |
| NTE-4 | Comment Type | CWE | O | `RE` | Table 0364 | - |
{:.grid}

### DG1

Diagnosis (OML_O21 only).

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| DG1-3 | Diagnosis Code | CWE | R | | SNOMED CT or ICD-10 | `ServiceRequest.reasonCode` |
{:.grid}

### OBX

Observation / Result.

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| OBX-1 | Set ID | SI | R | `1` | Starts at 1 for each OBR | - |
| OBX-2 | Value Type | ID | C | `NM` | Table 0125 - see [OBX-2 Value Type](mapping.html#obx-2-value-type) | type of `Observation.value[x]` |
| OBX-3 | Observation Identifier | CWE | R | `1022431000000105^Haemoglobin estimation^SCT^718-7^Hemoglobin [Mass/volume] in Blood^LN` | SNOMED CT UK (PaLM) observable entity; LOINC as the alternate code where known; local code with `L` only if there is no national code | `Observation.code` |
| OBX-4 | Observation Sub-ID | ST | C | | Groups related OBX (for example an organism and its sensitivities) | `Observation.hasMember` |
| OBX-5 | Observation Value | varies | C | `112` | Typed by OBX-2. Empty only with OBX-11 = `X`, `N`, `D` or `I` | `Observation.value[x]` |
| OBX-6 | Units | CWE | C | `g/L^^UCUM` | Required for `NM` and `SN`. UCUM code in CWE-1 | `valueQuantity.unit`, `.system`, `.code` |
| OBX-7 | References Range | ST | RE | `115-165` | `low-high`, `>low` or `<high` | `Observation.referenceRange` |
| OBX-8 | Abnormal Flags | IS | RE | `L` | Table 0078 | `Observation.interpretation` - [ConceptMap](ConceptMap-v2-0078-to-observation-interpretation.html) |
| OBX-11 | Observation Result Status | ID | R | `F` | Table 0085 | `Observation.status` - [ConceptMap](ConceptMap-v2-0085-to-observation-status.html) |
| OBX-14 | Date/Time of the Observation | TS | RE | `20261103091500` | Clinically relevant time (specimen collection) if different OBX have different times; otherwise OBR-7 | `Observation.effectiveDateTime` |
| OBX-16 | Responsible Observer | XCN | O | | | `Observation.performer` |
| OBX-17 | Observation Method | CWE | O | | | `Observation.method` |
| OBX-18 | Equipment Instance Identifier | EI | O | | Analyser | `Observation.device` |
| OBX-19 | Date/Time of the Analysis | TS | O | | | `Observation.issued` (**Open**) |
| OBX-23 | Performing Organization Name | [XON](#xon) | RE | `Manchester University NHS Foundation Trust^^^^^^^^^R0A` | XON-10 ODS code. **SHALL** be sent for subcontracted results | `Observation.performer` (Organization) |
{:.grid}

#### OBX Type ED (Embedded Documents)

A report PDF is sent as an OBX of type `ED`, OBX-5 = `^application^pdf^Base64^<data>`
(ED-2 type of data, ED-3 data subtype, ED-4 encoding, ED-5 data). Where the data is
too large for one field (DHCW limit 32K), it is split across consecutive `ED` OBX with
the same OBX-3, and the receiver joins them. For large documents an OBX of type `RP`
(reference pointer, a URL) **MAY** be used instead, by agreement. FHIR:
`DiagnosticReport.presentedForm` - see [Mapping](mapping.html#embedded-documents).

### SPM

Specimen. **SHOULD** be sent wherever a specimen was tested.

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| SPM-1 | Set ID | SI | O | `1` | | - |
| SPM-2 | Specimen ID | EIP | RE | `GP-SPC-000123&GPSYSTEM^26H012345&LIMS` | EIP-1 placer (label) number, EIP-2 filler (accession) number | `Specimen.identifier` (`PLAC`), `Specimen.accessionIdentifier` |
| SPM-3 | Specimen Parent IDs | EIP | C | | For aliquots | `Specimen.parent` |
| SPM-4 | Specimen Type | CWE | R | `119297000^Blood specimen^SCT` | SNOMED CT specimen | `Specimen.type` |
| SPM-7 | Specimen Collection Method | CWE | O | | | `Specimen.collection.method` |
| SPM-8 | Specimen Source Site | CWE | O | | SNOMED CT body structure | `Specimen.collection.bodySite` |
| SPM-14 | Specimen Description | ST | O | | | `Specimen.note` |
| SPM-17 | Specimen Collection Date/Time | DR | R | `20261103091500` | | `Specimen.collection.collectedDateTime` (or `collectedPeriod`) |
| SPM-18 | Specimen Received Date/Time | TS | RE | `20261103134000` | Required in ORU_R01 | `Specimen.receivedTime` |
| SPM-21 | Specimen Reject Reason | CWE | C | | When the specimen was rejected | `Specimen.condition` / `Specimen.status` = `unsatisfactory` |
| SPM-27 | Container Type | CWE | O | | | `Specimen.container.type` |
{:.grid}

### MSA

Message Acknowledgment (`ACK`, `ORL`).

| Field | Name | DT | Opt | Example | England rule | FHIR |
|---|---|---|---|---|---|---|
| MSA-1 | Acknowledgment Code | ID | R | `AA` | `AA` accept, `AE` error (resend after an agreed period), `AR` reject (do not resend) | `MessageHeader.response.code`: `ok`, `transient-error`, `fatal-error` |
| MSA-2 | Message Control ID | ST | R | `LIMS-MSG-000987` | MSH-10 of the message being acknowledged | `MessageHeader.response.identifier` |
| MSA-3 | Text Message | ST | O | | | `MessageHeader.response.details` → OperationOutcome |
{:.grid}

### Data Types

#### CX

Extended Composite ID - patient identifiers.

| Component | Name | England rule | FHIR Identifier |
|---|---|---|---|
| CX-1 | ID Number | | `value` |
| CX-4 | Assigning Authority | `NHS` for the NHS Number; the trust ODS code for a hospital number | `system` (NHS Number: `https://fhir.nhs.uk/Id/nhs-number`), `assigner.identifier` (ODS) |
| CX-5 | Identifier Type Code | Table 0203: `NH` NHS Number, `MR` medical record number, `PI` patient internal identifier | `type` |
{:.grid}

#### EI

Entity Identifier - order numbers.

| Component | Name | England rule | FHIR Identifier |
|---|---|---|---|
| EI-1 | Entity Identifier | | `value` |
| EI-2 | Namespace ID | The assigning organisation (ODS code) or application | `assigner.identifier` (ODS); and `system` through an agreed table |
| EI-3 / EI-4 | Universal ID / Type | **Not used** - the FHIR `Identifier.system` URI is not known to the LIMS at this stage of the pipeline; the receiver assigns it | - |
{:.grid}

#### XCN

Extended Composite ID Number and Name for Persons - clinicians.

| Component | Name | England rule | FHIR |
|---|---|---|---|
| XCN-1 | ID Number | Professional registration number | `Practitioner.identifier.value` |
| XCN-2 / XCN-3 | Family Name / Given Name | | `Practitioner.name` |
| XCN-6 | Prefix | | `Practitioner.name.prefix` |
| XCN-9 | Assigning Authority | `GMC`, `NMC`, `HCPC`, `GPHC`, `GMP` (GP national code); `L` for local codes | `Practitioner.identifier.system` - see [Terminology](terminology.html#identifier-systems) |
| XCN-13 | Identifier Type Code | `DN` doctor number, `NP` nurse practitioner, `RN` registered nurse | - |
{:.grid}

#### XON

Extended Composite Name and ID for Organizations.

| Component | Name | England rule | FHIR |
|---|---|---|---|
| XON-1 | Organization Name | | `Organization.name` |
| XON-10 | Organization Identifier | ODS code | `Organization.identifier` (`https://fhir.nhs.uk/Id/ods-organization-code`) |
{:.grid}
