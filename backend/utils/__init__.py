from web3 import Web3


def parseAddress(str):
    # ECS gives an address as decimal literal
    # so we must manually convert it back to hex
    if not str.startswith('0x'):
        str = hex(int(str))

    return Web3.toChecksumAddress(str)
