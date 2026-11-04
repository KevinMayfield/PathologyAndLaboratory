"""Create HL7 v2.5.1 ORU^R01 versions of the NHS England Pathology FHIR IG examples.

The NHS England Pathology FHIR Implementation Guide
(https://simplifier.net/guide/pathology-fhir-implementation-guide, examples index
version 0.5.1) publishes its examples as FHIR Documents. This script downloads them
from the fhir.r4.nhsengland.pathology package and writes the equivalent ORU^R01 using
the FHIR -> HL7 v2 rules on this guide's mapping page (input/pagecontent/mapping.md).

    python3 scripts/nhse_document_to_oru.py

writes examples/hl7v2/ORU_R01/*.hl7 (segments separated by CR, as HL7 v2 requires) and
input/pagecontent/NHSEnglandExamples.md. The notebooks convert the .hl7 files back to
FHIR.

The NHS England examples identify the patient by NHS Number only (there is no Patient
resource), but PID-5, PID-7 and PID-8 are required in HL7 v2. The messages therefore use
NHS England EDI test patients instead - see TEST_PATIENTS.
"""

import io
import json
import tarfile
import urllib.request
from datetime import datetime
from pathlib import Path

PACKAGE = "fhir.r4.nhsengland.pathology"
PACKAGE_VERSION = "0.3.0"
ROOT = Path(__file__).resolve().parent.parent
CACHE = ROOT / ".cache" / f"{PACKAGE}#{PACKAGE_VERSION}"
OUT = ROOT / "examples" / "hl7v2" / "ORU_R01"
PAGE = ROOT / "input" / "pagecontent" / "NHSEnglandExamples.md"
SIMPLIFIER = "https://simplifier.net/guide/pathology-fhir-implementation-guide/Home/FHIRAssets/AllAssets/Profiles/Examples/Bundles"

NHS_NUMBER = "https://fhir.nhs.uk/Id/nhs-number"
ODS = "https://fhir.nhs.uk/Id/ods-organization-code"
SCT = "http://snomed.info/sct"
LOINC = "http://loinc.org"
UCUM = "http://unitsofmeasure.org"

# Example name on the Simplifier examples index -> package file, specialism, and the
# HL7 v2 table 0074 Diagnostic Service Section (OBR-24) used for it.
EXAMPLES = [
    ("HbA1c-Report-Example", "Pathology-Bundle-HbA1c-Report-Example.json", "Clinical Biochemistry", "CH",
     "A single test with a quantitative (numeric) result."),
    ("CRP-Report-Example", "Pathology-Bundle-CRP-Report-Document-Example.json", "Clinical Biochemistry", "CH",
     "A single test with a quantitative (numeric) result."),
    ("HBsAg-Report-Example", "Pathology-Bundle-HBsAg-Report-Example.json", "Immunology / Serology", "SR",
     "A single test with a qualitative result."),
    ("HPV-Report-Example", "Pathology-Bundle-HPV-Report-Example.json", "Cytology", "CP",
     "A single test with a qualitative result and result comments."),
    ("FBC-Report-Example", "Pathology-Bundle-FBC-Report-Document-Example.json", "Haematology", "HM",
     "A single test group with quantitative (numeric) results."),
    ("Lipids-HbA1c-Report-Example", "Pathology-Bundle-Lipids-HbA1c-Report-Example.json", "Clinical Biochemistry", "CH",
     "A test group and a single test, with quantitative (numeric) results."),
    ("LFT-UandE-Report-Example", "Pathology-Bundle-LFT-UandE-Report-Example.json", "Clinical Biochemistry", "CH",
     "Several test groups with quantitative (numeric) results."),
    ("GTT-Unstructured-Report-Example", "Pathology-Bundle-GTT-Unstructured-Report-Example.json", "Clinical Biochemistry", "CH",
     "A dynamic function test (three specimens), with the results as text in one result."),
    ("Urine-MCS-Unstructured-Report-Example", "Pathology-Bundle-Urine-MCS-01-Unstructured-Report-Example.json", "Microbiology", "MB",
     "A complex test (microscopy, culture and sensitivities), with the results as text in one result."),
]

