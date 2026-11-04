Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203

Profile:        Specimen
Parent:         http://hl7.eu/fhir/laboratory/StructureDefinition/Specimen-eu-lab
Id:             Specimen
Title:          "Specimen"
Description:    """
`Diagnostic - Laboratory` `Specimen Collection` A specimen collected for laboratory testing (HL7 v2 SPM).
"""

* identifier 0..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the type"
* identifier ^slicing.ordered = false
* identifier contains
    placerSpecimenNumber 0..1 MS
* identifier[placerSpecimenNumber] only CorrelationIdentifier
* identifier[placerSpecimenNumber].type = $v2-0203#PLAC
* identifier[placerSpecimenNumber] ^short = "Specimen number assigned by the Order Placer, e.g. on the specimen label (HL7 v2 SPM-2.1 Placer Assigned Identifier)"

* accessionIdentifier 0..1 MS
* accessionIdentifier only AccessionIdentifier
* accessionIdentifier ^short = "Laboratory number assigned when received (HL7 v2 SPM-2.2 Filler Assigned Identifier)"

* type 1..1 MS
* type ^short = "HL7 v2 SPM-4 Specimen Type (SNOMED CT specimen)"

* subject 1..1 MS
* subject only Reference(Patient)

* receivedTime MS
* receivedTime ^short = "HL7 v2 SPM-18 Specimen Received Date/Time"

* collection MS
* collection.collected[x] MS
* collection.collected[x] ^short = "HL7 v2 SPM-17 Specimen Collection Date/Time"
* collection.bodySite MS
* collection.bodySite ^short = "HL7 v2 SPM-8 Specimen Source Site"
* collection.method ^short = "HL7 v2 SPM-7 Specimen Collection Method"

* note ^short = "HL7 v2 SPM-14 Specimen Description"
