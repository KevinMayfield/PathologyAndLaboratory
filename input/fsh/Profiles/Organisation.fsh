// Organisations and people who request, perform and report laboratory tests.
// Derived from HL7 Europe Core so they can be referenced from the HL7 Europe
// Laboratory profiles (which restrict their references to the EU Core profiles).
// NHS England's Pathology Laboratory Reporting API uses UK Core for these
// (UKCore-Organization, UKCore-Practitioner, UKCore-PractitionerRole) - see the
// Data Models page.

Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code

Profile:        Organization
Parent:         http://hl7.eu/fhir/base/StructureDefinition/organization-eu-core
Id:             Organization
Title:          "Organization"
Description:    """
`Care Services` An NHS organisation - a requesting GP practice or trust, or a laboratory (Order Filler). Identified by its ODS code.

HL7 v2: MSH-4 Sending Facility / MSH-6 Receiving Facility, ORC-21 Ordering Facility Name, OBX-23 Performing Organization Name, PV1-3 (requesting location).
"""

* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the system"
* identifier ^slicing.ordered = false
* identifier contains odsCode 0..1 MS
* identifier[odsCode] only OrganisationCode
* identifier[odsCode] ^short = "ODS Code (HL7 v2 XON-10 / HD-1)"
* name MS

Profile:        Practitioner
Parent:         http://hl7.eu/fhir/base/StructureDefinition/practitioner-eu-core
Id:             Practitioner
Title:          "Practitioner"
Description:    """
`Care Services` A clinician who requests (ORC-12 / OBR-16 Ordering Provider, PV1-8 Referring Doctor) or reports (OBR-32 Principal Result Interpreter, OBX-16 Responsible Observer) a laboratory test.
"""

* identifier 1..* MS
* identifier only PractitionerIdentifier
* identifier ^short = "GMC, NMC, HCPC or GP (GMP) code (HL7 v2 XCN-1, with XCN-9 Assigning Authority)"
* name MS

Profile:        PractitionerRole
Parent:         http://hl7.eu/fhir/base/StructureDefinition/practitionerRole-eu-core
Id:             PractitionerRole
Title:          "PractitionerRole"
Description:    """
`Care Services` A practitioner working for an organisation. The requester of a laboratory order: NHS England's Pathology Laboratory Reporting API finds the ODS code of the requesting organisation through `ServiceRequest.requester` → `PractitionerRole.organization` → `Organization.identifier`.
"""

* practitioner 1..1 MS
* practitioner only Reference(Practitioner)
* organization 1..1 MS
* organization only Reference(Organization)
* organization.identifier only OrganisationCode
