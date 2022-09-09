@echo off

echo -----------------
echo Downloading Java Development Kit
sudo apt install default-jdk
java -version

echo -----------------
echo Install curl
sudo apt install curl

echo Creating Software Directory ...
mkdir software

echo ----------------
echo Downloading nextflow into software
cd software
curl -s https://get.nextflow.io | bash
sudo ln -s /software/nextflow /usr/bin/nextflow
mv nextflow $HOME/bin
chmod +x nextflow
nextflow -v

echo ---------------
echo Downloading AWS CLI into software
sudo apt install awscli

echo ---------------
echo Downloading minimap2 into software
curl -L https://github.com/lh3/minimap2/releases/download/v2.24/minimap2-2.24_x64-linux.tar.bz2 | tar -jxvf -
sudo ln -s /software/minimap2-2.24_x64-linux/minimap2 /usr/bin/minimap2

echo ---------------
echo Downloading samtools into software
sudo apt install samtools

cd ..
