# Research notes (not published)

## Sources read 2026-11-04

- NHS England Pathology and Laboratory Medicine Reporting FHIR API - OAS file
  (`https://digital.nhs.uk/restapi/oas/pathology-laboratory-reporting`): POST
  `/FHIR/R4/Bundle` (document; Composition first; exactly one DiagnosticReport;
  Provenance.agent.who.identifier.value `<Product ID>:<Test Reporter>`; one
  requesting ODS code via DiagnosticReport.basedOn -> ServiceRequest.requester;
  NHS Number in Composition.subject.identifier). GET `/FHIR/R4/Bundle/{id}` returns
  the acknowledgement (Bundle type message). Example meta.profile values:
  England-Bundle-Lab-Pathology 0.1.0, Composition-eu-lab 2.0.0,
  DiagnosticReport-eu-lab 2.0.0-nhs-fix, ServiceRequest-eu-lab 2.0.0,
  patient-eu-core 2.0.0, England-Observation-Lab-Pathology 0.3.0,
  England-Provenance-Lab-Pathology 0.1.0, UKCore-PractitionerRole 2.4.0,
  UKCore-Practitioner 2.4.0, UKCore-Organization 2.5.0. Ack event code seen:
  `pathology-laboratory-reporting-test-result-stored-1-ack-1`
  (system `https://fhir.nhs.uk/CodeSystem/message-event`).
- MNS event `pathology-laboratory-reporting-test-result-stored-1` - in development,
  production 2027. Filters `requestingOrganisationODS` and
  `requestingOrganisationODS_manufsacturer_org` (sic, as on the page).
- DHCW HL7 ORU_R01 2.5.1 IG v2.0.0 STU (approved 22 March 2023).
- NW GMSA hl7v2 page (local source `../FHIRGenomics/input/pagecontent/hl7v2.md`).

## Copied files (keep in step)

- `input/fsh/DataTypes/NWDataTypes.fsh` <- `../Imaging/input/fsh/DataTypes/NWDataTypes.fsh`
  (<- NW GMSA). Added AccessionIdentifier.
- `input/fsh/Profiles/Patient.fsh` <- `../Imaging/input/fsh/Core/Patient.fsh` (<- NW GMSA)
- `input/fsh/Messaging/Messaging.fsh` <- `../Imaging/input/fsh/Messaging/Messaging.fsh` (<- NW GMSA)
- `input/resources/*.json` NamingSystems and build scripts <- `../Imaging`

## Open questions

- What does NHS England's `DiagnosticReport-eu-lab|2.0.0-nhs-fix` change? (Assumed:
  relaxes the composition extension.) Find the NHS England Pathology FHIR IG package
  on Simplifier and consider depending on it.
- Is `England-Observation-Lab-Pathology` derived from `Observation-resultslab-eu-lab`?
- NHS England Provenance example uses `http://hl7.org/fhir/v3/ProvenanceActivity#transform`
  (not a valid HL7 code system URI); this guide uses v3-DataOperation CREATE (TRANSFORM is not in that code system).
- PaLM code set for *requestable* tests (OBR-4) - SNOMED CT procedures assumed.
- `XCN-9` value for GP national codes: `GMP` used here; DHCW examples only show GMC/NMC.
- PID-32 NHS Number verification status - FHIR extension is UK Core; not profiled.
- Reference range comparators (`<48`) - EU Lab low/highComparator extensions.
- UKAS requirement for showing the subcontracting laboratory - clause to confirm.
- NHS England package `fhir.r4.nhsengland.pathology` latest published is 0.3.0 (examples
  index on Simplifier is IG version 0.5.1). England-Observation-Lab-Pathology is 0.2.1 in the
  package, 0.3.0 in the API OAS.
- NHS England examples have no Patient resource (NHS Number on subject.identifier only);
  the ORU_R01 versions use placeholder PID-5/7/8.
- Report model aligned to NHS England (2026-11-04): DiagnosticReport per report, generic
  code 721981007; OBR = organizer Observation (R6 Observation.organizer extension, defined
  in the NHS England package) - this guide's LaboratoryResult does not define the extension;
  notebook 02 adds it for NHS England documents only.
