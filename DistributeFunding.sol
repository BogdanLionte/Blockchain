pragma solidity >=0.4.22 <0.7.0;

pragma experimental ABIEncoderV2;

contract DistributeFunding {
    
    struct Actionary {
        uint percentage;
        address payable addr;
    }
    
    uint currentPercentage;
    Actionary[] actionaries;
    bool distributed;
    address owner;
    
    constructor() public payable{
        currentPercentage = 0;
        distributed = false;
        owner = msg.sender;
    }
    
    function addActionary(uint percentage) public {
        if(getIndex(msg.sender) < 0 && percentage > 0 && percentage <= 100 && currentPercentage + percentage <= 100) {
         actionaries.push(Actionary(percentage, msg.sender));
         currentPercentage += percentage;
        }
    }
    
    function removeActionary() public {
        int index = getIndex(msg.sender);
        if (index >= 0) {
            currentPercentage -= actionaries[uint(index)].percentage;
            actionaries[uint(index)] = actionaries[actionaries.length - 1];
            actionaries.pop();
        }
    }
    
    function getActionaries() public view returns (Actionary[] memory) {
        return actionaries;
    }
    
    function getCurrentPercentage() public view returns (uint) {
        return currentPercentage;
    }
    
    function wasDistributed() public view returns (bool){
        return distributed;
    }
    
    function distribute() public payable{
        if(!distributed && currentPercentage == 100 && msg.sender == owner) {
            for(uint index = 0; index < actionaries.length; index++) {
                Actionary memory actionary = actionaries[index];
                // uint money = (address(this).balance) / 100 * actionary.percentage;
                actionary.addr.transfer(1);
                // if(money <= address(this).balance) {
                //     actionary.addr.transfer(money);
                // }
            }
            distributed = true;
        }
    }
    
    function getBalance() public view returns (uint) {
            return address(this).balance;
    }
    
    function getIndex(address _addr) private view returns (int) {
        for(uint index = 0; index < actionaries.length; index++) {
            if (actionaries[index].addr == _addr) {
              return int(index);  
            }
        }
        return -1;
    }
}
