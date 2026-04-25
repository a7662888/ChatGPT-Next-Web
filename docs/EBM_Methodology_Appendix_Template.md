# Appendix X. Advanced Methodology for Evidence Synthesis

> **Usage note (for manuscript submission):**
> Replace bracketed placeholders (e.g., `[X]`) with your study-specific values.
> Keep one outcome per subsection when reporting pooled estimates.

---

## 1. General Statistical Framework

All meta-analytic procedures were conducted in R (version `[X.X.X]`). Analyses were primarily implemented using `metafor` (version `[X.X-X]`) and `netmeta` (version `[X.X-X]`) for frequentist methods, with optional Bayesian analyses using `gemtc` and `rjags` where indicated.

Unless otherwise stated, pooled effects were estimated under random-effects models with restricted maximum likelihood (REML). Effect sizes were reported as odds ratios (OR), risk ratios (RR), mean differences (MD), or standardized mean differences (SMD), each with 95% confidence intervals (CI).

---

## 2. Network Meta-Analysis (NMA)

### 2.1 Assumptions

NMA validity was assessed under the following assumptions:
1. **Transitivity:** Included studies were sufficiently comparable in clinical and methodological characteristics such that participants could, in principle, have been randomized to any treatment in the network.
2. **Consistency:** Direct and indirect evidence were statistically coherent.
3. **Connected network:** Interventions were linked through at least one common comparator.

### 2.2 Network Geometry

Network graphs were generated with:
- node size proportional to the number of studies including each treatment,
- edge thickness proportional to the number of direct comparisons,
- disconnected subnetworks analyzed separately (no cross-subnetwork treatment estimates).

### 2.3 Inconsistency Assessment

Local inconsistency was evaluated via node-splitting; global inconsistency via design-by-treatment interaction.

```r
library(netmeta)

# net1: netmeta object
ns <- netsplit(net1)
print(ns, show.studies = FALSE)
forest(ns, show = "both")

dc <- decomp.design(net1)
print(dc)  # p.Q.inc.random for global inconsistency
```

### 2.4 Ranking

Treatment ranking was summarized using frequentist P-scores (0–1; higher values indicate better performance under the specified direction). Rankograms and cumulative ranking plots were generated.

```r
library(netmeta)

netrank(net1, small.values = "bad")
rg <- rankogram(net1, small.values = "bad")
plot(rg)
plot(rg, cumulative.rankprob = TRUE)
```

**Reporting template:**

“Network consistency was [not] violated (design-by-treatment interaction: p = `[X.XXX]`). Treatment `[A]` had the highest P-score (`[X.XXX]`).”

---

## 3. Pairwise Meta-Analysis and Heterogeneity

Between-study heterogeneity was quantified using Cochran’s Q, I², and τ².

**Reporting template:**

“Substantial heterogeneity was observed (I² = `[X]%`, τ² = `[X.XX]`, Q(`[df]`) = `[X.XX]`, p = `[X.XXX]`).”

Where appropriate, prediction intervals were reported to represent expected effects in new settings.

---

## 4. Meta-Regression

Meta-regression explored whether prespecified study-level moderators explained heterogeneity.

```r
library(metafor)

res_reg <- rma(
  yi   = log_OR,
  sei  = se_log_OR,
  mods = ~ moderator_variable,
  data = df,
  method = "REML"
)
summary(res_reg)
regplot(res_reg, xlab = "Moderator", ylab = "Log Odds Ratio")
```

Covariates were limited based on information size (recommended rule-of-thumb: ≥10 studies per covariate) to reduce overfitting.

**Reporting template:**

“Meta-regression showed that `[moderator]` was [not] associated with effect size (QM(`[df]`) = `[X.XX]`, p = `[X.XXX]`), explaining `[X]%` of between-study heterogeneity.”

---

## 5. Imprecision and Optimal Information Size (OIS)

Imprecision was judged with both CI width and OIS considerations (GRADE framework). For binary outcomes, OIS was approximated by:

\[
\text{OIS} = \frac{\left(Z_{1-\alpha/2}+Z_{1-\beta}\right)^2\left[p_c(1-p_c)+p_i(1-p_i)\right]}{(p_c-p_i)^2}
\]

where \(\alpha=0.05\) (two-sided), \(\beta=0.20\), \(p_c\) is control event risk, and \(p_i\) is intervention event risk.

Evidence was downgraded for imprecision when total information size was below OIS and/or confidence intervals crossed clinical decision thresholds.

---

## 6. Outlier and Influence Analyses

Potential outliers were screened with studentized residuals and influence diagnostics. Primary conclusions were tested via sensitivity analyses excluding influential observations.

