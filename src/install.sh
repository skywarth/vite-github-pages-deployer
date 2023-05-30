if [[ "${{ inputs.package_manager }}" == "yarn" ]]
then
  if [[ "${{ inputs.debug_mode }}" == "true" ]]; then echo "Installing via yarn"; fi;
  yarn install --immutable --immutable-cache --check-cache;
else
  if [[ "${{ inputs.debug_mode }}" == "true" ]]; then echo "Installing via npm"; fi;
  npm ci;
fi