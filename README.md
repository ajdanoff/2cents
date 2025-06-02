# 2 Cents

A draft implementation of Smoke Tests suite for the [headhunter test puzzle](https://github.com/ikarkaz/headHunterTest).

## Description

Description

This project demonstrates an advanced cross-platform automation solution for Windows
GUI testing on Ubuntu. Developed as a response to a real-world test problem from a
Russian IT company, it showcases the integration of Wine, Python, and AutoIt to
automate smoke tests for a Windows application.

Key highlights include:

* **Cross-platform automation**: Running Windows GUI tests on Ubuntu using Wine and AutoIt scripting.

* **Python-based orchestration**: Modular test plan implemented in Python (testqawin.py) using Pytest framework.

* **Detailed reporting**: Integration with Allure to generate comprehensive HTML reports and logs for easy analysis.

* **Custom automation scripts**: Multiple AutoIt scripts automate key user workflows such as activation, conversion, import/export, and exit.

* **Reproducible setup**: Use of virtual environments and configuration files to ensure consistent test execution.

This project highlights skills in automation pipeline design, cross-platform compatibility
solutions, and practical problem-solving in software quality assurance.

Project Structure

* `allure-report`: generated HTML report files
* `allure_results`: raw Allure data with logs
* `autoit-v3`: Windows distributive of AutoIt
* `handbook`: folder with unzipped XML file
* `headHunderTest`: folder with executable files for testing
* `screens`: screenshots taken during test execution
* **Autoit scripts**:
   * `activation_script.au3` 
   * `conversion_script.au3` 
   * `exit_script.au3` 
   * `import_export_script.au3` 
   * `import_script.au3`

* `config.ini`: configuration file
* `ED101.csv`: generated CSV file
* `handbook.zip`: downloaded handbook file
* `log.txt`: log file of testqawin.exe
* `PackedEPD.json`: generated JSON file
* `PackedEPD.xml`: generated XML file
* `README.md`: this readme file
* `requirements.txt`: Python dependencies list
* `testqawin.py`: Python test suite containing the test plan

## Getting Started

### Dependencies

* Ubuntu 25.04
* Wine
* Python 3.13.3
* AutoIt-V3
* Python requirements are listed in `requirements.txt`

### Installing

```
git clone git@github.com:ajdanoff/2cents.git
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Executing Tests

Run the test suite with:
```
pytest testqawin.py::TestPlanQAWin --log-cli-level=INFO --alluredir=./allure_results
```
View the test report:
```
allure serve allure_results
```
Generate a report for sharing:
```
allure generate allure_results
```

## Help
The AutoIt scripts require a screen resolution of **1854 x 967**. 
If you encounter display authorization issues, run:
```
bash ./conn_to_disp.sh
```

## Authors

[Alexander Zhdanov](mailto:alexander.jdanoff@gmail.com)

## Version History

* 0.1
    * Initial Release

## License

This project is licensed under the [GNU General Public License v3](./LICENSE).

## Acknowledgments

Inspired by the AutoIt community and the original headhunter test puzzle.

* [autoit](https://www.autoitscript.com/autoit3/docs)
