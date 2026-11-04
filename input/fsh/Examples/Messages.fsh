// The full blood count as FHIR Messages (the HL7 v2 OML_O21, ORU_R01 and ACK
// equivalents) and as a FHIR Document (the NHS England Pathology Laboratory
// Reporting API form). The HL7 v2 messages are on the LAB-1 and LAB-3 pages.

Alias: $v2-0003 = http://terminology.hl7.org/CodeSystem/v2-0003
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code
Alias: $nhs-number = https://fhir.nhs.uk/Id/nhs-number
Alias: $loinc = http://loinc.org

// LAB-1 Placer Order Management - OML^O21

Instance: LaboratoryOrderMessage
InstanceOf: BundleMessage
Title: "Bundle Message - Laboratory Order (O21) [LAB-1]"
Description: "FHIR Message equivalent of the HL7 v2.5.1 OML^O21 full blood count order from the GP system to the laboratory."
Usage: #example
* identifier.system = "https://fhir.examplesurgery.nhs.uk/Id/message"
* identifier.value = "GP-MSG-000501"
* type = #message
* timestamp = "2026-11-03T09:10:05Z"
* entry[message].fullUrl = "https://fhir.example.nhs.uk/R4/MessageHeader/LaboratoryOrderMessageHeader"
* entry[message].resource = LaboratoryOrderMessageHeader
* entry[1].fullUrl = "https://fhir.example.nhs.uk/R4/ServiceRequest/LaboratoryOrderFBCNew"
* entry[1].resource = LaboratoryOrderFBCNew
* entry[2].fullUrl = "https://fhir.example.nhs.uk/R4/Patient/PatientOctaviaCHISLETT"
* entry[2].resource = PatientOctaviaCHISLETT
* entry[3].fullUrl = "https://fhir.example.nhs.uk/R4/PractitionerRole/PractitionerRoleGP"
* entry[3].resource = PractitionerRoleGP
* entry[4].fullUrl = "https://fhir.example.nhs.uk/R4/Practitioner/PractitionerGP"
* entry[4].resource = PractitionerGP
* entry[5].fullUrl = "https://fhir.example.nhs.uk/R4/Organization/OrganizationExampleSurgery"
* entry[5].resource = OrganizationExampleSurgery
* entry[6].fullUrl = "https://fhir.example.nhs.uk/R4/Organization/OrganizationMFT"
* entry[6].resource = OrganizationMFT

Instance: LaboratoryOrderMessageHeader
InstanceOf: MessageHeader
Usage: #inline
* id = "LaboratoryOrderMessageHeader"
* meta.lastUpdated = "2026-11-03T09:10:05Z"
* eventCoding = $v2-0003#O21 "OML - Laboratory order"
* destination.name = "LIMS"
* destination.endpoint = "https://lims.example.nhs.uk/R4/$process-message"
* destination.receiver.identifier.system = $ods-code
* destination.receiver.identifier.value = "R0A"
* sender.identifier.system = $ods-code
* sender.identifier.value = "A12345"
* source.name = "GPSYSTEM"
* source.endpoint = "https://gp.example.nhs.uk/R4"
* focus = Reference(ServiceRequest/LaboratoryOrderFBCNew)
* definition = "https://examplesihe.org.uk/MessageDefinition/laboratory-order"

// LAB-3 Order Results Management - ORU^R01

Instance: LaboratoryResultMessage
InstanceOf: BundleMessage
Title: "Bundle Message - Laboratory Result (R01) [LAB-3]"
Description: "FHIR Message equivalent of the HL7 v2.5.1 ORU^R01 full blood count result from the laboratory to the GP system."
Usage: #example
* identifier.system = "https://fhir.mft.nhs.uk/Id/message"
* identifier.value = "LIMS-MSG-000987"
* type = #message
* timestamp = "2026-11-03T16:05:30Z"
* entry[message].fullUrl = "https://fhir.example.nhs.uk/R4/MessageHeader/LaboratoryResultMessageHeader"
* entry[message].resource = LaboratoryResultMessageHeader
* entry[1].fullUrl = "https://fhir.example.nhs.uk/R4/DiagnosticReport/LaboratoryReportFBC"
* entry[1].resource = LaboratoryReportFBC
* entry[2].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBC"
* entry[2].resource = ResultFBC
* entry[3].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCWhiteCellCount"
* entry[3].resource = ResultFBCWhiteCellCount
* entry[4].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCHaemoglobin"
* entry[4].resource = ResultFBCHaemoglobin
* entry[5].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCPlateletCount"
* entry[5].resource = ResultFBCPlateletCount
* entry[6].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCRedCellCount"
* entry[6].resource = ResultFBCRedCellCount
* entry[7].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCHaematocrit"
* entry[7].resource = ResultFBCHaematocrit
* entry[8].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCMeanCellVolume"
* entry[8].resource = ResultFBCMeanCellVolume
* entry[9].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCMeanCellHaemoglobin"
* entry[9].resource = ResultFBCMeanCellHaemoglobin
* entry[10].fullUrl = "https://fhir.example.nhs.uk/R4/ServiceRequest/LaboratoryOrderFBC"
* entry[10].resource = LaboratoryOrderFBC
* entry[11].fullUrl = "https://fhir.example.nhs.uk/R4/Specimen/SpecimenFBC"
* entry[11].resource = SpecimenFBC
* entry[12].fullUrl = "https://fhir.example.nhs.uk/R4/Patient/PatientOctaviaCHISLETT"
* entry[12].resource = PatientOctaviaCHISLETT
* entry[13].fullUrl = "https://fhir.example.nhs.uk/R4/PractitionerRole/PractitionerRoleGP"
* entry[13].resource = PractitionerRoleGP
* entry[14].fullUrl = "https://fhir.example.nhs.uk/R4/Practitioner/PractitionerGP"
* entry[14].resource = PractitionerGP
* entry[15].fullUrl = "https://fhir.example.nhs.uk/R4/PractitionerRole/PractitionerRoleHaematologist"
* entry[15].resource = PractitionerRoleHaematologist
* entry[16].fullUrl = "https://fhir.example.nhs.uk/R4/Practitioner/PractitionerHaematologist"
* entry[16].resource = PractitionerHaematologist
* entry[17].fullUrl = "https://fhir.example.nhs.uk/R4/Organization/OrganizationExampleSurgery"
* entry[17].resource = OrganizationExampleSurgery
* entry[18].fullUrl = "https://fhir.example.nhs.uk/R4/Organization/OrganizationMFT"
* entry[18].resource = OrganizationMFT

