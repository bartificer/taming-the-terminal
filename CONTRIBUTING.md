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

## 5. Testing Before PR

Run:

```shell
make check
make build
```

Everything must validate cleanly.
