// Full blood count order and result. The HL7 v2.5.1 equivalents are on the
// LAB-1 and LAB-3 pages. SNOMED CT codes are UK Edition (PaLM) observable entities,
// with LOINC as a second coding; both checked on tx.fhir.org 2026-11-04.

Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org
Alias: $ucum = http://unitsofmeasure.org
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $v2-0074 = http://terminology.hl7.org/CodeSystem/v2-0074
Alias: $obs-cat = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $interp = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation

// Orders

Instance: LaboratoryOrderFBCNew
InstanceOf: LaboratoryOrder
Title: "Laboratory Order - Full blood count (new order)"
Description: "The order as placed by the GP system - HL7 v2 `ORC|NW|GP-ORD-000123^GPSYSTEM|||||||20261103091000|||G1234567^GREEN^Alex^^^Dr^^^GMP^^^^DN` and `OBR|1|GP-ORD-000123^GPSYSTEM||26604007^Complete blood count^SCT`. Placer Order Management [LAB-1]."
Usage: #example
* identifier[placerOrderNumber].type = $v2-0203#PLAC
* identifier[placerOrderNumber].system = "https://fhir.examplesurgery.nhs.uk/Id/order"
* identifier[placerOrderNumber].value = "GP-ORD-000123"
* identifier[placerOrderNumber].assigner.identifier.system = $ods-code
* identifier[placerOrderNumber].assigner.identifier.value = "A12345"
* requisition.system = "https://fhir.examplesurgery.nhs.uk/Id/requisition"
* requisition.value = "GP-REQ-000045"
* status = #active
* intent = #order
* priority = #routine
* code = $sct#26604007 "Complete blood count"
* subject = Reference(PatientOctaviaCHISLETT)
* authoredOn = "2026-11-03T09:10:00Z"
* requester = Reference(PractitionerRoleGP)
* performer = Reference(OrganizationMFT)
* reasonCode.text = "Tiredness"
* note.text = "Tired all the time for 3 months. ? anaemia"

Instance: LaboratoryOrderFBC
InstanceOf: LaboratoryOrder
Title: "Laboratory Order - Full blood count (accepted by the laboratory)"
Description: "The same order once the laboratory (Order Filler) has assigned its Filler Order Number - HL7 v2 ORC-3 / OBR-3 `26H012345^LIMS`."
Usage: #example
* identifier[placerOrderNumber].type = $v2-0203#PLAC
* identifier[placerOrderNumber].system = "https://fhir.examplesurgery.nhs.uk/Id/order"
* identifier[placerOrderNumber].value = "GP-ORD-000123"
* identifier[placerOrderNumber].assigner.identifier.system = $ods-code
* identifier[placerOrderNumber].assigner.identifier.value = "A12345"
* identifier[fillerOrderNumber].type = $v2-0203#FILL
* identifier[fillerOrderNumber].system = "https://fhir.mft.nhs.uk/Id/lims-order"
* identifier[fillerOrderNumber].value = "26H012345"
* identifier[fillerOrderNumber].assigner.identifier.system = $ods-code
* identifier[fillerOrderNumber].assigner.identifier.value = "R0A"
* requisition.system = "https://fhir.examplesurgery.nhs.uk/Id/requisition"
* requisition.value = "GP-REQ-000045"
* status = #completed
* intent = #order
* priority = #routine
* code = $sct#26604007 "Complete blood count"
* subject = Reference(PatientOctaviaCHISLETT)
* authoredOn = "2026-11-03T09:10:00Z"
* requester = Reference(PractitionerRoleGP)
* performer = Reference(OrganizationMFT)
* specimen = Reference(SpecimenFBC)
* reasonCode.text = "Tiredness"
* note.text = "Tired all the time for 3 months. ? anaemia"

// Specimen

