pragma solidity >=0.4.22 <0.7.0;
import "truffle/Assert.sol";
import "../contracts/CrowdFunding.sol";
pragma experimental ABIEncoderV2;


contract CrowdFundingTests {
   
    CrowdFunding crowdFunding;
    
    function beforeAll () public {
        crowdFunding = new CrowdFunding(100);
    }

    function testNoContributorsInitially () public returns (bool) {
        Assert.equal(0, crowdFunding.getContributors().length, "No contributors initially");
    }
    
    function testZeroFundInitially () public returns (bool) {
        Assert.equal(0, crowdFunding.getCurrentFunding(), "No funds initially");
    }
    
    function testCreateContributor() public returns (bool) {
        crowdFunding.create('contributor1', 'address1', uint(0));
        
        Assert.equal(1, crowdFunding.getContributors().length, "First contributor created");
    }
    
    function testExistingContributorAddsFunds() public returns (bool) {
        crowdFunding.deposit(20, crowdFunding.getContributor(0));
        
        Assert.equal(20, crowdFunding.getCurrentFunding(), "Contributor1 added 20 funds");
        Assert.equal(20, crowdFunding.getContributor(0).valueContributed, "Contributor1 contributed 20 funds, 20 total");
    }
    
    function testNewContributorAddsFunds() public returns (bool) {
        crowdFunding.deposit(30, CrowdFunding.Person("contributor2", "address2", uint(30), false));
        
        Assert.equal(2, crowdFunding.getContributors().length, "Second contributor created");
        Assert.equal(30, crowdFunding.getContributor(1).valueContributed, "Contributor2 added 30 funds");
        Assert.equal(50, crowdFunding.getCurrentFunding(), "Contributor2 added 30 funds, 50 total");
    }

    function testWithdrawFunds() public returns (bool) {
        crowdFunding.withdraw(15, crowdFunding.getContributor(0));
        Assert.equal(5, crowdFunding.getContributor(0).valueContributed, "Contributor1 withdrew 15 funds 5 remaining");
        Assert.equal(35, crowdFunding.getCurrentFunding(), "Contributor withdrew 15 funds, 35 total");
        
        crowdFunding.withdraw(20, crowdFunding.getContributor(1));
        Assert.equal(10, crowdFunding.getContributor(1).valueContributed, "Contributor2 withdrew 20 funds 10 remaining");
        Assert.equal(15, crowdFunding.getCurrentFunding(), "Contributor withdrew 20 funds, 15 total");
    }
    
    function testWithdrawMoreThanIsAvailable() public returns (bool) {
        Assert.equal(10, crowdFunding.getContributor(1).valueContributed, "Contributor1 has 10 funds");
        Assert.equal(15, crowdFunding.getCurrentFunding(), "Current funding is 15");
        crowdFunding.withdraw(200, crowdFunding.getContributor(1));
        Assert.equal(10, crowdFunding.getContributor(1).valueContributed, "Contributor1 has 10 funds");
        Assert.equal(15, crowdFunding.getCurrentFunding(), "Current funding is 15");
    }
    
}
