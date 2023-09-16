# authorize-job-resource

A [Concourse](https://concourse-ci.org/) resource to only allow specified GitHub users and/or teams to run a job within
a Concourse pipeline.

This resource
extends [karthikraina32/concourse-trigger-guard](https://github.com/karthikraina32/concourse-trigger-guard).

## Source Configuration

* `organization`: *Required.* The name of the organization to authorize users and/or teams under.
* `teams`: *Optional.* A list of teams to authorize within the given organization. Required if `users` is not specified.
* `users`: *Optional.* The name of the user to authorize. Required if `teams` is not specified.
* `access_token`: *Required.* A GitHub token with `read:org` scope.
* `ghe_host`: *Optional.* The hostname of the GitHub Enterprise instance to communicate with the GitHub API.

### Source Example

```yaml
resource_types:
  - name: authorize-job
    type: docker-image
    source:
      repository: jonesleonard/authorize-job-resource
      tag: latest

resources:
  - name: authorize-job
    type: authorize-job
    source:
      organization: my-org
      users:
        - my-user
      teams:
        - my-team
      access_token: ((github-access-token))
  - name: authorize-job-ghe
    type: authorize-job
    source:
      ghe_host: github.mycompany.com
      organization: my-org
      users:
        - my-user
      teams:
        - my-team
      access_token: ((github-access-token))
```

## Implementation Details

The resource authorizes users and/or teams to run a job within a GitHub organization. It relies on
the [`$BUILD_CREATED_BY`](https://concourse-ci.org/implementing-resource-types.html#resource-metadata) metadata
environment variable that concourse uses to expose the username of the user that triggered the build.
