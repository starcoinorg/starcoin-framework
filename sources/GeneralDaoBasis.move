address StarcoinFramework {

module GeneralDaoBasis {
    use StarcoinFramework::GeneralDao;

    struct BasisType has store {}


    public fun create_dao(signer: &signer) {
    }
}

}
