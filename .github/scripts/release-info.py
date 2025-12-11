import json
import os
import re
import sys
from datetime import date as _date  # avoid name clash with the `date` variable

# inspired by https://github.com/input-output-hk/jormungandr/blob/master/ci/release-info.py


def read_version(release_file, ref=None):
    """
    Reads the version from the release file,
    and optionally validates it against the given tag reference.
    """

    with open(release_file, "r") as read_file:
        d = json.load(read_file)
    version = d["version"]

    # validate version vs tag (when we have a tag ref)
    if ref is not None and ref.startswith("refs/tags/v") and ref != "refs/tags/v" + version:
        print(
            "::error file={path}::version {0} does not match release tag {1}".format(
                version, ref, path=release_file
            )
        )
        sys.exit(1)
    return version


event_name = sys.argv[1]

# YYYYMMDD (used for nightly builds)
date = _date.today().strftime("%Y%m%d")

ref = None

if event_name == "push":
    ref = os.getenv("GITHUB_REF")
    if ref.startswith("refs/tags/"):
        # real tagged release
        release_type = "tagged"
    elif ref == "refs/heads/ci/test/nightly":
        # emulate the nightly workflow
        release_type = "nightly"
        ref = None
    else:
        raise ValueError("unexpected ref " + ref)

elif event_name == "schedule":
    # scheduled nightly build
    release_type = "nightly"

elif event_name == "workflow_dispatch":
    # manual run: behave like a tagged build,
    # but don't validate against a tag ref
    release_type = "tagged"
    ref = None

else:
    raise ValueError("unexpected event name " + event_name)

version = read_version("release.json", ref)
prerelease = "false"

if release_type == "tagged":
    # plain version, tag is v<version>
    tag = "v" + version

elif release_type == "nightly":
    # nightly suffix & tag
    version = re.sub(
        r"^(\d+\.\d+\.\d+)(-.*)?$",
        r"\1-nightly." + date,
        version,
    )
    tag = "nightly." + date
    prerelease = "true"

for name in ("version", "date", "tag", "release_type", "prerelease"):
    print("::set-output name={0}::{1}".format(name, globals()[name]))
