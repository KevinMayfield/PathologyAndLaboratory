// FHIR Document form of the laboratory report, as used by the NHS England Pathology
// and Laboratory Medicine Reporting FHIR API (POST /FHIR/R4/Bundle, Bundle.type
// document, Composition first, exactly one DiagnosticReport, a Provenance naming the
// calling application). Derived from HL7 Europe Laboratory, as NHS England's
// England-Bundle-Lab-Pathology is. See PathologyReportingAPI.md.

Alias: $loinc = http://loinc.org

Profile:        LaboratoryReportComposition
Parent:         http://hl7.eu/fhir/laboratory/StructureDefinition/Composition-eu-lab
Id:             LaboratoryReportComposition
Title:          "Laboratory Report Composition"
Description:    """
`Diagnostic - Laboratory` `Document` The header of a laboratory report FHIR Document. NHS England's Pathology Laboratory Reporting API reads the patient's NHS Number from `Composition.subject.identifier`.
"""

* identifier MS
* identifier only CorrelationIdentifier
* status MS
* type MS
* subject 1..1 MS
* subject only Reference(Patient)
* subject.identifier 1..1 MS
* subject.identifier only NHSIdentifier
* subject.identifier ^short = "NHS Number - required by the NHS England Pathology Laboratory Reporting API"
* date MS
* author 1..* MS
* author only Reference(Organization or PractitionerRole or Practitioner)
* title MS
* custodian MS
* custodian only Reference(Organization)
* section MS
* section.entry only Reference(LaboratoryReport or LaboratoryResult)

Profile:        LaboratoryReportProvenance
Parent:         Provenance
Id:             LaboratoryReportProvenance
Title:          "Laboratory Report Provenance"
Description:    """
`Diagnostic - Laboratory` `Document` Which system sent the laboratory report. Follows NHS England's `England-Provenance-Lab-Pathology`: `agent.who.identifier.value` is `<Product ID>:<(Optional) Test Reporter identifier>`.
"""

* target 1..* MS
* activity 1..1 MS
* activity ^short = "NHS England examples use `http://hl7.org/fhir/v3/ProvenanceActivity#transform` (not a valid HL7 code system URI - Open). This guide uses http://terminology.hl7.org/CodeSystem/v3-DataOperation#CREATE"
* agent 1..* MS
* agent.who.identifier 1..1 MS
* agent.who.identifier.system 1..1
* agent.who.identifier.system ^short = "https://api.service.nhs.uk/pathology-laboratory-reporting/test-reporting-system for the NHS England Pathology Laboratory Reporting API"
* agent.who.identifier.value 1..1
* agent.who.identifier.value ^short = "<Product ID>:<(Optional) Test Reporter identifier>"

Profile:        BundleLaboratoryReportDocument
Parent:         http://hl7.eu/fhir/laboratory/StructureDefinition/Bundle-eu-lab
Id:             BundleLaboratoryReportDocument
Title:          "Bundle - Laboratory Report Document"
Description:    """
`Diagnostic - Laboratory` `Document` A laboratory report as a FHIR Document, aligned with NHS England's `England-Bundle-Lab-Pathology` used by the [Pathology Laboratory Reporting API](PathologyReportingAPI.html): Composition first, exactly one DiagnosticReport, and a Provenance identifying the sending application.
"""

* type = #document
* entry[composition].resource only LaboratoryReportComposition
* entry[diagnosticReport] ^short = "The Laboratory Report, which here SHALL also conform to HL7 Europe DiagnosticReport-eu-lab (it links to the Composition with the R5 DiagnosticReport.composition extension)"
* entry[patient].resource only Patient
* entry[observation].resource only LaboratoryResult
* entry[specimen].resource only Specimen
* entry[serviceRequest] 1..* MS
* entry[serviceRequest] ^short = "Required by NHS England to find the ODS code of the requesting organisation"
* entry[serviceRequest].resource only LaboratoryOrder
* entry[provenance] 1..* MS
* entry[provenance].resource only LaboratoryReportProvenance
