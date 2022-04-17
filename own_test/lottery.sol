// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

/* 
Overview of the Lottery contract.
Roles:: 
    1. Manager
    2. Participants

Participants can purchase lottery ticket by paying 0.1 ether. As soon as participant will 
pay 1 ether, his/her address will be noted and will be taken in winner selection. Winner
selection process will not be active until number of participants should be at least 3.
Once all the criteria met, manager will select random winner and will transfer all the 
deposited ether to winner's account.

*/

contract lottery{

    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

    receive() external payable{
        // participants should pay 0.1 ether to purchase lottery ticket.
        require(msg.value == 0.1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        // only manager can have permission to check balance.
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        // only manager can selectWinner and to start selecting winner, number of participants
        // should be at least 3.
        require(msg.sender == manager);
        require(participants.length >= 3);

        address payable winnerAddress;

        uint lucky_num = random();
        uint winnerIndex = lucky_num % participants.length;
        winnerAddress = participants[winnerIndex];

        winnerAddress.transfer(getBalance());

        // empty participants array
        participants = new address payable[](0);
    }

}