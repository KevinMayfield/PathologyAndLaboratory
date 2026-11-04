// Illustrative map from PaLM requestables (SNOMED CT UK) to LOINC order codes (HL7 Europe
// Laboratory lab-orderCodes-eu-lab). It only shows what such a map could look like - NHS England is
// understood to be producing the national map (To confirm). LOINC codes, displays and ORDER_OBS
// checked on tx.fhir.org (LOINC 2.83), 4 November 2026. equivalence is the target relative to the source.

Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org

Instance: palm-procedure-to-loinc
InstanceOf: ConceptMap
Title: "PaLM Requestable Tests to LOINC Order Codes (illustrative)"
Description: """
**Illustrative only.** Shows how the [PaLM Requestable Tests](ValueSet-palm-procedure.html) (SNOMED CT
UK, refset `1853561000000109`) could be mapped to LOINC order codes in the HL7 Europe Laboratory
`lab-orderCodes-eu-lab` value set (LOINC `ORDER_OBS` = Order or Both), the preferred binding for
`ServiceRequest.code` in HL7 Europe Laboratory. It covers only the tests in the NHS England examples.
It is not a national map: NHS England is understood to be producing one (**To confirm**).

LOINC panels follow US practice and their members are not the same as an England test profile (for
example an FBC or U&E), so most panel maps are `inexact`. Each laboratory decides the content of its
own profiles.
"""
Usage: #definition
* url = "https://examplesihe.org.uk/ConceptMap/palm-procedure-to-loinc"
* name = "PaLMProcedureToLOINC"
* title = "PaLM Requestable Tests to LOINC Order Codes (illustrative)"
* status = #draft
* experimental = true
* date = "2026-11-04"
* sourceCanonical = Canonical(PaLMProcedure)
* targetCanonical = "http://hl7.eu/fhir/laboratory/ValueSet/lab-orderCodes-eu-lab"
* group[+].source = $sct
* group[=].sourceVersion = "http://snomed.info/sct/83821000000107/version/20250702"
* group[=].target = $loinc

* group[=].element[+].code = #26604007
* group[=].element[=].display = "Full blood count"
* group[=].element[=].target[+].code = #57021-8
* group[=].element[=].target[=].display = "CBC W Auto Differential panel - Blood"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "An England FBC usually includes the white cell differential. Without it, 58410-2 CBC panel - Blood by Automated count. The LOINC panel members are not the same as a laboratory's FBC."

* group[=].element[+].code = #252167001
* group[=].element[=].display = "Urea and electrolytes"
* group[=].element[=].target[+].code = #24321-2
* group[=].element[=].target[=].display = "Basic metabolic 2000 panel - Serum or Plasma"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "No LOINC panel matches U&E (sodium, potassium, urea, creatinine, eGFR). The basic metabolic panel also has glucose, calcium, chloride and bicarbonate, and no eGFR."

* group[=].element[+].code = #26958001
* group[=].element[=].display = "Hepatic function panel"
* group[=].element[=].target[+].code = #24325-3
* group[=].element[=].target[=].display = "Hepatic function 2000 panel - Serum or Plasma"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "Same test, different members: the LOINC panel has AST and direct bilirubin. An England LFT is usually bilirubin, ALT, ALP, albumin and total protein, with GGT at some laboratories."

* group[=].element[+].code = #271244005
* group[=].element[=].display = "Measurement of serum lipid level"
* group[=].element[=].target[+].code = #24331-1
* group[=].element[=].target[=].display = "Lipid 1996 panel - Serum or Plasma"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "The LOINC panel is cholesterol, HDL, calculated LDL and triglyceride. An England lipid profile usually adds non-HDL cholesterol and the cholesterol/HDL ratio."

* group[=].element[+].code = #135842001
* group[=].element[=].display = "Serum C reactive protein level"
* group[=].element[=].target[+].code = #1988-5
* group[=].element[=].target[=].display = "C reactive protein [Mass/volume] in Serum or Plasma"
* group[=].element[=].target[=].equivalence = #wider
* group[=].element[=].target[=].comment = "The LOINC code is serum or plasma; the SNOMED CT concept is serum. High sensitivity CRP is a different code (30522-7)."

* group[=].element[+].code = #371981000000106
* group[=].element[=].display = "Hb A1c (Haemoglobin A1c) measurement - IFCC (International Federation of Clinical Chemistry and Laboratory Medicine) standardised"
* group[=].element[=].target[+].code = #59261-8
* group[=].element[=].target[=].display = "Hemoglobin A1c/Hemoglobin.total standardized per IFCC-RMP for CDT in Blood"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "IFCC standardised HbA1c, reported in mmol/mol."

* group[=].element[+].code = #47758006
* group[=].element[=].display = "Hepatitis B surface antigen measurement"
* group[=].element[=].target[+].code = #5195-3
* group[=].element[=].target[=].display = "Hepatitis B virus surface Ag [Presence] in Serum"
* group[=].element[=].target[=].equivalence = #narrower
* group[=].element[=].target[=].comment = "The LOINC code is a qualitative (presence) test in serum; the SNOMED CT concept does not give the scale or specimen."

* group[=].element[+].code = #700152009
* group[=].element[=].display = "Human papilloma virus screening"
* group[=].element[=].target[+].code = #82675-0
* group[=].element[=].target[=].display = "Human papilloma virus 16+18+31+33+35+39+45+51+52+56+58+59+66+68 DNA [Presence] in Cervix by NAA with probe detection"
* group[=].element[=].target[=].equivalence = #narrower
* group[=].element[=].target[=].comment = "High risk HPV as tested in NHS cervical screening. The LOINC code names the HPV types, specimen and method, so the right code depends on the assay."

* group[=].element[+].code = #113076002
* group[=].element[=].display = "Glucose tolerance test"
* group[=].element[=].target[+].code = #72171-2
* group[=].element[=].target[=].display = "Glucose tolerance 2 hours panel - Serum or Plasma"
* group[=].element[=].target[=].equivalence = #narrower
* group[=].element[=].target[=].comment = "The 2 hour (75 g) oral glucose tolerance test. Gestational and other protocols have other LOINC panels."

* group[=].element[+].code = #401324008
* group[=].element[=].display = "Urinary microscopy, culture and sensitivities"
* group[=].element[=].target[+].code = #50554-5
* group[=].element[=].target[=].display = "Urinalysis microscopic panel [#/volume] - Urine by Automated count"
* group[=].element[=].target[=].equivalence = #narrower
* group[=].element[=].target[=].comment = "No single LOINC order code for urine MC&S: it maps to microscopy, culture and susceptibility. Manual microscopy has other LOINC panels."
* group[=].element[=].target[+].code = #630-4
* group[=].element[=].target[=].display = "Bacteria identified in Urine by Culture"
* group[=].element[=].target[=].equivalence = #narrower
* group[=].element[=].target[=].comment = "The culture part of urine MC&S."
* group[=].element[=].target[+].code = #29576-6
* group[=].element[=].target[=].display = "Bacterial susceptibility panel"
* group[=].element[=].target[=].equivalence = #narrower
* group[=].element[=].target[=].comment = "The sensitivities part of urine MC&S."
