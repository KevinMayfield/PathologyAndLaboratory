// The DiagnosticReport is derived from HL7 Europe Core, not HL7 Europe Laboratory:
// DiagnosticReport-eu-lab requires the R5 DiagnosticReport.composition extension,
// which a FHIR Message (the HL7 v2 ORU_R01 equivalent) does not have. The NW GMSA IG
// makes the same choice. In a FHIR Document the report also conforms to the EU Lab
// pattern - see LaboratoryReportDocument.fsh. NHS England uses a locally amended
// DiagnosticReport-eu-lab (version 2.0.0-nhs-fix) for the same reason (To confirm).

Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203

Profile:        LaboratoryReport
Parent:         http://hl7.eu/fhir/base/StructureDefinition/diagnosticReport-eu-core
Id:             LaboratoryReport
Title:          "Laboratory Report"
Description:    """
`Diagnostic - Laboratory` A laboratory report - the IHE PaLM *Order Result*. One DiagnosticReport per reported test or panel (HL7 v2 OBR in ORU_R01), grouping its results (OBX).
"""

* identifier 1..* MS
* identifier only CorrelationIdentifier
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the type"
* identifier ^slicing.ordered = false
* identifier contains
    fillerOrderNumber 0..1 MS
* identifier[fillerOrderNumber] only ReportIdentifier
* identifier[fillerOrderNumber] ^short = "Filler Order Number / report number assigned by the laboratory (HL7 v2 OBR-3)"

* basedOn 0..* MS
* basedOn only Reference(LaboratoryOrder)
* basedOn ^short = "The order (HL7 v2 ORC-2 / OBR-2 Placer Order Number)"

* status MS
* status ^short = "HL7 v2 OBR-25 Result Status - see ConceptMap v2-0123 to DiagnosticReport.status"

* category 1..* MS
* category from http://hl7.org/fhir/ValueSet/diagnostic-service-sections (extensible)
* category ^short = "Laboratory discipline (HL7 v2 OBR-24 Diagnostic Serv Sect ID)"

* code MS
* code ^short = "Test or panel reported (HL7 v2 OBR-4 Universal Service Identifier)"

* subject 1..1 MS
* subject only Reference(Patient)

* encounter 0..1 MS
* encounter.identifier only VisitNumber
* encounter ^short = "HL7 v2 PV1-19 Visit Number"

* effective[x] 1..1 MS
* effective[x] ^short = "Specimen collection date/time (HL7 v2 OBR-7 Observation Date/Time)"

* issued 1..1 MS
* issued ^short = "Date/time the report was released (HL7 v2 OBR-22 Results Rpt/Status Chng - Date/Time)"

* performer 1..* MS
* performer ^short = "Laboratory responsible for the report (HL7 v2 OBX-23 Performing Organization Name, MSH-4)"

* resultsInterpreter MS
* resultsInterpreter ^short = "HL7 v2 OBR-32 Principal Result Interpreter"

* specimen 0..* MS
* specimen only Reference(Specimen)

* result 0..* MS
* result only Reference(LaboratoryResult)
* result ^short = "Results (HL7 v2 OBX)"

* conclusion MS
* conclusion ^short = "Report comment or interpretation (HL7 v2 NTE following OBR, or OBX of type TX / FT)"

* presentedForm 0..* MS
* presentedForm only NWAttachment
* presentedForm ^short = "Rendered report, e.g. PDF (HL7 v2 OBX of type ED or RP)"
