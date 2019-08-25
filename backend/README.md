# Smart contract backend

## install & build

```
cd backend 
(npm install -g truffle ganache)
npm install
oz compile
cp .env.dist .env
# add Infura keys and a hd wallet mnemonic to .env 
oz create

``` 
Select your favorite network & deploy the DoorFactory contract. Remember the contract's address -> it's also needed in the frontend (currently hardcoded on `user` and `index` pages). Play with the contract:

```
oz call --method "getDoorCount()" -n development --to <door factory contract address> # 0
oz send-tx # to create a new door

```

find the ABIs "hidden" inside the `build/contracts` folder


