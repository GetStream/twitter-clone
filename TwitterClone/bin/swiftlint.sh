if ! which swiftlint >/dev/null; then
    if ! which brew >/dev/null; then                    # If it's not found, check the Homebrew location and update PATH when needed
        if test -e "/usr/local/bin/brew"; then          # Default Homebrew location (pre M1 era)
            PATH="${PATH}:/usr/local/bin"
        elif test -e "/opt/homebrew/bin/brew"; then     # Default Homebrew location (M1 era)
            PATH="${PATH}:/opt/homebrew/bin"
        else
            echo "warning: Homebrew not found at default location"
        fi
    fi
fi

if which swiftlint >/dev/null; then
    swiftlint --quiet
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
