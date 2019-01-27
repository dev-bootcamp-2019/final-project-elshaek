pragma solidity ^0.5.0;

import "../libraries/StringUtils.sol";

contract Gather {
    bool private stopped = false;
    address payable public owner;
    enum UserStatus { Admin, Regular }

    struct User {
        UserStatus status;
        string displayName;
        uint gatheringCount;
        uint index;
    }
    mapping(address => User) public users;
    address[] private userIndex;

    uint private constant MAX_GATHERING_COUNT = 5;
    uint private constant MAX_PARTICIPANT_COUNT = 30;
    struct Gathering {
        address organizer;
        string name;
        address[] participants;
        uint index;
    }
    Gathering[] public gatheringIndex;

    event LogAdminAdded(address _address);
    event LogUserAdded(address _address);
    event LogNewGathering(string _string);
    event LogGatheringJoined(string _string, address _address);
    event LogLeftGathering(string _string, address _address);
    event LogNameChange(string _string);
    event LogDescriptionChange(string _string);

    modifier verifyAdmin() {
        require(users[msg.sender].status == UserStatus.Admin, "Admin access only!"); 
        _;
    }

    modifier verifyUser(address _address) {
        require(userIndex.length > 0, "There is currently no user");
        require(userIndex[users[_address].index] == _address, "User does not exist");
        _;
    }

    modifier verifyOrganizer(uint index) {
        require(msg.sender == gatheringIndex[index].organizer ); 
        _;
    }

    modifier organizedGatheringBelowMax(uint count) {
        count <= MAX_GATHERING_COUNT;
        _;
    }

    modifier notEmpty(string memory _string) {
        require (!StringUtils.equal(_string, ""), "String cannot be empty");
        _;
    }

    modifier stopWhenNeeded() { if (!stopped) _; }

    // Constructor
    constructor()
        public
    {
        owner = msg.sender;
        users[msg.sender] = User({status: UserStatus.Admin, displayName: "Admin", gatheringCount: 0, index: userIndex.length});
        userIndex.push(msg.sender);
        emit LogAdminAdded(msg.sender);
    }

    // Functions
    function kill() public {
        require(msg.sender == owner, "Contract owner access only");
        selfdestruct(owner);
    }

    function toggleGatheringActive() public verifyAdmin() { stopped = !stopped; }

    // Adds a new user to the platform
    function addUser(address _address, string memory _displayName)
        public
        returns(address)
    {
        users[_address] = User({status: UserStatus.Regular, displayName: _displayName, gatheringCount: 0, index: userIndex.length});
        userIndex.push(_address);
        emit LogUserAdded(_address);
        return _address;
    }

    function getUserStatus(address _address) 
        public 
        view
        returns (UserStatus userStatus) 
    {
        return users[_address].status;
    }

    // An admin can make an existing user an admin
    function addAdmin(address newAdminAddress)
        public
        verifyUser(newAdminAddress)
        verifyAdmin()
        returns(address)
    {
        users[newAdminAddress].status = UserStatus.Admin;
        emit LogAdminAdded(newAdminAddress);
        return newAdminAddress;
    }

    // Any user can organize a new gathering
    // Each user can organize up to a maximum of 5 gatherings
    function organizeNewGathering(string memory _name)
        public
        verifyUser(msg.sender)
        organizedGatheringBelowMax(users[msg.sender].gatheringCount)
        notEmpty(_name)
        returns(string memory)
    {
        Gathering memory g = Gathering({organizer: msg.sender, name: _name, participants: new address[](0), index: gatheringIndex.length});
        users[msg.sender].gatheringCount++;
        gatheringIndex.push(g);
        emit LogNewGathering(g.name);
        return g.name;
    }

    // The organizer can rename the gathering
    function setGatheringName(uint index, string memory gatheringName)
        public
        verifyOrganizer(index)
        notEmpty(gatheringName)
        returns(string memory)
    {
        Gathering memory g = gatheringIndex[index];
        g.name = gatheringName;
        emit LogNameChange(gatheringName);
        return gatheringName;
    }

    // The gatherings organizer can remove a gathering
    function removeGathering(uint index)
        public
        verifyUser(msg.sender)
        verifyOrganizer(index)
        returns(bool)
    {
        // remove from gatheringIndex
        uint lastIndex = gatheringIndex.length - 1;
        Gathering memory lastIndexGathering = gatheringIndex[lastIndex];
        require(index >= 0);
        gatheringIndex[index] = lastIndexGathering;
        lastIndexGathering.index = index;
        delete gatheringIndex[lastIndex];
    
        // Update organizer's gathering count
        require(users[msg.sender].gatheringCount > 0);
        users[msg.sender].gatheringCount--;
        return true;
    }

    // Any user can join any gathering
    function joinGathering(uint index)
        public
        stopWhenNeeded()
        verifyUser(msg.sender)
        returns(bool)
    {
        require(gatheringIndex[index].participants.length < MAX_PARTICIPANT_COUNT, "Gathering is full");
        gatheringIndex[index].participants.push(msg.sender);
        emit LogGatheringJoined(gatheringIndex[index].name, msg.sender);
        return true;
    }

    // A participant can leave a gathering
    function leaveGathering(uint index, uint participantIndex)
        public
        verifyUser(msg.sender)
        returns(bool)
    {
        if(participantIndex != (gatheringIndex[index].participants.length - 1)) {
            address lastParticipant = gatheringIndex[index].participants[gatheringIndex[index].participants.length - 1];
            gatheringIndex[index].participants[participantIndex] = lastParticipant;
        }
        delete gatheringIndex[index].participants[participantIndex];
        emit LogLeftGathering(gatheringIndex[index].name, msg.sender);
        return true;
    }

    // A gathering's organizer can remove a participant
    function removeParticipant(uint index, uint participantIndex)
        public
        verifyUser(msg.sender)
        verifyOrganizer(index)
        returns(bool)
    {
        uint participantCount = gatheringIndex[index].participants.length;
        uint lastIndex = participantCount - 1;
        
        if(participantIndex != lastIndex) {
            address lastParticipant = gatheringIndex[index].participants[lastIndex];
            gatheringIndex[index].participants[participantIndex] = lastParticipant;
        }
        delete gatheringIndex[index].participants[lastIndex];
        return true;
    }

    // Fallback function
    function() external { msg.sender; }
}
