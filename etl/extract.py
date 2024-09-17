import requests
import pandas as pd
import io


def get_data(base_url, package_id):
    # To retrieve the metadata for this package and its resources, use the package name in this page's URL:
    url = base_url + "/api/3/action/package_show"
    params = {"id": package_id}
    package = requests.get(url, params=params).json()

    # Initialize an empty list to store data
    data_list = []

    # To get resource data:
    for idx, resource in enumerate(package["result"]["resources"]):

        # for datastore_active resources:
        if resource["datastore_active"]:

            # To get all records in CSV format:
            url = base_url + "/datastore/dump/" + resource["id"]
            resource_dump_data = requests.get(url).text
            try:
                data_list.append(
                    pd.read_csv(
                        io.StringIO(resource_dump_data),
                        on_bad_lines='skip'
                    )
                )
            except pd.errors.ParserError as e:
                print(f"Error parsing {resource['id']}: {e}")

    # Combine all dataframes in data_list into a single dataframe if data_list is not empty
    if data_list:
        df = pd.concat(data_list, ignore_index=True)
    else:
        df = pd.DataFrame()  # Create an empty dataframe if no data

    # Print the head of the dataframe
    print(df.head())

    return df
