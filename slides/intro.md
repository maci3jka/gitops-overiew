[//]: # ()
[//]: # (![exit.JPG]&#40;/assets/Glass_exit_sign.jpg&#41;<!-- .element height="60%" width="60%" -->)

[//]: # ()
[//]: # (----)

### Plan

- Intro <!-- .element: class="fragment" -->
- About DevOps<!-- .element: class="fragment" -->
- About Continuous Deployment <!-- .element: class="fragment" -->
- About Git <!-- .element: class="fragment" -->
- About GitOps <!-- .element: class="fragment" -->
- Demo <!-- .element: class="fragment" -->
- Closing <!-- .element: class="fragment" -->

[comment]: <> (----)

[comment]: <> (### Contract)

[comment]: <> (* **Las Vegas rule**: What happens in the workshop stays in the workshop. If you gain some knowledge about another company/person please keep it to yourself.)

[comment]: <> (* **Be timely**: Be on time throughout the workshop. Don’t extend breaks.)

[comment]: <> (* **Ask questions**: Feel free to ask questions during workshops. We’ve tried to transfer all our knowledge to the workshop but if something isn’t clear don’t hesitate to ask.)

[comment]: <> (* **Respect each other**: Respect one another's ideas. Don't interrupt when someone is talking.)


[comment]: <> (----)

[comment]: <> (### About Michał)


[comment]: <> (<div id="left"> )

[comment]: <> (Michał is a DevOps Engineer at VirtusLab with three years of experience in Azure Cloud. Prior to that, he took care of CI/CD, )

[comment]: <> (configuration management, and software development in non-cloud projects. For two years along with engineering work,)

[comment]: <> (he fulfilled a role of a Scrum Master, but now he is back to full-time engineering work on the IaaC platform on Azure.)

[comment]: <> (</div>)

[comment]: <> (<div id="right">)

[comment]: <> (![michał.JPG]&#40;https://virtusity.com/wp-content/uploads/2022/11/michal_ogrodnik.jpeg&#41;<!-- .element height="50%" width="50%" -->)

[comment]: <> (</div> )


----

### About me


<div id="left"> 

Maciek is a Cloud Engineer at VirtusLab with over five years of experience. He started by being a tester, maintaining a testing environment in AWS.

Later, Maciek took on the role of an admin managing the company’s servers and resources in public clouds.

Then he worked as a developer in a team creating tooling for around 1000 users. Next, took role is developing the IaaC platform on Azure.

Now developing in Golang.
</div>


<div id="right">

![maciek.JPG](/assets/_DSF8414.JPG)<!-- .element height="50%" width="50%" -->

</div>

----

### What is GitOps?

GitOps is a technique to implement Continuous Delivery<!-- .element: class="fragment" -->

The core idea of GitOps is having a Git repository that always contains declarative descriptions of the infrastructure currently desired in the production environment and an automated process to make the production environment match the described state in the repository. <!-- .element: class="fragment" -->

If you want to deploy a new application or update an existing one, you only need to update the repository - the automated process handles everything else. It’s like having cruise control for managing your applications in production.<!-- .element: class="fragment" -->

----
### What problems GitOps solves

- Deploy Faster More Often <!-- .element: class="fragment" -->
- Easy and Fast Error Recovery <!-- .element: class="fragment" -->
- Easier Credential Management <!-- .element: class="fragment" -->
- Self-documenting Deployments <!-- .element: class="fragment" -->
- Shared Knowledge in Teams <!-- .element: class="fragment" -->

----

### GitOps popularity 

![img.png](/assets/gitops_trends.png)


