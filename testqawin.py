import configparser
import logging
import pdb
import time

import allure
import pytest
import requests
import shutil
import zipfile
import subprocess
import pyautogui
from PIL import Image
import os.path
import xml.etree.ElementTree as ET
import csv
import json


class XmlTools:
    """
    Class is for parsing xml files and xml structure checks.
    """

    @staticmethod
    def parse_xml(xml_file: str, tags: list[str]) -> list:
        """
        parse xml file and return xml items with tags
        Args:
            xml_file: str
            tags: list

        Returns: a list of xml nodes
        """
        def traverse_tree(root, xml_items, tags):
            if root.tag in tags:
                xml_items.append(root)
            for child in root:
                # xml_items.append(child)
                traverse_tree(child, xml_items, tags)

        xml_items = []
        try:
            tree = ET.parse(xml_file)
            root = tree.getroot()
            traverse_tree(root, xml_items, tags)
        except FileNotFoundError:
            logging.getLogger().error("file not found")
        except ET.ParseError:
            logging.getLogger().error("invalid xml format")
        return xml_items

    @staticmethod
    def check_headers_eq(header1, header2, keys):
        diff = {}
        for key in keys:
            val1 = header1.get(key)
            val2 = header2.get(key)
            if val1 != val2:
                diff[key] = [val1, val2]
        return diff

    @staticmethod
    def check_header_val_sum_tags(xml_items, header_key, tag, attrib_name=None):
        # first take header value
        head_val = None
        if xml_items[0].get(header_key).isdigit():
            head_val = int(xml_items[0].get(header_key))
        num = 0
        for i in range(1, len(xml_items)):
            item = xml_items[i]
            if item.tag == tag:
                if attrib_name:
                    attrs = item.attrib
                    attr = attrs.get(attrib_name)
                    if attr.isdigit():
                        num += int(attr)
                else:
                    num += 1
        return head_val, num

    @staticmethod
    def check_ed101_struct(xml_items):
        ed_date = xml_items[0].get("EDDate")
        ed_author = xml_items[0].get("EDAuthor")
        malformed_items = []
        for i in range(1, len(xml_items)):
            item = xml_items[i]
            if item.get("EDDate") != ed_date:
                malformed_items.append(item)
            elif item.get("EDAuthor") != ed_author:
                malformed_items.append(item)
            elif item.get("EDNo") != str(i):
                malformed_items.append(item)

        return malformed_items

    @classmethod
    def extrct_node_attrs(cls, item, node_map, nodes_map):
        if item.tag in nodes_map:
            if nodes_map[item.tag] == "Text":
                node_map[item.tag] = item.text
            elif isinstance(nodes_map[item.tag], list):
                attrs = item.attrib
                for attr in nodes_map[item.tag]:
                    if isinstance(attr, str):
                        node_map[attr] = attrs.get(attr)
                    elif isinstance(attr, dict):
                        for child in item:
                            cls.extrct_node_attrs(child, node_map, attr)
            elif isinstance(nodes_map[item.tag], dict):
                for child in item:
                    cls.extrct_node_attrs(child, node_map, nodes_map[item.tag])

    @classmethod
    def extrct_nodes_with_attrs(cls, xml_items, nodes_map):
        header = xml_items[0]
        xtrctd_data = []
        for i in range(1, len(xml_items)):
            node_map = {}
            item = xml_items[i]
            cls.extrct_node_attrs(item, node_map, nodes_map)
            xtrctd_data.append(node_map)
        return xtrctd_data

    @classmethod
    def comp_maps(cls, payer_nodes, bicdir_nodes, comp_map, check_length=False):
        diff = {}
        if check_length and (len(payer_nodes) != bicdir_nodes):
            return False, diff
        for i in range(len(payer_nodes)):
            payer_node = payer_nodes[i]
            bicdir_node = bicdir_nodes[i]
            for key, value in comp_map.items():
                comp_key = f"{key}:{value}"
                if key in payer_node and value in bicdir_node:
                    if payer_node[key] != bicdir_node[value]:
                        if comp_key not in diff:
                            diff[comp_key] = (i, payer_node, bicdir_node)
                else:
                    diff[comp_key] = (i, payer_node, bicdir_node)

        return diff == {}, diff


