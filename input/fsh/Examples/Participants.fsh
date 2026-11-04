// People and organisations used by the examples. Scenario: a GP at Example Surgery
// (ODS A12345, the example code used by NHS England's Pathology Laboratory Reporting
// API) requests a full blood count from the Manchester University NHS Foundation
// Trust (ODS R0A) laboratory. Octavia CHISLETT is the NW GMSA IG test patient.

Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code
Alias: $nhs-number = https://fhir.nhs.uk/Id/nhs-number
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203

Instance: PatientOctaviaCHISLETT
InstanceOf: Patient
Title: "Patient - Octavia CHISLETT"
Description: "Test patient (NHS Number 9449305552), HL7 v2 `PID|1||633^^^R0A^MR~9449305552^^^NHS^NH||CHISLETT^Octavia^^^Miss||20080920|F|||1 RAVENSFIELD GARDENS^^EPSOM^SURREY^KT19 0ST`."
Usage: #example
* identifier[nhsNumber].system = $nhs-number
* identifier[nhsNumber].value = "9449305552"
* identifier[nhsNumber].type = $v2-0203#NH
* identifier[MedicalRecordNumber].type = $v2-0203#MR
* identifier[MedicalRecordNumber].system = "https://fhir.mft.nhs.uk/Id/mrn"
* identifier[MedicalRecordNumber].value = "633"
* identifier[MedicalRecordNumber].assigner.identifier.system = $ods-code
* identifier[MedicalRecordNumber].assigner.identifier.value = "R0A"
* name.family = "CHISLETT"
* name.given = "Octavia"
* name.prefix = "Miss"
* gender = #female
* birthDate = "2008-09-20"
* address.line = "1 RAVENSFIELD GARDENS"
* address.city = "EPSOM"
* address.district = "SURREY"
* address.postalCode = "KT19 0ST"

Instance: OrganizationExampleSurgery
InstanceOf: Organization
Title: "Organization - Example Surgery (A12345)"
Description: "The requesting GP practice (Order Placer)."
Usage: #example
* identifier[odsCode].system = $ods-code
* identifier[odsCode].value = "A12345"
* name = "Example Surgery"

Instance: OrganizationMFT
InstanceOf: Organization
Title: "Organization - Manchester University NHS Foundation Trust (R0A)"
Description: "The laboratory (Order Filler)."
Usage: #example
* identifier[odsCode].system = $ods-code
* identifier[odsCode].value = "R0A"
* name = "Manchester University NHS Foundation Trust"

Instance: PractitionerGP
InstanceOf: Practitioner
Title: "Practitioner - Dr Alex GREEN (GP)"
Description: "The requesting GP. HL7 v2 XCN `G1234567^GREEN^Alex^^^Dr^^^GMP^^^^DN`."
Usage: #example
* identifier.system = "https://fhir.hl7.org.uk/Id/gmp-number"
* identifier.value = "G1234567"
* name.family = "GREEN"
* name.given = "Alex"
* name.prefix = "Dr"

Instance: PractitionerRoleGP
InstanceOf: PractitionerRole
Title: "PractitionerRole - Dr Alex GREEN at Example Surgery"
Description: "The requester of the order. NHS England's Pathology Laboratory Reporting API reads the requesting ODS code through this PractitionerRole."
Usage: #example
* practitioner = Reference(PractitionerGP)
* organization = Reference(OrganizationExampleSurgery)
* organization.identifier.system = $ods-code
* organization.identifier.value = "A12345"

Instance: PractitionerHaematologist
InstanceOf: Practitioner
Title: "Practitioner - Dr Sam HUGHES (Consultant Haematologist)"
Description: "The authorising clinician (HL7 v2 OBR-32 Principal Result Interpreter)."
Usage: #example
* identifier.system = "https://fhir.hl7.org.uk/Id/gmc-number"
* identifier.value = "7654321"
* name.family = "HUGHES"
* name.given = "Sam"
* name.prefix = "Dr"

Instance: PractitionerRoleHaematologist
InstanceOf: PractitionerRole
Title: "PractitionerRole - Dr Sam HUGHES at Manchester University NHS Foundation Trust"
Description: "The results interpreter."
Usage: #example
* practitioner = Reference(PractitionerHaematologist)
* organization = Reference(OrganizationMFT)
