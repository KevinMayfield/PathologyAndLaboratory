// Element-level mappings from the profiles to HL7 v2.5.1, shown on each profile's
// Mappings tab. These complement (not replace) the base FHIR "v2" mappings and the
// HL7 v2-to-FHIR IG segment maps. Read left to right for FHIR to v2, right to left
// for v2 to FHIR - see mapping.md. Id palm-v2 avoids clashing with the base "v2" id.

Mapping:  PatientToV2
Source:   Patient
Target:   "http://hl7.org/v2"
Id:       palm-v2
Title:    "HL7 v2.5.1 (England PaLM)"
Description: "PID segment, as used in OML_O21 and ORU_R01"
* -> "PID"
* identifier -> "PID-3 Patient Identifier List"
* identifier[nhsNumber] -> "PID-3 with CX-4 = NHS (assigning authority) and CX-5 = NH (identifier type). PID-32 Identity Reliability Code carries the NHS Number verification status"
* identifier[MedicalRecordNumber] -> "PID-3 with CX-5 = MR and CX-4 = trust ODS code"
* name -> "PID-5 Patient Name"
* name.family -> "PID-5.1 Family Name"
* name.given -> "PID-5.2 Given Name, PID-5.3 Second and Further Given Names"
* name.prefix -> "PID-5.5 Prefix"
* birthDate -> "PID-7 Date/Time of Birth"
* gender -> "PID-8 Administrative Sex - see ConceptMap v2-0001-to-administrative-gender"
* address -> "PID-11 Patient Address"
* address.postalCode -> "PID-11.5 Zip or Postal Code"
* telecom -> "PID-13 Phone Number - Home, PID-14 Phone Number - Business"
* deceasedDateTime -> "PID-29 Patient Death Date and Time"

Mapping:  LaboratoryOrderToV2
Source:   LaboratoryOrder
Target:   "http://hl7.org/v2"
Id:       palm-v2
Title:    "HL7 v2.5.1 (England PaLM)"
Description: "ORC and OBR segments of OML_O21 [LAB-1, LAB-2, LAB-35]"
* -> "ORC / OBR (OML_O21 ORDER group)"
* identifier[placerOrderNumber] -> "ORC-2 Placer Order Number (= OBR-2). EI-1 value, EI-2 namespace (sending application)"
* identifier[fillerOrderNumber] -> "ORC-3 Filler Order Number (= OBR-3)"
* requisition -> "ORC-4 Placer Group Number"
* status -> "ORC-1 Order Control and ORC-5 Order Status - see ConceptMap v2-0119-to-request-status"
* intent -> "fixed: order"
* code -> "OBR-4 Universal Service Identifier - PaLM requestable (SNOMED CT), with the laboratory's local code as the alternate (CWE-4 to CWE-6)"
* subject -> "PID"
* encounter -> "PV1-19 Visit Number"
* priority -> "TQ1-9 Priority - see ConceptMap v2-0485-to-request-priority"
* authoredOn -> "ORC-9 Date/Time of Transaction"
* requester -> "ORC-12 Ordering Provider (= OBR-16) and ORC-21 Ordering Facility Name; PV1-3 / PV1-8 for GP requests"
* performer -> "MSH-6 Receiving Facility"
* reasonCode -> "OBR-31 Reason for Study, DG1-3 Diagnosis Code"
* supportingInfo -> "OBX following the OBR (ask at order entry questions)"
* specimen -> "SPM"
* note -> "NTE following the OBR (NTE-2 = P placer comment), OBR-13 Relevant Clinical Information"

Mapping:  SpecimenToV2
Source:   Specimen
Target:   "http://hl7.org/v2"
Id:       palm-v2
Title:    "HL7 v2.5.1 (England PaLM)"
Description: "SPM segment"
* -> "SPM"
* identifier[placerSpecimenNumber] -> "SPM-2.1 Placer Assigned Identifier"
* accessionIdentifier -> "SPM-2.2 Filler Assigned Identifier"
* type -> "SPM-4 Specimen Type"
* subject -> "PID"
* receivedTime -> "SPM-18 Specimen Received Date/Time"
* collection.collected[x] -> "SPM-17 Specimen Collection Date/Time"
* collection.bodySite -> "SPM-8 Specimen Source Site (with SPM-9 modifier)"
* collection.method -> "SPM-7 Specimen Collection Method"
* note -> "SPM-14 Specimen Description"

