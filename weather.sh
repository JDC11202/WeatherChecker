#!/bin/bash  

# Display script usage/help information
function display_usage() {
    echo "Usage: $0 [-l <Location>] [-o <output_file>] [-t <type>] [-u <unit>] [-h]"
    echo "Options:"
    echo "  -l Specify an input location. Supported location args: Cities, Airport Codes, Domain Names, Area Codes, Etc."
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
output_file=""  # No default output file
unit="C"  # Default temperature unit (Celsius)

# Handle options/arguments
while getopts ":l:o:t:u:h" opt; do
    case $opt in
        l) 
            location="$OPTARG"
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

# Check if Location has been provided
if [ -z "$location" ]; then
    echo "Please provide a Location for WeatherChecker"
    display_usage
fi

# Fetch and display the weather for the provided location
echo "Fetching weather for: $location"

# Set the unit parameter based on user input
if [ "$unit" == "F" ]; then
    Temp_unit="u"
else
    Temp_unit="m"
fi

if [ "$report_type" == "simple" ]; then
    weather_info=$(curl -s "https://wttr.in/$location?format=3&$Temp_unit")
else
    weather_info=$(curl -s "https://wttr.in/$location?$Temp_unit")
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
    echo "Failed to fetch weather for: $location"
fi
