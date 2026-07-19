# Contributing to GameDevProject

Thank you for your interest in contributing to the GameDevProject! This document outlines the workflow, setup, and verification steps expected for all human contributors. For general project information, please refer to the [README.md](./README.md).

## Development Environment Setup

Before making changes, ensure your local environment is correctly configured.

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd GameDevProject
   ```
2. **Install dependencies:**
   Ensure you have the required engine and tools installed.
   ```bash
   # Install project dependencies
   npm install 
   ```
3. **Verify local setup:**
   Run the local smoke check to ensure the environment is healthy and the project builds correctly.
   ```bash
   npm run build
   npm run test:smoke
   ```

## Issue Tracking and Branching

All work must be tied to an issue in our issue tracker. Do not start work without an associated issue.

1. **Find or create an issue:** Ensure the issue has clear acceptance criteria and is assigned to you.
2. **Create a branch:** Create a new branch from the protected default branch (`main`).
3. **Branch naming convention:** Use the format `<issue-number>-short-description` (e.g., `42-add-player-movement`).

## Making Changes and Verification

Keep your changes focused on a single issue or a small set of related issues. Before submitting a Pull Request (PR), you must verify your changes locally to ensure CI will pass.

1. **Run automated tests:**
   ```bash
   npm run test
   ```
2. **Run linters and formatters:**
   ```bash
   npm run lint
   npm run format:check
   ```
3. **Run Quality Requirement Tests (QRTs):**
   ```bash
   npm run test:quality
   ```
4. **Update Documentation:** If your change affects user-facing behavior, update the relevant documentation and the root `CHANGELOG.md`.

## Pull Request (PR) Workflow

When your changes are ready, submit a PR targeting the protected default branch (`main`).

1. **Use the PR Template:** Fill out all sections of the PR template, including:
   - Summary of changes.
   - Testing performed locally.
   - Reviewer checklist.
2. **Link the Issue:** Ensure the PR description explicitly links to the related issue (e.g., `Closes #42`).
3. **Verify Acceptance Criteria:** Explicitly state in the PR description how the issue's acceptance criteria have been met.
4. **Changelog:** Confirm you have either added a user-visible entry to `CHANGELOG.md` or marked the change as non-user-visible in the PR checklist.

## Review and Merge Expectations

- **Approvals:** Every PR requires at least one approval from a team member *other than the author*. Authors cannot approve their own PRs.
- **CI Gates:** All CI checks (linting, formatting, build, unit/integration tests, QRTs, and additional QA checks) must pass before merging.
- **Merge Strategy:** We use **merge commits**. Squash and rebase merging are disabled to preserve a clear, traceable history.
- **Definition of Done:** A PR is only ready to merge when it satisfies the team's [Definition of Done](./docs/definition-of-done.md). This includes satisfied acceptance criteria, peer review, passing CI, and updated documentation.

## Deeper Documentation

For more detailed information on our architecture, quality standards, and development processes, please consult the following maintained documentation:

- [Development Process & Git Workflow](./docs/development-process.md)
- [Definition of Done](./docs/definition-of-done.md)
- [Architecture Overview & ADRs](./docs/architecture/README.md)
- [Quality Requirements & Tests](./docs/quality-requirements.md)
- [Testing Strategy & Coverage](./docs/testing.md)
- [Agent Guidelines](./AGENTS.md)
