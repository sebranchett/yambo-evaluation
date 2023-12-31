FROM ubuntu

ENV PATH=$PATH:"/opt/conda/bin"

RUN apt update
RUN apt install -y curl
RUN apt install -y vim
RUN apt install -y git
RUN apt install -y gpg
RUN apt install -y quantum-espresso
RUN apt install -y gnuplot

# Conda
# Install conda public GPG key to trusted store
RUN curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
RUN install -o root -g root -m 644 conda.gpg /usr/share/keyrings/conda-archive-keyring.gpg
# Check whether fingerprint is correct (will output an error message otherwise)
RUN gpg --keyring /usr/share/keyrings/conda-archive-keyring.gpg --no-default-keyring --fingerprint 34161F5BF5EB1D4BFBBB8F0A8AEB4F8B29D82806
# Add conda Debian repo
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/conda-archive-keyring.gpg] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list
# Install it!
RUN apt update
RUN apt install conda

RUN conda install yambo --channel conda-forge

RUN conda install numpy scipy matplotlib netCDF4 lxml pyyaml

RUN mkdir -p /home/yambo
WORKDIR /home/yambo

# Now install yambopy
RUN git clone https://github.com/yambo-code/yambopy.git
WORKDIR /home/yambo/yambopy
RUN python setup.py install
RUN pip install pymatgen
RUN pip install abipy
WORKDIR /home/yambo
