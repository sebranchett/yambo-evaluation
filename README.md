# Getting Yambo and Quantum Espresso to work for evaluation purposes

## DelftBlue

Yambo installation instructions [here](https://www.yambo-code.eu/wiki/index.php/Installation). Version tested: 5.1.2.

DelftBlue instructions [here](https://doc.dhpc.tudelft.nl/delftblue/crash-course/).

See 3 scripts:
```
config-script.sh  # to configure installation
make-script.sh  # to compile Yambo and supporting tools
check-script.sh  # to check Yambo has been installed
```
As explained in the Yambo installation instructions, successful output includes:
```
Cannot access CORE database (SAVE/*db1 and/or SAVE/*wf)
```
## Windows laptop with Docker

### Tried...
```
tar zxf yambo-5.1.2.tar.gz
rm yambo-5.1.2.tar.gz
```
... on vanilla linux, but too much work. Need to install compilers, etc.

### Tried...
```
docker pull maxcentre/yambo:5.1.1_gcc9
docker run --rm -it -v //c/Users/sbranchett/work/yambo/data:/home/yambo maxcentre/yambo:5.1.1_gcc9
```
...but then I don't have Quantum Espresso and I can't install it as I am a non-root user.

### Tried...
```
FROM continuumio/anaconda3

RUN conda install qe --channel conda-forge
RUN conda install yambo --channel conda-forge
```
...but after 16000 seconds, it still couldn't resolve the environment for the last command.

### Settled on...
Dockerfile in this repo, which uses `apt` to install Quantum Espresso, then installs Conda and then uses Conda to install Yambo.

Good enough for evaluation purposes.

### Useful commands
To build the Docker image:
```
docker build . -t yambo
```
To run a Docker container:
```
docker run --rm -it -e DISPLAY=$DISPLAY -v //c/Users/sbranchett/work/yambo/data:/home/yambo yambo
```
The $DISPLAY environment variable is to get gnuplot working properly.

Before running a Docker container from a Windows machine, use `ipconfig` to find its ip, and then add an ':0'.
```
export DISPLAY="192.168.99.1:0"
```
Also, change the Xming shortcut to run:
```
"C:\Program Files (x86)\Xming\Xming.exe" :0 -clipboard -multiwindow -ac
```
The "-ac" is important!
```
apt install -y x11-apps 
```
...has `xeyes` for testing.
