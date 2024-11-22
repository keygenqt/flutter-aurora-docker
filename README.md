# Aurora Flutter Docker

Docker contains [Aurora CLI](https://keygenqt.github.io/aurora-cli/), [Aurora PSDK](https://developer.auroraos.ru/doc/sdk/psdk), [Flutter for Aurora OS](https://omprussia.gitlab.io/flutter/flutter/). Allows you to build Flutter applications in any environment that has Docker. You can build the image by running the create.sh script. Building the image requires ~35Gb, I hope you don't have a MacBook and have plenty of space. This is a joke, a MacBook should do.

![Preview](https://raw.githubusercontent.com/keygenqt/flutter-aurora-docker/refs/heads/main/preview-light.png)

Build on Linux:

```shell
git clone https://github.com/keygenqt/flutter-aurora-docker.git
cd flutter-aurora-docker
chmod +x ./create.sh
./create.sh
```

Run image:

```shell
docker run --rm --name flutter-aurora -itd --privileged flutter-aurora
```

Check:

```shell
docker exec -it flutter-aurora /bin/bash -c 'python3 aurora-cli-3.2.7.pyz'
docker exec -it flutter-aurora /bin/bash -c 'flutter doctor'
docker exec -it flutter-aurora /bin/bash -c '$PSDK_DIR/sdk-chroot sdk-assistant list'
```

Stop image:

```shell
docker container stop flutter-aurora
```

### License

```
Copyright 2024 Vitaliy Zarubin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
