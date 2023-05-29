### What is git?

Before we dig into we need to brefly overview what is git and its features.

----

### Git

- Git is a Source management system. Allows version control of the files, code at most of the time.<!-- .element: class="fragment" -->

- Nowadays, it is industry standard for version control systems, a mature project, actively maintained by open source community.<!-- .element: class="fragment" --> 

- Developed in 2005 by Linus Torvalds, creator of Linux.<!-- .element: class="fragment" -->

----

### How it works

- files are gathered snapshot of code at given time called commit<!-- .element: class="fragment" -->
- each commit consist of<!-- .element: class="fragment" -->
  - message - given by author<!-- .element: class="fragment" -->
  - author data - mail, name<!-- .element: class="fragment" -->
  - sha - unique code<!-- .element: class="fragment" -->
  - pointer to previous commit // TODO check<!-- .element: class="fragment" -->
- list of commits create brach or history<!-- .element: class="fragment" -->
- if we start two changes from single commit additional branches are created<!-- .element: class="fragment" -->
- two branches can be merged into one<!-- .element: class="fragment" -->
- there can be an additional label added to commit called tag<!-- .element: class="fragment" -->
  - used in software lifecycle<!-- .element: class="fragment" -->

----
### How git works - graph

![git-flow-overview.jpg](/assets/git-flow-overview.jpg)

----
### Git features

- Way of tracking work<!-- .element: class="fragment" -->
- Assign changes to person<!-- .element: class="fragment" -->
- Collaborative work<!-- .element: class="fragment" -->
- Backup of source code<!-- .element: class="fragment" --> 
- Free and open source<!-- .element: class="fragment" -->
- Each particular version of code is bound with its commit<!-- .element: class="fragment" -->
