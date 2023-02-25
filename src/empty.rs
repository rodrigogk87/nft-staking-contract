#![no_std]

multiversx_sc::imports!();

/// An empty contract. To be used as a template when starting a new contract from scratch.
#[multiversx_sc::contract]
pub trait BestBidNftContract {
    #[init]
    fn init(&self) {}

    #[payable("VIBE-75ab7f")]
    #[endpoint]
    fn set_nft(&self){
        let caller = self.blockchain().get_caller();
        let nft = self.call_value().single_esdt();
        self.nfts_list(&caller).insert(nft);
    }

    #[endpoint]
    fn get_nft(&self){
        let caller = self.blockchain().get_caller();
        
        for token in self.nfts_list(&caller).iter() {
            self.send().direct_esdt(&caller, &token.token_identifier, token.token_nonce, &token.amount);                     
        }
          
        self.nfts_list(&caller).clear();
    }

    #[payable("EGLD")]
    #[endpoint]
    fn set_bid(&self){
        let caller = self.blockchain().get_caller();
        let payment_amount = self.call_value().egld_value();
        let last_bid = self.highest_bid().get();
        if payment_amount > last_bid {
            //transfer last bid to last winner
            self.send().direct_egld(&caller, &last_bid);
            //set new bidder
            self.highest_bid().set(&payment_amount);
            self.highest_bidder().set(&caller);
        }
    }

    #[view(getHighestBidder)]
    #[storage_mapper("highest_bidder")]
    fn highest_bidder(&self) -> SingleValueMapper<ManagedAddress>;

    #[view(getHighestBid)]
    #[storage_mapper("highest_bid")]
    fn highest_bid(&self) -> SingleValueMapper<BigUint>;

    #[view(getNFTs)]
    #[storage_mapper("nfts_list")]
    fn nfts_list(&self,addr: &ManagedAddress) -> UnorderedSetMapper<EsdtTokenPayment>;
    
}
