# Getting Yambo and Quantum Espresso to work, on a Windows laptop, for evaluation purposes

# Tried...
```
tar zxf yambo-5.1.2.tar.gz
rm yambo-5.1.2.tar.gz
```
... on vanilla linux, but too much work. Need to install compilers, etc.

# Tried...
```
docker pull maxcentre/yambo:5.1.1_gcc9
docker run --rm -it -v //c/Users/sbranchett/work/yambo/data:/home/yambo maxcentre/yambo:5.1.1_gcc9
```
...but then I don't have Quantum Espresso and I can't install it as I am a non-root user.

# Tried...
```
FROM continuumio/anaconda3

RUN conda install qe --channel conda-forge
RUN conda install yambo --channel conda-forge
```
...but after 16000 seconds, it still couldn't resolve the environment for the last command.

# Settled on...
Dockerfile in this repo, which uses `apt` to install Quantum Espresso, then installs Conda and then uses Conda to install Yambo.

Useful commands:
```
docker build . -t minimal-yambo
docker run --rm -it -v //c/Users/sbranchett/work/yambo/data:/home/yambo minimal-yambo
```
and then in the container:
```
export PATH=$PATH:"/opt/conda/bin"
cd /home/yambo
```

Good enough for evaluation purposes.
