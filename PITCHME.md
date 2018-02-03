@title[Introduction]

## Intermittent Test Failures
#### Pramod Jacob

---

@title[Source]

### Source

- This presentation is based on a talk given by **Tim Mertens** of **Avant** at **RubyConf 2017**

---

@title[Deterministic Behavior]

### Deterministic Behavior

- Deterministic code always produces the same output for a given input
- In contrast, non-deterministic code produces random, unexpected output for a given input, possibly caused by:
  - Race conditions
  - Unexpected state
  - Changing state

---

![Image-Absolute](assets/images/deterministic_nondeterministic.png)

---

### Non-Determinism and Tests

- Non-deterministic behavior causes intermittent test failures
- "Flaky tests are a myth." - Tim Mertens
- **Our goal is to build tests that defend against non-deterministic behavior**

---

## ???

---

## No.

---

### Finding Non-Deterministic Tests
...that are reproducible

---?code=code/test_rerun.rb&lang=ruby&title=Multiple Test Runs

---

### Causes for Non-Deterministic, __Reproducible__ Failures

---

### 1) Data Pollution

- Tests should always clean up after themselves, through before actions, etc.
- Be aware of both planned and unplanned dependencies

---?code=code/feature_toggle.rb&lang=ruby

@[1-2,4-13](This broke)
@[3](Line added to resolve dependency issues)
@[1-13](This works)

---
