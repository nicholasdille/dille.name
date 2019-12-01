## trivy: Image scans in CI/CD

### [trivy](https://github.com/aquasecurity/trivy) made by [Aqua Security](https://www.aquasec.com/)

- Covers OS (alpine, Ubuntu, Debian, CentOS, RedHat)
- Covers package managers (Ruby, Python, PHP, NPM, Rust)

Break build with high severity findings:

```bash
trivy \
    --skip-update \
    --ignore-unfixed \
    --exit-code 1 \
    --severity HIGH,CRITICAL \
    python:3.4-alpine3.9
```

### Cache management

- Databases are cached locally
- Persist cache across builds
