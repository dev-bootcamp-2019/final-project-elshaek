## Fail early and fail loud
Example code from Gather.sol:
```
modifier verifyAdmin() {
    require(users[msg.sender].status == UserStatus.Admin, "Admin access only!"); 
    _;
}
```
This modifier checks the condition required for execution at the beginning of the function body and throws an exception if the condition is not met. This reduces unnecessary code execution in the event that an exception will be thrown.

## Mortal
Example code from Gather.sol:
```
function kill() public {
    require(msg.sender == owner, "Contract owner access only");
    selfdestruct(owner);
}
```
This give the contract owner the ability to destroy the contract and remove it from the blockchain.

## Circuit Breaker
Example code from Gather.sol:
```
function toggleGatheringActive() public verifyAdmin() { stopped = !stopped; }
modifier stopWhenNeeded() { if (!stopped) _; }
```
The above allows an Admin to stop users from joining a gathering.

## Restricting Access
Example codes from Gather.sol:
```
modifier verifyAdmin() {
    require(users[msg.sender].status == UserStatus.Admin, "Admin access only!"); 
    _;
}

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

```
The above code only allows an Admin to add a new Admin; since admins have access to administrative methods such as stopping users from joining gatherings.
