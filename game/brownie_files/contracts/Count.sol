//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0;

contract Count{
    
    uint number;
    
    constructor(uint _number){
	number = _number;
    }
    
    function get() public view returns (uint){
    return number;
    }

    function inc(uint _number) public {
        uint copynumber = number * 1;
        number += _number;
        if(number <= copynumber){
        number = copynumber;
        }
    }

    function dec(uint _number) public {
        uint copynumber = number * 1;
        number -= _number;
        if(number >= copynumber){
        number = copynumber;
        }
    }
    
    function mul(uint _number) public {
        uint copynumber = number * 1;
        number *= _number;
        if(number <= copynumber){
        number = copynumber;
        }
    }

    function set(uint _number) public {
	number = _number;
    }
}
