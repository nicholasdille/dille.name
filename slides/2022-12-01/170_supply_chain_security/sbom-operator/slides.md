## Vulerability scanning

SBoMs can be used for vulnerability scanning

All components of an artifact are listed with version numbers

Matching against CVE databases provides unfixed vulnerabilities

Scan can be repeated at any time

---

### Example workflow

![](170_supply_chain_security/sbom-operator/scanning.drawio.svg) <!-- .element: style="float: right; width: 45%;" -->

`sbom-operator` [](https://github.com/ckotzbauer/sbom-operator) listens for events on pods <i class="fa fa-circle-1"></i>, generates an SBoM for an image...

...and stores it in a git repository <i class="fa fa-circle-2"></i>

`vulnerability-operator` [](https://github.com/ckotzbauer/vulnerability-operator) enumerates the SBoMs in the repository <i class="fa fa-circle-3"></i>...

...scans them for vulnerabilities and publishes metrics

Prometheus and Grafana can scrape <i class="fa fa-circle-4"></i> and visualize <i class="fa fa-circle-5"></i> them

---

## Demo

See SBoMs in [git](https://github.com/nicholasdille/sbom-store)

See metrics in [Grafana](http://grafana.inmylab.de)