# Whaler - Symfony 3

## Installation

### Step 1: Install [Whaler](https://github.com/whaler/whaler)

### Step 2: Install [Whaler haproxy plugin](https://github.com/whaler/whaler-haproxy-plugin)

### Step 3: Add [GitHub personal access token](https://github.com/settings/tokens) (optional)

``` bash
whaler vars:set COMPOSER_GITHUB_OAUTH YOUR-TOKEN-HASH-GOES-HERE
```

### Step 4: Start app

Go to directory where you cloned this repository and execute these command:

``` bash
whaler start --init
```

### Step 5: Open page

Instead of `<app>` write current dir name.

```
<app>.whaler.lh
```

## License

This software is under the MIT license. See the complete license in:

```
LICENSE
```