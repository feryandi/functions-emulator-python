#!/bin/bash
run_command_silently() {
    $1 &>/dev/null
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] 
  then
    echo "Usage: ./deploy.local.sh <directory> <function name> <function to execute> <environment file - optional>"
    exit 1
fi

printf "Accessing directory: '$1'\n"
pushd $1
rm -r env
printf "Installing requirements dependecies\n"
virtualenv -p python3 env
printf "."
source ./env/bin/activate
printf "."
run_command_silently "pip install -r requirements.txt"
printf "."
run_command_silently "pip install Flask"
printf "[OK]\n"

rm .gcloudignore
echo ".gcloudignore" >> .gcloudignore
echo "env" >> .gcloudignore
echo ".env.yaml" >> .gcloudignore
echo ".env.yaml.example" >> .gcloudignore
echo "__pycache__" >> .gcloudignore
echo "*.sh" >> .gcloudignore

popd
if [ ! -z "$4" ]
  then
    printf "Applying environment variables\n"
    sed -e 's/.*/export &/;s/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' $4 > .env
    source .env
fi
pushd $1

printf "Creating Flask server\n"
rm .runner.py
echo "from flask import Flask, request" >> .runner.py
echo "app = Flask(__name__)" >> .runner.py
echo "import main" >> .runner.py

echo "@app.route('/<function_name>', methods = ['GET', 'POST', 'OPTIONS', 'PUT', 'PATCH', 'DELETE', 'HEAD'])" >> .runner.py
echo "def route(function_name):" >> .runner.py
echo "  if function_name == '"$2"':" >> .runner.py
echo "      return(main."$3"(request))" >> .runner.py
echo "if __name__ == '__main__':" >> .runner.py
echo "  app.run()" >> .runner.py

printf "Starting Flask...\n"
python3 .runner.py
