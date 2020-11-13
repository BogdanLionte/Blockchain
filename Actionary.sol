pragma solidity >=0.4.22 <0.7.0;

pragma experimental ABIEncoderV2;

import 'DistributeFunding.sol';

contract Actionary {
    
        string public name;
        uint public percentage;
        address watch_addr = 0x5Fcd5d9f6444dD23Ca2af792B58B041A14fB34EB;
        
        constructor(string memory _name, uint _percentage) public {
            name = _name;
            percentage = _percentage;
        }
        
        function joinFunding() public {
            DistributeFunding distributeFunding = DistributeFunding(watch_addr);
            distributeFunding.addActionary(percentage);
        }
        
        function exitFunding() public {
            DistributeFunding distributeFunding = DistributeFunding(watch_addr);
            distributeFunding.removeActionary();
        }
        
        function getBalance() public view returns (uint) {
            return address(this).balance;
        }
}