class AdminTools(XmlTools):
    """
    Class is for administration routines.
    """

    @staticmethod
    def download_file(url: str, local_file_name: str) -> str | None :
        """
        downloads a file using url and saves to a file
        Args:
            url: url to download a file
            local_file_name: local file name
        Returns: file name or None

        """
        try:
            with requests.get(url, stream=True) as r:
                r.raise_for_status()
                with open(local_file_name, 'wb+') as f:
                    shutil.copyfileobj(r.raw, f)
            return local_file_name
        except requests.exceptions.RequestException as e:
            logging.getLogger().error("an error occurred: %s", e)
            return None

    @staticmethod
    def unzip_file(zip_filepath, extract_to_path, sep="\\"):
        paths = []
        with zipfile.ZipFile(zip_filepath, 'r') as zip_ref:
            zip_ref.extractall(extract_to_path)
            names = zip_ref.namelist()
            for name in names:
                paths.append(f"{extract_to_path}{sep}{name}")
        return paths

    @staticmethod
    def run_wine_subprocess(*args, capture_output=False):
        return subprocess.run(["wine", *args], capture_output=capture_output)

    @classmethod
    def read_csv_headers(cls, csv_file):
        headers = None
        data = []
        with open(csv_file, "r") as file:
            reader = csv.reader(file)
            headers = next(reader)
            while True:
                try:
                    data.append(next(reader))
                except StopIteration:
                    break
        return headers, data

    @classmethod
    def read_json(cls, json_file):
        data = None
        with open(json_file, 'r') as file:
            data = json.load(json_file)
        return data


