For fast development the developer experience needs to be good, similar to how a good racer needs a specialized car to compete in races.

In order to facilitate this the number of context switches needs to be minimized.
Breaking changes need to be obvious to the developer.
If something might fail it should fail as early as possible.

This rules out a number strategies and practices:

- Don't use one repo per project.
  Use a Monorepo instead: make cross cutting changes without the need to commit to different repositories and without the need to match the different software versions together in Production.
  This also allows to run Integration or E2E Tests across different Projects and for each developed feature.
  Breaking Changes to other Project party will become obvious during testing instead of being discovered down the line when the commit is already released.

- Don't use Atlassians Branching Model:
  Use GitFlow instead. You want to be fast, so there is no time to let everything rest in a development branch. Every PR merged should be ready for production and if you are not sure if it is ready to deploy yet, it still needs work.
  If the features you work on are so big that you feel you need an extra branch you should rethink your feature size. 

- Extra Developer Documentation Tools:
  Document in Code or add extra files in the Repository for everything a new team member might need to know.

- Unclear Scopes and no Decisions
  Even if the features you develop are murky af, as even the customer does not know what he wants yet - your team should. So do not decide for no decision.
  Specify what your inital feature should do (for how many people, with which boundaries) and iterate on that later, there is nobody witholding you from amending a decision, but its crucial for a shared understanding of the capabilities.


Every developer should have the core guidelines: 

- Don't assume. Ask!
  If something is unclear do not wait till you build the feature to ask if thats what somebody wanted ask him directly.
