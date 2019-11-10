//Meet.inc >>> ĐOor-Manager <<<
//The ĐOor-Manager is a factory that allows event managers to deploy their own Door Event.
//ĐOor opens doors at events that are anchored on the Ethereum blockchain.
//
//Last update: 10.11.2019

pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "./DoorEvent.sol";


contract DoorManager is Ownable, Pausable{
    //Variables
    address[] private doorEventAddresses;
    mapping (address => bool) private doorEventCreated;

    //Events
    event NewDoorCreated(
        address indexed doorOwner,
        address indexed doorAddress,
        string indexed doorName,
        uint ticketPrice,
        bool allowDisposeLeftovers
    );

    //Create new Door Event
    function createNewDoorEvent(uint256 doorEventTicketPrice, string memory doorEventName, bool allowDisposeLeftovers) public whenNotPaused returns(address) {
        //Creation of new Door Event
        DoorEvent myDoor = new DoorEvent(doorEventTicketPrice, doorEventName, allowDisposeLeftovers);

        //Transfer ownership to caller
        myDoor.transferOwnership(msg.sender);

        //Append address of the new created event to the event array
        doorEventAddresses.push(address(myDoor));

        //Confirm creation of event
        doorEventCreated[address(myDoor)] = true;

        //Emit event: New Door Event created
        emit NewDoorCreated(
            msg.sender,
            address(myDoor),
            doorEventName,
            doorEventTicketPrice,
            allowDisposeLeftovers
        );

        return address(myDoor);
    }

    //Get amount of Door Events created by this Door Manager
    function getDoorEventCount() public view returns(uint) {
        return doorEventAddresses.length;
    }

    //Get Door Event address by index
    function getDoorEventByIndex(uint index) public view returns(address) {
        return doorEventAddresses[index];
    }

    //Get all Door Event address created by this Door Manager
    /**
      * @dev Use 'pragma experimental ABIEncoderV2;' instead of 'pragma solidity ^0.5.x;'
      * @notice Here be dragons (experimental!)
      */
    function getAllDoorEvents() public view returns(address[] memory) {
        return doorEventAddresses;
    }

    //Validate Door Event creation
    function getConfirmationDoorEventCreated(address doorEventAddress) public view returns(bool) {
        return doorEventCreated[doorEventAddress];
    }
}