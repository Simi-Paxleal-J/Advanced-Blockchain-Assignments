pragma solidity >=0.5.13 < 0.7.3;

contract LakshmiLotterySystem{
    
    address owner;
    uint counts=0;
    
    mapping(address => uint) private addressOfLotteryParticipants;
    address[]  addressOfPartipant;
    address [] add;
    
    constructor() {
        owner = msg.sender;
        
    }
    
    function Particpat() payable public{
        require(msg.value>= 1 ether , " You require minumum 1 ether to participate in this lottery");
        require(contains(msg.sender)==0, " You are already a part of the lottery");
        addressOfLotteryParticipants[msg.sender] = msg.value;
        addressOfPartipant.push(msg.sender);
        counts++;
        add.push(msg.sender);
    }
    
    function randomNumberFunction()internal view returns(uint){
        uint randomNumber = uint(keccak256(abi.encodePacked(block.difficulty,
        block.timestamp, msg.sender,"Prabhpreet", addressOfPartipant))) % addressOfPartipant.length;
        return(randomNumber);
    }
    
    function transferEhterToWinner() public onlyOwner{
        uint randomWinner = randomNumberFunction();
        address payable winner = payable(addressOfPartipant[randomWinner]);
        winner.transfer(address(this).balance);
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner, "Owner only has access to this");
        _;
    }
    
    function contains( address _addr)  private view  returns(uint) { 
        return addressOfLotteryParticipants[_addr];
    }
    function reset ()public  onlyOwner{
        delete addressOfPartipant;
        for(uint i=0;i<counts;i++)
        {
          delete addressOfLotteryParticipants[add[i]];
        }
       
    }
}
