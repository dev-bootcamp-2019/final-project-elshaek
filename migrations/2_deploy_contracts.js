var StringUtils = artifacts.require("../libraries/StringUtils.sol");
var Gather = artifacts.require("./Gather.sol");

async function doDeploy(deployer) {
    await deployer.deploy(StringUtils);
    await deployer.link(StringUtils, Gather);
    await deployer.deploy(Gather);
}

module.exports = function(deployer) {
    deployer.then(async () => {
        await doDeploy(deployer);
    });
};
