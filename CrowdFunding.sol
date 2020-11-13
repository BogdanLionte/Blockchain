pragma solidity >=0.4.22 <0.7.0;

pragma experimental ABIEncoderV2;

contract CrowdFunding {

     uint public fundingGoal;
     uint public currentAmount;
     Person [] public contributors;
     
     struct Person {
        address _address;
        uint valueContributed;
        bool initialized;
    }

    constructor(uint _fundingGoal) public payable {
        fundingGoal = _fundingGoal;
        currentAmount = address(this).balance;
    }
    
    function create(address _address, uint valueContributed) private {
        contributors.push(Person(_address, valueContributed, true));
    } 
    
    function getContributor(uint index) private view returns (Person memory) {
        return contributors[index];
    }
    
    function getContributors() private view returns (Person[] memory) {
        return contributors;
    }
    
    function deposit() public payable {
        
        if (currentAmount >= fundingGoal) {
            revert("Goal reached");
        }
        
        uint contributorIndex;
        
        for(contributorIndex = 0; contributorIndex < contributors.length; contributorIndex++) {
            if (msg.sender == contributors[contributorIndex]._address) {
                break;
            }
        }
        
        if (contributorIndex < contributors.length) {
            contributors[contributorIndex].valueContributed = contributors[contributorIndex].valueContributed + msg.value / (10 ** 18);
        } else {
            contributors.push(Person(msg.sender, msg.value / (10 ** 18), true));
        }
        
        currentAmount = currentAmount + msg.value / (10 ** 18);

    }
    
    function withdraw(uint value) public payable {
        
        if (currentAmount >= fundingGoal) {
            revert("Goal reached");
        }
        
        for(uint contributorIndex = 0; contributorIndex < contributors.length; contributorIndex++) {
            if (contributors[contributorIndex]._address == address(msg.sender)) {
                if (contributors[contributorIndex].valueContributed >= value) {
                    contributors[contributorIndex].valueContributed = contributors[contributorIndex].valueContributed - value;
                    currentAmount = currentAmount - value;
                    msg.sender.transfer(value * (10 ** 18));
                } else {
                    revert("You didn't fund that much");
                }
            }
        }
    }
    
}