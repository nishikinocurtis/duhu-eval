if [ -z "$1" ]; then
  echo "Usage: $0 testcase_name"
  exit 1
fi

# LocalNative32g64
# LocalNative32g32
# LocalNative16g64
# LocalNative16g32
# LocalNative16g16
# LocalNative4g16
# LocalNative1g16

TESTCASE="$1"
CONFIG=${TESTCASE} sudo -E $(which python) raysort/main.py