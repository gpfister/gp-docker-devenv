#!/bin/sh

#
# gp-firebase-devenv
# Copyright (c) 2023, Greg PFISTER. MIT License.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

set -e

TIMESTAMP=$(date +"%Y%m%d")
VERSION=$(cat .version)
VERSION_MAJOR=$(echo $VERSION | sed 's/\([0-9]*\).\([0-9]*\).\([0-9]*\)$/\1/')
VERSION_MINOR=$(echo $VERSION | sed 's/\([0-9]*\).\([0-9]*\).\([0-9]*\)$/\1.\2/')
DOCKERFILE=$(echo "./Dockerfile."$1)
IMAGE_NAME=$(cat .image_name)
IMAGE="$IMAGE_NAME:$1"
IMAGE_VERSION="$IMAGE_NAME:$1-$VERSION"
IMAGE_VERSION_MAJOR="$IMAGE_NAME:$1-$VERSION_MAJOR"
IMAGE_VERSION_MINOR="$IMAGE_NAME:$1-$VERSION_MINOR"

if [ ! -f "$DOCKERFILE" ]; then
    echo "Dockerfile '$DOCKERFILE' not found"
    exit 1
fi

docker buildx build --push \
                    --platform linux/arm64,linux/amd64 \
                    -t $IMAGE \
                    -t $IMAGE_VERSION \
                    -t $IMAGE_VERSION_MAJOR \
                    -t $IMAGE_VERSION_MINOR \
                    -f "$DOCKERFILE" .
