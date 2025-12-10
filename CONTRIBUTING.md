# Guidelines for Contributors


## 1. Requirements

- Docker Desktop installed  
- Familiarity with GitHub  
- Basic AsciiDoc knowledge helpful  

## 2. Contribution Workflow

1. Fork the repo  
2. Create a branch:

```shell
git checkout -b feature/my-change
```

3. Make edits  

4. Run

```shell
make check
make build
```

5. Open a pull request  


## 3. Writing Episodes

Use format at the top of the doc.

```asciidoc
[[tttNN]]
== Episode NN Title
```

Add to the ToC in `book/ttt-contents.adoc`:

```asciidoc
include::tttNN.adoc[]
```

## 4. Cross‑References

If you need to link to another instalment, use the following syntax.

```asciidoc
xref:anchor-top-of-file[Text to link]
```

Avoid, because it is not the preferred syntax

```asciidoc
<<anchor-top-of-file,Text to link>>
```

Note: the following syntax is wrong

```asciidoc
link:file-name[Text to link]
```

## 5. Checking Vale errors

- Run `make lint` locally to see all errors Vale has found. These are mostly typos.
- Fix the errors manually by either correcting typos or by adding correctly spelled words to the `.github/styles/config/vocabularies/TTT/accept.txt` file
If the accept.txt file is updated, please sort the entries so the differences stand out more clearly in the commit. It also helps in finding out if there are 'almost duplicates' which may make you reconsider using the other word.

## 6. Testing Before PR

Run:

```shell
make check
make build
```

Everything must validate cleanly.
