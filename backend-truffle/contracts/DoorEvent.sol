//Meet.inc >>> ĐOor-Event <<<
//Đoor-Event - Everything's decentralized but not your Đoor
//ĐOor opens doors at events that are anchored on the Ethereum blockchain.
//
//Last update: 11.11.2019

pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


    //TODO
    //1. Review (old) hackathon code created in sleepytime limbo  [work in progress..]
    //2. Get GSN working
    //3. Upgradable contracts which includes created user data
    //4. Create event “tickets” that are transferable (can lead to a market)


contract DoorEvent is Ownable, Pausable {
    //SafeMath library for calculations
    using SafeMath for uint;


    /**
     * Variables
     */

    //Contract essential data
    string private eventName;
    uint private ticketPrice;
    bool private rsvpCanWithdrawFunds;

    //Attendees ("RSVPs") can either be
    enum rsvpStatus {
        NONE,       //0: unregistered,
        REGISTERED, //1: registered (ticket owner) or
        ATTENDED    //2: can have attended.
    }
    //Create attendee ("RSVP") struct
    struct rsvpStruct{
        rsvpStatus ticketStatus;
        bool hasWithdrawn;
    }
    mapping(address => rsvpStruct) private RSVPs;


    /**
     * Events
     */
    event LogDoorEventTicketSold(address indexed rsvp);


    //Contract initialization
    constructor(string memory doorEventName, uint256 doorEventTicketPrice, bool allowRSVPsWithdrawFunds) public {
        eventName = doorEventName;
        ticketPrice = doorEventTicketPrice;
        rsvpCanWithdrawFunds = allowRSVPsWithdrawFunds;
    }


    /**
     * Main functions
     */

    //Attendee can purchase a ticket for this Door Event
    function buyDoorEventTicket() public whenNotPaused payable returns(bool success) {
        require(
            RSVPs[msg.sender].ticketStatus == rsvpStatus.NONE,
            'User has already a ticket'
        );
        require(
            msg.value == ticketPrice,
            "msg.value does not meet the ticket price."
        );

        //Mark attendee as 'registered'
        RSVPs[msg.sender].ticketStatus = rsvpStatus.REGISTERED;

        //Emit event
        emit LogDoorEventTicketSold(msg.sender);

        return true;
    }


   /**
     * Support functions
     */

    function getDoorEventName() public view returns(string memory DoorEventName) {
        return eventName;
    }

    function getRsvpTicketStatus(address rsvpAddress) public view returns(rsvpStatus rsvpTicketStatus) {
        return RSVPs[rsvpAddress].ticketStatus;
    }

    function getRsvpHasWithdrawn(address rsvpAddress) public view returns(bool indeed) {
        return RSVPs[rsvpAddress].hasWithdrawn;
    }
}