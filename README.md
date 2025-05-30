# 2 Cents

A draft implementation of Smoke Tests suite for the headhunter test puzzle.\
https://github.com/ikarkaz/headHunterTest 

## Description

An example implementation of Windows GUI Test Suite on Ubuntu using wine + python + AutoIt.
The project contains the following files and folders:
* allure-report: generated html files
* allure_results: raw allure data with logs
* autoit-v3: a windows distributive of autoit
* handbook: a folder with an unzipped xml file
* headHunderTest: a folder with exe files necessary to test
* screens: contains screenshots taken during the tests execution
* autoit scripts:
  * activation_script.au3
  * conversion_script.au3
  * exit_script.au3
  * import_export_script.au3
  * import_script.au3
* config.ini: a configuration file
* ED101.csv: a generated csv
* handbook.zip: a downloaded handbook file
* log.txt: a log file of testqawin.exe
* PackedEPD.json: a generated json file
* PackedEPD.xml: a generated xml file
* README.md: a readme
* requirements.txt: a list of requirements for python
* testqawin.py: a python file with tests which contains a test plan.

## Getting Started

### Dependencies

* Ubuntu 25.04
* Wine
* Python 3.13.3
* AutoIt-V3
* Python requirements are listed in requirements.txt

### Installing

* clone project using git: ```git clone git@github.com:ajdanoff/2cents.git```
* create virtual environment: ```python3 -m venv .venv```
* ```source myenv/bin/activate```
* ```pip install -r requirements.txt```

### Executing program

* run the program using pytest: 
```
pytest testqawin.py::TestPlanQAWin --log-cli-level=INFO --alluredir=./allure_results
```
* to see results of the test suite run:
```
allure serve allure_results
```
* to generate a report for the test suite run:
```
allure generate allure_results
```

## Help
The autoit scripts are not scaled to different screen resolutions. You need to
set your display to use the following resolution 1854 x 967.
In case you have display authorization problems run the following script:
```
bash ./conn_to_disp.sh
```

## Authors

Contributors names and contact info

[Alexander Zhdanov](mailto:alexander.jdanoff@gmail.com)

## Version History

* 0.1
    * Initial Release

## License

This project is licensed under the [GNU GENERAL PUBLIC LICENSE V. 3] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, take a look at.
* [autoit](https://www.autoitscript.com/autoit3/docs)