Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203

Profile:        LaboratoryOrder
Parent:         http://hl7.eu/fhir/laboratory/StructureDefinition/ServiceRequest-eu-lab
Id:             LaboratoryOrder
Title:          "Laboratory Order"
Description:    """
`Diagnostic - Laboratory` A laboratory test request - the IHE PaLM *Order*. One ServiceRequest per ordered test or panel (HL7 v2 ORC/OBR pair). Orders placed together share `requisition` (ORC-4 Placer Group Number).
"""

* identifier 1..* MS
* identifier only CorrelationIdentifier
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the type"
* identifier ^slicing.ordered = false
* identifier contains
    placerOrderNumber 0..1 MS and
    fillerOrderNumber 0..1 MS
* identifier[placerOrderNumber] only OrderIdentifier
* identifier[placerOrderNumber].type = $v2-0203#PLAC
* identifier[placerOrderNumber] ^short = "Placer Order Number, assigned by the Order Placer (HL7 v2 ORC-2 / OBR-2)"
* identifier[fillerOrderNumber] only OrderIdentifier
* identifier[fillerOrderNumber].type = $v2-0203#FILL
* identifier[fillerOrderNumber] ^short = "Filler Order Number, assigned by the Order Filler (HL7 v2 ORC-3 / OBR-3)"

* requisition 0..1 MS
* requisition only CorrelationIdentifier
* requisition ^short = "Placer Group Number - orders placed together (HL7 v2 ORC-4)"

* status MS
* status ^short = "HL7 v2 ORC-1 Order Control / ORC-5 Order Status"
* intent MS

* code 1..1 MS
* code ^short = "Test or panel requested (HL7 v2 OBR-4 Universal Service Identifier)"
* code.coding ^slicing.discriminator.type = #value
* code.coding ^slicing.discriminator.path = "system"
* code.coding ^slicing.rules = #open
* code.coding ^slicing.description = "Slice based on the system"
* code.coding ^slicing.ordered = false
* code.coding contains palmProcedure 0..* MS
* code.coding[palmProcedure].system = "http://snomed.info/sct"
* code.coding[palmProcedure].code 1..1
* code.coding[palmProcedure] from PaLMProcedure (preferred)
* code.coding[palmProcedure] ^short = "PaLM requestable test (SNOMED CT UK, Pathology and laboratory medicine procedure refset) - the England equivalent of the National Genomic Test Directory and NICIP. The laboratory's own test code can be sent as another coding"

* subject 1..1 MS
* subject only Reference(Patient)

* encounter 0..1 MS
* encounter.identifier only VisitNumber
* encounter ^short = "HL7 v2 PV1-19 Visit Number"

* priority MS
* priority ^short = "HL7 v2 TQ1-9 Priority"

* authoredOn MS
* authoredOn ^short = "HL7 v2 ORC-9 Date/Time of Transaction"

* requester 1..1 MS
* requester only Reference(PractitionerRole or Organization)
* requester ^short = "Ordering provider and organisation (HL7 v2 ORC-12 / OBR-16, ORC-21, PV1-8)"

* performer 0..* MS
* performer only Reference(Organization)
* performer ^short = "Laboratory asked to perform the test (HL7 v2 MSH-6 Receiving Facility)"

* reasonCode MS
* reasonCode ^short = "HL7 v2 OBR-31 Reason for Study, DG1-3"

* supportingInfo MS
* supportingInfo ^short = "Ask at order entry answers and clinical details (HL7 v2 OBX following OBR)"

* specimen 0..* MS
* specimen only Reference(Specimen)

* note MS
* note ^short = "Clinical details and comments (HL7 v2 NTE, OBR-13 Relevant Clinical Information)"
