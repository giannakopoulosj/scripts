#!/bin/bash

set -e

_INCLUDE_PATTERN="R*.xml"
_REMOTE_USER="remote_user"
_REMOTE_HOST="foo.bar.lan"
_REMOTE_PATH="foo/bar"

rsync --remove-source-files -zvh ssh --include "$_INCLUDE_PATTERN" --exclude '*' backup.tar "$_REMOTE_USER"@"$_REMOTE_HOST":"$_REMOTE_PATH"

