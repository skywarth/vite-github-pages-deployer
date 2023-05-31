export PATH="./node_modules/.bin:$PATH"

echo 'testing2';

echo "$PACKAGE_MANAGER"
echo "$PUBLIC_BASE_PATH"

if [[ "$PACKAGE_MANAGER" == "yarn" ]]
then
  if [[ "$DEBUG_MODE" == "true" ]]; then echo "Building via yarn"; fi;
  yarn build -- --base="$PUBLIC_BASE_PATH"
else
  if [[ "$DEBUG_MODE" == "true" ]]; then echo "Building via npm"; fi;
  npm run build -- --base="$PUBLIC_BASE_PATH"
fi