Mapping:  LaboratoryReportToV2
Source:   LaboratoryReport
Target:   "http://hl7.org/v2"
Id:       palm-v2
Title:    "HL7 v2.5.1 (England PaLM)"
Description: "OBR segment of ORU_R01 [LAB-3, LAB-36]"
* -> "ORU_R01 PATIENT_RESULT - the OBR segments sharing OBR-3"
* identifier[fillerOrderNumber] -> "OBR-3 Filler Order Number (= ORC-3), shared by the OBRs of the report"
* basedOn -> "OBR-2 Placer Order Number (= ORC-2) - one ServiceRequest per OBR"
* status -> "OBR-25 Result Status - see ConceptMap v2-0123-to-diagnostic-report-status"
* category -> "OBR-24 Diagnostic Serv Sect ID (HL7 table 0074)"
* code -> "Report type (SNOMED CT 721981007 / LOINC 11502-2) - not in HL7 v2; and OBR-4 (PaLM requestable) for a report of one test. OBR-4 also maps to ServiceRequest.code and Observation.code"
* subject -> "PID"
* encounter -> "PV1-19 Visit Number"
* effective[x] -> "OBR-7 Observation Date/Time (specimen collection) - OBR-8 Observation End Date/Time for a period"
* issued -> "OBR-22 Results Rpt/Status Chng - Date/Time"
* performer -> "OBX-23 Performing Organization Name; otherwise MSH-4 Sending Facility"
* resultsInterpreter -> "OBR-32 Principal Result Interpreter"
* specimen -> "SPM"
* result -> "one per OBR: the OBR as a test group Observation (several OBX), or its single OBX"
* conclusion -> "NTE following the OBR, or an OBX of type TX / FT holding the report comment"
* presentedForm -> "OBX of type ED (Base64 PDF) or RP (reference pointer)"

Mapping:  LaboratoryResultToV2
Source:   LaboratoryResult
Target:   "http://hl7.org/v2"
Id:       palm-v2
Title:    "HL7 v2.5.1 (England PaLM)"
Description: "OBX segment of ORU_R01 [LAB-3, LAB-36]"
* -> "OBX (ORU_R01 OBSERVATION group); a test group organizer is the OBR"
* identifier -> "OBR-3 Filler Order Number + OBX-1 Set ID (or OBX-21 Observation Instance Identifier in later versions)"
* basedOn -> "OBR-2 Placer Order Number"
* status -> "OBX-11 Observation Result Status - see ConceptMap v2-0085-to-observation-status"
* code -> "OBX-3 Observation Identifier; OBR-4 for a test group organizer"
* subject -> "PID"
* effective[x] -> "OBX-14 Date/Time of the Observation, otherwise OBR-7"
* issued -> "OBR-22 Results Rpt/Status Chng - Date/Time"
* performer -> "OBX-23 Performing Organization Name, OBX-16 Responsible Observer"
* value[x] -> "OBX-5 Observation Value, with OBX-2 Value Type and OBX-6 Units - see mapping.html#obx-2-value-type"
* dataAbsentReason -> "OBX-11 = X or N, or an empty OBX-5"
* interpretation -> "OBX-8 Abnormal Flags - see ConceptMap v2-0078-to-observation-interpretation"
* note -> "NTE following the OBX"
* method -> "OBX-17 Observation Method"
* specimen -> "SPM (the specimen the OBR is reported on)"
* device -> "OBX-18 Equipment Instance Identifier"
* referenceRange -> "OBX-7 References Range"
* hasMember -> "organizer: the OBX under the OBR (or OBX-4 Observation Sub-ID grouping)"

Mapping:  MessageHeaderToV2
Source:   MessageHeader
Target:   "http://hl7.org/v2"
Id:       palm-v2
Title:    "HL7 v2.5.1 (England PaLM)"
Description: "MSH and MSA segments"
* -> "MSH"
* eventCoding -> "MSH-9.2 Trigger Event (O21, R01)"
* destination.receiver.identifier -> "MSH-6 Receiving Facility (ODS code)"
* destination.name -> "MSH-5 Receiving Application"
* sender.identifier -> "MSH-4 Sending Facility (ODS code)"
* source.name -> "MSH-3 Sending Application"
* response.identifier -> "MSA-2 Message Control ID (of the message being acknowledged)"
* response.code -> "MSA-1 Acknowledgment Code: AA = ok, AE = transient-error, AR = fatal-error"

Mapping:  BundleMessageToV2
Source:   BundleMessage
Target:   "http://hl7.org/v2"
Id:       palm-v2
Title:    "HL7 v2.5.1 (England PaLM)"
Description: "The HL7 v2 message"
* -> "Message (MSH ...)"
* identifier -> "MSH-10 Message Control ID"
* timestamp -> "MSH-7 Date/Time of Message"
