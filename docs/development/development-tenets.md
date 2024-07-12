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

- Extra Developer Documentation Tools:
  Document in Code or add extra files in the Repository for everything a new team member might need to know.
