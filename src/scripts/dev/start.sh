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

VERSION=$(echo "`cat .version`-dev")
IMAGE_NAME=$(cat .image_name)
IMAGE="$IMAGE_NAME:$1-$VERSION"
CONTAINER=$(echo "`cat .image_name | sed -e 's/ghcr.io\///g' -e 's/gpfister\///g'`-$1-$VERSION")

docker container create --name $CONTAINER \
                        --privileged \
                        $IMAGE        
docker container start $CONTAINER
docker exec -it \
            $CONTAINER \
            /bin/zsh
