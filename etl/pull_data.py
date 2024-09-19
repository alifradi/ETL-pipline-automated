import json
from extract import get_data


def main():
    # Load the JSON file
    with open('functions_data.json') as f:
        config = json.load(f)

    # Iterate over each item in the JSON file and call get_data
    for item in config:
        base_url, package_id = item['arguments']
        print(f"Fetching data for {package_id}...")
        df = get_data(base_url, package_id)
        # You can save the dataframe to a file or database here if needed
        df.to_csv(f"{item['table_name']}.csv", index=False)
        print(f"Data for {package_id} saved to {item['table_name']}.csv")


if __name__ == "__main__":
    main()
