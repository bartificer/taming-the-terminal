#!/usr/bin/env python3
#
# (re)create the mp3_files from all the audio macros in the book
#
# 2025-12-11 Helma van der Linden
#
import re
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
SRC_DIR = ROOT_DIR / "book"
VARS_FILE = SRC_DIR / "variables.adoc"
OUT_DIR = ROOT_DIR / "publish"
OUT_FILE = OUT_DIR / "mp3_files"

AUDIO_MACRO_RE = re.compile(r"audio::([^\[]+)\[")

ATTR_LINE_RE = re.compile(r"^:([^:]+):\s*(.*)$")
ATTR_REF_RE = re.compile(r"\{([^}]+)\}")


def load_attributes_from_file(path: Path) -> dict:
    """Load :name: value attributes from an AsciiDoc file into a dict."""
    attrs = {}
    if not path.is_file():
        return attrs
    for line in path.read_text(encoding="utf-8").splitlines():
        m = ATTR_LINE_RE.match(line)
        if m:
            name, value = m.group(1), m.group(2)
            attrs[name] = value
    return attrs


def expand_attributes(s: str, attrs: dict, missing_warn: bool = False, context: str = "") -> str:
    """
    Expand {attr} references in s using attrs dict.
    - If an attribute is missing, it is left as {attr}.
    - Optionally prints a warning if missing_warn=True.
    """
    def repl(match):
        name = match.group(1)
        if name in attrs:
            return attrs[name]
        if missing_warn:
            print(f"WARNING: unresolved attribute '{{{name}}}' in {context!r}: {s!r}")
        return match.group(0)  # keep {name} as-is

    return ATTR_REF_RE.sub(repl, s)


def main():
    print(f"Updating {OUT_FILE} from audio:: macros in {SRC_DIR}")

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    # 1. Load global attributes from variables.adoc
    global_attrs = load_attributes_from_file(VARS_FILE)
    if global_attrs:
        print(f"Loaded {len(global_attrs)} global attributes from {VARS_FILE}")
    else:
        print(f"WARNING: no global attributes found in {VARS_FILE}")

    all_refs = set()

    # 2. Walk all .adoc files under SRC_DIR
    for adoc in sorted(SRC_DIR.rglob("*.adoc")):
        text = adoc.read_text(encoding="utf-8")

        # Per-file attributes: local override global if same name
        file_attrs = load_attributes_from_file(adoc)
        combined_attrs = dict(global_attrs)
        combined_attrs.update(file_attrs)

        matches = AUDIO_MACRO_RE.findall(text)
        if not matches:
            continue

        print(f"Found {len(matches)} audio:: macros in {adoc.relative_to(ROOT_DIR)}")

        for raw_target in matches:
            # raw_target is whatever is between audio:: and [
            # e.g. "{url-mp3}/{mp3file}"
            expanded = expand_attributes(
                raw_target,
                combined_attrs,
                missing_warn=True,
                context=str(adoc.relative_to(ROOT_DIR)),
            )

            if ".mp3" in expanded:
                all_refs.add(expanded)
            else:
                # Only informational; you can comment this out if too noisy
                print(
                    f"NOTE: audio target without .mp3 after expansion in {adoc.relative_to(ROOT_DIR)}: {expanded!r}"
                )

    # 3. Write results to publish/mp3_files
    sorted_refs = sorted(all_refs)
    OUT_FILE.write_text("\n".join(sorted_refs) + "\n", encoding="utf-8")

    print(f"Updated {OUT_FILE} with {len(sorted_refs)} entries.")


if __name__ == "__main__":
    main()
