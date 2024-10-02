# Contributing

## Editing Documentation

For each documentation directory you will find a `src` directory which contains chapter files. You can edit these chapter files to change the content.

The documentation uses [Python Markdown](https://python-markdown.github.io/) for the HTML documentation and [Pandoc's Markdown](https://pandoc.org/MANUAL.html#pandocs-markdown) for the PDF documentation. Any edits should strive to be compatible with both (for most things these two are compatible with each other).

In addition to the files in this repository, see the respective `doc` directory in other repositories such as the [header files in wolfssl](https://github.com/wolfSSL/wolfssl/tree/master/doc/dox_comments/header_files).

All files _must_ be in UTF-8 format, and should use only spaces and LF. Beware of pasting text from PDF or web sites that will likely contain special characters. Some editors will quietly convert the source file to something other than UTF-8, causing `make` to fail.

If an error such as this is encountered:

```
ERROR -  Error reading page 'myfile.md': 'utf-8' codec can't decode byte 0x92 in position 526: invalid start byte
```

Assuming it created on Windows for instance, it can be fixed like this:
```
file -i myfile.md
iconv -f ISO-8859-1 -t UTF-8 myfile.md -o temp.md
mv temp.md myfile.md
```

If this error is encountered:

```
WARNING: buildx: failed to read current commit information with git rev-parse --is-inside-work-tree
```

Check with `git status`. The issue is likely the "dubious ownership" and can be fixed like this:

```
git config --global --add safe.directory [your/git/clone/root]
```

## New Manual

### Files Needed

As a minimum a manual directory needs:

* header.txt
* mkdocs.yml
* Makefile
* src directory

#### header.txt

The `header.txt` needs to have the following content (adjust the title for your manual). This is needed to generate the PDF output:

```
% wolfBoot Documentation  ![](logo.png)

---
header-includes:
    # Blank pages on new sections
    - \usepackage{titlesec}
    - \newcommand{\sectionbreak}{\clearpage}
    # Fancy page headers
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[LO,RE]{COPYRIGHT \copyright 2021 wolfSSL Inc.}
    # Wrap long syntax highlighting code blocks
    - \usepackage{fvextra}
    - \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}
    # Wrap long non-sytax highlighted code blocks
    - \usepackage{listings}
    - \let\verbatim\undefined
    - \let\verbatimend\undefined
    - \lstnewenvironment{verbatim}{\lstset{breaklines,basicstyle=\ttfamily}}{}
subparagraph: yes
---
```

#### mkdocs.yml

The `mkdocs.yml` file defines the layout for the HTML documentation output. It should be as below with the `site_name` and `nav` adjusted for your documentation. It can contain nested navigation, see `wolfSSL/mkdocs.yml` for a more complex example.

Your first documentation file in the `Makefile` will be renamed `index.md` for the HTML build.

```
site_name: wolfBoot Manual
site_url: https://wolfssl.com/
docs_dir: build/html/
site_dir: html/
copyright: wolfSSL Inc. 2021
nav:
    - "1. Introduction": index.md
    - "2. Compiling wolfBoot": chapter02.md
    - "3. Targets": chapter03.md
    - "4. Hardware Abstraction Layer": chapter04.md
    - "5. Flash Partitions": chapter05.md
    - "6. wolfBoot Features": chapter06.md
    - "7. Integrating wolfBoot in an existing project": chapter07.md
    - "8. Troubleshooting": chapter08.md
theme:
  name: null
  custom_dir: ../mkdocs-material/material
  language: en
  palette:
    primary: indigo
    accent: indigo
  font:
    text: Roboto
    code: Roboto Mono
  icon: "logo.png"
  logo: logo.png
  favicon: logo.png
  feature:
    tabs: true
extra_css: [skin.css]
extra:
    generator: false
use_directory_urls: false
```

#### Makefile

The following is a minimal `Makefile` for a project:

```
-include ../common/common.am
.DEFAULT_GOAL := all
all: pdf html


SOURCES = chapter01.md \
          chapter02.md \
          chapter03.md \
          chapter04.md \
          chapter05.md \
          chapter06.md \
          chapter07.md \
          chapter08.md

PDF = wolfBoot-Manual.pdf

.PHONY: html-prep
html-prep:

.PHONY: pdf-prep
pdf-prep:
```

The `common.am` contains has a lot of content to process the Markdown files into the HTML and PDF outputs. The `SOURCES` list should be changed to a list of your source Markdown files in the order you wish them to be rendered for the PDF. The `PDF` variable should be changed to your PDF output filename.

The `html-prep` should contain any additional steps you wish to make prior to rendering the HTML output and likewise the `pdf-prep` should contain additional steps for the PDF output.

There are more complex examples which also pull in Doxygen content from the project source code for appendices in `wolfTPM/Makefile` and `wolfSSL/Makefile`.

#### src Directory

The `src` directory contains the source Markdown documentation that will be compiled into PDF and HTML manuals.

### Docker Builds

The build process is quite complex with several required dependencies, particularly for the manuals that require Doxygen. Therefore a Docker based build has been created which will do all the hard work automatically without you having to install any dependencies (apart from Docker itself).

For every manual an entry needs to be added into the `Makefile` at the root of this directory tree.

#### Makefile

An entry needs to be added to the `Makefile` at the root of this directory tree with the following contents (adjusted for the target at the third step of your Dockerfile entry):

```
.PHONY: wolfboot
wolfboot: MANPATH=wolfBoot
wolfboot: PDFFILE=wolfBoot-Manual.pdf
wolfboot: build
    @$(DOCKER_CMD)
```

The `MANPATH` should be set to the subdirectory name the manual is in. `PDFFILE` should be set to the PDF filename generated by the manual's Makefile.

You will also need to add an entry to the `all` line for your project.
