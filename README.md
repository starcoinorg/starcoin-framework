# Starcoin Move framework


## Build and Test

Install `mpm` first, download from the release page of [starcoiorg/starcoin](https://github.com/starcoinorg/starcoin).

Or use:
```bash
cargo install --git https://github.com/starcoinorg/starcoin --bin mpm
```

Build:

```shell
mpm package build 
```

Run unit test:

```shell
mpm package test
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

You can view our [Code of Conduct](./CODE_OF_CONDUCT.md).