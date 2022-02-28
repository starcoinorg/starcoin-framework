# Starcoin Move framework


## Build and Test

Setup dev environment:

```bash
bash scripts/dev_setup.sh -t -y
```

Build:

```shell
mpm package build 
```

Run unit test:

```shell
mpm package test
```

Run move prove

```shell
mpm package prove
```

Run spec test:

```shell
mpm spectest
```

## Contributing

First off, thanks for taking the time to contribute! Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Contributions in the following are welcome:

1. Report a bug.
2. Submit a feature request.
3. Implement feature or fix bug.

### How to add new module to starcoin-framework:

1. Add New Move module to `sources` dir, such as `MyModule.move`.
2. Write Move code and add unit test in the module file.
3. Add a spec test [spectests](../spectests), such as: `test_my_module.move`.
4. Run the spec test `mpm spectest test_my_module.move `

If you are not sure that the module belongs to starcoin-framework, please submit it to [starcoin-framework-commons](https://github.com/starcoinorg/starcoin-framework-commons) first.

You can view our [Code of Conduct](./CODE_OF_CONDUCT.md).