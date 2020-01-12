var DoorManager = artifacts.require("./DoorManager.sol");

module.exports = function(deployer, network) {
  console.log("network:", network);

  deployer.deploy(DoorManager);
};