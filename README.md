# Bamboo Worker | [![Build Status](https://travis-ci.org/Numergy/bamboo-worker.svg?branch=master)](https://travis-ci.org/Numergy/bamboo-worker)

Convert an yaml file into a shell script and run them into a docker container.

## Requirements

 - Ruby 1.9.3 or newer

## Installation

```
$ gem build bamboo-worker.gemspec
$ gem install bamboo-worker-VERSION.gem
```

## Usage

```
Usage: bamboo-worker [COMMAND] [OPTIONS]

Options:

    -v, --version      Shows the current version
    -h, --help         Display this help message.

Available commands:

  build   Build bash script from yaml file
  run     Run bash script on worker

See `<command> --help` for more information on a specific command.
```

### Build script

Generate script that can be running on your own system.
Require some tools to work, as example, need rbenv for ruby builds.

See [.travis.yml](.travis.yml) file for example:

```
Usage: bamboo-worker build [OPTIONS]

Options:

    -c, --config           Build from file and run script. (default: .travis.yml)
    -d, --destination      Destination path to saving files. (default: /tmp)
    -l, --log_level        Log level (debug, info, warn, error, fatal, unknown) (default: info)
    -h, --help             Display this help message.
```

### Run build

Build script and run them into a specific worker.

```
Usage: bamboo-worker run [OPTIONS] [WORKER ARGS]

Options:

    -d, --destination      Destination path to saving files. (default: /tmp)
    -w, --worker           Worker to use to run scripts. (default: docker)
    -c, --config           Build from file and run script. (default: .travis.yml)
    -l, --log_level        Log level (debug, info, warn, error, fatal, unknown) (default: info)
    -h, --help             Display this help message.
```

For example:

```
$ bamboo-worker run -d .. -c .bamboo.yml -l debug -v '/home/user/.ssh:/root/.ssh:ro'
# Will building script in parent directory using .bamboo.yml file.
# Run docker container and mount `/home/user/.ssh/root` volume into `/root/.ssh/` in readonly.
# Display stdout in debug mode.

```

### Docker container

A configuration file (`~/.bamboo/worker.yml`) is needed to use docker worker.

```
docker:
  containers:
    ruby: 'repo.numergy.ci:5000/ruby-builder'
    python: 'repo.numergy.ci:5000/python-builder'
    node_js: 'repo.numergy.ci:5000/node_js-builder'
    php: 'repo.numergy.ci:5000/php-builder'
    java: 'repo.numergy.ci:5000/java-builder'
```

Or directly in your yaml file:

```
language: ruby

docker:
  container: repo.numergy.ci:5000/custom_container

rvm:
  - 2.0.0
  - 2.1.0

script:
  - bundle exec rake
```

### Running tests

Using bamboo-worker itself:

`$ bamboo-worker run`

Using rake

```
$ bundle install
$ bundle exec rake
```