Instance: SpecimenFBC
InstanceOf: Specimen
Title: "Specimen - Blood (EDTA) for full blood count"
Description: "HL7 v2 `SPM|1|GP-SPC-000123^26H012345||119297000^Blood specimen^SCT|||||||||||||20261103091500|20261103134000`."
Usage: #example
* identifier[placerSpecimenNumber].type = $v2-0203#PLAC
* identifier[placerSpecimenNumber].system = "https://fhir.examplesurgery.nhs.uk/Id/specimen"
* identifier[placerSpecimenNumber].value = "GP-SPC-000123"
* accessionIdentifier.type = $v2-0203#ACSN
* accessionIdentifier.system = "https://fhir.mft.nhs.uk/Id/lims-accession"
* accessionIdentifier.value = "26H012345"
* accessionIdentifier.assigner.identifier.system = $ods-code
* accessionIdentifier.assigner.identifier.value = "R0A"
* status = #available
* type = $sct#119297000 "Blood specimen"
* subject = Reference(PatientOctaviaCHISLETT)
* receivedTime = "2026-11-03T13:40:00Z"
* collection.collectedDateTime = "2026-11-03T09:15:00Z"

// Report

RuleSet: LaboratoryReportFBCContent
* identifier[fillerOrderNumber].type = $v2-0203#FILL
* identifier[fillerOrderNumber].system = "https://fhir.mft.nhs.uk/Id/lims-order"
* identifier[fillerOrderNumber].value = "26H012345"
* identifier[fillerOrderNumber].assigner.identifier.system = $ods-code
* identifier[fillerOrderNumber].assigner.identifier.value = "R0A"
* basedOn = Reference(LaboratoryOrderFBC)
* status = #final
* category = $v2-0074#HM "Hematology"
* code.coding[+] = $sct#26604007 "Complete blood count"
* code.coding[+] = $loinc#58410-2 "CBC panel - Blood by Automated count"
* subject = Reference(PatientOctaviaCHISLETT)
* effectiveDateTime = "2026-11-03T09:15:00Z"
* issued = "2026-11-03T16:05:00Z"
* performer = Reference(OrganizationMFT)
* resultsInterpreter = Reference(PractitionerRoleHaematologist)
* specimen = Reference(SpecimenFBC)
* result[+] = Reference(ResultFBCWhiteCellCount)
* result[+] = Reference(ResultFBCHaemoglobin)
* result[+] = Reference(ResultFBCPlateletCount)
* result[+] = Reference(ResultFBCRedCellCount)
* result[+] = Reference(ResultFBCHaematocrit)
* result[+] = Reference(ResultFBCMeanCellVolume)
* result[+] = Reference(ResultFBCMeanCellHaemoglobin)
* conclusion = "Mild anaemia with low white cell count. Suggest repeat in 4 weeks."

Instance: LaboratoryReportFBC
InstanceOf: LaboratoryReport
Title: "Laboratory Report - Full blood count"
Description: "HL7 v2 `OBR|1|GP-ORD-000123^GPSYSTEM|26H012345^LIMS|26604007^Complete blood count^SCT|||20261103091500|...|20261103160500|||F` with seven OBX results. Order Results Management [LAB-3]."
Usage: #example
* insert LaboratoryReportFBCContent

Instance: LaboratoryReportFBCDocument
InstanceOf: LaboratoryReport
Title: "Laboratory Report - Full blood count (in a FHIR Document)"
Description: "The same report as it appears in the [FHIR Document](Bundle-LaboratoryReportDocumentFBC.html): it also conforms to HL7 Europe DiagnosticReport-eu-lab, which links the report to its Composition with the R5 `DiagnosticReport.composition` extension."
Usage: #inline
* meta.profile[+] = "https://fhir.nwgenomics.nhs.uk/PaLM/StructureDefinition/LaboratoryReport"
* meta.profile[+] = "http://hl7.eu/fhir/laboratory/StructureDefinition/DiagnosticReport-eu-lab"
* id = "LaboratoryReportFBCDocument"
* extension[DiagnosticReportCompositionR5].valueReference = Reference(Composition/CompositionFBC)
* insert LaboratoryReportFBCContent

// Results

RuleSet: FBCResult(sctCode, sctDisplay, loincCode, loincDisplay)
* status = #final
* category[laboratory] = $obs-cat#laboratory
* code.coding[+] = $sct#{sctCode} "{sctDisplay}"
* code.coding[+] = $loinc#{loincCode} "{loincDisplay}"
* subject = Reference(PatientOctaviaCHISLETT)
* basedOn = Reference(LaboratoryOrderFBC)
* effectiveDateTime = "2026-11-03T09:15:00Z"
* issued = "2026-11-03T16:05:00Z"
* performer = Reference(OrganizationMFT)
* specimen = Reference(SpecimenFBC)