# NHS England EDI test patients (NHS England Test Data Repository), as used by the NW GMSA IG
# (https://nw-gmsa.github.io/en/testing.html#nhs-england-edi--test-patients) and by older
# versions of NHS England PaLM. They also exist in the NHS England INT environment (PDS), so
# developers can trace them. Each NHS Number in the NHS England examples is replaced by one
# of them; the sex matches the examples' content (HPV cervical screening is female).
# MRNs (York and Scarborough, RCB - the local acute trust for Pickering Medical Practice) and the
# laboratory's own patient numbers (Y8J7D, type PI) are recorded in the NW GMSA Testing repository's
# MRN-Mapping.md (https://github.com/nw-gmsa/Testing/blob/main/MRN-Mapping.md).
TEST_PATIENTS = {
    "9727710638": {"nhs_number": "9999999468", "family": "EDITESTPATIENT", "given": "ONE", "middle": "John",
                   "birth_date": "19250127", "sex": "M", "postcode": "B6 5RQ",
                   "mrn": ("RCB4719263", "RCB"), "pi": ("Y8J7D0381527", "Y8J7D")},
    "9727710859": {"nhs_number": "9999999549", "family": "EDITESTPATIENT", "given": "NINE", "middle": "",
                   "birth_date": "20020202", "sex": "F", "postcode": "EX1 2SS",
                   "mrn": ("RCB6052841", "RCB"), "pi": ("Y8J7D0592374", "Y8J7D")},
}

OBSERVATION_STATUS = {"final": "F", "preliminary": "P", "corrected": "C", "amended": "C",
                      "cancelled": "X", "entered-in-error": "W", "registered": "I"}
REPORT_STATUS = {"final": "F", "preliminary": "P", "partial": "A", "corrected": "C", "amended": "C",
                 "appended": "C", "cancelled": "X", "registered": "I", "entered-in-error": "X"}
CODING_SYSTEM = {SCT: "SCT", LOINC: "LN", UCUM: "UCUM"}


# --- helpers -------------------------------------------------------------------------

def load_package():
    """Download (once) and unpack the NHS England package into .cache/."""
    if not CACHE.exists():
        url = f"https://packages.simplifier.net/{PACKAGE}/{PACKAGE_VERSION}"
        with urllib.request.urlopen(url, timeout=120) as response:
            data = response.read()
        with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as tar:
            tar.extractall(CACHE, filter="data")
    return CACHE / "package" / "examples"


def esc(text):
    """HL7 v2 escape sequences for the encoding characters, and \\.br\\ for new lines.

    The NHS England unstructured examples contain a literal backslash-n (JSON "\\\\n")
    meaning a new line; it is treated as one here.
    """
    text = str(text).replace("\\n", "\n")
    text = (text.replace("\\", "\\E\\").replace("|", "\\F\\").replace("^", "\\S\\")
            .replace("&", "\\T\\").replace("~", "\\R\\"))
    return text.replace("\r\n", "\n").replace("\n", "\\.br\\")


def ts(value):
    """FHIR dateTime -> HL7 v2 TS, keeping the time zone."""
    if not value:
        return ""
    dt = datetime.fromisoformat(value.replace("Z", "+00:00"))
    out = dt.strftime("%Y%m%d%H%M%S" if dt.second else "%Y%m%d%H%M")
    if dt.utcoffset() is not None:
        out += dt.strftime("%z")
    return out


def seg(name, fields):
    """Build a segment from {field number: value}."""
    last = max(fields) if fields else 0
    return name + "|" + "|".join(fields.get(i, "") for i in range(1, last + 1))


