<div class="alert alert-danger" role="alert">
<b>Draft.</b> This implementation guide is a draft for discussion. It is <b>not</b> an
authoritative source and is not endorsed by NHS England, IHE or HL7. Check the cited
sources before using it for implementation.
</div>

### Aim

This guide is an **England Pathology and Laboratory Medicine (PaLM) Technical
Framework**. It takes the
[IHE Pathology and Laboratory Medicine (PaLM) Technical Framework](https://www.ihe.net/resources/technical_frameworks/#PaLM)
- its actors, workflows and transactions - and localises it for interoperability
in England:

- **HL7 v2.5.1** for the messages laboratories, order communications, EPRs and GP
  systems already exchange (`OML^O21`, `ORU^R01`, `ACK`), following the IHE PaLM
  transactions and the conventions of the
  [NW GMSA HL7 v2 standards](https://nw-gmsa.github.io/en/hl7v2.html) and the
  [Digital Health and Care Wales HL7 ORU_R01 2.5.1 Implementation Guide](https://nw-gmsa.github.io/DHCW-HL7-v2-5-1-ORUR01-Specification.pdf)
- **HL7 FHIR R4** for the same content, as FHIR Messages (the HL7 v2 equivalent) and
  FHIR Documents (the form used by the
  [NHS England Pathology and Laboratory Medicine Reporting FHIR API](https://digital.nhs.uk/developer/api-catalogue/pathology-laboratory-reporting))
- **how to map between the two**, so a trust, network or supplier can run HL7 v2 and
  FHIR side by side and convert between them

Like the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/), it supports both HL7 v2
and FHIR rather than choosing one.

### Scope

In scope:

- Laboratory orders and results for the specialisms covered by the NHS England
  Pathology and Laboratory Medicine Reporting standard
  ([DAPB4101](https://digital.nhs.uk/data-and-information/information-standards/governance/latest-activity/standards-and-collections/dapb4101-pathology-and-laboratory-medicine-reporting-information-standard)):
  clinical biochemistry, haematology, immunology, transfusion medicine and
  microbiology (bacteriology, virology and serology)
- Ordering and reporting within a trust (EPR / order communications to LIMS), to
  primary care (LIMS to GP system), and between laboratories (pathology networks and
  reference laboratories)

Out of scope (for now):

- Cellular pathology and genomics reports - see the
  [Cancer Pathology Report](https://kevinmayfield.github.io/CancerPathologyReport/)
  proof of concept and the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)
- Laboratory device automation (IHE LAW, LDA), labelling (LBL) and point of care
  testing (LPOCT) - outlined on [IHE PaLM in England](PaLM.html) only

### Content

**Analysis and Design (Volume 1)**

- [IHE PaLM in England](PaLM.html) - the IHE PaLM profiles and how they apply in England
- [Actors and Systems](actors.html) - IHE actors and the NHS systems that play them
- [Laboratory Testing Workflow (LTW)](LTW.html) - ordering and resulting within and
  between organisations
- [Inter-Laboratory Workflow (ILW)](ILW.html) - pathology networks and referral
  (reference) laboratories
- [Results Distribution in England](ResultsDistribution.html) - how results reach
  the requester, the GP record and shared care records

**Interactions (Volume 2)**

- [Placer Order Management [LAB-1]](LAB-1.html), [Filler Order Management [LAB-2]](LAB-2.html)
- [Order Results Management [LAB-3]](LAB-3.html)
- [Sub-order Management [LAB-35]](LAB-35.html), [Sub-order Results Delivery [LAB-36]](LAB-36.html)
- [NHS England Pathology Laboratory Reporting API](PathologyReportingAPI.html) - the
  national FHIR API, Patient Data Manager and the Multicast Notification Service event

**Data Models (Volume 3)**

- [FHIR Resources](DataModel.html) - the profiles and how they relate to HL7 Europe
  Laboratory, UK Core and the NHS England Pathology FHIR IG
- [Terminology](terminology.html) - SNOMED CT (PaLM), LOINC, UCUM and HL7 v2 tables

**HL7 v2 and Mapping (Volume 4)**

- [HL7 v2.5.1 Segments and Data Types](hl7v2.html) - the England localisation of
  MSH, PID, PV1, ORC, OBR, TQ1, NTE, OBX, SPM and MSA
- [Mapping HL7 v2 and FHIR](mapping.html) - message, segment, data type and
  vocabulary mappings in both directions

### Example

One scenario runs through the guide: a GP at Example Surgery (ODS `A12345`) requests
a **full blood count** for Octavia CHISLETT (NHS Number 9449305552) from the
Manchester University NHS Foundation Trust (ODS `R0A`) laboratory.

| Step | HL7 v2.5.1 | FHIR |
|---|---|---|
| Order [LAB-1] | `OML^O21` - see [LAB-1](LAB-1.html#example) | [Bundle Message - Laboratory Order (O21)](Bundle-LaboratoryOrderMessage.html) |
| Result [LAB-3] | `ORU^R01` - see [LAB-3](LAB-3.html#example) | [Bundle Message - Laboratory Result (R01)](Bundle-LaboratoryResultMessage.html) |
| Acknowledgement | `ACK^R01` | [Bundle Message - Acknowledgement](Bundle-LaboratoryResultAcknowledgement.html) |
| Result to the GP via NHS England | - | [Bundle Document - Full blood count](Bundle-LaboratoryReportDocumentFBC.html) |
{:.grid}

### Sources

- [IHE PaLM Technical Framework](https://www.ihe.net/resources/technical_frameworks/#PaLM) -
  Volume 1 (profiles), Volume 2 (transactions), Volume 3 (content)
- [NHS England - Pathology and Laboratory Medicine Reporting FHIR API](https://digital.nhs.uk/developer/api-catalogue/pathology-laboratory-reporting)
  and the [NHS England Pathology FHIR Implementation Guide](https://simplifier.net/guide/pathology-fhir-implementation-guide)
- [NHS England - Pathology and Laboratory Medicine Reporting: Test Result Stored Event](https://digital.nhs.uk/developer/api-catalogue/multicast-notification-service/pathology-test-result-stored-event)
- [NW GMSA - HL7 v2 Standards](https://nw-gmsa.github.io/en/hl7v2.html)
- [Digital Health and Care Wales - HL7 ORU_R01 2.5.1 Implementation Guide](https://nw-gmsa.github.io/DHCW-HL7-v2-5-1-ORUR01-Specification.pdf) (v2.0.0 STU, approved 22 March 2023)
- [HL7 Europe Laboratory Report](https://hl7.eu/fhir/laboratory/) 2.1.0 and
  [HL7 Europe Base and Core](https://hl7.eu/fhir/base/) 2.0.1
- [HL7 Version 2 to FHIR](https://build.fhir.org/ig/HL7/v2-to-fhir/)
