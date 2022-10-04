# Starcoin Move framework

## Network Deploy status

- halley: latest
- proxima: v11
- barnard: v11
- main: v11

## Documents

- [latest](./build/StarcoinFramework/docs)
- [v11](./release/v11/docs)

## Usage

Add `address` and `dependency` to the project's Move.toml

```
[addresses]
StarcoinFramework = "0x1"

[dependencies]
StarcoinFramework = {git = "https://github.com/starcoinorg/starcoin-framework.git", rev="cf1deda180af40a8b3e26c0c7b548c4c290cd7e7"}
```

* v11 git version: cf1deda180af40a8b3e26c0c7b548c4c290cd7e7

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

Run integration test:

```shell
mpm integration-test
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
3. Add an integration test to [integration-tests](./integration-tests) dir, such as: `test_my_module.move`.
4. Run the integration test `mpm integration-test test_my_module.move `.
5. Run script `./script/build.sh` for build and generate documents.
6. Commit the changes and create a pull request.

If you are not sure that the module belongs to starcoin-framework, please submit it to [move-funs](https://github.com/movefuns/movefuns) first.

You can view our [Code of Conduct](./CODE_OF_CONDUCT.md).
