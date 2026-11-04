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
