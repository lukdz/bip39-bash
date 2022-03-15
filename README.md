# BIP39 generator in bash

Generate BIP39 mnemonic using bash. List of 12 or 24 words with the last one containing a checksum.
Project was created to provide simple and auditable generator of random mnemonic seed.

# Description

When creating a new crypto wallet users may choose to do so in many way ways.
There are many free and open source software wallets available as well as a few hardware wallets.
For added security user may choose to use such tools on offline system to avoid leakage of private keys.
Unfortunately this solution doesn't prevent creation of new keys based on "random" seed provided by bad actors.
Verification of code by user (even programer) is difficult due to size of the software running the wallets
(e.g. [Electrum](https://github.com/spesmilo/electrum) has more than 100k lines of code).
Hardware wallets often run proprietary software and those who don't have big code base even only on firmware side
([Trezor Firmware](https://github.com/trezor/trezor-firmware) 300k, [BitBox02 Firmware](https://github.com/digitalbitbox/bitbox02-firmware) 500k lines of code).

This project was created to provide program that is easy to use and audit. 
Code base in bare version consist only **5 lines of code**. 
To better understand each command consider using [explainshell](https://explainshell.com/explain?cmd=xxd+-l+%22%24%7Brandom_octet_lenght%7D%22+-b+-c+1+%2Fdev%2Frandom)) or linux man pages.

For verification of generated mnemonic seeds can be used any software or hardware wallet (or even on-line tool [iancoleman bip39](https://github.com/iancoleman/bip39)).
To verify that wallet software doesn't have any bugs you can use a few different to cross check results (address and private keys generated based on seed).
**Use different lists of words for verification and for storage of real assets.**

For additional security consider adding a passphrase to your word list.

## Usage

```bash
bash generate.sh # 24 words option by default
bash generate.sh 24
bash generate.sh 12
bash simple24.sh
bash simple12.sh
bash bare24.sh
bash bare12.sh
```

## Content

| File        | Description                                                                  |
| ----------- | ---------------------------------------------------------------------------- |
| generate.sh | base script for 12 and 24 words generation                                   |
| simple24.sh | simplified 24 words generator for easier audit                               |
| simple12.sh | simplified 12 words generator for easier audit                               |
| bare24.sh   | bare 24 words generator for manual retyping on air gapped systems            |
| bare12.sh   | bare 12 words generator for manual retyping on air gapped systems            |
| english.txt | list of english words for BIP39                                              |
| sha256.log  | `shasum -a 256 *.txt *.sh > sha256.log` for validation on air gapped systems |

## External links

- [How to create a 24-word Seed Phrase using Dice and Linux Command-Line](https://www.reddit.com/r/CryptoCurrency/comments/k3mwph/how_to_create_a_24word_seed_phrase_using_dice_and/)
- [BIP39 how software found the checksum?](https://bitcointalk.org/index.php?topic=5300691.0)
