# Date Created: 03/08/2025
# AUTHOR: Gustavo Wydler Azuaga
---

# git_worfkflows_program

Welcome to the **git_worfkflows_program** repository! 🎉

## 📌 About This Project
This program is a github workflow script which simplifies github branches operations
- Validates logged in user thorugh ssh.
- Prompts the user to work in $PWD, or provide a different path to a repo
- Prompts the user for the creation of a new branch
- Checks wether the branch exists or not. If it doesn't, it creates it. If it does it prompts the user to use it or not.
- Once automatically checked out in the branch, it opens a gnome-terminal for the user to make changes add files, etc.
- Prompts for the user to press enter once all the changes and tests are done in the branch.
- Asks the user if they want to stage all files, or not. If not all files are staged, it asks which to stage.
- Requests a commit message
- Attempts to create the new remote branch and push the changes to it.
- Asks for the account to which the user wants to raise a PR.
- Constructs a PR url based on the:
  - account owner
  - repo_name
  - branch_name    
- Opens an interactive menu, which enables the user to select their google chrome profile
- Once the user selects the user profile, it will attempt to open the PR for that user with repo and branch.
- It later prompts for approval, and to press enter after the PR was merged.
- Once the user presses enter, it removes the remote branch, and tracks for the local branch to be removed as well.
- If finally git pulls the main branch.

To use this program, the user must meet the following equirements:

- gnome-terminal
- gh tool installed
- ssh keys for github user in place in github
- oauth for github user generated
  
   - You will have 3 users:
      - default
      - Profile 2
      - Profile 3
    
      Replace the code with the name of your google-chrome profiles. If you have only 2 profiles, remove the instances accordingly.

      Example: If you have only default and user 2, remove the lines for user 3. The echo and 3) with below instances.
        
      ```bash
      echo
      echo "🔹 1 - Profile <place_your_google_chrome_default_profile_name_here> (default profile)"
      echo "🔹 2 - Profile <place_your_google_chrome_profile2_name_here> (Profile 2)"
      echo "🔹 3 - Profile <place_your_google_chrome_profile3_name_here> (Profile 3)"
      ```
      

     ```bash
     read -p "🌐 Select Chrome profile to open PR: " profile
     case $profile in
     1)
      gnome-terminal -- google-chrome --profile-directory=Default "$pr_url"
      break
      ;;
     2)
      gnome-terminal -- google-chrome --profile-directory="Profile 2" "$pr_url"
      break
      ;;

     3)
      gnome-terminal -- google-chrome --profile-directory="Profile 3" "$pr_url"
      break
      ;;
     ```

## 🚀 Getting Started

1. Clone this repository:
   ```bash
   git clone git@github.com:kurogane13/git_worfkflows_program.git
   ```
2. Navigate into the directory:
   ```bash
   cd git_worfkflows_program
   ```

##
---
💡 *Happy coding! 🚀*
