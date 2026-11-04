// SNOMED CT UK Edition PaLM (Pathology and Laboratory Medicine) value sets - the England
// equivalent of the National Genomic Test Directory (genomics) and NICIP (imaging) for
// laboratory tests that can be requested. Same rule as UK Core's
// UKCore-PathologyAndLaboratoryMedicineProcedures (fhir.r4.ukcore.stu2 2.0.2), defined here
// so this guide does not depend on UK Core. Same filter style as the Imaging IG's
// UKImagingProcedure (../Imaging/input/fsh/Terminology/Imaging.fsh), but with the codes listed.

Alias: $sct = http://snomed.info/sct

// PaLMProcedure (the PaLM requestables, codes listed) is generated into PaLMProcedure.fsh by
// scripts/palm_valueset.py.

ValueSet:       LaboratoryReportSNOMEDCT
Id:             laboratory-report-snomedct
Title:          "Laboratory Report Codes (SNOMED CT)"
Description:    """
SNOMED CT codes for `DiagnosticReport.code`: the test reported, as a [PaLM requestable](ValueSet-palm-procedure.html)
(OBR-4, for a report of one test or test group), or the report type `721981007` *Diagnostic studies
report* used by the NHS England Pathology FHIR IG.
"""
* ^status = #draft
* ^experimental = true
* include codes from valueset PaLMProcedure
* $sct#721981007 "Diagnostic studies report"
