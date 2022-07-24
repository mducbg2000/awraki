import smartpy as sp


class Signature(sp.Contract):
    def __init__(self):
        self.init_type(
            sp.TBigMap(
                sp.TBytes,
                sp.TSet(
                    sp.TRecord(
                        signer=sp.TAddress,
                        signature=sp.TSignature,
                        timestamp=sp.TTimestamp,
                    )
                ),
            )
        )
        self.init(sp.big_map({}))

    @sp.entry_point
    def sign(self, params):
        if (~self.data.contains(params.content)):
            self.data[params.content] = sp.set([])
        self.data[params.content].add(
            sp.record(
                signer=sp.sender,
                timestamp=sp.now,
                signature=params.signature,
            )
        )

    @sp.offchain_view()
    def verify(self, param):
        if (~self.data.contains(param)):
            sp.result(sp.unit)
        sp.result(self.data[param])


@sp.add_test(name="Signature")
def test():
    signer = sp.test_account("Signer")
    signer2 = sp.test_account("Signer2")

    c1 = Signature()
    scenario = sp.test_scenario()
    scenario.h1("Signature")
    scenario += c1

    sig = sp.make_signature(
        secret_key=signer.secret_key, message=sp.pack("Test"), message_format="Raw"
    )

    c1.sign(content=sp.pack("Test"), signature=sig).run(
        sender=signer
    )

    sig2 = sp.make_signature(
        secret_key=signer2.secret_key, message=sp.pack("Test"), message_format="Raw"
    )

    c1.sign(content=sp.pack("Test"), signature=sig2).run(
        sender=signer2
    )


sp.add_compilation_target("signature", Signature())
