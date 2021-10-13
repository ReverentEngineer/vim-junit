import xml.etree.ElementTree as ET
from argparse import ArgumentParser

def interpret(tree):
    root = tree.getroot()
    result = dict(testsuites=[])
    if root.tag == "testsuite":
        testsuites = [root]
    elif root.tag == "testsuites":
        testsuites = root.findall('testsuite')
    else:
        raise RuntimeError("Invalid root tag")
    
    for suite in testsuites:
        testsuite = suite.attrib.copy()
        testsuite['testcases'] = []
        for case in suite.findall('testcase'):
            testcase = case.attrib.copy()
            testcase['failures'] = []
            for failure in case.findall('failure'):
                testfailure = failure.attrib.copy()
                testfailure['text'] = failure.text
                testcase['failures'].append(testfailure)
            testsuite['testcases'].append(testcase)
        result['testsuites'].append(testsuite)
    return result

def loads(data):
    tree = ET.fromstring(data)
    return interpret(tree)

def load(filename):
    tree = ET.parse(filename)
    return interpret(tree)

def main():
    parser = ArgumentParser()
    parser.add_argument("junit_file")
    args = parser.parse_args()
    testsuite = load(args.junit_file)
    import json
    print(json.dumps(testsuite, indent=4, sort_keys=True))


if __name__ == '__main__':
    main()
