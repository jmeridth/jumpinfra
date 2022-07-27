from os.path import exists
import json
import pathlib
import sys

APP_NAMES = ["api", "admin", "web"]
CURRENT_DIRECTORY = pathlib.Path(__file__).parent.resolve()
ENVIRONMENTS = ["test", "staging", "production"]


def check_if_env_secrets_file_exist(file_path):
    if not exists(f"{CURRENT_DIRECTORY}/{file_path}"):
        print(f"{file_path} is missing.  Please create and populate")
        sys.exit(1)


def compare_keys(file_path):
    with open(f"{CURRENT_DIRECTORY}/{file_path}", "r") as f:
        all_secrets = json.load(f)
        for app in APP_NAMES:
            secrets_keys = all_secrets[f"{app}_secrets_keys"]
            secrets = all_secrets[f"{app}_secrets"].keys()
            difference = list(set(secrets_keys) - set(secrets))
            if len(difference) > 0:
                print(
                    f"There are differences between the "
                    f"{app}_secrets_keys list and the "
                    f"{app}_secrets dictionary in {file_path}.\n"
                    f"The differences are {difference}\n"
                    "Please correct this before running "
                    "terraform plan or apply. Thank you"
                )
                sys.exit(1)
            print(f"All secrets keys are valid for {app} application")


def input_error():
    print(
        "No environment parameter has been included\n"
        "Example: python3 check_secrets.py test"
    )
    sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        input_error()
    env = sys.argv[1].lower()
    if env not in ENVIRONMENTS:
        input_error()
    path_to_file = f"../terraform/secrets.{env}.tfvars.json"
    check_if_env_secrets_file_exist(path_to_file)
    compare_keys(path_to_file)
