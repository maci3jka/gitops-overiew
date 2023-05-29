### GitOps

Joining DevOps metodology, Continous Deployment practices and Git version control tool results in GitOps

----

### GitOps definition

GitOps is an operational framework that takes DevOps best practices used for application development such as version control,
collaboration, compliance, and CI/CD, and applies them to infrastructure automation.

----

### GitOps summary

_GitOps: versioned CI/CD on top of declarative infrastructure.
Stop scripting and start shipping._

Kelsey Hightower

https://twitter.com/kelseyhightower/status/953638870888849408

----

### Principles

- Declarative<!-- .element: class="fragment" -->
- Versioned and Immutable<!-- .element: class="fragment" -->
- Pulled Automatically<!-- .element: class="fragment" -->
- Continuously Reconciled<!-- .element: class="fragment" -->


----

### Push vs Pull GitOps

- There are two ways to implement the deployment strategy for GitOps: Push-based and Pull-based deployments.<!-- .element: class="fragment" --> 
- The difference between the two deployment types is how it is ensured, that the deployment environment actually resembles the desired infrastructure.<!-- .element: class="fragment" --> 
- When possible, the Pull-based approach should be preferred as it is considered the more secure and thus better practice to implement GitOps.<!-- .element: class="fragment" -->


----

### Push-based GitOps


![git-flow-overview.jpg](/assets/git-ops-push.png)

----

### Pull-based GitOps


![git-flow-overview.jpg](/assets/git-ops-pull.png)


----
### Benefits
- Improved collaboration<!-- .element: class="fragment" -->
- Increased deployment speed and frequency<!-- .element: class="fragment" -->
- Increased reliability<!-- .element: class="fragment" -->
- Improved stability<!-- .element: class="fragment" -->
- Consistency and standardisation<!-- .element: class="fragment" -->
- Ease of adoption<!-- .element: class="fragment" -->
- Greater efficiency<!-- .element: class="fragment" -->
- More flexibility to experiment<!-- .element: class="fragment" -->
- More robust security<!-- .element: class="fragment" -->
- Improved compliance and auditing<!-- .element: class="fragment" -->