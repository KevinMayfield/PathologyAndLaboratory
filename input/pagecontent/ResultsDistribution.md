<div class="alert alert-danger" role="alert">
<b>Draft.</b> This implementation guide is a draft for discussion. It is <b>not</b> an
authoritative source and is not endorsed by NHS England, IHE or HL7. Check the cited
sources before using it for implementation.
</div>

In IHE PaLM the Order Filler sends results to the Order Result Tracker
([LAB-3](LAB-3.html)). In England results usually reach more than one place: the
requesting clinician's system, the GP record, and regional and national shared
records. This page describes the routes.

### Routes

| Route | Sender | Receiver | Format | Notes |
|---|---|---|---|---|
| Within a trust | LIMS | Trust EPR | HL7 v2 `ORU^R01` [LAB-3] (or FHIR Message) | The most common interface |
| To GP order comms | LIMS, through the Trust Integration Engine (TIE) | GP order comms (the Order Placer the GP used) | HL7 v2 `ORU^R01` [LAB-3] | Order comms returns the results to the practice |
| To primary care - current | GP order comms or results distribution middleware | GP clinical system | Pathology Messaging EDIFACT (MEDRPT) | Being replaced by the NHS England Pathology Laboratory Reporting API |
| To primary care - national FHIR | GP order comms (the API's "laboratory middleware system") | NHS England Pathology Laboratory Reporting API → PDM → GP system | FHIR Document | See [NHS England Pathology Laboratory Reporting API](PathologyReportingAPI.html) |
| To other laboratories | LIMS | LIMS | HL7 v2 `ORU^R01` [LAB-36] | See [ILW](ILW.html) |
| To shared care records | LIMS or integration engine | Regional shared care record | HL7 v2 `ORU^R01`, PDF document (IHE XDS / MHD) or FHIR | Often a copy of the LAB-3 feed - see below |
{:.grid}

### Regional Shared Care Records

In the north of England laboratory results are likely to be shared through a **regional
shared care record**, rather than (or as well as) point to point. The technology differs by
region:

| Pattern | How results are shared | Notes |
|---|---|---|
| IHE XDS document sharing | The report as a **document** - often a PDF rendered by the LIMS or TIE - registered in an XDS registry/repository (IHE XD-LAB is the laboratory content profile) | Easy to add, but the results are not computable by the receiver. Prefer a structured document (the [FHIR Document](StructureDefinition-BundleLaboratoryReportDocument.html) of this guide, or CDA) alongside or instead of the PDF |
| Yorkshire and Humber Care Record (YHCR) | FHIR resources published by each organisation and queried across the region | Based on the [Interweave Implementation Guide](https://fhir.interweavedigital.com/index.html) (CareConnect / FHIR STU3, with R4 profiles including `Interweave-DiagnosticReport`) |
| Shared care record fed by HL7 v2 | A copy of the `ORU^R01` [LAB-3] feed from the TIE | The record vendor converts to its own model |
{:.grid}

For any of them the content **SHOULD** follow DAPB4101 (see
[IHE PaLM in England](PaLM.html#what-england-adds)), so that a result in the shared care
record is coded the same way as the one in the GP record. Where a PDF is shared it
**SHOULD** be the same report as the structured content, not a separately produced one.

### One Content, Several Containers

The same report is carried in different *containers* on different routes. The
content - Patient, order, specimen, report, results - is the same; this guide uses one
set of [FHIR profiles](DataModel.html) for all of them.

| Container | Use | FHIR | HL7 v2 |
|---|---|---|---|
| Message (event) | Point to point, an event the receiver acts on | [Bundle Message](StructureDefinition-BundleMessage.html) with the [Laboratory Result (R01)](MessageDefinition-laboratory-result.html) definition | `ORU^R01` |
| Document | A signed-off, shareable report stored and retrieved as a whole | [Bundle - Laboratory Report Document](StructureDefinition-BundleLaboratoryReportDocument.html) | `ORU^R01` with an `ED` (PDF) OBX, or `MDM^T02` |
| RESTful resources | Querying results (for example a shared care record) | DiagnosticReport and Observation (IHE QEDm) | - |
{:.grid}

The [mapping](mapping.html#fhir-message-to-fhir-document) page shows how to turn a
FHIR Message into a FHIR Document.

### Acknowledgements

Every route needs the sender to know the result arrived:

- HL7 v2 - `ACK^R01` with `MSA-1` = `AA` (accept), `AE` (error - resend after an agreed
  period) or `AR` (reject - do not resend; queue for support). Senders **SHOULD**
  request `MSH-15` = `AL` and send messages for a patient in order, moving on only
  after `AA` (as DHCW requires)
- FHIR Message - a response message, `MessageHeader.response.code` = `ok`,
  `transient-error` or `fatal-error`
- NHS England API - the GP system stores an acknowledgement in PDM, which the
  laboratory middleware retrieves (`GET /FHIR/R4/Bundle/{id}`)