def ei(identifier, namespace):
    """Identifier -> EI: value^namespace. The FHIR Identifier.system is not sent - a LIMS
    does not know it; the receiver (integration engine) assigns it from the namespace."""
    if not identifier:
        return ""
    return f"{esc(identifier['value'])}^{namespace}"


def cwe(concept):
    """CodeableConcept -> CWE: first coding in components 1-3, second in 4-6, text in 9."""
    if not concept:
        return ""
    parts = [""] * 9
    for i, coding in enumerate(concept.get("coding", [])[:2]):
        parts[i * 3] = esc(coding.get("code", ""))
        parts[i * 3 + 1] = esc(coding.get("display", ""))
        parts[i * 3 + 2] = CODING_SYSTEM.get(coding.get("system"), "L")
    if concept.get("text"):
        parts[8] = esc(concept["text"])
    return "^".join(parts).rstrip("^")


def ods(org):
    return next((i["value"] for i in org.get("identifier", []) if i.get("system") == ODS), "")


def xon(org):
    return f"{esc(org.get('name', ''))}^^^^^^^^^{ods(org)}" if org else ""


def xcn(practitioner):
    if not practitioner:
        return ""
    ident = practitioner.get("identifier", [{}])[0]
    authority = {"https://fhir.hl7.org.uk/Id/gmc-number": "GMC", "https://fhir.hl7.org.uk/Id/gmp-number": "GMP",
                 "https://fhir.hl7.org.uk/Id/nmc-number": "NMC"}.get(ident.get("system"), "L")
    name = practitioner.get("name", [{}])[0]
    return (f"{ident.get('value', '')}^{esc(name.get('family', ''))}^{esc((name.get('given') or [''])[0])}"
            f"^^^{(name.get('prefix') or [''])[0]}^^^{authority}^^^^DN")


def quantity_unit(q):
    """Quantity -> OBX-6: UCUM code^unit text^UCUM, or ^unit text when there is no code."""
    if q.get("system") == UCUM and q.get("code"):
        return f"{esc(q['code'])}^{esc(q.get('unit', q['code']))}^UCUM"
    return f"^{esc(q.get('unit', ''))}" if q.get("unit") else ""


def number(value):
    return str(value)


def obx_value(obs):
    """Observation.value[x] -> (OBX-2, OBX-5, OBX-6)."""
    if "valueQuantity" in obs:
        q = obs["valueQuantity"]
        if q.get("comparator"):
            return "SN", f"{esc(q['comparator'])}^{number(q['value'])}", quantity_unit(q)
        return "NM", number(q["value"]), quantity_unit(q)
    if "valueRange" in obs:
        r = obs["valueRange"]
        return "SN", f"^{number(r['low']['value'])}^-^{number(r['high']['value'])}", quantity_unit(r["low"])
    if "valueCodeableConcept" in obs:
        return "CWE", cwe(obs["valueCodeableConcept"]), ""
    if "valueString" in obs:
        text = obs["valueString"]
        multi_line = "\n" in text or "\\n" in text
        return ("FT" if multi_line else "ST"), esc(text), ""
    return "", "", ""


def reference_range(obs):
    rr = (obs.get("referenceRange") or [{}])[0]
    if "low" in rr and "high" in rr:
        return f"{number(rr['low']['value'])}-{number(rr['high']['value'])}"
    if "high" in rr:
        return f"<{number(rr['high']['value'])}"
    if "low" in rr:
        return f">{number(rr['low']['value'])}"
    # Interpretive text (often several lines) does not fit OBX-7 (ST) - see notes()
    return ""


def notes(obs):
    """Result comments (NTE after the OBX): Observation.note, then any reference range
    given only as text, which cannot be sent in OBX-7."""
    out = [n["text"] for n in obs.get("note", [])]
    rr = (obs.get("referenceRange") or [{}])[0]
    if "text" in rr and "low" not in rr and "high" not in rr:
        out.append(rr["text"])
    return out


