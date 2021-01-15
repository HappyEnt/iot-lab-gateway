#! /bin/bash

GIT_DIR=$(readlink -e $(dirname $0)/..)
HDR="${GIT_DIR}/tests_utils/COPYING_HEADER"


files_list=$(git ls-tree -r HEAD --full-tree --name-only)
# exclude some files
files_list=$(echo "${files_list}" | grep -v \
    -e 'tests_utils/' \
    -e '.gitignore' \
    -e 'setup.cfg' \
    -e 'tox.ini' \
    -e '.md$' \
    -e '.elf' \
    -e '.hex' \
    -e '.github/workflows/python-test.yml' \
    -e 'codecov.yml' \
    -e 'Dockerfile' \
    -e 'node.z1' \
    -e '.json'\
    -e 'AUTHORS' \
    -e 'COPYING' \
    -e 'MANIFEST.in'\
    -e 'README'\
    -e 'CHANGELOG'\
    -e '.coveragerc'\
    \
    -e 'gateway_code/static'\
    -e 'gateway_code/tests/config/'\
    -e 'bin/rules.d'\
    -e 'doc' \
    -e '.jpg' \
    \
    -e 'control_node_serial/tests/utils/' \
    -e 'control_node_serial/examples/' \
    -e 'control_node_serial/src/control_node_measures.rb'\
    -e 'control_node_serial/src/control_node_measures_oml.h'\
    -e 'Makefile'\
    -e '.dot'\
)

# Verify that 'AUTHORS' and 'COPYING' files exist
check_license_files() {
    test -f AUTHORS && test -f COPYING
    local ret=$?
    if [[ $ret -ne 0 ]]; then
        echo "Files AUTHORS and COPYING must be present" >&2
    fi
    return $ret
}


# Verify that file has license header
check_file_header() {
    local file="$1"
    # ignore not commited removed files
    test -f "${file}" || return 0

    # common lines == copying header
    grep -F -x -f ${HDR} "${file}" | diff - ${HDR} > /dev/null

    local ret=$?
    if [[ $ret -ne 0 ]]; then
        echo "Copying header not in ${file}" >&2
    fi
    return $ret
}


# Verify that all_files have license header
check_headers() {
    local ret=0
    for file in ${files_list}
    do
        check_file_header "$file"
        ret=$(( $ret + $? ))
    done

    if [[ $ret -ne 0 ]]; then
        echo "There are $ret wrong files"
    fi
    return $ret
}



check_license_files && check_headers
exit $?
