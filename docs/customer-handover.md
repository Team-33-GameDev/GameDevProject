# Customer Handover Documentation

This document describes the current, actual handover state of the GameDevProject product. It is intended for the customer and stakeholders to understand how to access, operate, configure, and maintain the product following the final delivery of `MVP v3`. 

## Current Handover Status

* **Handover Level:** `Independently used by customer`
* **Customer-Confirmation Status:** `Accepted`

**Status Explanation:** 
The customer has received the final `MVP v3` builds and source code, and is currently using the product independently for evaluation and internal testing. The handover is formally accepted, subject to a few minor follow-up items (detailed below) that do not block core gameplay or independent operation. The team has transferred all necessary repository access, deployment artifacts, and documentation required for the customer to operate and maintain the product.

## Product Status and Handover Scope

### What is Transferred and Delegated
* **Source Code & Repository:** Full ownership and administrative access to the [Team-33-GameDev/GameDevProject](https://github.com/Team-33-GameDev/GameDevProject) GitHub repository has been transferred to the customer.
* **Deployed Artifacts:** The final `MVP v3` exported builds (Windows, Linux, and Web) are hosted on GitHub Releases and GitHub Pages.
* **Documentation:** All maintained documentation, including architecture, testing, and development processes, is fully updated and accessible within the repository and the hosted documentation site.
* **CI/CD Pipelines:** The GitHub Actions workflows for automated testing, quality gates, and build generation are active and configured under the customer's repository settings.

### What is Retained by the Team
* **University Accounts:** The development team retains access to their university-provided accounts, which were used during the course. These have been removed as collaborators from the primary repository.
* **Local Development Environments:** Personal local Godot editor configurations and IDE setups remain with the individual developers.

## Access and Usage Instructions

### Playing the Game (End-User Access)
The customer and end-users can access the final product in two ways:
1. **Desktop Builds (Windows/Linux):** Download the latest release archives from the [GitHub Releases page](https://github.com/Team-33-GameDev/GameDevProject/releases). Extract the archive and run the executable.
2. **Web Build:** Play directly in the browser via the hosted [GitHub Pages site](https://team-33-gamedev.github.io/GameDevProject/).

### Modifying and Building the Game (Developer Access)
To modify the game or generate new builds:
1. Clone the repository: `git clone https://github.com/Team-33-GameDev/GameDevProject.git`
2. Open the project in **Godot Engine 4.6 / 4.7** (or the specific stable 4.x version your team finalized).
3. Run the project directly from the editor using the "Play" button, or use the editor's export tools to generate new desktop/web builds.

## Configuration and Secrets Management

The base game is primarily client-side and does not require external secrets to run.

* **Local User Configuration:** Game settings (resolution, volume, controls) are automatically saved in the user's local Godot data directory. No manual configuration is required for end-users.

## Setup, Deployment, Recovery, and Verification

### Verification (Smoke Check)
To verify the product is functioning correctly after a fresh clone or build:
1. Launch the game from the Godot editor or the exported executable.
2. Verify the Main Menu loads without console errors.
3. Click "Start Game" and verify the first level loads and the player character responds to input.
4. Exit the game and verify that a `save_manager.gd` file is created in the user data directory.

### Recovery and Resetting
If the game state becomes corrupted or the customer needs to reset progress for testing:
* **Desktop:** Delete the `savegame.json` file located in the Godot user data directory (e.g., `%APPDATA%/Godot/app_userdata/GameDevProject/` on Windows).
* **Web:** Clear the browser's local storage and cache for the game's URL.

## Main Entry Points for Documentation

The following documentation pages serve as the primary entry points for normal use, operation, and troubleshooting:

* **Project Overview & Quick Start:** [Root README.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/README.md)
* **Customer Handover & Transition Details:** [docs/customer-handover.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/customer-handover.md)
* **Architecture & System Design:** [docs/architecture/README.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/architecture/README.md)
* **Development Workflow & CI/CD:** [docs/development-process.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/development-process.md)
* **Hosted Documentation Site:** [GameDevProject Docs](https://github.com/Team-33-GameDev/GameDevProject)

## Troubleshooting and Support Guidance

| Issue | Probable Cause | Resolution |
| :--- | :--- | :--- |
| **Godot editor fails to open the project.** | Using an incompatible Godot version (e.g., Godot 3.x or an older 4.x). | Ensure you are using Godot 4.6 / 4.7. |
| **Exporting fails with "No export template found".** | Missing Godot export templates. | In the Godot editor, go to `Editor -> Manage Export Templates` and download the templates for your editor version. |
| **Web build shows a blank screen or fails to load.** | Browser caching or WebGL context loss. | Hard refresh the browser (`Ctrl+F5`). Ensure the browser supports WebGL 2.0. |

## Known Limitations and Important Risks

1. **Web Build Performance:** The HTML5 exported build may experience frame-rate drops on low-end devices or older browsers due to WebGL overhead. The desktop builds are recommended for optimal performance.
2. **Save File Interruption:** If the game is force-closed exactly while writing to the save file, there is a minor risk of save file corruption. The game does not currently implement atomic save writing.
3. **Mobile Export:** While the Godot project supports Android/iOS export, mobile-specific touch controls and UI scaling have not been fully optimized or tested in `MVP v3`.

## Remaining Actions

The customer has confirmed that the current state is sufficient for independent use.

**Blocker Status:** None of these items block the current handover level or independent operation. They are scheduled as post-handover maintenance tasks.

## Documentation Sufficiency

The current documentation set is **sufficient** for the reached handover level (`Independently used by customer`). All necessary setup, deployment, configuration, and architectural reasoning is documented. If the customer decides to transition to the `Deployed or operated on customer side` level in the future (e.g., setting up their own dedicated backend), the team recommends updating `docs/development-process.md` with specific infrastructure-as-code or cloud-hosting instructions at that time.
