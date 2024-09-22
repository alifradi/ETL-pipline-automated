library(dplyr)
library(purrr)
library(tidyr)
library(lubridate)
library(jsonlite)
library(stringr)
library(readr)



# Define the path to the data directory
data_dir <- "/data"

# Read the data files from the volume
active_affordable_and_social_housing_units <- read.csv(file.path(data_dir, "active_affordable_and_social_housing_units.csv"), na = c("n/a",""), check.names = FALSE)

air_conditioned_and_cool_spaces_heat_relief_network <- read.csv(file.path(data_dir, "air_conditioned_and_cool_spaces_heat_relief_network.csv"), check.names = FALSE)

earlyon_child_and_family_centres <- read.csv(file.path(data_dir, "earlyon_child_and_family_centres.csv"), check.names = FALSE)

marriage_licence_statistics <- read.csv(file.path(data_dir, "marriage_licence_statistics.csv"), check.names = FALSE)

neighbourhood_crime_rates <- read.csv(file.path(data_dir, "neighbourhood_crime_rates.csv"), check.names = FALSE)

neighbourhood_profiles <- read.csv(file.path(data_dir, "neighbourhood_profiles.csv"), check.names = FALSE)

outbreaks_in_toronto_healthcare_institutions <- read.csv(file.path(data_dir, "outbreaks_in_toronto_healthcare_institutions.csv"), check.names = FALSE)

parks_and_recreation_facilities <- read.csv(file.path(data_dir, "parks_and_recreation_facilities.csv"), check.names = FALSE)

places_of_interest_and_toronto_attractions <- read.csv(file.path(data_dir, "places_of_interest_and_toronto_attractions.csv"), check.names = FALSE)

tennis_courts_facilities <- read.csv(file.path(data_dir, "tennis_courts_facilities.csv"), check.names = FALSE)

toronto_signature_sites <- read.csv(file.path(data_dir, "toronto_signature_sites.csv"), check.names = FALSE)


# Transformations
active_affordable_and_social_housing_units <- active_affordable_and_social_housing_units %>%
  select(-`_id`) %>%
  filter(!(is.na(`Subsidized Housing Units`))) %>%
  filter(!(is.na(`Affordable Housing Units`))) %>%
  separate(Quarter, into = c("Quarter", "Year"), sep = " ")

air_conditioned_and_cool_spaces_heat_relief_network <- air_conditioned_and_cool_spaces_heat_relief_network %>%
  select(
    -notes,
    -imageUrl,
    -`_id`,
    -locationTypeCode,
    -locationTypeDesc,
    -locationCode,
  )  %>% pivot_longer(values_to = 'Time' ,
                                                   names_to = 'event',
                                                   cols = contains(c("Close", "Open"))) %>%
  mutate(
    Day = case_when(
      str_detect(event, "mon") ~ "Monday",
      str_detect(event, "tue") ~ "Tuesday",
      str_detect(event, "wed") ~ "Wednesday",
      str_detect(event, "thu") ~ "Thursday",
      str_detect(event, "fri") ~ "Friday",
      str_detect(event, "sat") ~ "Saturday",
      str_detect(event, "sun") ~ "Sunday"
    )
  ) %>%
  mutate(EventType = case_when(
    str_detect(event, "Close") ~ "Close",
    str_detect(event, "Open") ~ "Open"
  )) %>%
  pivot_wider(values_from = Time, names_from = EventType) %>%
  group_by(locationId, Day) %>%
  fill(Open, Close) %>%
  arrange(desc(Open)) %>%
  fill(Open, Close) %>%
  ungroup() %>% 
  select(-event,- locationId) %>%
  unique() %>%
  mutate(
    Availability = case_when(
      str_detect(Open, "CALL") ~ "On call",
      str_detect(Open, "CLOSE") ~ "Not available/closed",
      str_detect(Open, "^\\d{4}$") &
        str_detect(Close, "^\\d{4}$") ~ paste0(abs(
          parse_date_time(Close, orders = "HM") - parse_date_time(Open, orders = "HM")
        ), " hours"),
      TRUE ~ NA_character_
    )
  ) %>%
  mutate(
    amenities = case_when(
      str_detect(amenities, "WRT_FNT:WI_FI:ACCESS:POOL") ~ "WIFI AND POOL",
      str_detect(amenities, "WRT_FNT:ACCESS:POOL") ~ "POOL",
      str_detect(amenities, "WI_FI:ACCESS") ~ "WIFI",
      str_detect(amenities, "WI_FI") ~ "WIFI",
      str_detect(amenities, "ACCESS:WI_FI:") ~ "WIFI",
      str_detect(amenities, "WRT_FNT:WI_FI:ACCESS") ~ "WIFI",
      str_detect(amenities, "ACCESS:POOL:WRT_FNT:") ~ "POOL",
      amenities == "PET_FRIENDLY" ~ "PET FRIENDLY" ,
      amenities == "POOL" ~ "POOL",
      TRUE ~ "ACCESS"
    )
  )

