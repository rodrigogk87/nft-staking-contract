USER_PEM="./walletKey.pem"
PROXY="https://devnet-gateway.multiversx.com"
CHAIN_ID="D"
MYCONTRACT="output/myfirst-contract.wasm"
SC_ADDRESS="erd1qqqqqqqqqqqqqpgqvg4rw9697prsmx8rl7sr3u3ttrt9kg53fwrq95e72p"

AMOUNT=20000000000000000

deploy() {
    mxpy --verbose contract deploy --bytecode="$MYCONTRACT"  \
    --recall-nonce --pem=${USER_PEM} \
    --gas-limit=10000000 \
    --send --outfile="deploy-devnet.interaction.json" \
    --proxy=${PROXY} --chain=${CHAIN_ID} || return
}

upgrade() {
    mxpy --verbose contract upgrade ${SC_ADDRESS} \
    --bytecode="$MYCONTRACT" \
    --recall-nonce --pem=${USER_PEM} \
    --gas-limit=100000000 \
    --send --outfile="upgrade-devnet.interaction.json" \
    --proxy=${PROXY} --chain=${CHAIN_ID} || return
}

setBid(){
    mxpy --verbose contract call ${SC_ADDRESS} \
    --proxy=${PROXY} --chain=${CHAIN_ID} \
    --send --recall-nonce --pem=${USER_PEM} \
    --gas-limit=10000000 \
    --value=${AMOUNT} \
    --function="set_bid"
}

user_address="$(mxpy wallet pem-address $USER_PEM)"
method_name=0x7365745f6e6674
nft_token=0x564942452d373561623766
nft_token_nonce=1
nft_token_amount=1

setNft(){
    mxpy --verbose contract call $user_address --recall-nonce \
        --pem=${USER_PEM} \
        --gas-limit=100000000 \
        --proxy=${PROXY} --chain=${CHAIN_ID} \
        --function="ESDTNFTTransfer" \
        --arguments $nft_token $nft_token_nonce $nft_token_amount $SC_ADDRESS $method_name \
        --send || return
}


getBestBid() {
    mxpy --verbose contract query ${SC_ADDRESS} \
    --proxy=${PROXY} \
    --function="getHighestBid" 
}

getBestBidder() {
    mxpy --verbose contract query ${SC_ADDRESS} \
    --proxy=${PROXY} \
    --function="getHighestBidder" 
}
#mxpy --verbose contract call erd1qqqqqqqqqqqqqpgq0zl7mh8y5ex8gvzp7alnlmm6vuydgleefwrqdhscul --chain="D" --pem="walletKey.pem" --gas-limit=5000000 --function="claim" --proxy="https://devnet-gateway.multiversx.com" --recall-nonce --send
#mxpy --verbose contract query erd1qqqqqqqqqqqqqpgq0zl7mh8y5ex8gvzp7alnlmm6vuydgleefwrqdhscul --function="claim" --proxy="https://devnet-gateway.multiversx.com"
#mxpy wallet bech32 --encode e909c29ef7b9ff14b0cbdd8eb59d386bfe7f0c0441158a1156704d565cdc4b86