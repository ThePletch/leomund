rm -r "api/compiled"
# compile all coffeescript files
coffee -o api/compiled --no-header --bare -c api/src/*.coffee
executing_directory=$(pwd)

# bundle each lambda function with the node_modules directory
for file in api/compiled/*.js; do
  # get filename without extension
  filename=$(basename "$file")
  filename="${filename%.*}"

  # make a directory for the function and copy in code and modules
  function_dir="api/compiled/$filename"
  mkdir "$function_dir"
  mv "$file" "$function_dir/index.js"
  mkdir "$function_dir/node_modules"
  cp -r node_modules "$function_dir"

  # zip up the function directory
  cd "$function_dir"
  zip -r "../$filename.zip" .
  cd "$executing_directory"
done
