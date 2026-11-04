// FHIR Message equivalents of the IHE PaLM HL7 v2.5.1 messages. The MessageHeader
// eventCoding is the HL7 v2 trigger event (v2-0003), the NW GMSA convention.

Alias: $v2-0003 = http://terminology.hl7.org/CodeSystem/v2-0003

Instance: laboratory-order
InstanceOf: MessageDefinition
Title: "Message Definition - Laboratory Order (O21)"
Description: "FHIR Message equivalent of the HL7 v2.5.1 `OML^O21^OML_O21` laboratory order - Placer Order Management [LAB-1], Filler Order Management [LAB-2] and Sub-order Management [LAB-35]. The focus is the Laboratory Order."
Usage: #definition
* url = "https://examplesihe.org.uk/MessageDefinition/laboratory-order"
* name = "LaboratoryOrder"
* title = "Laboratory Order (O21)"
* status = #draft
* experimental = true
* date = "2026-11-04"
* eventCoding = $v2-0003#O21 "OML - Laboratory order"
* category = #consequence
* description = """
FHIR Message equivalent of the HL7 v2.5.1 `OML^O21^OML_O21` message, sent by the Order
Placer (EPR, GP system, order comms) to the Order Filler (LIMS) for
[Placer Order Management [LAB-1]](LAB-1.html), by the Order Filler to the Order Placer
for [Filler Order Management [LAB-2]](LAB-2.html), and by a Requester (referring
laboratory) to a Subcontractor (reference laboratory) for
[Sub-order Management [LAB-35]](LAB-35.html).

Each ORC/OBR pair becomes a [Laboratory Order](StructureDefinition-LaboratoryOrder.html),
PID a [Patient](StructureDefinition-Patient.html) and SPM a
[Specimen](StructureDefinition-Specimen.html). See [Mapping HL7 v2 and FHIR](mapping.html).

The HL7 v2 acknowledgement `ORL^O22` (or `ACK^O21`) is a FHIR response message
(`MessageHeader.response`).
"""
* focus[+]
  * code = #ServiceRequest
  * profile = "https://examplesihe.org.uk/StructureDefinition/LaboratoryOrder"
  * min = 1
  * max = "*"
* responseRequired = #always

Instance: laboratory-result
InstanceOf: MessageDefinition
Title: "Message Definition - Laboratory Result (R01)"
Description: "FHIR Message equivalent of the HL7 v2.5.1 `ORU^R01^ORU_R01` unsolicited result - Order Results Management [LAB-3] and Sub-order Results Delivery [LAB-36]. The focus is the Laboratory Report."
Usage: #definition
* url = "https://examplesihe.org.uk/MessageDefinition/laboratory-result"
* name = "LaboratoryResult"
* title = "Laboratory Result (R01)"
* status = #draft
* experimental = true
* date = "2026-11-04"
* eventCoding = $v2-0003#R01 "ORU/ACK - Unsolicited transmission of an observation message"
* category = #consequence
* description = """
FHIR Message equivalent of the HL7 v2.5.1 `ORU^R01^ORU_R01` message, sent by the Order
Filler (LIMS) to the Order Result Tracker (EPR, GP system, shared care record) for
[Order Results Management [LAB-3]](LAB-3.html), and by a Subcontractor to the Requester
for [Sub-order Results Delivery [LAB-36]](LAB-36.html).

Each OBR becomes a [Laboratory Report](StructureDefinition-LaboratoryReport.html) and each
OBX a [Laboratory Result](StructureDefinition-LaboratoryResult.html). See
[Mapping HL7 v2 and FHIR](mapping.html).

The same content can be sent as a FHIR Document - the form used by the
[NHS England Pathology Laboratory Reporting API](PathologyReportingAPI.html).

The HL7 v2 acknowledgement `ACK^R01` is a FHIR response message (`MessageHeader.response`).
"""
* focus[+]
  * code = #DiagnosticReport
  * profile = "https://examplesihe.org.uk/StructureDefinition/LaboratoryReport"
  * min = 1
  * max = "*"
* responseRequired = #always