```r
library(metafor)

res_full <- rma(yi, vi, data = df, method = "REML")
rstud <- rstudent(res_full)
df$outlier <- abs(rstud$z) > 1.96

res_no_out <- rma(yi, vi, data = df[!df$outlier, ], method = "REML")

cat("Full:", round(exp(coef(res_full)), 2),
    "(", round(exp(res_full$ci.lb), 2), "-", round(exp(res_full$ci.ub), 2), ")\n")
cat("No outliers:", round(exp(coef(res_no_out)), 2),
    "(", round(exp(res_no_out$ci.lb), 2), "-", round(exp(res_no_out$ci.ub), 2), ")\n")
```

---

## 7. Effect Measure Transformations

### 7.1 Median/IQR to Mean/SD

For studies reporting medians and interquartile ranges, conversion methods (e.g., Wan/Luo) were applied cautiously, with sensitivity analyses when skewness was suspected.

```r
mean_est <- (Q1 + median + Q3) / 3
sd_est <- (Q3 - Q1) / (2 * qnorm((0.75 * n - 0.125) / (n + 0.25)))
```

### 7.2 Log(OR) and SMD Conversion

```r
d_from_log_or <- function(log_or) log_or * sqrt(3) / pi
log_or_from_d <- function(d) d * pi / sqrt(3)
```

### 7.3 NNT/NNH from OR and Baseline Risk

```r
nnt_nnh <- function(or, p_baseline) {
  odds_t <- or * p_baseline / (1 - p_baseline)
  p_treatment <- odds_t / (1 + odds_t)
  arr <- p_baseline - p_treatment
  if (abs(arr) < .Machine$double.eps) return(list(type = "No difference", value = Inf))
  if (arr > 0) return(list(type = "NNT", value = 1/arr))
  list(type = "NNH", value = 1/abs(arr))
}
```

---

## 8. Bayesian Analyses (Optional)

When sparse data or model instability limited frequentist estimation, Bayesian random-effects NMA was conducted.

```r
library(gemtc)
library(rjags)

network <- mtc.network(data = df_long, treatments = df_treatments, studies = df_studies)
model <- mtc.model(network, type = "consistency", linearModel = "random")
results <- mtc.run(model, n.adapt = 5000, n.iter = 20000, thin = 10)
summary(results)

rank_prob <- rank.probability(results, preferredDirection = -1)
plot(rank_prob)
```

Convergence was assessed using trace plots and Gelman–Rubin diagnostics where applicable.

---

## 9. Three-Level and Multivariate Meta-Analysis

When effect sizes were statistically dependent (e.g., multiple outcomes/time points per study), dependency was modeled explicitly.

```r
library(metafor)

# Three-level model
res_3lvl <- rma.mv(
  yi, vi,
  random = ~ 1 | study_id/effect_id,
  data = df,
  method = "REML"
)
summary(res_3lvl)

# Multivariate model
res_mv <- rma.mv(
  yi, V = V_matrix,
  mods = ~ outcome_type,
  random = ~ outcome_type | study_id,
  struct = "UN",
  data = df_long,
  method = "REML"
)
summary(res_mv)
```

---

## 10. Subgroup Effects, Effect Modification, and Confounding

Subgroup analyses evaluated potential effect modification. Inference focused on **interaction tests** rather than significance within individual subgroups. For observational evidence syntheses, residual confounding and ecological bias were considered in certainty assessment.

**Reporting template:**

“The subgroup-by-treatment interaction was [not] significant (p-interaction = `[X.XXX]`), suggesting [presence/absence] of effect modification by `[factor]`.”

---

## 11. Small-Study Effects and Publication Bias

For outcomes with sufficient studies (typically ≥10), funnel plots and Egger-type tests were used. Trim-and-fill analyses were prespecified as exploratory.

**Reporting template:**

“Egger’s test indicated [no] small-study effects (p = `[X.XXX]`). Trim-and-fill imputed `[N]` potentially missing studies; the adjusted pooled estimate was `[X.XX]` (95% CI `[X.XX]` to `[X.XX]`).”

---

## 12. Software and Reproducibility Statement

All analyses were scripted and version-controlled. Statistical code and analytic decisions were archived to ensure reproducibility.

**Template sentence:**

“Analyses were performed in R `[version]` using `metafor`, `meta`, `netmeta`, and (where applicable) `gemtc`/`rjags`. Reproducible scripts and logs are available in the supplementary repository.”

---

## 13. Quick Fill Checklist (Before Submission)

- [ ] R version and package versions inserted.
- [ ] Primary effect measure and direction defined.
- [ ] Heterogeneity metrics (I², τ², Q) fully reported.
- [ ] Interaction p-values used for subgroup interpretation.
- [ ] OIS/imprecision judgment explicitly justified.
- [ ] Sensitivity analyses (outlier/influence/high risk of bias) reported.
- [ ] Publication bias methods limited to outcomes with adequate study counts.
- [ ] NMA assumptions (transitivity/consistency) explicitly addressed.

