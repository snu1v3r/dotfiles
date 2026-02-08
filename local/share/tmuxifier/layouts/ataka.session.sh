# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/cybernet-ataka/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "ataka"; then

  # Create a new window inline within session layout definition.
  new_window "ataka-dev"
  run_cmd "cd ataka && source ../.venv/bin/activate && clear"
  new_window "backend-dev"
  run_cmd "cd backend && source .venv/bin/activate && clear"
  new_window "frontend-dev"
  run_cmd "cd frontend && clear"
  new_window "runners"
  run_cmd "cd frontend && clear"
  send_keys "npm run dev"
  new_window "ataka"
  send_keys "docker compose up --build"
  new_window "cli"
  select_window "runners"
  split_h 40
  run_cmd "cd backend && clear"

  # Load a defined window layout.
  # load_window "ataka"

  # Select the default active window on session creation.
  #select_window 1

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
