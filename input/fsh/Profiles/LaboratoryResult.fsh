Profile:        LaboratoryResult
Parent:         http://hl7.eu/fhir/laboratory/StructureDefinition/Observation-resultslab-eu-lab
Id:             LaboratoryResult
Title:          "Laboratory Result"
Description:    """
`Diagnostic - Laboratory` A laboratory result (HL7 v2 OBX), or a test group (HL7 v2 OBR with several OBX) acting as an organizer whose `hasMember` are its results - for example the full blood count. NHS England marks organizers with the `http://hl7.org/fhir/6.0/StructureDefinition/extension-Observation.organizer` extension. NHS England's Pathology Laboratory Reporting API uses its own `England-Observation-Lab-Pathology` profile, which is also derived from HL7 Europe Laboratory.
"""

* identifier MS
* identifier only CorrelationIdentifier

* basedOn MS
* basedOn only Reference(LaboratoryOrder)

* status MS
* status ^short = "HL7 v2 OBX-11 Observation Result Status - see ConceptMap v2-0085 to Observation.status"

* code MS
* code ^short = "What was measured (HL7 v2 OBX-3 Observation Identifier). SNOMED CT UK (PaLM) observable entity, optionally with LOINC"

* subject 1..1 MS
* subject only Reference(Patient)

* effective[x] MS
* effective[x] ^short = "HL7 v2 OBX-14 Date/Time of the Observation, otherwise OBR-7"

* issued MS
* issued ^short = "HL7 v2 OBR-22 Results Rpt/Status Chng - Date/Time"

* performer MS
* performer ^short = "HL7 v2 OBX-23 Performing Organization Name, OBX-16 Responsible Observer"

* value[x] MS
* value[x] ^short = "HL7 v2 OBX-5 Observation Value, typed by OBX-2 Value Type, with OBX-6 Units"

* dataAbsentReason MS
* dataAbsentReason ^short = "Why there is no value, e.g. HL7 v2 OBX-11 = X (results cannot be obtained)"

* interpretation MS
* interpretation ^short = "HL7 v2 OBX-8 Abnormal Flags"

* note MS
* note ^short = "HL7 v2 NTE following the OBX"

* method ^short = "HL7 v2 OBX-17 Observation Method"

* specimen MS
* specimen only Reference(Specimen)

* device ^short = "HL7 v2 OBX-18 Equipment Instance Identifier"

* referenceRange MS
* referenceRange ^short = "HL7 v2 OBX-7 References Range"
* referenceRange.text ^short = "HL7 v2 OBX-7 as sent, where it cannot be parsed into low/high"

* hasMember ^short = "Results of a test group - the OBX under the OBR (or grouped by HL7 v2 OBX-4 Observation Sub-ID)"
