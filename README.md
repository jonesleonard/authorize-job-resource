![deploy](https://github.com/jonesleonard/authorize-job-resource/actions/workflows/deploy.yml/badge.svg)

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
  # NORMAL USAGE
  - name: authorize-job
    type: authorize-job
    expose_build_created_by: true
    source:
      organization: my-org
      users:
        - my-user
      teams:
        - my-team
      access_token: ((github-access-token))
  # GITHUB ENTERPRISE USAGE
  - name: authorize-job-ghe
    type: authorize-job
    expose_build_created_by: true
    source:
      ghe_host: github.mycompany.com
      organization: my-org
      users:
        - my-user
      teams:
        - my-team
      access_token: ((github-access-token))
    # GITHUB ENTERPRISE CLOUD USAGE WITH SUFFIX
  - name: authorize-job-ghec-suffix
    type: authorize-job
    expose_build_created_by: true
    source:
      suffix: _mycompany
      organization: my-org
      users:
        - my-user
      teams:
        - my-team
      access_token: ((github-access-token))
```

Note that `expose_build_created_by: true` is required for this resource to function properly. It exposes the
`$BUILD_CREATED_BY` metadata environment variable to the resource.

## Behavior

This resource is intended to be used as a `put` resource. It will authorize the specified users and/or teams to run a
job within a Concourse pipeline.

### `check`: No-Op

### `in`: No-Op

### `out`: Authorize Users and/or Teams

Authorize the specified users and/or teams to run a job within a Concourse pipeline.

#### Put Example

```yaml
jobs:
  - name: my-job
    plan:
      - put: authorize-job
      - ... # the rest of the job plan
```

## Implementation Details

Below are implementation details that impact the behavior of this resource.

### `$BUILD_CREATED_BY`

The resource relies on
the [`$BUILD_CREATED_BY`](https://concourse-ci.org/implementing-resource-types.html#resource-metadata)
metadata exposed by Concourse to resources.

This metadata environment variable exposes the username of the user that triggered the build. The resource uses this
username to determine if the user is authorized to run the job. If the username provided to the resource does not match
the username of the user that triggered the build, the resource will fail.

Ensure that your Concourse instance provides user's GitHub username as the `$BUILD_CREATED_BY` metadata environment.

### GitHub Enterprise Cloud Username

This resource supports GitHub, GitHub Enterprise Server, and GitHub Enterprise Cloud. When using with GitHub Enterprise
Cloud you may need to modify the username. For example, your company may append a suffix to the username to avoid
conflicts. If the `$BUILD_CREATED_BY` value does not include this suffix you can use the `suffix` parameter to modify
the username.