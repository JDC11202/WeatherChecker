<h1 align="center"> WeatherChecker </h1> <br>
<p align="center">
    <img alt=WeatherChecker title="WeatherChecker" src="Images/WeatherCheckerGif.gif">
</p>

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Options](#Options)

## Introduction

This Bash script project is designed to make it easy to check weather forecasts from open-source providers. This project uses the <a href="https://https://wttr.in">wttr.in</a> service specifically to allow users to input any city, postal code, airport code, etc. from either a text file of locations or the command line. 

## Usage

To use the WeatherChecker script, run the following command within your terminal.

<p>```bash <br>
./weatherChecker.sh [options]
</p>

## Options

The following options can be utilized by users within the WeatherChecker script:
* -l (location): Specify a single input location, Supported formats for wttr.in include Cities (+ for spaces in names), airport codes, domain names, area codes, and coordinates.
* -f (file): Specify a text file containing locations (one per line).
* -o (output_file): Specify the output file where results will be saved (default: none).
* -t (type): Specify the type of weather report: Supported types are <ins>Simple</ins> and <ins>Detailed</ins>.
* -u (unit): Specify the Standard Unit of Measure (Celcius or Fahrenheit).
* -h: Display help information.