- NPEx (National Pathology Exchange): X-Lab Ltd with The Health Informatics Service, national
  NHS service since 2010, now marketed as Labgnostic. Message formats used by NPEx - to confirm.
- YHCR: Interweave IG https://fhir.interweavedigital.com/index.html (STU3, R4 profiles incl.
  Interweave-DiagnosticReport).
- England-Bundle-Lab-Pathology 0.1.0 (package 0.3.0) defect: slice provenanceTestReportingSystem
  typed Resource -> every entry "matches more than one slice", plus "required slice not found".
  NHS England's own examples declare Bundle-eu-lab|2.0.0 and validate cleanly. Report to NHS England.
- Notebook validation was run with VALIDATOR_TX=n/a (tx.fhir.org timed out repeatedly); codes were
  checked separately with CodeSystem/$lookup.
- MRNs RCB4719263 / RCB6052841 and lab PIs Y8J7D0381527 / Y8J7D0592374 added to
  ../Testing/MRN-Mapping.md (not committed there).
- Observation.organizer: input/resources/StructureDefinition-Extension-UKCore-ObservationOrganizer.json is
  HL7 UK's Extension-UKCore-ObservationOrganizer (R4 backport of R6 Observation.organizer, Apache 2.0),
  copied unchanged from fhir.r4.nhsengland.pathology 0.3.0 except for an added structuredefinition-wg = oo
  extension (the IG Publisher requires a work group for hl7.org URLs); allowed by the special-url parameter.
  Imported because the FHIR Document examples use it - the NHS England package is NOT a dependency.
- PaLM requestables: SNOMED CT UK refset 1853561000000109 (Pathology and laboratory medicine
  procedure simple reference set); UK Core STU2 2.0.2 ValueSet UKCore-PathologyAndLaboratoryMedicineProcedures
  (memberOf 1853561000000109), preferred on UKCore-ServiceRequest-Lab.code and
  UKCore-Observation-Group-Lab.code. Results: 1853551000000106 (PaLM observables), 999002881000000100 (PBCL).
  tx.fhir.org UK Edition is 20230412 - no PaLM refsets. To confirm: whether example codes
  (1022441000000101 FBC etc., from NHS England examples) are procedures or observables.
- Answered (2026-11-04, CSIRO Ontoserver, UK Edition 20250702): refset 1853561000000109 has 358 members,
  1853551000000106 4019, PBCL 999002881000000100 3741. The NHS England examples' test group codes
  (1022441000000101 FBC, LFT, U&E, lipids, GTT, CRP, HBsAg, urine MCS) are PBCL; HbA1c/HPV are PaLM
  observables - none are PaLM procedures. PaLM procedures: 26604007 FBC, 252167001 U&E, 271244005 lipids,
  135842001 CRP, 371981000000106 HbA1c IFCC, 47758006 HBsAg, 700152009 HPV, 113076002 GTT, 401324008 urine MCS.
  LFT: 26958001 Hepatic function panel.
- Checked (2026-11-04): no published list of PaLM requestable (panel) -> member observables or units.
  SNOMED CT UK Edition 20250702 (CSIRO Ontoserver): procedures are defined only by Method/Component
  (26604007 FBC = Measurement of Blood cell); observables (e.g. 1108071000000101 neutrophil count) carry
  Component/Property/Inheres in/Direct site but no Units attribute. TRUD Pathology category: NHS National
  Laboratory Medicine Catalogue (item 77, technology preview, last release 5.1.0 Nov 2015), PBCL (item 23),
  PBCL Read->SNOMED map (item 270); guest pages don't say whether NLMC/PBCL contain groupings or units
  (download needs a TRUD login). DAPB4017 (retired 1 Nov 2023) planned a UK Pathology Units List (UCUM)
  and said single-unit results would carry the unit in the UTL/SNOMED model - not seen in the UK Edition.
  NHS England PaLM mapping guidance: reportables are single items, not panels. Open: NLMC/PBCL file
  contents; whether UKPUL is still published.
