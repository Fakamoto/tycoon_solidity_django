// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Game {
    address private __owner;
    constructor() {
        __owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == __owner, "Ownable: caller is not the owner");
        _;
    }

    struct Player{
        uint gold;
        uint collectors;
        uint multiplier;
        uint lastCheck;
    }

    mapping (address => bool) players;
    mapping (address => Player) addressToPlayer;

    modifier isPlayer() {
        require(players[msg.sender] == true, "you are not a player");
        _;
    }

    function buyLand() external payable {
        require(msg.value == 1 ether, "not sending 1 ether");
        require(players[msg.sender] != true, "you already have a land");
        addressToPlayer[msg.sender] = Player(100, 0, 0, block.timestamp);
        players[msg.sender] = true;
    }

    function buyCollector() external isPlayer {
        refresh();
        require(addressToPlayer[msg.sender].gold >= 30, "not enough money");
        addressToPlayer[msg.sender].gold -= 30;
        addressToPlayer[msg.sender].collectors += 1;
        if (addressToPlayer[msg.sender].multiplier == 0) {
            addressToPlayer[msg.sender].multiplier = 1;
        }
    }

    function refresh() public isPlayer {
        addressToPlayer[msg.sender].gold += ((uint(block.timestamp) - uint(addressToPlayer[msg.sender].lastCheck)) * addressToPlayer[msg.sender].collectors ) * addressToPlayer[msg.sender].multiplier;
        addressToPlayer[msg.sender].lastCheck = uint(block.timestamp);
        winGame();
    }

    function display() public isPlayer returns (uint[] memory){
        uint[] memory response = new uint[](3);
        response[0] = addressToPlayer[msg.sender].gold;
        response[1] = addressToPlayer[msg.sender].collectors;
        response[2] = addressToPlayer[msg.sender].multiplier;
        return response;
    }

    function upgradeMultiplier() public isPlayer {
        refresh();
        require(addressToPlayer[msg.sender].gold >= uint(300), "not enough gold");
        addressToPlayer[msg.sender].gold -= uint(300);
        addressToPlayer[msg.sender].multiplier *= uint(2);

    }

    function winGame() public isPlayer {
        if (addressToPlayer[msg.sender].gold >= uint(100000)){
            if(addressToPlayer[msg.sender].collectors >= uint(10)){
                delete addressToPlayer[msg.sender];
                delete players[msg.sender];
                payable(msg.sender).transfer(address(this).balance);
            }
        }
    }

    function money() public view returns(uint){
        return address(this).balance;
    }
    function withdraw() external onlyOwner payable {
        address payable _owner = payable(address(uint160(__owner)));
        _owner.transfer(address(this).balance);
    }
}
