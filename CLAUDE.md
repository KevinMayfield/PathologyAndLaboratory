# CLAUDE.md

Draft FHIR Implementation Guide: an **England Pathology and Laboratory Medicine
(PaLM) Technical Framework** - the IHE PaLM Technical Framework localised for
England, covering HL7 v2.5.1 and HL7 FHIR R4 and how to map between them. Like the
NW GMSA FHIR IG (`../FHIRGenomics`, https://nw-gmsa.github.io/en/) it supports both
HL7 v2 and FHIR.

## Scope

- **Draft only.** Every page starts with the red "Draft" alert box (copy it from an
  existing page). Never present content as authoritative or endorsed by NHS England,
  IHE or HL7.
- Laboratory medicine specialisms in the NHS England Pathology and Laboratory
  Medicine Reporting standard (DAPB4101): clinical biochemistry, haematology,
  immunology, transfusion, microbiology. Cellular pathology belongs in
  `../CancerPathologyReport`; genomics in `../FHIRGenomics` - link, don't repeat.
- Sources: IHE PaLM TF, NHS England Pathology Laboratory Reporting FHIR API (and its
  OAS file) and MNS test-result-stored event, NW GMSA HL7 v2 page, DHCW HL7
  ORU_R01 2.5.1 IG. HL7 v2 version is 2.5.1; FHIR is R4 (4.0.1).

## Layout

- FSH: `input/fsh/` - `DataTypes/` (copied from NW GMSA via Imaging), `Profiles/`,
  `Messaging/` (MessageHeader, BundleMessage, MessageDefinitions), `Terminology/`
  (HL7 v2 table ConceptMaps), `Mappings/` (FSH `Mapping:` to HL7 v2, id `palm-v2`),
  `Examples/`.
- Pages: `input/pagecontent/`, organised as IHE volumes - Volume 1 Analysis and
  Design, Volume 2 Interactions (LAB-1, LAB-2, LAB-3, LAB-35, LAB-36, NHS England
  API), Volume 3 Data Models, Volume 4 HL7 v2 and Mapping (`hl7v2.md`, `mapping.md`).
- A new page must be added to both `pages:` and `menu:` in `sushi-config.yaml`.
- Research notes and open questions that should not be published:
  `notes/research.md` (outside `input/`, so the IG Publisher ignores it).

## Conventions

- Same conventions as the Cancer Pathology Report and Imaging IGs: Markdown pages;
  diagrams as Mermaid; tables end with `{:.grid}`; HL7 v2 mappings are "indicative".
- Profiles derive from HL7 Europe Laboratory / Core (as NHS England's Pathology FHIR
  IG does); no UK Core dependency. `LaboratoryReport` derives from
  `diagnosticReport-eu-core` because `DiagnosticReport-eu-lab` requires a
  Composition link - in a FHIR Document the report also declares
  `DiagnosticReport-eu-lab`.
- HL7 v2 example messages on LAB-1 / LAB-3 must stay consistent with the FHIR
  examples in `input/fsh/Examples/`.
- Check SNOMED CT (UK Edition, `version=http://snomed.info/sct/83821000000107`) and
  LOINC codes on tx.fhir.org (`CodeSystem/$lookup`) before using them.
- Cite sources with links. Mark anything unverified or undecided as **Open** or
  **To confirm** rather than guessing.
- Files copied from other IGs carry a `DUPLICATION:` header comment naming the
  source; keep them in step.

## Build and publish

- `sushi build .` after any FSH or `sushi-config.yaml` change; expect 0 errors and
  0 warnings.
- Full build: `./_genonce.sh` (HL7 IG Publisher, `input-cache/publisher.jar`; run
  `./_updatePublisher.sh` to fetch it). Mermaid diagrams are only rendered by the full
  build. Check `output/qa.html`.
- Any push runs `.github/workflows/igPublish.yml`; pushes to `main` update the
  published site (GitHub Pages must be enabled with source "GitHub Actions").
  Commit or push only when asked.
