//Meet.inc >>> ĐOor-Event <<<
//
//Test file for making use of GSN
//
//Last update: 12.11.2019

pragma solidity ^0.5.0;

//import "@openzeppelin/contracts/ownership/Ownable.sol";
//import "@openzeppelin/contracts/lifecycle/Pausable.sol";
//import "@openzeppelin/contracts/GSN/GSNRecipient.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/lifecycle/Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/GSN/GSNRecipient.sol";

contract DoorEvent is Ownable, Pausable, GSNRecipient {
    //Contract essential data
    string private eventName;
    uint RSVPcounter = 0;


    //Create attendee ("RSVP") struct
    struct rsvpStruct{
        bool rsvpConfirmed;
    }
    mapping(address => rsvpStruct) private RSVPs;


    //Contract initialization
    constructor(string memory doorEventName) public {
        eventName = doorEventName;
    }

    //Confirm or retract RSVP
    function toggleAttendance() public whenNotPaused returns(bool success) {
        bool rsvpStatus = RSVPs[_msgSender()].rsvpConfirmed;
        if (rsvpStatus == false){
            RSVPs[_msgSender()].rsvpConfirmed = true;
            RSVPcounter++;
        }
        else{
            RSVPs[_msgSender()].rsvpConfirmed = false;
            RSVPcounter--;
        }

        return true;
    }

    //How many people will attend?
    function getRSVPcount() public view returns(uint RSVPcounts) {
        return RSVPcounter;
    }
}