(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �f1Y �[o�0�yxᥐ�@�eb�������֧($.x�&�Ҳ��}v� !a]�j�$�$r9�o���c���xa���sk�O���W]>�����Q:m�-I�/t�v����L��c+E�y�k��������Eq�l� x�[Nm� �5��fB�Bg1�`�0��9�ӵdJ�&ߒZB3�0E�18�^&�	W|�#�K#�A?E8�=��G�D��(��-�o��O��oTe؋q3i[��9-��!�Z�!��M��4Z�Q�	�&mmjkm"���Y�`�)�\Q4�?j����l���8�� \NH"���xj�=�ǥ�p�sN��[����h<���T��P�Y�*>?�H�*��cS!�� {�����oի���Е�B��~��h3U%�a��ŝ�ȫ����}��ڷ$\��E�6��n�ua�M4"�t?�e��!�t@��s�UO>S��9����/A3t����T��5���ҨZ`>O'��h��l2�養���v<������' �v��Ў�q3��raT�
�ٸ/;��!>�� �5��
F6F!��n�! %��<.&���e����4�&��!�\�qC�dYnT�d��
��!��T:��6��'_���Rq=��T��q��*�bU�B7�}�Pl�,�"ϗD�O�-,�
�����e��ļ���㡬�_�(���y�~��ǧ���`0��`0��`0��`0���'�
O� (  