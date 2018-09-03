# Functions Emulator for Python 3.7
Recently, Google Cloud Functions gives support to upload Python scripts. However, there is no emulator for this.

## How to Use
1. Put your function to a directory
2. Don't forget the requirements.txt and main.py as this both required by Cloud Functions
3. Run the deploy.local.sh with these parameters:
```
./deploy.local.sh <directory> <function name> <function to execute> <environment file - optional>
```

## Example
To run the default example of hello_world in Cloud Functions, run this command:
```
./deploy.local.sh hello_world function-1 hello_world
```
Now, you should have access to the function via default Flask endpoint: `127.0.0.1:5000/function-1` and it should works as in the real Cloud Functions.
