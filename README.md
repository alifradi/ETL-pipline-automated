# ETL-pipline-automated

## Dataset
Population_Crime:
  Refresh_rate: Monthly
  Columns:
    - ASSAULT
    - AUTOTHEFT
    - BIKETHEFT
    - BREAKENTER
    - HOMICIDE
    - ROBBERY
    - SHOOTING
    - THEFTFROMMV
    - THEFTOVER
    - Years: ['2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023']

Housing_Affordability:
  Refresh_rate: Quarterly
  Columns:
    - Quarter
    - Subsidized Housing Units
    - Affordable Housing Units

Places_of_Interest_and_Toronto_Attractions:
  Refresh_rate: As available
  Columns:
    - ADDRESS_INFO
    - NAME
    - CATEGORY
    - GEOID
    - ADDRESS_FULL
    - POSTAL_CODE
    - MUNICIPALITY
    - CITY
    - WARD
    - WARD_2003
    - WARD_2018
    - geometry

Amenities:
  Refresh_rate: Monthly
  Columns:
    - LOCATIONID
    - ASSET_ID
    - ASSET_NAME
    - TYPE
    - AMENITIES
    - ADDRESS
    - geometry

Large_Industrial_Commercial_Properties:
  Refresh_rate: Monthly
  Columns:
    - site_name
    - district
    - closest_major_intersection
    - status
    - property_type_primary
    - total_site_area_acres
    - sq_ft_available
    - asking_price
    - planning_status
    - planning_status_zoning
    - planning_status_city_ward
    - geometry

Census_of_Population:
  Refresh_rate: Every 5 years
  Columns:
    - Category
    - Topic
    - Characteristic
    - City of Toronto
    - Neighborhoods

EarlyON_Child_and_Family_Centres:
  Refresh_rate: Daily
  Columns:
    - loc_id
    - program_name
    - languages
    - address
    - major_intersection
    - ward
    - lat
    - lng
    - geometry

Air_Conditioned_and_Cool_Spaces:
  Refresh_rate: Daily
  Columns:
    - locationId
    - locationTypeCode
    - locationTypeDesc
    - locationName
    - address
    - geometry

Outbreaks_in_Toronto_Healthcare_Institutions:
  Refresh_rate: Weekly
  Columns:
    - Institution Name
    - Institution Address
    - Outbreak Setting
    - Type of Outbreak
    - Date Outbreak Began
    - Date Declared Over
    - Active

Marriage_Licence_Statistics:
  Refresh_rate: Monthly
  Columns:
    - CIVIC_CENTRE
    - MARRIAGE_LICENSES
    - TIME_PERIOD

Tennis_Courts_Facilities:
  Refresh_rate: As available
  Columns:
    - ID
    - Name
    - Type
    - Lights
    - Courts
    - LocationAddress
    - WinterPlay
    - geometry
