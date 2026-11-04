<div class="alert alert-danger" role="alert">
<b>Draft.</b> This implementation guide is a draft for discussion. It is <b>not</b> an
authoritative source and is not endorsed by NHS England, IHE or HL7. Check the cited
sources before using it for implementation.
</div>

The [IHE Pathology and Laboratory Medicine (PaLM) Technical Framework](https://www.ihe.net/resources/technical_frameworks/#PaLM)
defines **profiles** (Volume 1), the **transactions** they use (Volume 2) and
**content** (Volume 3) for laboratory and pathology workflows. IHE profiles are
international; a *national extension* or *localisation* says how they are used in
one country. This guide is a localisation for England.

### The IHE PaLM Profiles

| Profile | What it covers | In England | This guide |
|---|---|---|---|
| Laboratory Testing Workflow (LTW) | Ordering, scheduling and resulting of in vitro diagnostic tests between the clinical world and the laboratory | Order communications / EPR / GP system to LIMS, and LIMS results back. The core of this guide | [LTW](LTW.html) |
| Inter-Laboratory Workflow (ILW) | A laboratory sub-contracting tests to another laboratory | Pathology networks (hub and spoke) and referrals to specialist and reference laboratories | [ILW](ILW.html) |
| Laboratory Analytical Workflow (LAW) | LIMS / middleware to analyser work orders and results | Inside the laboratory - usually supplier middleware | Outline only |
| Laboratory Device Automation (LDA) | Pre- and post-analytical automation | Inside the laboratory | Outline only |
| Laboratory Barcode Labeling (LBL) | Specimen container labels | Order comms label printing (placer specimen numbers) | Outline only - see [Specimen](StructureDefinition-Specimen.html) identifiers |
| Laboratory Point Of Care Testing (LPOCT) | Point of care testing devices | POCT middleware to LIMS / EPR | Outline only |
| Laboratory Clinical Specimen Data (LCSD) | Clinical data needed by the laboratory to process specimens | Ask at order entry questions and clinical details | [LAB-1](LAB-1.html) (OBX and NTE following the OBR) |
| Sharing Laboratory Reports (XD-LAB) | Laboratory reports as shareable documents | Shared care records, the NHS England Pathology Laboratory Reporting API (FHIR Document) | [Results Distribution](ResultsDistribution.html), [Pathology Laboratory Reporting API](PathologyReportingAPI.html) |
| Anatomic Pathology Workflow (APW) and Structured Reports (APSR) | Cellular pathology ordering and structured reports | Cellular pathology LIMS, RCPath datasets, COSD | Out of scope - see [Cancer Pathology Report](https://kevinmayfield.github.io/CancerPathologyReport/) |
{:.grid}

### Transactions Used in This Guide

| Transaction | From | To | HL7 v2.5.1 | FHIR (this guide) |
|---|---|---|---|---|
| [Placer Order Management [LAB-1]](LAB-1.html) | Order Placer | Order Filler | `OML^O21` / `ORL^O22` | [Laboratory Order (O21)](MessageDefinition-laboratory-order.html) message |
| [Filler Order Management [LAB-2]](LAB-2.html) | Order Filler | Order Placer | `OML^O21` (SN, OC, SC) / `ORL^O22` | [Laboratory Order (O21)](MessageDefinition-laboratory-order.html) message |
| [Order Results Management [LAB-3]](LAB-3.html) | Order Filler | Order Result Tracker | `ORU^R01` / `ACK^R01` | [Laboratory Result (R01)](MessageDefinition-laboratory-result.html) message, or a [Laboratory Report Document](StructureDefinition-BundleLaboratoryReportDocument.html) |
| [Sub-order Management [LAB-35]](LAB-35.html) | Requester | Subcontractor | `OML^O21` / `ORL^O22` | [Laboratory Order (O21)](MessageDefinition-laboratory-order.html) message |
| [Sub-order Results Delivery [LAB-36]](LAB-36.html) | Subcontractor | Requester | `ORU^R01` / `ACK^R01` | [Laboratory Result (R01)](MessageDefinition-laboratory-result.html) message |
{:.grid}

<div class="alert alert-info" role="alert">
IHE PaLM LTW also allows <code>OUL^R22</code> (specimen-oriented results) for LAB-3.
NHS systems almost always use <code>ORU^R01</code>, which is also what the DHCW and
NW GMSA specifications use, so this guide uses <code>ORU^R01</code> only.
</div>

### What England Adds

The IHE profiles say *which* messages to send. A localisation also has to say how to
fill them in. For England this guide adds:

- **Identifiers** - NHS Number (`PID-3` with assigning authority `NHS` and type `NH`),
  ODS codes for organisations (`MSH-4`, `MSH-6`, `XON-10`), GMC / NMC / HCPC / GP
  (GMP) codes for clinicians (`XCN-1` with `XCN-9`), and placer / filler order and
  specimen numbers - see [HL7 v2.5.1 Segments](hl7v2.html) and
  [FHIR Resources](DataModel.html)
- **Terminology** - SNOMED CT UK Edition for tests and results (the PaLM codes used
  by DAPB4101), with LOINC as an optional second code, UCUM for units - see
  [Terminology](terminology.html)
- **National services** - the [NHS England Pathology Laboratory Reporting API](PathologyReportingAPI.html)
  (replacing Pathology Messaging EDIFACT to GP systems), Patient Data Manager and the
  Multicast Notification Service
- **FHIR** - the FHIR equivalent of each HL7 v2 message, built on
  [HL7 Europe Laboratory Report](https://hl7.eu/fhir/laboratory/) (as the NHS England
  Pathology FHIR IG is), and the [mapping](mapping.html) between them
