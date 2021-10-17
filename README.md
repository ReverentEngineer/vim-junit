# Installation

Install using your favorite plugin manager such as [Pathogen](https://github.com/tpope/vim-pathogen), 
[Vundle](https://github.com/VundleVim/Vundle.vim), or [vim-plug](https://github.com/junegunn/vim-plug).

# Usage

First, you might want to setup a glob expression that can find your junit XML 
results by setting `g:junit_path_expr`. A default of `**/*junit.xml` is provided, 
but this might not be sufficient for your purposes.

After that, it should be as simple as:

```
JUnit
```

If you're using my [vim-cmake](https://github.com/ReverentEngineer) plugin, 
a sample workflow might have you running:

```
CTest --output-junit=junit.xml
JUnit
```
