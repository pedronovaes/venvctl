#!/usr/bin/env bats

setup() {
    # Script path to be tested.
    SCRIPT="./bin/venvctl.sh"

    # Temp dirs.
    mkdir -p /tmp/tmp_envs/
    export ENV_DIR="/tmp/tmp_envs"

    mkdir -p /tmp/mocks
    PATH="/tmp/mocks:$PATH"

    # Mock virtualenv.
    cat > /tmp/mocks/virtualenv <<'EOF'
#!/bin/bash
TARGET="${@: -1}"
mkdir -p "$TARGET/bin"
echo "#!/bin/bash" > "$TARGET/bin/activate"
EOF
    chmod +x /tmp/mocks/virtualenv

    # Mock pip.
    cat > /tmp/mocks/pip <<'EOF'
#!/bin/bash
echo "pip fake called $*"
EOF
    chmod +x /tmp/mocks/pip
}

teardown() {
    rm -rf /tmp/tmp_envs /tmp/mocks
}

@test "Display help with --help" {
    run $SCRIPT --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage: venvctl"* ]]
}

@test "Lists empty when no environments exist" {
    run $SCRIPT --list
    [ "$status" -eq 0 ]
    [[ "$output" == *"No environments found"* ]]
}

@test "Error when using --list together with --name" {
    run $SCRIPT --list --name testenv
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: --list flag should be used alone."* ]]
}

@test "Creates environment with --name" {
    run $SCRIPT --name testenv
    [ "$status" -eq 0 ]
    [[ -d "$ENV_DIR/testenv" ]]
    [[ "$output" == *"Virtual environment created successfully."* ]]
}

@test "Install packages with --req" {
    REQ_FILE="$(mktemp)"
    echo "requests" > "$REQ_FILE"

    run $SCRIPT --name testenv2 --req "$REQ_FILE"
    [ "$status" -eq 0 ]
    [[ "$output" == *"-r $REQ_FILE"* ]]

    rm -f "$REQ_FILE"
}

@test "Warns when requirements.txt does not exist" {
    run $SCRIPT --name testenv3 --req nonexistent.txt
    [ "$status" -eq 0 ]
    [[ "$output" == *"Warning: file nonexistent.txt not found"* ]]
}

@test "Deletes existing environment" {
    mkdir -p "$ENV_DIR/testenv_del"
    run $SCRIPT --delete testenv_del
    [ "$status" -eq 0 ]
    [[ "$output" == *"Environment 'testenv_del' removed"* ]]
    [ ! -d "$ENV_DIR/testenv_del" ]
}

@test "Error when deleting non-existent environment" {
    run $SCRIPT --delete notfound
    [ "$status" -eq 0 ]
    [[ "$output" == *"not found"* ]]
}

@test "Error when using invalid flag option" {
    run $SCRIPT --invalid
    [ "$status" -eq 1 ]
    [[ "$output" == *"venvctl: invalid option"* ]]
}
