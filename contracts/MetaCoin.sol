pragma solidity >=0.4.21 <0.6.0;

import "./ConvertLib.sol";

// This is a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
    mapping (address => uint) balances;

    Owner benjamin;

    mapping (address => Owner) public houseOwners;
    mapping (int => int[]) public housesToOwners;

    House house1;
    House house2;
    House house3;
    House house4;
    House house5;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() public {
        balances[msg.sender] = 10000;

        //Add mocked Data
        addBenjaminHouses(0xC1991F924F713aAC384d63cdb5fdf7060C72a669, "Benjamin", 1000000);
    }

    function addBenjaminHouses(address ownerAddr, string memory _name, int _money) public {
      house1 = House(1,"12 rue Fragonard, Nice", 120000, false, false);
      house2 = House(2,"13 rue Chanzy, Paris", 160000, false, false);
      house3 = House(4,"16 Villa Marguerite, Boulogne", 187000, false, false);
      house4 = House(5,"26 rue Marcel Icard, Paris", 1200000, false, false);
      house5 = House(6,"45 rue Farafagné, Lyon", 220000, false, false);

      int[] memory ids;
      ids[0] = 1;
      ids[1] = 2;
      ids[2] = 3;
      ids[3] = 4;

      benjamin = Owner(ownerAddr, _name, _money, ids);

      houseOwners[ownerAddr] = benjamin;
    }


    function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
        if (balances[msg.sender] < amount) return false;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function getBalanceInEth(address addr) public view returns(uint) {
        return ConvertLib.convert(getBalance(addr),2);
    }

    function getBalance(address addr) public view returns(uint) {
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
