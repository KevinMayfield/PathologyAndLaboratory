// HL7 v2 table to FHIR code mappings used by the HL7 v2 to FHIR conversion.
// These are indicative and are based on the HL7 v2-to-FHIR IG vocabulary maps
// (https://build.fhir.org/ig/HL7/v2-to-fhir/) - see mapping.md. The reverse
// (FHIR to HL7 v2) uses the same rows read right to left.

RuleSet: ConceptMapHeader(id, name, title, source, target)
* url = "https://fhir.nwgenomics.nhs.uk/PaLM/ConceptMap/{id}"
* name = "{name}"
* title = "{title}"
* status = #draft
* experimental = true
* date = "2026-11-04"
* sourceUri = "http://terminology.hl7.org/ValueSet/{source}"
* targetUri = "http://hl7.org/fhir/ValueSet/{target}"

RuleSet: Map(source, target, equivalence)
* group[=].element[+].code = #{source}
* group[=].element[=].target[+].code = #{target}
* group[=].element[=].target[=].equivalence = #{equivalence}

RuleSet: Unmatched(source, comment)
* group[=].element[+].code = #{source}
* group[=].element[=].target[+].equivalence = #unmatched
* group[=].element[=].target[=].comment = "{comment}"

Instance: v2-0123-to-diagnostic-report-status
InstanceOf: ConceptMap
Title: "HL7 v2 Result Status (OBR-25) to DiagnosticReport.status"
Description: "HL7 v2 table 0123 Result Status (OBR-25) to FHIR `DiagnosticReport.status`. Indicative, based on the HL7 v2-to-FHIR IG."
Usage: #definition
* insert ConceptMapHeader(v2-0123-to-diagnostic-report-status, V20123ToDiagnosticReportStatus, HL7 v2 Result Status to DiagnosticReport.status, v2-0123, diagnostic-report-status)
* group[+].source = "http://terminology.hl7.org/CodeSystem/v2-0123"
* group[=].target = "http://hl7.org/fhir/diagnostic-report-status"
* insert Map(O, registered, wider)
* insert Map(I, registered, wider)
* insert Map(S, partial, wider)
* insert Map(A, partial, wider)
* insert Map(P, preliminary, equivalent)
* insert Map(C, corrected, equivalent)
* insert Map(R, partial, wider)
* insert Map(F, final, equivalent)
* insert Map(X, cancelled, equivalent)
* insert Unmatched(Y, No order on record for this test - reject the message)
* insert Unmatched(Z, No record of this patient - reject the message)

Instance: v2-0085-to-observation-status
InstanceOf: ConceptMap
Title: "HL7 v2 Observation Result Status (OBX-11) to Observation.status"
Description: "HL7 v2 table 0085 Observation Result Status Codes Interpretation (OBX-11) to FHIR `Observation.status`. Indicative, based on the HL7 v2-to-FHIR IG."
Usage: #definition
* insert ConceptMapHeader(v2-0085-to-observation-status, V20085ToObservationStatus, HL7 v2 Observation Result Status to Observation.status, v2-0085, observation-status)
* group[+].source = "http://terminology.hl7.org/CodeSystem/v2-0085"
* group[=].target = "http://hl7.org/fhir/observation-status"
* insert Map(C, corrected, equivalent)
* insert Map(D, entered-in-error, wider)
* insert Map(F, final, equivalent)
* insert Map(I, registered, equivalent)
* insert Map(N, cancelled, wider)
* group[=].element[=].target[=].comment = "Not asked - also set Observation.dataAbsentReason = not-asked"
* insert Map(O, registered, wider)
* insert Map(P, preliminary, equivalent)
* insert Map(R, preliminary, wider)
* insert Map(S, preliminary, wider)
* insert Map(U, final, wider)
* insert Map(W, entered-in-error, equivalent)
* insert Map(X, cancelled, wider)
* group[=].element[=].target[=].comment = "Results cannot be obtained - also set Observation.dataAbsentReason"

Instance: v2-0001-to-administrative-gender
InstanceOf: ConceptMap
Title: "HL7 v2 Administrative Sex (PID-8) to Patient.gender"
Description: "HL7 v2 table 0001 Administrative Sex (PID-8) to FHIR `Patient.gender`. Indicative, based on the HL7 v2-to-FHIR IG."
Usage: #definition
* insert ConceptMapHeader(v2-0001-to-administrative-gender, V20001ToAdministrativeGender, HL7 v2 Administrative Sex to Patient.gender, v2-0001, administrative-gender)
* group[+].source = "http://terminology.hl7.org/CodeSystem/v2-0001"
* group[=].target = "http://hl7.org/fhir/administrative-gender"
* insert Map(F, female, equivalent)
* insert Map(M, male, equivalent)
* insert Map(O, other, equivalent)
* insert Map(U, unknown, equivalent)
* insert Map(A, other, wider)
* insert Map(N, unknown, wider)

