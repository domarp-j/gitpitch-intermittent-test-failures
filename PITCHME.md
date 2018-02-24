@title[Introduction]

## Intermittent Test Failures
#### Pramod Jacob

---

@title[Source]

### Source

- This presentation is a review of a talk given by [Tim Mertens of Avant at RubyConf 2017](https://www.youtube.com/watch?v=JH9vugpPNyw)

---

@title[Deterministic Behavior]

### Deterministic Behavior

- Deterministic code always produces the same output for a given input
- In contrast, non-deterministic code produces random, unexpected output for a given input, possibly caused by:
  - Race conditions
  - Unexpected state
  - Changing state

+++

![Image-Absolute](assets/images/deterministic_nondeterministic.png)

---

### Non-Determinism and Tests

- Non-deterministic behavior causes intermittent test failures
- "Flaky tests are a myth." - Tim Mertens
- **Our goal is to build tests that defend against non-deterministic behavior**

---

## ???

Notes:
Will this presentation solve the timeout errors we're seeing in acceptance tests?

+++

## No.

Notes:
Unfortunately no, but fully Dockerizing our test suite *may* help.

---

### Finding Non-Deterministic Tests
...that are reproducible

+++?code=code/test_rerun.rb&lang=ruby&title=Multiple Test Runs

---

### Causes for Non-Deterministic, __Reproducible__ Failures

+++

### 1) Data Pollution

- Tests should always clean up after themselves, through before actions, etc.
- Be aware of both planned and unplanned dependencies

+++?code=code/feature_toggle.rb&lang=ruby

@[1-2,4-15](This broke)
@[3](Line added to resolve dependency issues)
@[1-15](This works)

+++

### 1) Data Pollution

- Make sure transactional fixtures are enabled

+++?code=code/trans_fix.rb&lang=ruby

<span class="code-presenting-annotation fragment current-only visible current-fragment">Try not to do this</span>

---

### 2) Vague Assertions

- Never expect the return value of an ActiveRecord query to return in some assumed order

+++?code=code/user_test_bad.rb&lang=ruby

+++?code=code/user_test_good.rb&lang=ruby

@[5](Check the count)
@[6-7](Check for included values)
@[8](Check for excluded values)

+++

### 2) Vague Assertions

- Don't expect tables to be empty - check for __relative__ change

+++?code=code/assertion_bad.rb&lang=ruby

+++?code=code/assertion_good.rb&lang=ruby

---

### 3) Randomized Test Data

- Don't randomize your test data
- Don't use Faker, which might return strings in a format that code doesn't handle properly
  - Names: D'Angelo, Doe-Smith, Smith Jennings
  - Phone numbers in different formats
- If you do need to randomize data, output it with test error messages to make debugging easier

---

### 4) Mutated Constants

- Don't overwrite constants - they can be mutated between tests
- RSpec has a `stub_const` method for stubbing constants
- MiniTest requires a gem `minitest_stub_const`

+++?code=code/minitest_stub_const.rb&lang=ruby

<span class="code-presenting-annotation fragment current-only visible current-fragment">[Source: minitest-stub-const docs](https://github.com/adammck/minitest-stub-const)</span>

+++

### 4) Mutated Constants

- In tests, set constants using `let` variables
- Constants defined directly within tests often aren't restricted to the scope in which they're defined
- Setting multiple constants with the same name can result in a race condition

+++?code=code/test_const_bad.rb&lang=ruby

+++?code=code/test_const_good.rb&lang=ruby

---

### Debugging Non-Deterministic Reproducible Failures

+++

### Using Seeds & Debuggers

- Obtain two test seeds
  - One where the ND test fails
  - One where the ND test succeeds
- Add a `binding.pry` in the ND test
- Re-run the tests with each seed, and determine what is different

+++?code=code/seed&lang=shell

+++

### Using Bisect

- Obtain a test seed that includes the test failure
- Use **bisection** to identify the minimum amount of tests that produce the test failure
  - RSpec has a built-in `--bisect` option
  - [`minitest-bisect`](https://github.com/seattlerb/minitest-bisect) gem
- Useful to identify if data pollution is the culprit behind the ND test

---

### Non-Reproducible N.D. Tests

+++

### 1) Date and Time

- Date/Time tests, if not properly handled, can essentially be time-bombs that explode at any given time for an unknown reason (a new year, its a weekend or holiday, etc)

+++

### 1) Date and Time

- Make sure to stub out the current `Date`, `Time`, or `DateTime`
  - [`timecop`](https://github.com/travisjeffery/timecop) gem comes in handy here, but it isn't necessary


+++?code=code/date_stub.rb&lang=ruby

@[2-9](Date gaps)
@[15-18](This would break without date stubbing)
@[11-13](Date stubbing)
@[1-19]()

+++

### 1) Date and Time

- Make sure that you're clearly distinguishing between UTC & local time
  - `Date.today` uses system time zone
  - `Date.current` uses application time zone

+++?code=code/date_today_current.rb&lang=ruby

+++

### 1) Date and Time

- Don't use `created_at` or `updated_at` as a reliable metric in any way

---

### 2) Environmental Differences

- Compare configs between environments (env variables)
- Check if CI is executing tests differently than local machine
- Seeds missing/present on local machine?
- Missing migrations?
- OS differences?

Notes:
Docker consistency between local & CI should resolve this

---

### 3) Timeouts and Asynchronous JavaScript

- You can't always trust your local machine to replicate CI failures
- Wait for pages to finish loading before interacting with them
  - [`site_prism` gem load validations](https://github.com/natritmeyer/site_prism)

Notes:
Discussion - is it always bad to increase timeouts when needed?

---

### 4) I'm So Lost

- SSH into the environment & try to reproduce it
- Check gem GitHub repos for related issues/changes
- Make sure you're using a debugger
- Add logging to your tests

---

### Solidify your Debugging Process

- Understand the system
- Make it fail
- Quit thinking and look


<span class="code-presenting-annotation fragment current-only visible current-fragment">
  [Source: Debugging by David J. Agans](https://www.amazon.com/Debugging-Indispensable-Software-Hardware-Problems/dp/0814474578)
</span>
---

### Solidify your Debugging Process

- Divide and conquer
- Change one thing at a time
- Keep an audit trail

<span class="code-presenting-annotation fragment current-only visible current-fragment">
  [Source: Debugging by David J. Agans](https://www.amazon.com/Debugging-Indispensable-Software-Hardware-Problems/dp/0814474578)
</span>

---

### Solidify your Debugging Process

- Check the plug
- Get a fresh view
- If you didn't fix it, it ain't fixed

<span class="code-presenting-annotation fragment current-only visible current-fragment">
  [Source: Debugging by David J. Agans](https://www.amazon.com/Debugging-Indispensable-Software-Hardware-Problems/dp/0814474578)
</span>

---

### Takeaways

- When you find a non-deterministic test failure
  - Find out if it's reproducible or non-reproducible
  - Use the strategies above to narrow down the scope of the problem
  - Be systematic and write things down!

Note:
I have created a Confluence page that you can use as a quick primer for diagnosing intermittent test failures.

---

### Takeaways

- Defensive testing at the outset is the best way to prevent intermittent test failures
