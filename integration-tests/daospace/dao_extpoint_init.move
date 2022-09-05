//# init -n test --public-keys FreePlugin=0x562712dad78be5126ac8afcb7e8d3d9385ba6dbc77dbc7fcd8cd4dc4bbf20286

//# faucet --addr FreePlugin --amount 10000000000000

//# run --signers FreePlugin
script {
    use FreePlugin::ExtensionPointScript;

    fun main(sender: signer) {
        ExtensionPointScript::initialize(sender);
    }
}
// check: EXECUTED

//# view --address FreePlugin --resource 0x7dA9Cd8048A4620fda9e22977750C517::ExtensionPoint::Registry

//# run --signers FreePlugin
script {
    use FreePlugin::ExtensionPointScript;

    fun main(sender: signer) {
        ExtensionPointScript::initialize(sender);
    }
}

//# faucet --addr bob --amount 2000000000

//# run --signers bob
script {
    use FreePlugin::ExtensionPointScript;

    fun main(sender: signer) {
        ExtensionPointScript::initialize(sender);
    }
}