Instance: v2-0485-to-request-priority
InstanceOf: ConceptMap
Title: "HL7 v2 Extended Priority (TQ1-9) to ServiceRequest.priority"
Description: "HL7 v2 table 0485 Extended Priority Codes (TQ1-9) to FHIR `ServiceRequest.priority`. Indicative, based on the HL7 v2-to-FHIR IG. The absence of TQ1 means routine."
Usage: #definition
* insert ConceptMapHeader(v2-0485-to-request-priority, V20485ToRequestPriority, HL7 v2 Extended Priority to ServiceRequest.priority, v2-0485, request-priority)
* group[+].source = "http://terminology.hl7.org/CodeSystem/v2-0485"
* group[=].target = "http://hl7.org/fhir/request-priority"
* insert Map(S, stat, equivalent)
* insert Map(A, asap, equivalent)
* insert Map(R, routine, equivalent)
* insert Map(P, urgent, wider)
* insert Map(C, urgent, wider)
* insert Map(T, urgent, wider)
* insert Unmatched(PRN, As needed - not a priority in FHIR; use ServiceRequest.asNeeded[x])

Instance: v2-0119-to-request-status
InstanceOf: ConceptMap
Title: "HL7 v2 Order Control (ORC-1) to ServiceRequest.status"
Description: "HL7 v2 table 0119 Order Control Codes (ORC-1) to FHIR `ServiceRequest.status`, for the codes used by Placer Order Management [LAB-1] and Filler Order Management [LAB-2]. Indicative."
Usage: #definition
* insert ConceptMapHeader(v2-0119-to-request-status, V20119ToRequestStatus, HL7 v2 Order Control to ServiceRequest.status, v2-0119, request-status)
* group[+].source = "http://terminology.hl7.org/CodeSystem/v2-0119"
* group[=].target = "http://hl7.org/fhir/request-status"
* insert Map(NW, active, wider)
* group[=].element[=].target[=].comment = "New order (LAB-1)"
* insert Map(SN, active, wider)
* group[=].element[=].target[=].comment = "Send order number - new order created by the Order Filler (LAB-2)"
* insert Map(CA, revoked, wider)
* group[=].element[=].target[=].comment = "Cancel order request (placer)"
* insert Map(OC, revoked, wider)
* group[=].element[=].target[=].comment = "Order cancelled (filler)"
* insert Map(DC, revoked, wider)
* group[=].element[=].target[=].comment = "Discontinue order request"
* insert Map(SC, active, wider)
* group[=].element[=].target[=].comment = "Status changed - the order status is in ORC-5"
* insert Map(OK, active, wider)
* group[=].element[=].target[=].comment = "Order accepted and OK (response)"
* insert Map(UA, revoked, wider)
* group[=].element[=].target[=].comment = "Unable to accept order (response)"
* insert Map(XO, active, wider)
* group[=].element[=].target[=].comment = "Change order request"

Instance: v2-0078-to-observation-interpretation
InstanceOf: ConceptMap
Title: "HL7 v2 Interpretation Codes (OBX-8) to Observation.interpretation"
Description: "HL7 v2 table 0078 Interpretation Codes (OBX-8 Abnormal Flags) to FHIR `Observation.interpretation` (v3 ObservationInterpretation). The codes are the same in both."
Usage: #definition
* insert ConceptMapHeader(v2-0078-to-observation-interpretation, V20078ToObservationInterpretation, HL7 v2 Abnormal Flags to Observation.interpretation, v2-0078, observation-interpretation)
* group[+].source = "http://terminology.hl7.org/CodeSystem/v2-0078"
* group[=].target = "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
* insert Map(N, N, equivalent)
* insert Map(L, L, equivalent)
* insert Map(H, H, equivalent)
* insert Map(LL, LL, equivalent)
* insert Map(HH, HH, equivalent)
* insert Map(A, A, equivalent)
* insert Map(AA, AA, equivalent)
* insert Map(S, S, equivalent)
* insert Map(R, R, equivalent)
* insert Map(I, I, equivalent)
* insert Map(POS, POS, equivalent)
* insert Map(NEG, NEG, equivalent)
