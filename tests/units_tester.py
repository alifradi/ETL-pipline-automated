import json
import importlib
import sys
import os
import pandas as pd

# Add the directory containing the modules to the Python path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'etl'))

# Load the functions data from the JSON file located in the etl directory
json_file_path = os.path.join(os.path.dirname(__file__), '..', 'etl',
'functions_data.json')
with open(json_file_path, 'r') as f:
    functions_data = json.load(f)

for function_data in functions_data:
    if function_data['type'] == 'extract':
        module_name = function_data['module_name']
        function_name = function_data['function_name']
        arguments = function_data['arguments']
        dataframe_name = function_data['table_name']

        try:
            # Dynamically import the module and get the function
            module = importlib.import_module(module_name)
            function = getattr(module, function_name)

            # Call the function with the provided arguments
            result = function(*arguments)

            # Check if the result is a dataframe
            if isinstance(result, pd.DataFrame):
                print(f"The output of {function_name} is a dataframe called {dataframe_name}.")
            else:
                print(f"{function_name} is rendering {dataframe_name} which has not a dataframe type.")
                if result.shape[0] == 0:
                  print(f"{dataframe_name} is empty.")

        except (ImportError, AttributeError) as e:
            print(f"Error importing {function_name} from {module_name}: {e}")
        except Exception as e:
            print(f"Error calling {function_name}: {e}")