Instance: LaboratoryResultMessageHeader
InstanceOf: MessageHeader
Usage: #inline
* id = "LaboratoryResultMessageHeader"
* meta.lastUpdated = "2026-11-03T16:05:30Z"
* eventCoding = $v2-0003#R01 "ORU/ACK - Unsolicited transmission of an observation message"
* destination.name = "GPSYSTEM"
* destination.endpoint = "https://gp.example.nhs.uk/R4/$process-message"
* destination.receiver.identifier.system = $ods-code
* destination.receiver.identifier.value = "A12345"
* sender.identifier.system = $ods-code
* sender.identifier.value = "R0A"
* source.name = "LIMS"
* source.endpoint = "https://lims.example.nhs.uk/R4"
* focus = Reference(DiagnosticReport/LaboratoryReportFBC)
* definition = "https://examplesihe.org.uk/MessageDefinition/laboratory-result"

// ACK^R01 - acknowledgement

Instance: LaboratoryResultAcknowledgement
InstanceOf: BundleMessage
Title: "Bundle Message - Acknowledgement (ACK^R01)"
Description: "FHIR response message equivalent of HL7 v2.5.1 `MSA|AA|LIMS-MSG-000987` - the GP system accepts the result message."
Usage: #example
* identifier.system = "https://fhir.examplesurgery.nhs.uk/Id/message"
* identifier.value = "GP-MSG-000777"
* type = #message
* timestamp = "2026-11-03T16:05:32Z"
* entry[message].fullUrl = "https://fhir.example.nhs.uk/R4/MessageHeader/LaboratoryResultAcknowledgementHeader"
* entry[message].resource = LaboratoryResultAcknowledgementHeader

Instance: LaboratoryResultAcknowledgementHeader
InstanceOf: MessageHeader
Usage: #inline
* id = "LaboratoryResultAcknowledgementHeader"
* meta.lastUpdated = "2026-11-03T16:05:32Z"
* eventCoding = $v2-0003#R01 "ORU/ACK - Unsolicited transmission of an observation message"
* destination.name = "LIMS"
* destination.endpoint = "https://lims.example.nhs.uk/R4"
* destination.receiver.identifier.system = $ods-code
* destination.receiver.identifier.value = "R0A"
* sender.identifier.system = $ods-code
* sender.identifier.value = "A12345"
* source.name = "GPSYSTEM"
* source.endpoint = "https://gp.example.nhs.uk/R4"
* response.identifier = "LIMS-MSG-000987"
* response.code = #ok

// NHS England Pathology Laboratory Reporting API - FHIR Document