# --- conversion ------------------------------------------------------------------------

def convert(bundle, obr24, message_id):
    by_url = {e["fullUrl"]: e["resource"] for e in bundle["entry"]}

    def get(ref):
        return by_url.get(ref["reference"]) if ref and "reference" in ref else None

    report = next(r for r in by_url.values() if r["resourceType"] == "DiagnosticReport")
    patient = TEST_PATIENTS[report["subject"]["identifier"]["value"]]
    lab = get(report["performer"][0])
    lab_ods = ods(lab)
    requests = [get(b) for b in report.get("basedOn", [])]

    # Requesting practitioner and organisation: PractitionerRole, or a bare Practitioner
    def requester(sr):
        who = get(sr.get("requester"))
        if who and who["resourceType"] == "PractitionerRole":
            return get(who.get("practitioner")), get(who.get("organization"))
        return who, None

    gp, gp_org = requester(requests[0])
    if gp_org is None:
        gp_org = next((o for sr in requests for o in [requester(sr)[1]] if o), None)
    gp_ods = ods(gp_org) if gp_org else ""

    lines = [
        "MSH|^~\\&|" + "|".join([
            "LIMS", lab_ods, "GPSYSTEM", gp_ods, ts(bundle["timestamp"]), "",
            "ORU^R01^ORU_R01", message_id, "P", "2.5.1", "", "", "AL", "", "", "UNICODE UTF-8"]),
        seg("PID", {1: "1", 3: f"{patient['mrn'][0]}^^^{patient['mrn'][1]}^MR"
                                f"~{patient['pi'][0]}^^^{patient['pi'][1]}^PI"
                                f"~{patient['nhs_number']}^^^NHS^NH",
                    5: f"{patient['family']}^{patient['given']}^{patient['middle']}".rstrip("^"),
                    7: patient["birth_date"], 8: patient["sex"], 11: f"^^^^{patient['postcode']}",
                    32: "01"}),
        seg("PV1", {1: "1", 2: "O", 3: f"^^^^^^^^{esc(gp_org.get('name', ''))}^{gp_ods}" if gp_org else "",
                    8: xcn(gp)}),
    ]

    filler = ei(report["identifier"][0], lab_ods)
    results = report.get("result", [])
    # Pair each order with the DiagnosticReport.result at the same position (one OBR per
    # order); any extra results go under the last order.
    groups = [[] for _ in requests]
    for i, ref in enumerate(results):
        groups[min(i, len(requests) - 1)].append(get(ref))

    for set_id, (sr, group) in enumerate(zip(requests, groups), start=1):
        sr_gp, sr_org = requester(sr)
        placer = ei(sr["identifier"][0], gp_ods)
        # A test group (organizer) is the OBR; its hasMember are the OBX. A single test
        # becomes an OBR with one OBX, using the result's code for OBR-4.
        lead = group[0]
        obr4 = cwe(lead["code"])
        leaves = []
        for obs in group:
            if obs.get("hasMember"):
                leaves.extend(get(m) for m in obs["hasMember"])
            else:
                leaves.append(obs)

        lines.append(seg("ORC", {1: "RE", 2: placer, 3: filler, 5: "CM", 9: ts(sr.get("authoredOn")),
                                 12: xcn(sr_gp or gp), 21: xon(sr_org or gp_org)}))
        lines.append(seg("OBR", {1: str(set_id), 2: placer, 3: filler, 4: obr4,
                                 7: ts(lead.get("effectiveDateTime")), 16: xcn(sr_gp or gp),
                                 22: ts(report.get("issued")), 24: obr24,
                                 25: REPORT_STATUS.get(report["status"], "F")}))
        if set_id == 1 and report.get("conclusion"):
            lines.append(seg("NTE", {1: "1", 2: "L", 3: esc(report["conclusion"])}))

        specimens = []
        for obx_id, obs in enumerate(leaves, start=1):
            value_type, value, units = obx_value(obs)
            interpretation = (obs.get("interpretation") or [{}])[0].get("coding", [{}])[0].get("code", "")
            performer = get((obs.get("performer") or [None])[0]) or lab
            lines.append(seg("OBX", {1: str(obx_id), 2: value_type, 3: cwe(obs["code"]), 5: value, 6: units,
                                     7: reference_range(obs), 8: interpretation,
                                     11: OBSERVATION_STATUS.get(obs["status"], "F"),
                                     14: ts(obs.get("effectiveDateTime")), 23: xon(performer)}))
            for nte_id, note in enumerate(notes(obs), start=1):
                lines.append(seg("NTE", {1: str(nte_id), 2: "L", 3: esc(note)}))
            if obs.get("specimen"):
                spec = get(obs["specimen"])
                if spec and spec not in specimens:
                    specimens.append(spec)
        if not specimens:
            specimens = [get(s) for s in report.get("specimen", [])]

        for spm_id, spec in enumerate(specimens, start=1):
            placer_spec = spec.get("identifier", [{}])[0]
            accession = spec.get("accessionIdentifier", {})
            spm2 = f"{esc(placer_spec.get('value', ''))}&{gp_ods}^{esc(accession.get('value', ''))}&{lab_ods}"
            spec_type = spec.get("type", {})
            spm4 = cwe(spec_type) if spec_type.get("coding") else f"^^^^^^^^{esc(spec_type.get('text', ''))}"
            collected = spec.get("collection", {}).get("collectedDateTime")
            lines.append(seg("SPM", {1: str(spm_id), 2: spm2, 4: spm4, 17: ts(collected),
                                     18: ts(spec.get("receivedTime"))}))
    return "\r".join(lines) + "\r"


