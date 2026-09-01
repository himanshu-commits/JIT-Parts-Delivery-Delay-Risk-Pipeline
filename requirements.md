# Requirements Document

## Project: JIT Parts Delivery Delay-Risk Pipeline (Demo Build)

**Purpose:** Interview showcase project demonstrating hands-on understanding of
AWS, Terraform, CI/CD, and ETL/ELT data pipelines — built as a working,
runnable demo rather than a theoretical writeup.

**Build time:** ~1 day
**Built with:** Claude (Anthropic) generating code, infra, and docs directly

---

## 1. What this project is about

A simulated pipeline for a Just-in-Time (JIT) automotive parts delivery
problem: purchase orders, carrier delivery tracking, and plant dock scans are
combined to flag which deliveries are at risk of arriving late to the
production line. It mirrors a real data engineering task at a company like
BMW — multiple raw data sources, a transform/risk-calculation step, a curated
output, and a visualization layer — while running fully on mock data so it
needs no live AWS account or company systems to demo.

The project is intentionally small in scope but touches every layer a real
production pipeline would have: ingestion, transformation, storage design,
infrastructure-as-code, and deployment automation.

## 2. Goal

Produce a working, demoable artifact (not just a design doc) that lets me
credibly say in an interview: "I built this — here's the code, here's the
infrastructure it would run on in AWS, and here's how it would deploy via
CI/CD."

## 3. Scope

### In scope
- Mock data generation simulating 3 real sources (SAP POs, carrier ETA, dock scans)
- ETL script: extract → transform (join + risk flag) → load
- Static visualization output (risk breakdown + supplier on-time rate)
- Terraform definition of the target AWS architecture (S3, IAM, Glue, Data Catalog)
- A CI/CD pipeline definition (GitHub Actions) that would deploy the Terraform + ETL code on push
- A short ELT variant note — same pipeline, alternate pattern (see section 7)
- README explaining the architecture and mapping it to the job description

### Out of scope (explicitly, for time)
- Live AWS deployment (code is written to be deploy-ready, not actually deployed)
- Real SAP/carrier API integration
- ML-based delay prediction (rule-based risk threshold only)
- Front-end app (Angular) — static chart substitutes for a live dashboard

## 4. Components to build

| # | Component | Covers |
|---|---|---|
| 1 | `generate_mock_data.py` | Simulated raw data sources |
| 2 | `etl.py` | ETL: extract, transform, load, with a configurable risk threshold |
| 3 | `visualize.py` | Data analytics / visualization output |
| 4 | `terraform/main.tf` | AWS infra as code: S3 data lake, IAM role, Glue job, Glue Data Catalog |
| 5 | `.github/workflows/deploy.yml` | CI/CD: validates and deploys Terraform + ETL code on push |
| 6 | `README.md` | Explains the project and maps it to the JD |
| 7 | `requirements.md` (this file) | Defines scope and what was built |

## 5. Tech stack

- **AWS** — S3 (data lake), IAM (least-privilege access), Glue (ETL + Data Catalog), Athena (query layer, referenced not built)
- **Terraform** — infrastructure as code, parameterized by `plant_id` and `environment` so it can redeploy to multiple plants
- **CI/CD** — GitHub Actions workflow running `terraform plan`/`apply` and packaging ETL code on push to `main`
- **Data Analytics / ETL** — Python + pandas for extract/transform/load logic; matplotlib for the visualization layer
- **ELT variant** — noted as an alternative pattern (raw data loaded first, transformed via SQL/Athena afterward) to show awareness of both approaches

## 6. Success criteria

- Pipeline runs end-to-end locally with one command per stage and produces a real chart
- Terraform file is valid, reviewable code — not pseudo-code — even though not deployed
- CI/CD workflow file is realistic and would actually run if pushed to a repo with AWS credentials configured
- Everything is explainable in under 2 minutes verbally, with a clear line back to every bullet in the job description

## 7. ETL vs. ELT — why this matters and how it's covered

- **ETL** (what's built): transform happens in Python/pandas *before* loading the curated result. Matches the current script — good for smaller, well-understood transformations like this risk calculation.
- **ELT** (the alternative, noted in README): raw data would be loaded into S3 as-is first, and the transformation (joins, risk calc) would happen afterward via SQL in Athena or a Glue Spark job reading directly from the raw layer. This is the more common pattern at scale, because it keeps raw data intact for reprocessing and pushes transform compute to the query engine.
- Mentioning both in the interview signals awareness that ETL vs. ELT is a real architectural choice, not just two words for the same thing.

## 8. What "Claude built this quickly" means in practice

- Mock data, ETL logic, visualization script, Terraform file, and this
  requirements doc were generated directly as runnable files, then the
  pipeline was executed to confirm it actually works (not just written and
  assumed correct).
- The scope was deliberately kept to what can be verified end-to-end in a
  single sitting: no dependency on real AWS credentials, real SAP/carrier
  systems, or a multi-day build.
- Everything is structured so it *reads* like production code (least-privilege
  IAM, parameterized Terraform, configurable thresholds, incremental-friendly
  design) even at demo scale — because that structure is what actually
  demonstrates understanding of the job, not the size of the dataset.