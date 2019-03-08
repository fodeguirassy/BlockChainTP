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

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() public {
        balances[0x6ff707eddd9978dB0BDDDb357c3dFDE74b4B5Ad2] = 10000;

        //Add mocked Data
        //addBenjaminHouses(0xC1991F924F713aAC384d63cdb5fdf7060C72a669, "Benjamin", 1000000);
        //addCaroHouses(0xC1991F924F713aAC384d63cdb5fdf7060C72a669, "Caroline", 3000000);
    }

    function buyAHouse(int _houseId) public returns (bool) {
        if (isHouseOwner(_houseId)) {
            return false;
        } else {
            Owner memory buyer = houseOwners[msg.sender];
            House memory house = allHouses[_houseId];
            buyer.ownedHouseIds[(buyer.ownedHouseIds.length + 1)] = house.houseId;
            buyer.money -= house.price;

            //TODO Remove to
            houseIdsToOwner[_houseId] = buyer;

            return true;
        }

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

    function onBuyClicked() public view returns (bool) {
        return true;
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


    function isHouseOwner(int id) public view returns (bool) {
        Owner memory currentOwner = houseOwners[msg.sender];
        uint housesCount = currentOwner.ownedHouseIds.length;
        if (housesCount <= 0) {
            return false;
        } else {
            uint index = 0;
            while (index < housesCount) {
                if (id == currentOwner.ownedHouseIds[index]) {
                    return true;
                }
                index ++;
            }
        }
        return false;
    }


    function putHouseOnSale(int _houseId) public {
        if (isHouseOwner(_houseId)) {
            allHouses[_houseId].isOnSale = true;
        }
    }

    function addBenjaminHouses(address ownerAddr, string memory _name, int _money) public {
        house1 = House(1, "12 rue Fragonard, Nice", 120000, false, false);
        house2 = House(2, "13 rue Chanzy, Paris", 160000, false, false);
        house3 = House(4, "16 Villa Marguerite, Boulogne", 187000, false, false);
        house4 = House(5, "26 rue Marcel Icard, Paris", 1200000, false, false);
        house5 = House(6, "45 rue Farafagné, Lyon", 220000, false, false);


        allHouses[1] = house1;
        allHouses[2] = house2;
        allHouses[3] = house3;
        allHouses[4] = house4;
        allHouses[5] = house5;

        int[] memory ids;
        ids[0] = 1;
        ids[1] = 2;
        ids[2] = 3;
        ids[3] = 4;

        benjamin = Owner(ownerAddr, _name, _money, ids);

        houseOwners[ownerAddr] = benjamin;
        houseIdsToOwner[1] = benjamin;
        houseIdsToOwner[2] = benjamin;
        houseIdsToOwner[3] = benjamin;
        houseIdsToOwner[4] = benjamin;
        houseIdsToOwner[5] = benjamin;
    }

    function addCaroHouses(address ownerAddr, string memory _name, int _money) public {
        house6 = House(7, "24 rue de la Nation, Nice", 1420000, false, false);
        house7 = House(8, "138 rue De Caroline, Lyon", 3160000, false, false);
        house8 = House(9, "160 rue de Marguerite, Orleans", 147000, false, false);
        house9 = House(10, "26 rue Marion Cotillard, Paris", 4200000, false, false);
        house10 = House(11, "45 rue Herblé, Lyon", 250000, false, false);

        allHouses[6] = house6;
        allHouses[7] = house7;
        allHouses[8] = house8;
        allHouses[9] = house9;
        allHouses[10] = house10;

        int[] memory ids;
        ids[0] = 7;
        ids[1] = 8;
        ids[2] = 9;
        ids[3] = 10;
        ids[4] = 11;

        caroline = Owner(ownerAddr, _name, _money, ids);

        houseOwners[ownerAddr] = caroline;

        houseIdsToOwner[6] = caroline;
        houseIdsToOwner[7] = caroline;
        houseIdsToOwner[8] = caroline;
        houseIdsToOwner[9] = caroline;
        houseIdsToOwner[10] = caroline;
        houseIdsToOwner[11] = caroline;

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
        int[] ownedHouseIds;
    }

    struct House {
        int houseId;
        string location;
        int price;
        bool isOnSale;
        bool sold;
    }
}
