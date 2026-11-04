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
| To primary care - current | Results distribution middleware | GP clinical system | Pathology Messaging EDIFACT (MEDRPT) | Being replaced by the NHS England Pathology Laboratory Reporting API |
| To primary care - national FHIR | Laboratory middleware | NHS England Pathology Laboratory Reporting API → PDM → GP system | FHIR Document | See [NHS England Pathology Laboratory Reporting API](PathologyReportingAPI.html) |
| To other laboratories | LIMS | LIMS | HL7 v2 `ORU^R01` [LAB-36] | See [ILW](ILW.html) |
| To shared care records | LIMS or integration engine | Regional shared care record | HL7 v2 `ORU^R01` or FHIR | Often a copy of the LAB-3 feed |
{:.grid}

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