RuleSet: QuantityResult(value, unit, low, high)
* valueQuantity = {value} '{unit}' "{unit}"
* referenceRange.low = {low} '{unit}' "{unit}"
* referenceRange.high = {high} '{unit}' "{unit}"

Instance: ResultFBCWhiteCellCount
InstanceOf: LaboratoryResult
Title: "Laboratory Result - Total white cell count"
Description: "HL7 v2 `OBX|1|NM|1022541000000102^Total white cell count^SCT||3.5|10*9/L^^UCUM|4.0-11.0|L|||F|||20261103091500`."
Usage: #example
* insert FBCResult(1022541000000102, Total white cell count, 6690-2, Leukocytes [#/volume] in Blood by Automated count)
* insert QuantityResult(3.5, 10*9/L, 4.0, 11.0)
* interpretation = $interp#L "Low"

Instance: ResultFBCHaemoglobin
InstanceOf: LaboratoryResult
Title: "Laboratory Result - Haemoglobin"
Description: "HL7 v2 `OBX|2|NM|1022431000000105^Haemoglobin estimation^SCT||112|g/L^^UCUM|115-165|L|||F|||20261103091500`."
Usage: #example
* insert FBCResult(1022431000000105, Haemoglobin estimation, 718-7, Hemoglobin [Mass/volume] in Blood)
* insert QuantityResult(112, g/L, 115, 165)
* interpretation = $interp#L "Low"

Instance: ResultFBCPlateletCount
InstanceOf: LaboratoryResult
Title: "Laboratory Result - Platelet count"
Description: "HL7 v2 `OBX|3|NM|1022651000000100^Platelet count^SCT||250|10*9/L^^UCUM|150-400|N|||F|||20261103091500`."
Usage: #example
* insert FBCResult(1022651000000100, Platelet count, 777-3, Platelets [#/volume] in Blood by Automated count)
* insert QuantityResult(250, 10*9/L, 150, 400)
* interpretation = $interp#N "Normal"

Instance: ResultFBCRedCellCount
InstanceOf: LaboratoryResult
Title: "Laboratory Result - Red blood cell count"
Description: "HL7 v2 `OBX|4|NM|1022451000000103^Red blood cell count^SCT||4.20|10*12/L^^UCUM|3.80-5.80|N|||F|||20261103091500`."
Usage: #example
* insert FBCResult(1022451000000103, Red blood cell count, 789-8, Erythrocytes [#/volume] in Blood by Automated count)
* insert QuantityResult(4.20, 10*12/L, 3.80, 5.80)
* interpretation = $interp#N "Normal"

Instance: ResultFBCHaematocrit
InstanceOf: LaboratoryResult
Title: "Laboratory Result - Haematocrit"
Description: "HL7 v2 `OBX|5|NM|1022291000000105^Haematocrit^SCT||0.38|L/L^^UCUM|0.37-0.47|N|||F|||20261103091500`."
Usage: #example
* insert FBCResult(1022291000000105, Haematocrit, 4544-3, Hematocrit [Volume Fraction] of Blood by Automated count)
* insert QuantityResult(0.38, L/L, 0.37, 0.47)
* interpretation = $interp#N "Normal"

Instance: ResultFBCMeanCellVolume
InstanceOf: LaboratoryResult
Title: "Laboratory Result - Mean cell volume"
Description: "HL7 v2 `OBX|6|NM|1022491000000106^Mean cell volume^SCT||88|fL^^UCUM|80-100|N|||F|||20261103091500`."
Usage: #example
* insert FBCResult(1022491000000106, Mean cell volume, 787-2, MCV [Entitic mean volume] in Red Blood Cells by Automated count)
* insert QuantityResult(88, fL, 80, 100)
* interpretation = $interp#N "Normal"

Instance: ResultFBCMeanCellHaemoglobin
InstanceOf: LaboratoryResult
Title: "Laboratory Result - Mean cell haemoglobin"
Description: "HL7 v2 `OBX|7|NM|1022471000000107^Mean cell haemoglobin^SCT||29.0|pg^^UCUM|27.0-33.0|N|||F|||20261103091500`."
Usage: #example
* insert FBCResult(1022471000000107, Mean cell haemoglobin, 785-6, MCH [Entitic mass] by Automated count)
* insert QuantityResult(29.0, pg, 27.0, 33.0)
* interpretation = $interp#N "Normal"