earlyon_child_and_family_centres <- earlyon_child_and_family_centres %>%
  select(-service_system_manager,
         -virtualHours,
         -`<html>`,
         - centre_type,
         -`_id`,
         -languages,
         -french_language_program,
         -indigenous_program,
         -programTypes,
         -serviceName,
         -website_name,
         ) %>%
  filter(if_any(everything(), ~ !is.na(.) & . != "")) %>%
  filter(!is.na(day))

marriage_licence_statistics <- marriage_licence_statistics %>%
  mutate(
    CIVIC_CENTRE = case_when(
      CIVIC_CENTRE == "NY" ~ 'North York',
      CIVIC_CENTRE == "SC" ~ "Scarborough",
      CIVIC_CENTRE == "TO" ~ "Toronto City Hall",
      CIVIC_CENTRE == "ET" ~ "East York"
    )
  )

neighbourhood_crime_rates <- neighbourhood_crime_rates %>%
  pivot_longer(names_to = 'mesure',
               values_to = 'Valeurs',
               cols = contains(
                 c(
                   'THEFTOVER',
                   'THEFTFROMMV',
                   'SHOOTING',
                   'ROBBERY',
                   'HOMICIDE',
                   'BREAKENTER',
                   'BIKETHEFT',
                   'AUTOTHEFT',
                   'ASSAULT'
                 )
               )) %>%
  mutate(Year = str_extract(mesure, "\\d{4}"),
         Incident = str_replace(mesure, "_?\\d{4}", "")) %>%
  filter(!is.na(Valeurs)) %>% 
  select(-POPULATION_2023,-`_id`)

neighbourhood_profiles <- neighbourhood_profiles %>%
  select(-Attribute) %>%
  pivot_longer(cols = !contains(
    c(
      "_id",
      "Category",
      'Topic',
      'Data Source',
      'Characteristic',
      'City of Toronto'
    )
  ),
  names_to = 'Neighborhood',
  values_to = 'Value')

outbreaks_in_toronto_healthcare_institutions <- outbreaks_in_toronto_healthcare_institutions %>%
  select(-`Causative Agent - 1`, -`Causative Agent - 2`)

parks_and_recreation_facilities <- parks_and_recreation_facilities

places_of_interest_and_toronto_attractions <- places_of_interest_and_toronto_attractions %>%
  select(-EMAIL, -RECEIVED_DATE,-LO_NUM_SUF, -HI_NUM, -HI_NUM_SUF)

tennis_courts_facilities <- tennis_courts_facilities

toronto_signature_sites <- toronto_signature_sites

print("Loding transformed data...")

# Save the transformed data to the transform volume
write_csv(active_affordable_and_social_housing_units, file.path("../clean_data", "active_affordable_and_social_housing_units_clean.csv"))
write_csv(air_conditioned_and_cool_spaces_heat_relief_network, file.path("../clean_data", "air_conditioned_and_cool_spaces_heat_relief_network_clean.csv"))
write_csv(earlyon_child_and_family_centres, file.path("../clean_data", "earlyon_child_and_family_centres_clean.csv"))
write_csv(marriage_licence_statistics, file.path("../clean_data", "marriage_licence_statistics_clean.csv"))
write_csv(neighbourhood_crime_rates, file.path("../clean_data", "neighbourhood_crime_rates_clean.csv"))
write_csv(neighbourhood_profiles, file.path("../clean_data", "neighbourhood_profiles_clean.csv"))
write_csv(outbreaks_in_toronto_healthcare_institutions, file.path("../clean_data", "outbreaks_in_toronto_healthcare_institutions_clean.csv"))
write_csv(parks_and_recreation_facilities, file.path("../clean_data", "parks_and_recreation_facilities_clean.csv"))
write_csv(places_of_interest_and_toronto_attractions, file.path("../clean_data", "places_of_interest_and_toronto_attractions_clean.csv"))
write_csv(tennis_courts_facilities, file.path("../clean_data", "tennis_courts_facilities_clean.csv"))
write_csv(toronto_signature_sites, file.path("../clean_data", "toronto_signature_sites_clean.csv"))
