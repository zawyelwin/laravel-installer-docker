# Laravel Installer Docker Image

[![Docker Build](https://img.shields.io/docker/cloud/build/zylwin/laravel-installer)](https://hub.docker.com/repository/docker/zylwin/laravel-installer)
[![Docker Pulls](https://img.shields.io/docker/pulls/zylwin/laravel-installer)](https://hub.docker.com/repository/docker/zylwin/laravel-installer)

This repository contains Docker image for the [Laravel Installer](https://github.com/laravel/installer), providing a convenient way to create Laravel projects for those who use docker as their development environment.


## Usage

### Pull the Docker Image

To pull the Docker image from Docker Hub, run:

```sh
docker pull zylwin/laravel-installer:latest
```


Create a docker volume for composer cache

```sh
docker volume create composer_cache
```

To create a new Laravel project, run:

```sh
docker run -it --rm -v $(pwd):/app -v composer_cache:/composer/cache zylwin/laravel-installer new
```

### Configuring a Shell Alias

You may wish to configure a shell alias to execute commands more easily:

```sh
alias laravel='docker run --rm -v $(pwd):/app -v composer_cache:/composer/cache zylwin/laravel-installer'
```

To make sure this is always available, add this to your shell configuration file in your home directory, such as `~/.zshrc` or `~/.bashrc`, and then restart your shell.

```sh
echo 'alias laravel="docker run --rm -it -v $(pwd):/app -v composer_cache:/composer/cache zylwin/laravel-installer"' >> ~/.zshrc

source ~/.zshrc

laravel new
```

### Build the Docker Image

Alternatively, If they want to update anything in the Dockerfile, you can clone this repository and build the image locally using:

```sh
git clone https://github.com/zawyelwin/laravel-installer-docker.git

cd laravel-installer-docker

docker buildx build --platform linux/amd64,linux/arm64 --build-arg INSTALLER_VERSION=$INSTALLER_VERSION -t <your-dockerhub-username>/laravel-installer .
```

# License

This project is licensed under the [MIT license](LICENSE.md).

# Contributing

Contributions are welcome! If you have any improvements or bug fixes, please feel free to open an issue or submit a pull request.

# Acknowledgements

- [Laravel Installer](https://github.com/laravel/installer)
-   Some documentation referenced from the [Laravel Documentation](https://laravel.com/docs).