@allure.suite("Test QA")
class TestPlanQAWin:
    """
    1. On the website of the Bank of Russia (http://cbr.ru) download the Directory of Participants
     of the Payment System of the Bank of Russia (ED807) for use when working with the application.
    2. Unzip the handbook.zip
    3. Testcases:
        3.1 Activation
            Given that the program is running:
            3.1.1 Check that menu «? -> О программе» is available
            3.1.2 Click on the «? -> О программе» button
            3.1.3 Enter the email credentials in the text field
            3.1.4 Click OK Button
            3.1.5 Check that the activation key is successfully entered. (Take a screenshot)
        3.2 Conversion
            Given that the program is running:
            3.2.1 Check that menu «Сonvert -> ED807toPacketEPD» is available
            3.2.2 Click on the «Сonvert -> ED807toPacketEPD» button
            3.2.3 Choose a xml file using the file chooser using the following format: «*.ED807*.xml»
            3.2.3 Check that PacketEPD.xml exists
        3.3 Check generated PacketEPD.xml structure
            Given that the resulting PacketEPD.xml has been generated
            3.3.1 Check PacketEPD has the same headers (EDNo, EDDate и EDAuthor) as in ED807
            3.3.2 Check EDQuantity, Sum, SystemCode=”01”
            3.3.3 Check that PacketEPD has ED101 structure.
                3.3.3.1 for every ED101 tag:
                    a. check EDDate and EDAuthor attributes are the same as in header
                    b. check that EDNo is unique (incremented by 1 for each tag)
            3.3.4 Check PacketEPD Payer corresponding attributes have the same values as in BICDirectoryEntry
                AccDocNo=ParticipantInfo.PtType, AccDocDate=ParticipantInfo.DateIn, Sum=ParticipantInfo.Rgn,
                ed:Name=ParticipantInfo.NameP, BIC=BICDirectoryEntry.BIC, CorrespAcc=Accounts.Account
            3.3.5 Check PacketEPD Payee corresponding attributes have the same values as in BICDirectoryEntry
                ed:Name=ParticipantInfo.NameP, BIC=BICDirectoryEntry.BIC, CorrespAcc=Accounts.Account
        3.4 Import
            3.4.1 Check that PacketEPD.xml exists
            Given that the program is running:
            3.4.2 Check that menu «Import -> PacketEPD» is available, click, wait until the table is loaded
        3.5 Export to CSV and JSON
            3.5.1 Check that menu «Export -> to CSV» is available, click to export
            3.5.2 Check that menu «Export -> to CSV» is available, click to export, wait until Export to JSON
            message is appeared.
            3.5.3 Check that both ED101.csv and PacketEPD.json exist
        3.6 Check exported ED101.csv
            Given that ED101.csv is exported:
            3.5.1 Check the following columns in ED101.csv:
                  - ED101:
                      0 «БИК Плательщика»
                      1 «БИК Получателя»
                      2 «Сумма»
                      3 «Номер документа»
                      4 «Дата документа»
                      5 «Назначение платежа»
        3.7 Check exported PacketEPD.json
            Given that PacketEPD.json is exported:
            3.7.1 Check that it contains data
        3.8 Exit
            Given that the program is running:
            3.7.1 Click on the exit button
    4. Generate report using allure
    """

    @pytest.fixture(scope="class")
    def config(self):
        config = configparser.ConfigParser()
        config.read("config.ini")
        yield config

    @pytest.fixture(scope="class")
    def unzip_handbook(self, config):
        config = config["HANDBOOK"]
        paths = AdminTools.unzip_file(config["HANDBOOK_FILE"], config["HANDBOOK_DIR"])
        yield paths

    @pytest.fixture(scope="class")
    def parse_xml_items(self, config, unzip_handbook):
        xml_items_handbook = AdminTools.parse_xml(
            unzip_handbook[0].replace("\\", "/"),
            tags=["{urn:cbr-ru:ed:v2.0}ED807", "{urn:cbr-ru:ed:v2.0}BICDirectoryEntry"]
        )
        xml_items_epd = AdminTools.parse_xml(config["CONVERSION"]["CVRT_FILE"], tags=["PacketEPD", "ED101"])
        yield xml_items_handbook, xml_items_epd

    @pytest.fixture(scope="class")
    def csv_headers(self):
        return ["БИК Плательщика", "БИК Получателя", "Сумма", "Номер документа", "Дата документа", "Назначение платежа"]

    @allure.testcase("1. download the Directory of Participants of the Payment System")
    def test_download_handbook(self, config):
        config = config["HANDBOOK"]
        local_file_name = AdminTools.download_file(config["HANDBOOK_URL"], config["HANDBOOK_FILE"])
        assert local_file_name is not None, "the file has not been downloaded properly !"

    @allure.testcase("3.1 Activation")
    def test_activation(self, config):
        # config = config["ACTIVATION"]
        AdminTools.run_wine_subprocess(
            config["AUTOIT"]["AUTOIT_EXE"],
            config["ACTIVATION"]["ACT_SCRPT"],
            config["TESTQAWIN"]["TQAW_EXE"],
            config["ACTIVATION"]["ACT_EMAIL"],
        )
        time.sleep(5)
        im1: Image.Image = pyautogui.screenshot(region=(70, 947, 300, 15))
        im1.save(config["ACTIVATION"]["ACTIVATION_TMPLT"])
        assert os.path.exists(config["ACTIVATION"]["ACTIVATION_TMPLT"]), "a screenshot has not been created"

    @allure.testcase("3.2 Conversion")
    def test_conversion(self, config, unzip_handbook):
        # config = config["ACTIVATION"]
        AdminTools.run_wine_subprocess(
            config["AUTOIT"]["AUTOIT_EXE"],
            config["CONVERSION"]["CVRT_SCRPT"],
            config["TESTQAWIN"]["TQAW_EXE"],
            config["ACTIVATION"]["ACT_EMAIL"],
            unzip_handbook[0]
        )
        assert os.path.exists(config["CONVERSION"]["CVRT_FILE"]), \
            f"a conversion file {config["CONVERSION"]["CVRT_FILE"]} has not been created !"

    @allure.testcase("3.3.1 Check PacketEPD headers")
    def test_check_headers_epd(self, parse_xml_items):
        # pdb.set_trace()
        xml_items_handbook, xml_items_epd = parse_xml_items
        diff = AdminTools.check_headers_eq(xml_items_handbook[0], xml_items_epd[0], keys=["EDNo", "EDDate", "EDAuthor"])
        assert diff == {}, f"diff for header elements is not empty: {diff}"
        # logging.getLogger().info(xml_items_handbook)
        # logging.getLogger().info(xml_items_epd)

    @allure.testcase("3.3.2 Check EDQuantity, Sum, SystemCode='01'")
    def test_check_header_sum_epd(self, parse_xml_items):
        # pdb.set_trace()
        _, xml_items_epd = parse_xml_items
        head_val, num = AdminTools.check_header_val_sum_tags(xml_items_epd, header_key="EDQuantity", tag="ED101")
        assert head_val == num, f"header value EDQuantity: {head_val} != the number of tags ED101: {num} "
        head_val, num = AdminTools.check_header_val_sum_tags(xml_items_epd, header_key="Sum", tag="ED101",
                                                             attrib_name="Sum")
        assert head_val == num, f"header value Sum: {head_val} != the sum of tag ED101 Sum attributes: {num} "

    @allure.testcase(
        "3.3.4 Check PacketEPD Payer corresponding attributes have the same values as in BICDirectoryEntry.")
    def test_check_epd_payer_attrs(self, parse_xml_items):
        # pdb.set_trace()
        xml_items_handbook, xml_items_epd = parse_xml_items
        payer_node_map = {
            "ED101": ["Sum",
                      {"AccDoc": ["AccDocNo", "AccDocDate"]},
                      {"Payer": {"Name": "Text", "Bank": ["BIC", "CorrespAcc"]}}
                      ]
        }
        payer_nodes = AdminTools.extrct_nodes_with_attrs(xml_items_epd, payer_node_map)
        logging.getLogger().info("gathered payer data: ", payer_nodes)
        bicdir_node_map = {
            "{urn:cbr-ru:ed:v2.0}BICDirectoryEntry": ["BIC",
                                                      {"{urn:cbr-ru:ed:v2.0}ParticipantInfo": ["PtType", "DateIn",
                                                                                               "Rgn", "NameP"]},
                                                      {"{urn:cbr-ru:ed:v2.0}Accounts": ["Account"]}
                                                      ]
        }
        bicdir_nodes = AdminTools.extrct_nodes_with_attrs(xml_items_handbook, bicdir_node_map)
        bicdir_nodes_even = [bicdir_nodes[i] for i in range(len(bicdir_nodes)) if i % 2 == 0]
        logging.getLogger().info("gathered bicdir data: ", bicdir_nodes_even)
        comp_map = {
            "AccDocNo": "PtType",
            "AccDocDate": "DateIn",
            "Sum": "Rgn",
            "Name": "NameP",
            "BIC": "BIC",
            "CorrespAcc": "Account"
        }
        check_diff, diff = AdminTools.comp_maps(payer_nodes, bicdir_nodes_even, comp_map)
        assert check_diff, f"ED101:Payer and ED807:BICDirectoryEntry are different: {diff}"

    @allure.testcase(
        "3.3.5 Check PacketEPD Payee corresponding attributes have the same values as in BICDirectoryEntry.")
    def test_check_epd_payee_attrs(self, parse_xml_items):
        xml_items_handbook, xml_items_epd = parse_xml_items
        payee_node_map = {
            "ED101": {
                "Payee": {"Name": "Text", "Bank": ["BIC", "CorrespAcc"]}
            }
        }
        payee_nodes = AdminTools.extrct_nodes_with_attrs(xml_items_epd, payee_node_map)
        logging.getLogger().info("gathered payer data: ", payee_nodes)
        bicdir_node_map = {
            "{urn:cbr-ru:ed:v2.0}BICDirectoryEntry": ["BIC",
                                                      {"{urn:cbr-ru:ed:v2.0}ParticipantInfo": ["NameP"]},
                                                      {"{urn:cbr-ru:ed:v2.0}Accounts": ["Account"]}
                                                      ]
        }
        bicdir_nodes = AdminTools.extrct_nodes_with_attrs(xml_items_handbook, bicdir_node_map)
        bicdir_nodes_odd = [bicdir_nodes[i] for i in range(len(bicdir_nodes)) if i % 2 != 0]
        logging.getLogger().info("gathered bicdir data: ", bicdir_nodes_odd)
        comp_map = {
            "Name": "NameP",
            "BIC": "BIC",
            "CorrespAcc": "Account"
        }
        check_diff, diff = AdminTools.comp_maps(payee_nodes, bicdir_nodes_odd, comp_map)
        assert check_diff, f"ED101:Payer and ED807:BICDirectoryEntry are different: {diff}"

    @allure.testcase("3.4 Import")
    def test_import(self, config):
        # config = config["ACTIVATION"]
        assert os.path.exists(config["CONVERSION"]["CVRT_FILE"]), \
            f"a conversion file {config["CONVERSION"]["CVRT_FILE"]} has not been created !"

        AdminTools.run_wine_subprocess(
            config["AUTOIT"]["AUTOIT_EXE"],
            config["IMPORT"]["IMPRT_SCRPT"],
            config["TESTQAWIN"]["TQAW_EXE"],
            config["ACTIVATION"]["ACT_EMAIL"]
        )

        # assert compl_proc.stdout != b'', "no data imported !"
        time.sleep(5)
        im1: Image.Image = pyautogui.screenshot(region=(68, 90, 1780, 855))
        im1.save(config["IMPORT"]["IMPRT_TMPLT"])
        assert os.path.exists(config["IMPORT"]["IMPRT_TMPLT"]), "a screenshot has not been created"
        # logging.getLogger().info("stdout: %s, stderr: %s", compl_proc.stdout, compl_proc.stderr)

    @allure.testcase("3.5 Export to CSV and JSON")
    def test_export_to_csv_json(self, config):
        # config = config["ACTIVATION"]
        assert os.path.exists(config["CONVERSION"]["CVRT_FILE"]), \
            f"a conversion file {config["CONVERSION"]["CVRT_FILE"]} has not been created !"

        compl_proc = AdminTools.run_wine_subprocess(
            config["AUTOIT"]["AUTOIT_EXE"],
            config["IMPORT"]["IMPRT_EXPRT_SCRPT"],
            config["TESTQAWIN"]["TQAW_EXE"],
            config["ACTIVATION"]["ACT_EMAIL"]
        )

        time.sleep(5)

        assert os.path.exists(config["IMPORT"]["IMPRT_CSV_FILE"]), \
            f"a csv file {config["IMPORT"]["IMPRT_CSV_FILE"]} has not been created !"
        assert os.path.exists(config["IMPORT"]["IMPRT_JSON_FILE"]), \
            f"a json file {config["IMPORT"]["IMPRT_JSON_FILE"]} has not been created !"

        # logging.getLogger().info("stdout: %s, stderr: %s", compl_proc.stdout, compl_proc.stderr)

    @allure.testcase("3.6 Check exported ED101.csv")
    def test_exported_csv(self, config, csv_headers):
        assert os.path.exists(config["IMPORT"]["IMPRT_CSV_FILE"]), \
            f"a csv file {config["IMPORT"]["IMPRT_CSV_FILE"]} has not been created !"
        headers, data = AdminTools.read_csv_headers(config["IMPORT"]["IMPRT_CSV_FILE"])
        assert data != [], "no data in csv !"
        for header in csv_headers:
            assert header in headers, f"header: {header} is not in csv headers: {csv_headers}"

    @allure.testcase("3.7 Check exported PacketEPD.xml")
    def test_exported_json(self, config):
        assert os.path.exists(config["IMPORT"]["IMPRT_JSON_FILE"]), \
            f"a json file {config["IMPORT"]["IMPRT_JSON_FILE"]} has not been created !"
        headers, data = AdminTools.read_csv_headers(config["IMPORT"]["IMPRT_JSON_FILE"])
        assert data is not None, "no data in json !"

    @allure.testcase("3.8 Exit")
    def test_exit(self, config):
        # config = config["ACTIVATION"]
        compl_proc = AdminTools.run_wine_subprocess(
            config["AUTOIT"]["AUTOIT_EXE"],
            config["EXIT"]["EXT_SCRPT"],
            config["TESTQAWIN"]["TQAW_EXE"],
            capture_output=True
        )
        assert compl_proc.stderr == b'', "there is an error during exit !"