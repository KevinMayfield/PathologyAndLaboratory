<div class="alert alert-danger" role="alert">
<b>Draft.</b> This implementation guide is a draft for discussion. It is <b>not</b> an
authoritative source and is not endorsed by NHS England, IHE or HL7. Check the cited
sources before using it for implementation.
</div>

These are HL7 v2.5.1 `ORU^R01` versions of the examples in the
[NHS England Pathology FHIR Implementation Guide - Examples Index](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/Examples/Examples-Index?version=0.5.1)
(version 0.5.1). They show what a LIMS sends ([Order Results Management [LAB-3]](LAB-3.html))
for the same reports that laboratory reporting systems send to the
[NHS England Pathology Laboratory Reporting API](PathologyReportingAPI.html) as FHIR Documents.

They were generated from the FHIR Documents in the `fhir.r4.nhsengland.pathology` package by
[`scripts/nhse_document_to_oru.py`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/scripts/nhse_document_to_oru.py),
using the FHIR to HL7 v2 rules on [Mapping HL7 v2 and FHIR](mapping.html#fhir-to-hl7-v2). The
[notebooks](https://github.com/KevinMayfield/PathologyAndLaboratory/tree/main/notebooks) convert them
back: `ORU^R01` to a FHIR Message, then the FHIR Message to a FHIR Document for the NHS England API.

### Notes

- **Patient** - the NHS England examples identify the patient by NHS Number only, but PID-5
  (name), PID-7 (date of birth) and PID-8 (sex) are required in HL7 v2. These messages use
  **NHS England EDI test patients** instead - the patients used by older versions of NHS England
  PaLM and by the [NW GMSA IG](https://nw-gmsa.github.io/en/testing.html#nhs-england-edi--test-patients).
  They exist in the NHS England INT environment (PDS), so developers can trace them:

  | NHS England example NHS Number | EDI test patient | Sex | Date of birth | Postcode |
  |---|---|---|---|---|
  | 972 771 0638 (HbA1c, CRP, Lipids/HbA1c, LFT/U&E) | 999 999 9468 EDITESTPATIENT ONE (John) | M | 1925-01-27 | B6 5RQ |
  | 972 771 0859 (HBsAg, HPV, FBC, GTT, urine MCS) | 999 999 9549 EDITESTPATIENT NINE | F | 2002-02-02 | EX1 2SS |
  {:.grid}

  PID-3 also carries a hospital number (MRN, type `MR`, assigned by York and Scarborough
  Teaching Hospitals `RCB`, the local acute trust for the requesting practice) and the
  laboratory's own patient number (type `PI`, assigned by `Y8J7D`); these are recorded in the
  NW GMSA [MRN-Mapping](https://github.com/nw-gmsa/Testing/blob/main/MRN-Mapping.md):

  | NHS Number | MRN (`RCB`) | Laboratory patient number (`Y8J7D`, `PI`) |
  |---|---|---|
  | 999 999 9468 | RCB4719263 | Y8J7D0381527 |
  | 999 999 9549 | RCB6052841 | Y8J7D0592374 |
  {:.grid}

  PID-32 = `01` (NHS Number present and verified). The requesting practice and laboratory are
  those of the NHS England examples
- **Identifiers** - order, report and specimen identifiers are sent as EI `value^namespace`,
  the namespace being the ODS code of the organisation that assigned the number. The FHIR
  `Identifier.system` (a URI) is **not** sent: the LIMS does not know it at this stage of the
  pipeline. The receiver - usually the integration engine - assigns it from an agreed table of
  (field, namespace) to system, as notebook 01 does
- **Test groups** - each ServiceRequest becomes an ORC/OBR. A test group (an NHS England
  *organizer* Observation, for example the FBC) is the OBR and its members are the OBX. A
  single test is an OBR with one OBX
- **Report** - all the OBRs share the report number (OBR-3 = `DiagnosticReport.identifier`),
  so the receiver can rebuild one DiagnosticReport
- **Text results** - multi-line `valueString` (the unstructured examples) is an OBX of type
  `FT` with `\.br\` line breaks
- **Reference ranges as text** - interpretive text (the HbA1c example) does not fit OBX-7
  (ST, no line breaks), so it is sent as a result comment (NTE after the OBX); converted back
  it becomes `Observation.note`
- **Character set** - MSH-18 = `UNICODE UTF-8` (the examples contain non-ASCII characters)
- **Units** - OBX-6 is `UCUM code^unit^UCUM` when the example gives a UCUM code, otherwise the
  unit text only (`^unit`)
- **Not carried** - specimen fasting status (GTT) has no SPM field in HL7 v2.5.1; OBR-24 is
  chosen for each specialism (the NHS England examples use the SNOMED CT specialty
  394915009 General pathology throughout)


### HbA1c-Report-Example

**Clinical Biochemistry.** A single test with a quantitative (numeric) result.

- NHS England FHIR Document: [Bundle-HbA1c-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-HbA1c-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-HbA1c-Report-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/HbA1c-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/HbA1c-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202203081209+0000||ORU^R01^ORU_R01|NHSE-EX-0001|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB4719263^^^RCB^MR~Y8J7D0381527^^^Y8J7D^PI~9999999468^^^NHS^NH||EDITESTPATIENT^ONE^John||19250127|M|||^^^^B6 5RQ|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220129-000241^B82033|REP-20220130-007843^Y8J7D||CM||||202201291024+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220129-000241^B82033|REP-20220130-007843^Y8J7D|999791000000106^Haemoglobin A1c level - International Federation of Clinical Chemistry and Laboratory Medicine standardised^SCT|||202201291018+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202201301248+0000||CH|F
OBX|1|NM|999791000000106^Haemoglobin A1c level - International Federation of Clinical Chemistry and Laboratory Medicine standardised^SCT||54|mmol/mol^mmol/mol^UCUM|||||F|||202201291018+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
NTE|1|L|DIAGNOSIS OF DIABETES MELLITUS:\.br\HbA1c of 48 mmol/mol and above is diagnostic of DM (WHO 2011)\.br\42 - 47 mmol/mol indicates high risk of DM (NICE Guidance PH38 2012)\.br\\.br\MONITORING OF DIABETES MELLITUS (ADULTS):\.br\Type 2 target values: 48 mmol/mol – 57 mmol/mol (NICE Guidelines NG28)\.br\Type 1 target values: 48 mmol/mol or lower (NICE Guidelines NG17)
SPM|1|SPC-REQ-20220129-000362&B82033^SPC-Lab-20220129-008927&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||202201291018+0000|202201291514+0000
```

### CRP-Report-Example

**Clinical Biochemistry.** A single test with a quantitative (numeric) result.

- NHS England FHIR Document: [Bundle-CRP-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-CRP-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-CRP-Report-Document-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/CRP-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/CRP-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202203081209+0000||ORU^R01^ORU_R01|NHSE-EX-0002|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB4719263^^^RCB^MR~Y8J7D0381527^^^Y8J7D^PI~9999999468^^^NHS^NH||EDITESTPATIENT^ONE^John||19250127|M|||^^^^B6 5RQ|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220307-000142^B82033|REP-20220308-004205^Y8J7D||CM||||202201291024+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220307-000142^B82033|REP-20220308-004205^Y8J7D|1001371000000100^Serum CRP (C reactive protein) level^SCT^1106741000000105^CRP (C reactive protein) mass concentration in serum^SCT|||202203071142+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202203081209+0000||CH|F
OBX|1|NM|1001371000000100^Serum CRP (C reactive protein) level^SCT^1106741000000105^CRP (C reactive protein) mass concentration in serum^SCT||200|^mg/L|0-5|H|||F|||202203071142+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
SPM|1|SPC-REQ-20220307-000105&B82033^SPC-Lab-20220307-007856&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||202203071142+0000|202203071458+0000
```

### HBsAg-Report-Example

**Immunology / Serology.** A single test with a qualitative result.

- NHS England FHIR Document: [Bundle-HBsAg-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-HBsAg-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-HBsAg-Report-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/HBsAg-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/HBsAg-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202203081209+0000||ORU^R01^ORU_R01|NHSE-EX-0003|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB6052841^^^RCB^MR~Y8J7D0592374^^^Y8J7D^PI~9999999549^^^NHS^NH||EDITESTPATIENT^NINE||20020202|F|||^^^^EX1 2SS|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220307-000004^B82033|REP-20220311-003927^Y8J7D||CM||||202203070953+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220307-000004^B82033|REP-20220311-003927^Y8J7D|1014211000000100^Hepatitis B surface antigen level^SCT^51061000237103^Hepatitis B surface antigen in serum qualitative result^SCT|||202203071321+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202203111006+0000||SR|F
OBX|1|ST|1014211000000100^Hepatitis B surface antigen level^SCT^51061000237103^Hepatitis B surface antigen in serum qualitative result^SCT||Negative||||||F|||202203071321+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
SPM|1|SPC-REQ-20220307-000051&B82033^SPC-Lab-20220307-006130&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||202203071321+0000|202203071534+0000
```

### HPV-Report-Example

**Cytology.** A single test with a qualitative result and result comments.

- NHS England FHIR Document: [Bundle-HPV-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-HPV-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-HPV-Report-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/HPV-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/HPV-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202203081209+0000||ORU^R01^ORU_R01|NHSE-EX-0004|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB6052841^^^RCB^MR~Y8J7D0592374^^^Y8J7D^PI~9999999549^^^NHS^NH||EDITESTPATIENT^NINE||20020202|F|||^^^^EX1 2SS|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220321-000017^B82033|REP-20220403-008209^Y8J7D||CM||||202203211017+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220321-000017^B82033|REP-20220403-008209^Y8J7D|50121000237101^Human papilloma virus RNA nucleic acid amplification qualitative result^SCT|||202203221104+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202204031543+0000||CP|F
OBX|1|ST|50121000237101^Human papilloma virus RNA nucleic acid amplification qualitative result^SCT||Not detected||||||F|||202203221104+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
NTE|1|L|No cytology result (HPV Screening)
NTE|2|L|Suggested management : Normal  Recall
SPM|1|SPC-REQ-20220321-000065&B82033^SPC-Lab-20220322-005962&Y8J7D||^^^^^^^^Cervical swab|||||||||||||202203221104+0000|202203221525+0000
```

### FBC-Report-Example

**Haematology.** A single test group with quantitative (numeric) results.

- NHS England FHIR Document: [Bundle-FBC-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-FBC-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-FBC-Report-Document-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/FBC-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/FBC-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202202091117+0000||ORU^R01^ORU_R01|NHSE-EX-0005|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB6052841^^^RCB^MR~Y8J7D0592374^^^Y8J7D^PI~9999999549^^^NHS^NH||EDITESTPATIENT^NINE||20020202|F|||^^^^EX1 2SS|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220129-000012^B82033|REP-20220209-001369^Y8J7D||CM||||202202070917+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220129-000012^B82033|REP-20220209-001369^Y8J7D|1022441000000101^FBC - full blood count^SCT|||202202081023+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202202091117+0000||HM|F
OBX|1|NM|1022541000000102^Total white cell count^SCT^1110441000000100^White blood cell count in blood^SCT||4.76|^10*9/L|4-11||||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|2|NM|1022451000000103^Red blood cell count^SCT||3.63|^10*12/L|4.1-5.1|L|||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|3|NM|1022431000000105^Haemoglobin estimation^SCT^1107511000000100^Haemoglobin mass concentration in blood^SCT||108|^g/L|120-150|L|||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|4|NM|1022291000000105^Haematocrit^SCT^1111571000000101^Haematocrit volume fraction of blood^SCT||0.352|^l/l|0.36-0.46|L|||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|5|NM|1022491000000106^MCV - Mean corpuscular volume^SCT^1491000237105^Erythrocytes MCV (mean corpuscular volume) in blood^SCT||97|^fL|80-100||||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|6|NM|1022471000000107^MCH - Mean corpuscular haemoglobin^SCT^1022471000000107^MCH - Mean corpuscular haemoglobin^SCT||29.8|^pg|27-32||||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|7|NM|1022481000000109^MCHC - Mean corpuscular haemoglobin concentration^SCT^1022481000000109^MCHC - Mean corpuscular haemoglobin concentration^SCT||307|^g/L|315-345|L|||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|8|NM|1022651000000100^Platelet count^SCT^1108041000000107^Platelet count in blood^SCT||143|^10*9/L|140-400||||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|9|NM|1022551000000104^Neutrophil count^SCT^1108071000000101^Neutrophil count in blood^SCT||2.66|^10*9/L|2-7||||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|10|NM|1022581000000105^Lymphocyte count^SCT^67541000237108^Lymphocyte count in blood^SCT||0.7|^10*9/L|1-3|L|||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|11|NM|1022591000000107^Monocyte count^SCT^1107991000000100^Monocyte count in blood^SCT||1.3|^10*9/L|0.2-1|H|||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|12|NM|1022561000000101^Eosinophil count^SCT^1107391000000104^Eosinophil count in blood^SCT||0.07|^10*9/L|0.02-0.5||||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|13|NM|1022571000000108^Basophil count^SCT^1106091000000103^Basophil count in blood^SCT||0.03|^10*9/L|0.01-0.1||||F|||202202081023+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
SPM|1|SPC-REQ-20220208-000016&B82033^SPC-Lab-20220208-001397&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||202202081023+0000|202202081603+0000
```

### Lipids-HbA1c-Report-Example

**Clinical Biochemistry.** A test group and a single test, with quantitative (numeric) results.

- NHS England FHIR Document: [Bundle-Lipids-HbA1c-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-Lipids-HbA1c-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-Lipids-HbA1c-Report-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/Lipids-HbA1c-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/Lipids-HbA1c-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202203081209+0000||ORU^R01^ORU_R01|NHSE-EX-0006|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB4719263^^^RCB^MR~Y8J7D0381527^^^Y8J7D^PI~9999999468^^^NHS^NH||EDITESTPATIENT^ONE^John||19250127|M|||^^^^B6 5RQ|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220704-000027-001^B82033|REP-20220706-002378^Y8J7D||CM||||202207041105+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220704-000027-001^B82033|REP-20220706-002378^Y8J7D|1005661000000103^Serum lipids level^SCT|||202207050852+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202207061049+0000||CH|F
OBX|1|NM|1005671000000105^Serum cholesterol level^SCT^1106541000000101^Cholesterol substance concentration in serum^SCT||6.1|mmol/L^mmol/L^UCUM|||||F|||202207050852+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|2|NM|1005681000000107^Serum high density lipoprotein cholesterol level^SCT^1107681000000108^HDL (high density lipoprotein) cholesterol substance concentration in serum^SCT||1.44|mmol/L^mmol/L^UCUM|||||F|||202207050852+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|3|NM|1015681000000109^Serum cholesterol/high density lipoprotein ratio^SCT^1107741000000108^HDL (high density lipoprotein) cholesterol/total cholesterol ratio in serum^SCT||4.2|^1/1|||||F|||202207050852+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|4|NM|1006191000000106^Serum non high density lipoprotein cholesterol level^SCT^12021000237106^Non-HDL (high density lipoprotein) cholesterol molar concentration in serum^SCT||4.7|mmol/L^mmol/L^UCUM|||||F|||202207050852+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
SPM|1|SPC-REQ-20220705-000004&B82033^SPC-Lab-20220705-006215&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||202207050852+0000|202207051517+0000
ORC|RE|REQ-20220704-000027-002^B82033|REP-20220706-002378^Y8J7D||CM||||202207041105+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|2|REQ-20220704-000027-002^B82033|REP-20220706-002378^Y8J7D|999791000000106^Haemoglobin A1c level - International Federation of Clinical Chemistry and Laboratory Medicine standardised^SCT|||202207050852+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202207061049+0000||CH|F
OBX|1|NM|999791000000106^Haemoglobin A1c level - International Federation of Clinical Chemistry and Laboratory Medicine standardised^SCT||38|mmol/mol^mmol/mol^UCUM|||||F|||202207050852+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
SPM|1|SPC-REQ-20220705-000004&B82033^SPC-Lab-20220705-006215&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||202207050852+0000|202207051517+0000
```

### LFT-UandE-Report-Example

**Clinical Biochemistry.** Several test groups with quantitative (numeric) results.

- NHS England FHIR Document: [Bundle-LFT-UandE-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-LFT-UandE-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-LFT-UandE-Report-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/LFT-UandE-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/LFT-UandE-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202203081209+0000||ORU^R01^ORU_R01|NHSE-EX-0007|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB4719263^^^RCB^MR~Y8J7D0381527^^^Y8J7D^PI~9999999468^^^NHS^NH||EDITESTPATIENT^ONE^John||19250127|M|||^^^^B6 5RQ|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220307-000046-001^B82033|REP-20220308-008902^Y8J7D||CM||||202203070948+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220307-000046-001^B82033|REP-20220308-008902^Y8J7D|1031081000000108^Liver function tests^SCT|||202203071002+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202203081423+0000||CH|F
OBX|1|NM|997591000000109^Serum total bilirubin level^SCT^1107221000000109^Total bilirubin substance concentration in serum^SCT||6|umol/L^umol/L^UCUM|<21||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|2|NM|1000821000000103^Serum albumin level^SCT^1105861000000106^Albumin mass concentration in serum^SCT||47|g/L^g/L^UCUM|35-50||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|3|NM|1000621000000104^Serum alkaline phosphatase level^SCT^1106051000000106^Alkaline phosphatase enzyme activity in serum^SCT||96|[iU]/L^iu/L^UCUM|30-130||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|4|NM|1018251000000107^Serum alanine aminotransferase level^SCT^1106081000000100^Alanine aminotransferase enzyme activity in serum^SCT||15|[iU]/L^iu/L^UCUM|<40||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
SPM|1|SPC-REQ-20220307-000014&B82033^SPC-Lab-20220307-007856&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||202203071002+0000|202203071454+0000
ORC|RE|REQ-20220307-000046-002^B82033|REP-20220308-008902^Y8J7D||CM||||202203070948+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|2|REQ-20220307-000046-002^B82033|REP-20220308-008902^Y8J7D|1000971000000107^Urea and electrolytes level^SCT|||202203071002+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202203081423+0000||CH|F
OBX|1|NM|1000951000000103^Serum urea level^SCT^1110281000000107^Urea substance concentration in serum^SCT||3.7|mmol/L^mmol/L^UCUM|2.5-7.8||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|2|NM|1000661000000107^Serum sodium level^SCT^1107871000000107^Sodium substance concentration in serum^SCT||139|mmol/L^mmol/L^UCUM|133-146||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|3|NM|1000651000000109^Serum potassium level^SCT^1107761000000109^Potassium substance concentration in serum^SCT||4.7|mmol/L^mmol/L^UCUM|3.5-5.3||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|4|NM|1000731000000107^Serum creatinine level^SCT^1107001000000108^Creatinine substance concentration in serum^SCT||73|umol/L^umol/L^UCUM|59-104||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
OBX|5|NM|1011481000000105^eGFR (estimated glomerular filtration rate) using creatinine Chronic Kidney Disease Epidemiology Collaboration equation per 1.73 square metres^SCT||100|mL/min/((173/100).m2)^mL/min/1.73m2^UCUM|||||F|||202203071002+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
NTE|1|L|Calculated eGFR is not valid in children or pregnancy.\.br\Less accurate with acute change in creatinine (AKI).\.br\Caution with high or low muscle mass or amputation.\.br\Avoid blood sampling within 12 hours of eating meat.\.br\Ethnicity factor comment removed Dec21 NG203.\.br\
SPM|1|SPC-REQ-20220307-000014&B82033^SPC-Lab-20220307-007856&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||202203071002+0000|202203071454+0000
```

### GTT-Unstructured-Report-Example

**Clinical Biochemistry.** A dynamic function test (three specimens), with the results as text in one result.

- NHS England FHIR Document: [Bundle-GTT-Unstructured-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-GTT-Unstructured-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-GTT-Unstructured-Report-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/GTT-Unstructured-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/GTT-Unstructured-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202203081209+0000||ORU^R01^ORU_R01|NHSE-EX-0008|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB6052841^^^RCB^MR~Y8J7D0592374^^^Y8J7D^PI~9999999549^^^NHS^NH||EDITESTPATIENT^NINE||20020202|F|||^^^^EX1 2SS|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220207-000013^B82033|REP-20220210-000218^Y8J7D||CM||||202202070920+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220207-000013^B82033|REP-20220210-000218^Y8J7D|1005711000000106^Glucose tolerance test^SCT|||20220209100123+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202202101149+0000||CH|F
NTE|1|L|Fasting glucose below 5.1, 1hr below 10.0 and 2hr below 8.5 mmol/L. Normal response to glucose load, no further action required.
OBX|1|FT|1005711000000106^Glucose tolerance test^SCT||GTT Fasting Glucose   4.8 mmol/L \.br\ GTT Glucose 60 min    8.8 mmol/L\.br\ GTT Glucose 120 min   6.4 mmol/L||||||F|||20220209100123+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
SPM|1|SPC-REQ-20220209-000082&B82033^SPC-Lab-20220209-001531&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||20220209100123+0000|20220209141706+0000
SPM|2|SPC-REQ-20220209-000083&B82033^SPC-Lab-20220209-001549&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||20220209110307+0000|20220209141706+0000
SPM|3|SPC-REQ-20220209-000084&B82033^SPC-Lab-20220209-001587&Y8J7D||^^^^^^^^Venous blood specimen|||||||||||||20220209120217+0000|20220209141706+0000
```

### Urine-MCS-Unstructured-Report-Example

**Microbiology.** A complex test (microscopy, culture and sensitivities), with the results as text in one result.

- NHS England FHIR Document: [Bundle-Urine-MCS-Unstructured-Report-Example](https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles/Bundle-Urine-MCS-Unstructured-Report-Example?version=0.5.1) (package `fhir.r4.nhsengland.pathology` 0.3.0, `Pathology-Bundle-Urine-MCS-01-Unstructured-Report-Example.json`)
- HL7 v2 file: [`examples/hl7v2/ORU_R01/Urine-MCS-Unstructured-Report-Example.hl7`](https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/Urine-MCS-Unstructured-Report-Example.hl7)

```
MSH|^~\&|LIMS|Y8J7D|GPSYSTEM|B82033|202203081209+0000||ORU^R01^ORU_R01|NHSE-EX-0009|P|2.5.1|||AL|||UNICODE UTF-8
PID|1||RCB6052841^^^RCB^MR~Y8J7D0592374^^^Y8J7D^PI~9999999549^^^NHS^NH||EDITESTPATIENT^NINE||20020202|F|||^^^^EX1 2SS|||||||||||||||||||||01
PV1|1|O|^^^^^^^^PICKERING MEDICAL PRACTICE^B82033|||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN
ORC|RE|REQ-20220221-000018^B82033|REP-20220225-006301^Y8J7D||CM||||202202211029+0000|||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN|||||||||PICKERING MEDICAL PRACTICE^^^^^^^^^B82033
OBR|1|REQ-20220221-000018^B82033|REP-20220225-006301^Y8J7D|995581000000104^Urinary microscopy, culture and sensitivities^SCT|||202202211107+0000|||||||||C1008215^GASKELL^Gale^^^Dr^^^GMC^^^^DN||||||202202251347+0000||MB|F
NTE|1|L|Likely to be clinically significant.
OBX|1|FT|995581000000104^Urinary microscopy, culture and sensitivities^SCT||Microscopy\.br\Casts  None seen\.br\White cells  >35 x10*6/L\.br\Red cells  10-35 x10*6/L\.br\Epithelial cells  +\.br\\.br\Culture\.br\1. Staphylococcus aureus   Scanty growth\.br\\.br\Sensitivities  1\.br\Flucloxacillin   S\.br\Trimethoprim  S\.br\Nitrofurantoin  R||||||F|||202202211107+0000|||||||||TD008362 PATH LAB 001^^^^^^^^^Y8J7D
SPM|1|SPC-REQ-20220221-000024&B82033^SPC-Lab-20220221-004306&Y8J7D||^^^^^^^^Urine specimen|||||||||||||202202211107+0000|202202211458+0000
```
