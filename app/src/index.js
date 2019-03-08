import Web3 from "web3";
import metaCoinArtifact from "../../build/contracts/MetaCoin.json";

const demoAvailable = [ // for tests
  {
    id: 1,
    name: "cottage",
    price: "50k"
  }, {
    id: 2,
    name: "loft",
    price: "60k"
  }
];

const demoOwned = [
  {
    id: 3,
    name: "studio",
    price: "20k"
  }
];

const App = {
  web3: null,
  account: null,
  meta: null,

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
      console.log(this.meta);

      // get accounts
      const accounts = await web3.eth.getAccounts();
      console.log(accounts);

      this.account = accounts[0];

      const { getFirstHouseId, getFirstHouseAddress, getFirstHousePrice,
        getFirstHouseOwnerHash,  } = this.meta.methods;
      const firstHouseId = await getFirstHouseId().call();
      console.log(firstHouseId);

      const firstHouseAddress = await getFirstHouseAddress().call();
      console.log(firstHouseAddress);

      const firstHousePrice = await getFirstHousePrice().call();
      console.log(firstHousePrice);

      const firstHouseOwnerHash = await getFirstHouseOwnerHash().call();
      console.log(firstHouseOwnerHash);


      const { getSecondHouseId, getSecondHouseAddress,
        getSecondHousePrice, getSecondHouseOwnerHash } = this.meta.methods;

      const secondHouseId = await getSecondHouseId().call();
      console.log(secondHouseId);

      const secondHouseAddress = await getSecondHouseAddress().call();
      console.log(secondHouseAddress);

      const secondHousePrice = await getSecondHousePrice().call();
      console.log(secondHousePrice);

      const secondHouseOwnerHash = await getSecondHouseOwnerHash().call();
      console.log(secondHouseOwnerHash);


      const { getThirdHouseId, getThirdHouseAddress, getThirdHousePrice,
        getThirdHouseOwnerHash } = this.meta.methods;

      const thirdHouseId = await getThirdHouseId().call();
      console.log(thirdHouseId);

      const thirdHouseAddress = await getThirdHouseAddress().call();
      console.log(thirdHouseAddress);

      const thirdHousePrice = await getThirdHousePrice().call();
      console.log(thirdHousePrice);


      const thirdHouseOwnerHash = await getThirdHouseOwnerHash().call();
      console.log(thirdHouseOwnerHash);

      const { onBuyClicked } = this.meta.methods;
      //onBuyClicked(ownerAddress, price, houseId).send();
      this.refreshTotalHouses();

    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }
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
    var content = "";
    const btnMsg = status === 'toBuy' ? 'buy' : 'sell';
    houses.forEach(function(house) {
        var elem = '<li class="list-group-item">'
            + '<span>' + house.name + '</span>'
            + '\t<span>' + house.price + '</span>'
            + '\t<button class="btn btn-primary" id=' + house.id + '>' + btnMsg + '</button>'
            + '</li>';
        content += elem;
    });
    let element
    if (status === 'toBuy') {
      element = document.getElementById("available_properties");
    } else {
      element = document.getElementById("owned_properties");
    }
    element.innerHTML = content;
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
