
## Topic1 :- Enhancment of Permanenetly Shadowed Region (PSR) of Lunar Craters Captured by OHRC of Chandrayan -2
### Desired Outcomes
#### Desired Outcome: To increase SNR of the south pole of the moon surface.

[for more info click to visit:](https://www.sih.gov.in/sih2024PS?technology_bucket=QWxs&category=U29mdHdhcmU=&organization=SW5kaWFuIFNwYWNlIFJlc2VhcmNoIE9yZ2FuaXphdGlvbiAoSVNSTyk=&organization_type=QWxs)

### Reference Links to Research paper:
#### [Low Light Image Enhancement](https://paperswithcode.com/task/low-light-image-enhancement)
#### [Analysis of the permanently shadowed region of Cabeus crater in lunar south pole using orbiter high resolution camera imagery](https://www.sciencedirect.com/science/article/pii/S0019103523003391#:~:text=Permanently%20shadowed%20regions%20(PSRs)%20on,elevation%20angles%20throughout%20the%20year.)
#### [Surface morphology inside the PSR area of lunar polar crater Shoemaker in comparison with that of the sunlit areas](https://www.sciencedirect.com/science/article/pii/S0032063324000035)
#### [Automated detection and classification of lunar craters using multiple approaches](https://www.sciencedirect.com/science/article/pii/S0273117705010392#bbib14)
#### [Noise2Void - Learning Denoising from Single Noisy Images](https://arxiv.org/abs/1811.10980)
### Important Terms:
#### [Color Spaces](https://developer.mozilla.org/en-US/docs/Glossary/Color_space)


### Code:
#### How to do selenorefrencing of an image
#### First you need to install gdal
```bash
conda create -n gdal
conda activate gdal
conda install -c conda-forge gdal
```

#### Verify installation
```bash
python
from osgeo import gdal
```

### n2v

#### Env create
```bash
conda create -n n2v python=3.9
conda activate n2v
```
#### Linux
```bash
conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/
python3 -m pip install tensorflow==2.10
```

#### For windows
```bash
conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0
python3 -m pip install tensorflow==2.10
```

#### installation
```bash
git clone https://github.com/juglab/n2v.git
cd n2v
pip install -e .
```

#### jupyter environment with conda
```bash
conda activate n2v
pip install ipykernel
pip install numpy==1.23.5
python -m ipykernel install --user --name n2v --display-name "my_env"
```

#### after this run jupyter lab
#### if jupyter lab not install install it then install it

#### if no error occur hence the installation was succesful
#### if you are using Linux use the .sh file
#### if you are using Win use .bat file
