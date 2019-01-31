pragma solidity ^0.5.0;

// import "truffle/DeployedAddresses.sol";
import "truffle/Assert.sol";
import "../contracts/Gather.sol";
import "../libraries/StringUtils.sol";

contract TestGather {
    // Gather gather = Gather(DeployedAddresses.Gather());
    Gather gather = new Gather();

    // Contract owner is always set as Admin
    function testOwnerIsAdmin() public {
        Gather.UserStatus result = gather.getUserStatus(gather.owner());
        Gather.UserStatus expected = Gather.UserStatus.Admin;

        Assert.equal(uint(result),  uint(expected), "contract owner is admin");
    }

    // Any user with Admin status can add another user as Admin
    function testAdminCanAddAdmin() public {
        gather.addUser(address(1), "sam");
        gather.addAdmin(address(1));
        Gather.UserStatus result = gather.getUserStatus(address(1));
        Gather.UserStatus expected = Gather.UserStatus.Admin;

        Assert.equal(uint(result),  uint(expected), "admin can add a new admin");
    }

    // any user on the platform can organize a gathering
    function testAddGathering() public {
        (uint count, string memory result) = gather.organizeNewGathering("Potluck");
        string memory expected = "Potluck";

        Assert.equal(result,  expected, "any user can organize a gathering");
    }

    // the organizer of a gathering can change the name of the gathering
    function testSetGatheringName() public {
        (uint count, string memory result) = gather.organizeNewGathering("Arisan");
        string memory expected = "Arisan";

        Assert.equal(result,  expected, "user organized a new gathering with name Arisan");

        uint index = 0;
        string memory result2 = gather.setGatheringName(index, "Bloop");
        string memory expected2 = "Bloop";

        Assert.equal(result2,  expected2, "organizer can change gathering name");
    }

    // any user can join a gathering
    function testJoinGathering() public {
        gather.organizeNewGathering("Potluck");
        uint index = 0;
        bool result = gather.joinGathering(index);
        bool expected = true;

        Assert.equal(result,  expected, "user can join a gathering");
    }
}