Instance: LaboratoryReportDocumentFBC
// InstanceOf Bundle (with meta.profile) so the entries can be ordered by position:
// SUSHI orders named slice entries itself, and a FHIR Document needs the Composition first.
InstanceOf: Bundle
Title: "Bundle Document - Full blood count (NHS England Pathology Laboratory Reporting API)"
Description: "The full blood count as a FHIR Document, the form POSTed by laboratory middleware to the NHS England Pathology Laboratory Reporting API (`POST /FHIR/R4/Bundle`)."
Usage: #example
* meta.profile = "https://examplesihe.org.uk/StructureDefinition/BundleLaboratoryReportDocument"
* identifier.system = "https://fhir.mft.nhs.uk/Id/report-document"
* identifier.value = "26H012345-1"
* type = #document
* timestamp = "2026-11-03T16:05:30Z"
* entry[0].fullUrl = "https://fhir.example.nhs.uk/R4/Composition/CompositionFBC"
* entry[0].resource = CompositionFBC
* entry[1].fullUrl = "https://fhir.example.nhs.uk/R4/DiagnosticReport/LaboratoryReportFBCDocument"
* entry[1].resource = LaboratoryReportFBCDocument
* entry[2].fullUrl = "https://fhir.example.nhs.uk/R4/Patient/PatientOctaviaCHISLETT"
* entry[2].resource = PatientOctaviaCHISLETT
* entry[3].fullUrl = "https://fhir.example.nhs.uk/R4/ServiceRequest/LaboratoryOrderFBC"
* entry[3].resource = LaboratoryOrderFBC
* entry[4].fullUrl = "https://fhir.example.nhs.uk/R4/Specimen/SpecimenFBC"
* entry[4].resource = SpecimenFBC
* entry[5].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBC"
* entry[5].resource = ResultFBC
* entry[6].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCWhiteCellCount"
* entry[6].resource = ResultFBCWhiteCellCount
* entry[7].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCHaemoglobin"
* entry[7].resource = ResultFBCHaemoglobin
* entry[8].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCPlateletCount"
* entry[8].resource = ResultFBCPlateletCount
* entry[9].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCRedCellCount"
* entry[9].resource = ResultFBCRedCellCount
* entry[10].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCHaematocrit"
* entry[10].resource = ResultFBCHaematocrit
* entry[11].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCMeanCellVolume"
* entry[11].resource = ResultFBCMeanCellVolume
* entry[12].fullUrl = "https://fhir.example.nhs.uk/R4/Observation/ResultFBCMeanCellHaemoglobin"
* entry[12].resource = ResultFBCMeanCellHaemoglobin
* entry[13].fullUrl = "https://fhir.example.nhs.uk/R4/PractitionerRole/PractitionerRoleGP"
* entry[13].resource = PractitionerRoleGP
* entry[14].fullUrl = "https://fhir.example.nhs.uk/R4/PractitionerRole/PractitionerRoleHaematologist"
* entry[14].resource = PractitionerRoleHaematologist
* entry[15].fullUrl = "https://fhir.example.nhs.uk/R4/Practitioner/PractitionerGP"
* entry[15].resource = PractitionerGP
* entry[16].fullUrl = "https://fhir.example.nhs.uk/R4/Practitioner/PractitionerHaematologist"
* entry[16].resource = PractitionerHaematologist
* entry[17].fullUrl = "https://fhir.example.nhs.uk/R4/Organization/OrganizationExampleSurgery"
* entry[17].resource = OrganizationExampleSurgery
* entry[18].fullUrl = "https://fhir.example.nhs.uk/R4/Organization/OrganizationMFT"
* entry[18].resource = OrganizationMFT
* entry[19].fullUrl = "https://fhir.example.nhs.uk/R4/Provenance/ProvenanceFBC"
* entry[19].resource = ProvenanceFBC

Instance: CompositionFBC
InstanceOf: LaboratoryReportComposition
Usage: #inline
* id = "CompositionFBC"
// HL7 Europe Bundle-eu-lab invariants: the Composition shares an identifier
// (dr-comp-identifier) and a type coding (dr-comp-type) with the DiagnosticReport.
* identifier.type = http://terminology.hl7.org/CodeSystem/v2-0203#FILL
* identifier.system = "https://fhir.mft.nhs.uk/Id/lims-order"
* identifier.value = "26H012345"
* status = #final
* type.coding[+] = http://snomed.info/sct#721981007 "Diagnostic studies report"
* type.coding[+] = $loinc#11502-2 "Laboratory report"
* category = $loinc#18723-7 "Hematology studies (set)"
* subject = Reference(Patient/PatientOctaviaCHISLETT)
* subject.identifier.system = $nhs-number
* subject.identifier.value = "9449305552"
* date = "2026-11-03T16:05:00Z"
* author = Reference(Organization/OrganizationMFT)
* title = "Laboratory Report - Full blood count"
* custodian = Reference(Organization/OrganizationMFT)
* section.title = "Haematology"
* section.code = $loinc#18723-7 "Hematology studies (set)"
* section.text.status = #generated
* section.text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Full blood count: white cell count 3.5 10*9/L (L), haemoglobin 112 g/L (L), platelets 250 10*9/L, red cell count 4.20 10*12/L, haematocrit 0.38 L/L, MCV 88 fL, MCH 29.0 pg.</p><p>Mild anaemia with low white cell count. Suggest repeat in 4 weeks.</p></div>"
* section.entry = Reference(DiagnosticReport/LaboratoryReportFBCDocument)
* extension[diagnosticReport].valueReference = Reference(DiagnosticReport/LaboratoryReportFBCDocument)

Instance: ProvenanceFBC
InstanceOf: LaboratoryReportProvenance
Usage: #inline
* id = "ProvenanceFBC"
* target = Reference(Composition/CompositionFBC)
* recorded = "2026-11-03T16:05:30Z"
* activity = http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle#transform "Transform/Translate Record Lifecycle Event"
* agent.who.identifier.system = "https://api.service.nhs.uk/pathology-laboratory-reporting/test-reporting-system"
* agent.who.identifier.value = "P.GH7-4TY"
