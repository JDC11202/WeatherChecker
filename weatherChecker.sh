#!/bin/bash  

# Display script usage/help information
function display_usage() {
    echo "Usage: $0 [-l <Location>] [-f <file>] [-o <output_file>] [-t <type>] [-u <unit>] [-h]"
    echo "Options:"
    echo "  -l Specify a single input location. Supported location args: Cities, Airport Codes, Domain Names, Area Codes, Etc."
    echo "  -f Specify a text file with locations (one per line)."
    echo "  -o Specify the name of the output file (default: none, will not save to file)."
    echo "  -t Specify type of weather report. Supported types are 'simple' and 'detailed'."
    echo "  -u Specify temperature unit: 'C' for Celsius or 'F' for Fahrenheit (default: 'C')."
    echo "  -h Display help information."
    exit 1
}

echo "Welcome to WeatherChecker"

# Check if any arguments were provided
if [[ $# -eq 0 || "$1" == "-h" ]]; then
    display_usage
    exit 0
fi

report_type="simple"
location=""
file=""
output_file=""  # No default output file
unit="C"  # Default temperature unit (Celsius)

# Handle options/arguments
while getopts ":l:f:o:t:u:h" opt; do
    case $opt in
        l) 
            location="$OPTARG"
            ;;
        f) 
            file="$OPTARG"
            ;;
        o) 
            output_file="$OPTARG"
            ;;
        t)
            if [[ "$OPTARG" == "simple" || "$OPTARG" == "detailed" ]]; then
                report_type="$OPTARG"
            else
                echo "Invalid argument for -t."
                display_usage
                exit 1
            fi
            ;;
        u)
            if [[ "$OPTARG" == "C" || "$OPTARG" == "F" ]]; then
                unit="$OPTARG"
            else
                echo "Invalid argument for -u. Use 'C' for Celsius or 'F' for Fahrenheit."
                display_usage
                exit 1
            fi
            ;;
        h)
            display_usage
            ;;
        \?)
            display_usage
            ;;
        :)    
            echo "Option -$OPTARG requires an argument."
            display_usage
            ;;
    esac
done

# Prepare the locations to check
locations=()

# Function to validate location format
function is_valid_location() {
    # Allow letters, numbers, spaces, dashes, and underscores
    [[ "$1" =~ ^[a-zA-Z0-9\ _-]+$ ]]
}

# If a file is provided, read locations from it
if [ -n "$file" ]; then
    if [[ ! -f "$file" ]]; then
        echo "File not found: $file"
        exit 1
    fi
    while IFS= read -r line; do
        # Trim whitespace
        line=$(echo "$line" | xargs)
        # Validate and add the line if it's a valid location
        if is_valid_location "$line"; then
            locations+=("$line")
        else
            echo "Invalid location entry: '$line'. Skipping."
        fi
    done < "$file"
    # Debug output
    echo "Locations from file: ${locations[@]}"
# If a single location is provided, validate and add it to the list
elif [ -n "$location" ]; then
    if is_valid_location "$location"; then
        locations+=("$location")
    else
        echo "Invalid location entry: '$location'."
        exit 1
    fi
fi

# Combine locations for wttr.in
locations_string=$(IFS=,; echo "${locations[*]}")

# Debug output
echo "Combined locations string: $locations_string"

# Check if locations are correctly populated
if [ ${#locations[@]} -eq 0 ]; then
    echo "No valid locations found to check."
    exit 1
fi

# Fetch and display the weather for the provided locations
echo "Fetching weather for: $locations_string"

# Set the unit parameter based on user input
if [ "$unit" == "F" ]; then
    Temp_unit="u"
else
    Temp_unit="m"
fi

if [ "$report_type" == "simple" ]; then
    weather_info=$(curl -s "https://wttr.in/{$locations_string}?format=3&$Temp_unit")
else
    weather_info=$(curl -s "https://wttr.in/{$locations_string}?$Temp_unit")
fi

# Check if curl command was successful and output the weather
if [[ $? -eq 0 && -n "$weather_info" ]]; then
    echo "$weather_info"  # Echo the result to the command line
    if [ -n "$output_file" ]; then
        echo "$weather_info" > "$output_file"  # Save to the output file if specified
        echo "Weather results saved to $output_file"
    else
        echo "No output file specified. Results will not be saved."
    fi
else
    echo "Failed to fetch weather for: $locations_string"
fi
