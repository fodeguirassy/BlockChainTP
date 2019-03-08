pragma solidity >=0.4.21 <0.6.0;

import "./ConvertLib.sol";

// This is a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
    mapping(address => uint) balances;

    Owner benjamin;
    Owner caroline;

    mapping(address => Owner) public houseOwners;
    mapping(int => Owner) public houseIdsToOwner;
    mapping(address => House) public ownerToHouses;
    mapping(int => House) public allHouses;

    House house1;
    House house2;
    House house3;
    House house4;
    House house5;

    House house6;
    House house7;
    House house8;
    House house9;
    House house10;
    House house11;


    mapping(int => address) public idsToOwnersAddress;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() public {
        balances[0x6ff707eddd9978dB0BDDDb357c3dFDE74b4B5Ad2] = 10000;
        balances[0xB00272975F2fa4376dBBD05ad0f20E5888F4eBe7] = 10000;
    }

    function getFirstHouseId() public view returns (int) {
        return 1;
    }

    function getFirstHouseAddress() public view returns (string memory) {
        return "12 rue de Fragonnard, Paris";
    }

    function getFirstHousePrice() public view returns (int) {
        return 10;
    }

    function onBuyClicked(address ownerAddress, int _price, int _houseId) public returns (string memory) {

        if (_houseId == 1) {
            if (msg.sender == 0x6ff707eddd9978dB0BDDDb357c3dFDE74b4B5Ad2) {
                return "You can't buy your own house";
            } else {
                sendCoin(ownerAddress, uint (_price));
                return "You've just bought a new House";
            }

        } else if (_houseId == 2) {
            if (msg.sender == 0xB00272975F2fa4376dBBD05ad0f20E5888F4eBe7) {
                return "You can't buy your own house";
            } else {
                sendCoin(ownerAddress,uint (_price));
                return "You've just bought a new House";
            }

        } else if (_houseId == 3) {
            if (msg.sender == 0x6ff707eddd9978dB0BDDDb357c3dFDE74b4B5Ad2) {
                return "You can't buy your own house";
            } else {
                sendCoin(ownerAddress,uint (_price));
                return "You've just bought a new House";
            }
        }
    }

    function getHousesLength() public view returns (int) {
        return 11;
    }

    //0xb00272975f2fa4376dbbd05ad0f20e5888f4ebe7

    function getFirstHouseOwnerHash() public view returns (address) {
        return 0x6ff707eddd9978dB0BDDDb357c3dFDE74b4B5Ad2;
    }

    function getHouseByIndex(int _index) public view returns (int, string memory, int, bool, bool) {
        House memory result = allHouses[_index];
        return (result.houseId, result.location, result.price, result.isOnSale, result.sold);
    }

    function getSecondHouseId() public view returns (int) {
        return 2;
    }

    function getSecondHouseAddress() public view returns (string memory) {
        return "25 rue de Chanzy, Nanterre";
    }

    function getSecondHousePrice() public view returns (int) {
        return 20;
    }

    function getSecondHouseOwnerHash() public view returns (address) {
        return 0xB00272975F2fa4376dBBD05ad0f20E5888F4eBe7;
    }

    function getThirdHouseId() public view returns (int) {
        return 3;
    }

    function getThirdHouseAddress() public view returns (string memory) {
        return "12 Place de la Nation";
    }

    function getThirdHousePrice() public view returns (int) {
        return 50;
    }

    function getThirdHouseOwnerHash() public view returns (address) {
        return 0x6ff707eddd9978dB0BDDDb357c3dFDE74b4B5Ad2;
    }

    function sendCoin(address receiver, uint amount) public returns (bool sufficient) {
        if (balances[msg.sender] < amount) return false;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function getBalanceInEth(address addr) public view returns (uint) {
        return ConvertLib.convert(getBalance(addr), 2);
    }

    function getBalance(address addr) public view returns (uint) {
        return balances[addr];
    }

    struct Owner {
        address ownerAddress;
        string name;
        int money;
    }

    struct House {
        int houseId;
        string location;
        int price;
        bool isOnSale;
        bool sold;
    }
}
