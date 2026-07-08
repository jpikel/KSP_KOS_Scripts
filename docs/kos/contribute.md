> Source: https://ksp-kos.github.io/KOS/contribute.html (mirrored offline copy for local reference)

# Contribute

## How to Contribute to this Project

The kOS project welcomes developers with C# expertise and familiarity with the KSP API. Source code is hosted on GitHub at [https://github.com/KSP-KOS/KOS](https://github.com/KSP-KOS/KOS).

### Standard Contribution Workflow

For those experienced with Git and GitHub:

- Fork the main repository to your GitHub account
- Clone your fork locally
- Create a feature branch from `develop` (avoid editing `develop` directly)
- Make your changes in the feature branch
- Commit and push changes to your GitHub fork
- Submit a Pull Request to merge your branch into the main repository's `develop` branch
- Wait for developer review—the team actively monitors contributions
- Keep your `develop` branch synchronized with upstream before submitting to expedite merging

For developers unfamiliar with Git workflows, reach out to team members for guidance or request access to the Slack channel.

## Slack Chat

An active Slack channel hosts ongoing developer discussions about complex topics. Contact a main developer to request an invitation.

## How to Get Credited in the Next Release

Starting with version 0.19.0, contributor credits are opt-in. To be named in release notes, add your information to the `### Contributors` section of the CHANGELOG.md file in your pull request. This streamlined approach eliminates the need for post-release permission requests and ensures accurate attribution.

## How to Edit this Documentation

The documentation uses reStructuredText, compiled to HTML via Sphinx and the Read The Docs Theme.

To rebuild locally:

```
make clean
make html
```

Setup requires installing Sphinx and Read the Docs Theme as documented in their respective repositories.

Original documentation infrastructure was established by Johann Goetz.
