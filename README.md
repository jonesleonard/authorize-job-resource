# authorize-job-resource

A [Concourse](https://concourse-ci.org/) resource to only allow specified GitHub users and/or teams to run a job within a
Concourse pipeline.

## Source Configuration

* `organization`: *Required.* The name of the organization to authorize users and/or teams under.
* `teams`: *Optional.* A list of teams to authorize within the given organization. Required if `users` is not specified.
* `users`: *Optional.* The name of the user to authorize. Required if `teams` is not specified.
* `access_token`: *Required.* A GitHub token with `read:org` scope. This token is used to authorize users and/or teams
  to run a job within the given organization.
* `ghe_host`: *Optional.* The hostname of the GitHub Enterprise instance to authorize users and/or teams under. If
  omitted, the resource will authorize users and/or teams under GitHub.com.

## Implementation Details

The resource authorizes users and/or teams to run a job within a GitHub organization. It relies on
the [`$BUILD_CREATED_BY`](https://concourse-ci.org/implementing-resource-types.html#resource-metadata) metadata
environment variable that concourse uses to expose the username of the user that triggered the build.