def main():
    examples_dir = load_package()
    OUT.mkdir(parents=True, exist_ok=True)
    page = [PAGE_HEADER]
    for n, (name, file, specialism, obr24, summary) in enumerate(EXAMPLES, start=1):
        bundle = json.loads((examples_dir / file).read_text())
        message = convert(bundle, obr24, f"NHSE-EX-{n:04d}")
        (OUT / f"{name}.hl7").write_bytes(message.encode("utf-8"))
        page.append(f"### {name}\n\n**{specialism}.** {summary}\n\n"
                    f"- NHS England FHIR Document: [Bundle-{name}]({SIMPLIFIER}/Bundle-{name}?version=0.5.1) "
                    f"(package `{PACKAGE}` {PACKAGE_VERSION}, `{file}`)\n"
                    f"- HL7 v2 file: [`examples/hl7v2/ORU_R01/{name}.hl7`]"
                    f"(https://github.com/KevinMayfield/PathologyAndLaboratory/blob/main/examples/hl7v2/ORU_R01/{name}.hl7)\n\n"
                    "```\n" + message.replace("\r", "\n") + "```\n")
        print("wrote", OUT / f"{name}.hl7")
    PAGE.write_text("\n".join(page))
    print("wrote", PAGE)


PAGE_HEADER = """<div class="alert alert-danger" role="alert">
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
  `FT` with `\\.br\\` line breaks
- **Reference ranges as text** - interpretive text (the HbA1c example) does not fit OBX-7
  (ST, no line breaks), so it is sent as a result comment (NTE after the OBX); converted back
  it becomes `Observation.note`
- **Character set** - MSH-18 = `UNICODE UTF-8` (the examples contain non-ASCII characters)
- **Units** - OBX-6 is `UCUM code^unit^UCUM` when the example gives a UCUM code, otherwise the
  unit text only (`^unit`)
- **Not carried** - specimen fasting status (GTT) has no SPM field in HL7 v2.5.1; OBR-24 is
  chosen for each specialism (the NHS England examples use the SNOMED CT specialty
  394915009 General pathology throughout)

"""

if __name__ == "__main__":
    main()
