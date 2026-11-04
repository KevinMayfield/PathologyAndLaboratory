# England Pathology and Laboratory Medicine (PaLM) Technical Framework

**Draft** HL7 FHIR Implementation Guide localising the
[IHE Pathology and Laboratory Medicine (PaLM) Technical Framework](https://www.ihe.net/resources/technical_frameworks/#PaLM)
for interoperability in England. It covers:

- **HL7 v2.5.1** - `OML^O21`, `ORU^R01` and acknowledgements for the IHE PaLM
  transactions LAB-1, LAB-2, LAB-3, LAB-35 and LAB-36, with England identifiers and
  terminology
- **HL7 FHIR R4** - the same content as FHIR Messages and as FHIR Documents aligned
  with the [NHS England Pathology and Laboratory Medicine Reporting FHIR API](https://digital.nhs.uk/developer/api-catalogue/pathology-laboratory-reporting)
- **Mapping** between HL7 v2 and FHIR in both directions

Not an authoritative source; not endorsed by NHS England, IHE or HL7.

## Build

```sh
./_updatePublisher.sh   # once - downloads the HL7 IG Publisher
sushi build .           # FSH -> fsh-generated/
./_genonce.sh           # full build -> output/index.html
```

Requires Node.js (SUSHI: `npm install -g fsh-sushi`), Java 17+ and Jekyll.
