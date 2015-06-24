Starenv
=======

> **Load and manage suites of environment variables.**



Synopsis
--------

One of the tenants of building [12-factor apps](http://12factor.net/) is loading your [configuration from the environment](http://12factor.net/config).

However, developing complicated applications, entirely configured from the environment, comes with some pitfalls:

1. *Environment variables aren't easy to manage*

1. *Environment variables aren't easy to reproduce*

1. *Environment variables aren't easy to reason about*

1. *Environment variables aren't easy to tweak*

Starenv was created to alleviate these problems.

1. *Starenv supports multiple, project-defined env files.*

1. *Starenv allows declaring dependencies files.*

1. *Starenv allows conditionally and contextually loading files.*

1. *Starenv comes with rake tasks for managing and documenting environment variables.*
