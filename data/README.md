# Data Documentation

This file documents the data used in this research project.

## Data Sources

### Raw Data

List all raw data files in `data/raw/` and their sources:

| File | Source | Collection Date | Description |
|------|--------|-----------------|-------------|
| `example.csv` | [Source Name/URL] | YYYY-MM-DD | Brief description of what this data contains |

### Processed Data

List derived data files in `data/processed/`:

| File | Source Script | Created | Description |
|------|---------------|---------|-------------|
| `cleaned_data.csv` | `scripts/R/01_clean_data.R` | YYYY-MM-DD | Description of processing applied |

## Data Dictionary

### Raw Data Variables

Describe the variables/columns in your raw data:

**example.csv:**
- `variable1`: Description, units, range
- `variable2`: Description, units, range
- `variable3`: Description, units, range

### Processed Data Variables

Describe any derived variables:

**cleaned_data.csv:**
- `new_variable1`: Description, calculation method
- `transformed_variable2`: Description, transformation applied

## Data Collection Methods

Describe how the data was collected:
- Sampling method
- Time period
- Geographic scope
- Sample size
- Instruments or tools used

## Data Processing

Document the processing pipeline:

1. **Cleaning** (`scripts/R/01_clean_data.R`):
   - Missing value handling
   - Outlier detection
   - Data validation

2. **Transformation** (`scripts/R/02_transform_data.R`):
   - Variable transformations
   - Feature engineering
   - Normalization

3. **Analysis** (`scripts/R/03_analyze_data.R`):
   - Statistical methods
   - Models applied

## Data Integrity

### Checksums

Verify data integrity using checksums:

```bash
# Generate checksums
shasum -a 256 data/raw/*.csv > data/raw/checksums.txt

# Verify checksums
shasum -a 256 -c data/raw/checksums.txt
```

Current checksums (if applicable):
```
[paste checksum output here]
```

## Data Versioning

If data has multiple versions:

| Version | Date | Changes | File |
|---------|------|---------|------|
| 1.0 | YYYY-MM-DD | Initial data | `data_v1.csv` |
| 1.1 | YYYY-MM-DD | Corrected errors in variable X | `data_v1.1.csv` |

## Ethical Considerations

- **Human subjects:** If applicable, note IRB approval number and consent details
- **Privacy:** Describe any anonymization or de-identification procedures
- **Restrictions:** Note any usage restrictions or data sharing limitations

## Access and Sharing

- **Availability:** Describe where/how others can access this data
- **License:** Specify data license (e.g., CC0, CC-BY)
- **Contact:** Who to contact for data requests

## Citations

If using published datasets, cite them here:

```bibtex
@data{dataset2024,
  author = {Author Name},
  title = {Dataset Title},
  year = {2024},
  publisher = {Repository Name},
  doi = {10.xxxx/xxxxx}
}
```

## Notes

Any additional notes, caveats, or known issues with the data:
- Known limitations
- Quality concerns
- Future updates planned
