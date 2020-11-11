pragma solidity >=0.4.22 <0.7.0;

pragma experimental ABIEncoderV2;

contract CrowdFunding {

     uint public fundingGoal;
     uint public currentFunding;
     Person [] public contributors;
     
     struct Person {
        string name;
        string addres;
        uint valueContributed;
        bool initialized;
    }

    constructor(uint _fundingGoal) public {
        fundingGoal = _fundingGoal;
    }
    
    function getCurrentFunding() public view returns (uint) {
        return currentFunding;
    }
    
    function create(string memory name, string memory addres, uint valueContributed) public {
        contributors.push(Person(name, addres, valueContributed, true));
    } 
    
    function getContributor(uint index) public view returns (Person memory) {
        return contributors[index];
    }
    
    function getContributors() public view returns (Person[] memory) {
        return contributors;
    }
    
    
    function deposit(uint sum, Person memory _contributor) public {
        uint contributorIndex;

	if (currentFunding >= fundingGoal) {
	    return;
	}       
 
        for(contributorIndex = 0; contributorIndex < contributors.length; contributorIndex++) {
            if (keccak256(bytes(contributors[contributorIndex].name)) == keccak256(bytes(_contributor.name))) {
                break;
            }
        }
        
        if (contributorIndex < contributors.length) {
            contributors[contributorIndex].valueContributed = contributors[contributorIndex].valueContributed + sum;
        } else {
            _contributor.initialized = true;
            _contributor.valueContributed = sum;
            contributors.push(_contributor);
        }
        
        currentFunding = currentFunding + sum;
        
    }
    
    function withdraw(uint sum, Person memory _contributor) public {

	if (currentFunding >= fundingGoal) {
	    return;
	}

        for(uint contributorIndex = 0; contributorIndex < contributors.length; contributorIndex++) {
            if (keccak256(bytes(contributors[contributorIndex].name)) == keccak256(bytes(_contributor.name))) {
                if (contributors[contributorIndex].valueContributed >= sum) {
                    contributors[contributorIndex].valueContributed = contributors[contributorIndex].valueContributed - sum;
                    currentFunding = currentFunding - sum;
                }
            }
        }
    }
    
}
