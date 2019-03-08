import Web3 from "web3";
import metaCoinArtifact from "../../build/contracts/MetaCoin.json";

const demoAvailable = [ // for tests
  {
    id: 1,
    name: "cottage",
    price: "50k",
    isOnSale: true
  }, {
    id: 2,
    name: "loft",
    price: "60k",
    isOnSale: true
  }
];

const demoOwned = [
  {
    id: 3,
    name: "studio",
    price: "20k",
    isOnSale: false
  }, {
    id: 3,
    name: "palace",
    price: "1000k",
    isOnSale: true
  }
];

const App = {
  web3: null,
  account: null,
  meta: null,
  housesOnSell:[],

  start: async function() {
    const { web3 } = this;

    try {
      // get contract instance
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = metaCoinArtifact.networks[networkId];
      this.meta = new web3.eth.Contract(
        metaCoinArtifact.abi,
        deployedNetwork.address,
      );

      // get accounts
      const accounts = await web3.eth.getAccounts();

      this.account = accounts[0];

      const { onBuyClicked } = this.meta.methods;
      const result = await onBuyClicked().call();

      await this.getHouses();
      this.refreshHouses(this.housesOnSell, 'toBuy');
      this.refreshTotalHouses();
    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }
  },

  getHouses: async function() {
    const { getFirstHouseId, getFirstHouseAddress, getFirstHousePrice, getFirstHouseOwnerHash } = this.meta.methods;
    const firstHouseId = await getFirstHouseId().call();
    const firstHouseAddress = await getFirstHouseAddress().call();
    const firstHousePrice = await getFirstHousePrice().call();
    const firstHouseOwnerHash = await getFirstHouseOwnerHash().call();
    this.housesOnSell.push({
        id: firstHouseId,
        name: firstHouseAddress,
        price: firstHousePrice,
        ownerHash: firstHouseOwnerHash,
        img: 'https://cdn.pixabay.com/photo/2013/10/09/02/27/boat-house-192990_1280.jpg'
    });

    const { getSecondHouseId, getSecondHouseAddress, getSecondHousePrice, getSecondHouseOwnerHash } = this.meta.methods;
    const secondHouseId = await getSecondHouseId().call();
    const secondHouseAddress = await getSecondHouseAddress().call();
    const secondHousePrice = await getSecondHousePrice().call();
    const secondHouseOwnerHash = await getSecondHouseOwnerHash().call();
    this.housesOnSell.push({
        id: secondHouseId,
        name: secondHouseAddress,
        price: secondHousePrice,
        ownerHash: secondHouseOwnerHash,
        img: 'https://cdn.pixabay.com/photo/2016/11/18/17/46/architecture-1836070_1280.jpg'
    });
  },

  refreshBalance: async function() {
    const { getBalance } = this.meta.methods;
    const balance = await getBalance(this.account).call();

    const balanceElement = document.getElementsByClassName("balance")[0];
    balanceElement.innerHTML = balance;
  },

  sendCoin: async function() {
    const amount = parseInt(document.getElementById("amount").value);
    const receiver = document.getElementById("receiver").value;

    this.setStatus("Initiating transaction... (please wait)");

    const { sendCoin } = this.meta.methods;
    await sendCoin(receiver, amount).send({ from: this.account });

    this.setStatus("Transaction complete!");
    this.refreshBalance();
  },

  setStatus: function(message) {
    const status = document.getElementById("status");
    status.innerHTML = message;
  },

  refreshHouses: function(houses, status) {
    try {
      var content = "";
      const btnMsg = status === 'toBuy' ? 'buy' : 'sell';
      houses.forEach(function(house) {
        var elem = '<li class="list-group-item">'
            + '<img class="col-md-12" src="' + house.img + '" />'
            + '<p>' + house.name + '</p>'
            + '\t<p>$' + house.price + 'k</p>';
        if (status === 'owned') {
            const msg = house.isOnSale ? 'remove from selling' : 'sell';
            elem += '\t<button class="btn btn-primary" id=' + house.id + '> ' + msg + '</button>';
        } else {
            elem += '\t<button class="btn btn-primary" id=' + house.id + '> buy </button>';
        }
        elem += '</li>';
        content += elem;
      });
      let element;
      if (status === 'toBuy') {
        element = document.getElementById("available_properties");
      } else {
        element = document.getElementById("owned_properties");
      }
      element.innerHTML = content;
    } catch (error) {
        console.log(error);
    }
  },

  refreshTotalHouses: async function() {
    const { getHousesLength } = this.meta.methods;
    const nbHouses = await getHousesLength().call();
    const element = document.getElementById("totalHouses");
    element.innerHTML = nbHouses;
  }
};

window.App = App;

window.addEventListener("load", function() {
  if (window.ethereum) {
    // use MetaMask's provider
    App.web3 = new Web3(window.ethereum);
    window.ethereum.enable(); // get permission to access accounts
  } else {
    console.warn(
      "No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live",
    );
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    App.web3 = new Web3(
      new Web3.providers.HttpProvider("http://127.0.0.1:9545"),
    );
  }

  App.start();
});
