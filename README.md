# Whaler - Symfony

> **NB!** Firstly: [configure environment](.whaler/README.md)

## Create project

Go to directory where you cloned this repository and execute these commands:

``` bash
whaler start --init
whaler run php.
composer create-project symfony/skeleton . --prefer-dist
exit
```

Open page:

```
http://<app>.whaler.lh
```

> **NB!** Instead of `<app>` write current dir name.

## Make release

```bash
.build/make.sh --repository=symfony/app
cd .dist
whaler start [app_name] --init
```

## License

This software is under the MIT license. See the complete license in:

```
LICENSE
```