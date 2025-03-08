#!/bin/bash

CYAN='\e[36m'
GREEN='\e[32m'
RED='\e[31m'
BOLD='\e[1m'
RESET='\e[0m'

echo "──────────────────────────────────────────────"
echo "  🌌 Welcome to the Futuristic Git Assistant  "
echo "──────────────────────────────────────────────"
echo "🚀 Automating Your Workflow Like a Pro! 🛠️"
echo

# Start option with timestamp
echo "🔹 Start Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "🔹 Repository Path: $PWD"
echo

read -p "🔧 Ready to begin? Press Enter to start..."

# Step 1: Validate user authentication
echo
echo -e "${CYAN}🔒 Validating user authentication...${RESET}"
echo
rm -f ssh_auth_check.log
ssh -v -T git@github.com 2>&1 | tee ssh_auth_check.log

if grep -q "You've successfully authenticated" ssh_auth_check.log; then
    AUTH_USER=$(grep -oP "Hi \K\w+" ssh_auth_check.log)  # Extract username from SSH output
    echo
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${GREEN}${BOLD}! ✅ Authentication successful for user: $AUTH_USER ${RESET}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
elif grep -q "Permission denied" ssh_auth_check.log || grep -q "publickey" ssh_auth_check.log; then
    echo
    echo -e "${RED}${BOLD}❌ Authentication failed!${RESET}"
    echo -e "${RED}🚨 Possible issues detected:${RESET}"
    echo -e "${RED}🔹 Public key authentication failed.${RESET}"
    echo -e "${RED}🔹 Permission denied.${RESET}"
    echo -e "${RED}🔹 SSH key might not be added to GitHub.${RESET}"
    echo
    read -p "🔄 Press Enter to retry authentication or CTRL+C to exit... " retry
    exec "$0" # Restart the script
else
    echo
    echo -e "${RED}${BOLD}⚠️ Something went wrong with authentication.${RESET}"
    echo -e "${RED}🔎 Check ssh_auth_check.log for details.${RESET}"
    echo
    read -p "🔄 Press Enter to retry authentication or CTRL+C to exit... " retry
    exec "$0"
fi

# Step 2: Prompt for branch name
while true; do
  echo
  echo
  echo "You are working in path: $PWD"
  echo
  read -p "Change path to another repo? (y/n): " change_path
  if [[ "$change_path" == "y" ]]; then
    echo
    git_dirs=$(find ~ -type d -name .git)
    echo "$git_dirs"
    echo
    read -p "Enter the path to the repo without the .git and last forward slash (eg: /path/to/repo ): " repo_path
    if [[ ! -d "$repo_path" ]]; then
      echo
      echo "❌ Directory '$repo_path' does not exist."
      continue
    fi

    cd "$repo_path"

  else
    break
  fi
  echo
  read -p "📌 Enter the new branch name: " branch_name

  if [[ -d "$branch_name" ]]; then
      if [[ -d ".git" && -n "$branch_name" ]]; then
        read -p "💡 Use existing branch '$branch_name'? (y/n): " use_branch
        if [[ "$use_branch" == "y" ]]; then
          echo "🔄 Switching to '$branch_name'..."
          cd "$branch_name" || exit
          git checkout "$branch_name"
        else
          read -p "❌ Not using '$branch_name'. Press enter to proceed." enter
        fi
      fi
      echo "⚠️ Directory '$branch_name' already exists."
  else
      # Create and switch to the new branch
      echo
      echo "Creating  and switching to '$branch_name'..."
      git branch "$branch_name"
      echo
      git checkout "$branch_name"
      break
  fi
done

echo
# Open terminal in current directory
echo "🖥️ Opening terminal at $PWD..."
gnome-terminal "$PWD"
echo
read -p "⏳ Start working on your changes. Press Enter when done: " enter

# Step 3: Stage changes
echo
read -p "📂 Stage all files? (y/n): " stage_all
if [[ "$stage_all" == "y" ]]; then
    git add .
else
    echo
    ls -lha
    echo
    read -p "📝 Enter files to stage: " files_to_stage
    git add $files_to_stage
fi

# Step 4: Commit changes
echo
read -p "💬 Commit message: " commit_msg
git commit -m "$commit_msg"

# Step 5: Push changes
git push --set-upstream origin "$branch_name"

# Step 6: Provide repo user
echo
read -p "👤 Enter repo owner username: " account_owner

# Step 7: Extract repository name
#repo_name=$(basename -s .git $(git config --get remote.origin.url))
repo_name=$(git config --get remote.origin.url | sed -E 's/.*\/([^/]+)\.git/\1/')

# Step 8: Construct PR URL
pr_url="https://github.com/$account_owner/$repo_name/pull/new/$branch_name"

# Open PR in Chrome profile
while true; do
  echo
  echo "🔹 1 - Profile Gus"
  echo "🔹 2 - Profile kuroiyamahar15"
  echo "🔹 3 - Profile kurogane.tecnology"
  echo
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

    *) echo "❌ Invalid option. Try again." ;;
  esac
done

echo
read -p "⏳ Wait for approval or merge PR. Press Enter when done: " enter
echo
# Step 9: Delete remote branch
git push origin --delete "$branch_name"

# Delete untracked branches
echo
repo_path=${repo_path:-$PWD}  # Default to current directory if empty
repo_path=$(eval echo "$repo_path")  # Expand ~ (home directory)

# Validate that the directory exists
if [[ ! -d "$repo_path" ]]; then
    echo "❌ Error: Directory '$repo_path' does not exist."
    return 1
fi

# Validate that it's a Git repository
if [[ ! -d "$repo_path/.git" ]]; then
    echo "❌ Error: '$repo_path' is not a valid Git repository."
    return 1
fi

# Move into the repository directory
cd "$repo_path" || { echo "❌ Error: Failed to enter directory '$repo_path'"; return 1; }

# Fetch latest remote branches
echo "🔄 Fetching the latest remote branches..."
git fetch --prune

# List local branches
echo "🔎 Local branches:"
git branch
echo

# Find local branches that no longer have a remote
echo "🔎 Checking for local branches without a remote counterpart..."
echo
untracked_branches=($(git branch --format "%(refname:short)" | while read -r branch; do
    if ! git ls-remote --exit-code --heads origin "$branch" > /dev/null 2>&1; then
        echo "$branch"
    fi
done))

# If no untracked branches exist, exit
if [[ ${#untracked_branches[@]} -eq 0 ]]; then
    echo "✅ No untracked local branches found."
    return 0
fi

# Prompt the user for deletion
echo "⚠️ Untracked branches detected:"
echo
for branch in "${untracked_branches[@]}"; do
    read -rp "🔥 Delete local branch '$branch'? (y/n): " confirm
    if [[ "$confirm" == "y" ]]; then
        if [[ "$branch" == "$(git rev-parse --abbrev-ref HEAD)" ]]; then
            echo "⚠️ Switching to 'master' before deletion..."
            echo
            git checkout master || git checkout main
        fi
        echo "🗑️ Deleting '$branch'..."
        echo
        git branch -D "$branch"
        echo "✅ Deleted '$branch'."
    else
        echo "❌ Skipped '$branch'."
    fi
done
echo
echo "🎉 Cleanup complete!"

git pull

# Step 11: Provide report
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Summary of Actions Taken: "
echo "✔️ Created and switched to branch: $branch_name"
echo "✔️ Staged files and committed changes"
echo "✔️ Pushed branch to remote"
echo "✔️ Opened PR in Chrome: $pr_url"
echo "✔️ Deleted remote branch and cleaned untracked branches"
echo "✔️ Pulled latest changes"
echo "🚀 All steps completed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
