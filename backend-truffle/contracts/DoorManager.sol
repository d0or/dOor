pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "./Door.sol";

contract DoorFactory is Ownable, Pausable {

    address[] private doors;
    mapping (address => bool) private createdConfirmations;

    event Created(
        address indexed owner,
        address indexed doorAddress,
        string indexed name,
        uint ticketPrice,
        bool allowWithdrawal
    );

    //returns new door contract address
    function createNewDoor(string memory _name, uint256 _ticketPrice, bool _allowWithdrawal) public whenNotPaused returns(address) {
        
        Door door = new Door(_name,_ticketPrice, _allowWithdrawal);

        door.transferOwnership(msg.sender);

        doors.push(address(door));

        createdConfirmations[address(door)] = true; //is this necessary??

        emit Created(
            msg.sender,
            address(door),
            _name,
            _ticketPrice,
            _allowWithdrawal
        );

        return address(door);
    }

    function getDoorCount() public view returns(uint) {
        return doors.length;
    }

    function getDoorByIndex(uint index) public view returns(address) {
        return doors[index];
    }

    /**
      * @dev Use 'pragma experimental ABIEncoderV2;' instead of 'pragma solidity ^0.5.x;'
      * @notice Here be dragons (experimental!)
      */
    function getAllDoors() public view returns(address[] memory) {
        return doors;
    }

    function confirmDoorCreated(address _doorAddress) public view returns(bool) {
        return createdConfirmations[_doorAddress];
    }
}
