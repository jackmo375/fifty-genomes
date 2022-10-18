# comments
# --------
# To download the bucket you need to use gsutil with crcmod enabled.
# The latter requires a python package which needs to be installed in a virtual enviroment.
# To use gsutil, you first need to load python 3:
module load python/3.5.2

# then, you need to load the python virtual enviroment that has crcmod installed:
source ~/python-enviroments/gsutil/bin/activate

# finally it is best to specifiy -m and -n options, so the command should be:
$gsutil -m cp -n gs://genomics-public-data/resources/broad/hg38/v0/* ./

# Note: the placing of -n and -m are special, and cannot be moved.
# -m makes the download faster
# -n ensures that existing files are not overwritten

# All the best,
# Jack
# 2022-09-01


