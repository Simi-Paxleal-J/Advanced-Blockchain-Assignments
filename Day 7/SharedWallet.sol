pragma solidity ^0.5.13;


contract SharedWallet 
{
   
    address public owner; //STORE OWNER ADDRESS
    mapping(address => bool) private financialTeam;  
    mapping(address => bool) private A_grade;
    mapping(address => bool) private B_grade; 
    mapping(address => bool) private C_grade;
    mapping(address => bool) private D_grade;
    mapping(address => uint256)  private limit; //MAP ADDRESSES WITH THEIR LIMITS
    
     constructor ()public
     {
         owner=msg.sender;
         financialTeam[owner]=true;
         
     }
     // ONLY OWNER AND FINANCIAL TEAM CAN USE..
     modifier onlyOwner()
     {
        require(msg.sender == owner || financialTeam[msg.sender], "Owner and financial Team has access to this");
        _;
    }
    //ONLY MEMBERS OF WALLET CAN USE
    modifier onlyMembers() 
    {
        require(A_grade[msg.sender] || B_grade[msg.sender] || C_grade[msg.sender] || financialTeam[msg.sender] ||D_grade[msg.sender], "You are not a member of the wallet");
        _;
    }
     
    //FOR ADDING MEMBERS TO FINANCIAL TEAM
    function addTofinancialTeam(address _add)public onlyOwner
    {
         financialTeam[_add]=true;
        
    }
    
    
    
    //FOR COMPARING TWO STRING
    function compareStrings(string memory a, string memory b) private pure returns (bool)
    {
     return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
    
    
    //FOR ADDING MEMBER WITH GRADE
    function addMemberWithGrade(address _add,string memory _grade)public onlyOwner
    {
      if(compareStrings("A",_grade))
      {
          A_grade[_add]=true;
          limit[_add]=60;

      }
      else if(compareStrings("B",_grade))    
      {
          B_grade[_add]=true;
          limit[_add]=40;
          
      }
      else  if(compareStrings("C",_grade))
      {
            C_grade[_add]=true;
            limit[_add]=20;      
      }
      else  if(compareStrings("D",_grade))
      {
            D_grade[_add]=true;
            limit[_add]=10;
      }
      else
      { 
          revert("Please Grade from A, B, C and D only in capital letters"); //IF OTHER ARGUMENTS GIVEN OTHER THAN CAPITAL A,B,C AND D.
          
      }
      
    }
    //FOR REFILLING THE EXHAUSTED LIMIT
    function refillLimit(address _add)public onlyOwner 
    {
        require(limit[_add] == 0 ,"User has  limit to spent.....");
          if(A_grade[_add])
        {
            limit[_add]=60;
        }
        else if(B_grade[_add])
        {
            limit[_add]=40;
        }
        else if(C_grade[_add])
        {
            limit[_add]=20;
        }
        else if(D_grade[_add])
        {
            limit[_add]=10;
        }
        
    }
     //FOR KNOWING WHICH GROUP TO YOU BELONG AND WHATS YOUR WITHDRAWING LIMITS 
    function checkGroupAndLimit() public view onlyMembers returns(string memory _Grade,uint256 onetimeLimit, uint256 remaininglimit)
    {

         if(A_grade[msg.sender])
         {
            return("A",30,limit[msg.sender]);
         }
        
        else if(B_grade[msg.sender])
        {
            return("B",20,limit[msg.sender]);
        }
        else if(C_grade[msg.sender])
        {
            return("C",10,limit[msg.sender]);
        }
        else if(D_grade[msg.sender])
        {
            return("D",5,limit[msg.sender]);
        }
       else if(financialTeam[msg.sender])
        {
            return("Financial Team",address(this).balance/1 ether,address(this).balance/1 ether);
        }
        
    }
        
    
        
    
    //FOR DIPOSITING BALANCE...
    function dipositInWallet()public payable onlyOwner
    {
      
    }
    
    
    //FOR WITHDRAWING AMOUNT....
    function withdrawFromWallet(uint256 amt)public payable onlyMembers
    {
        
        uint256 _amt2=address(this).balance / 1 ether;
        require(amt < _amt2,"Insufficient Balance......"); //AMOUNT SHOULD BE LESS THAN WALLET BALANCE
        
        if(A_grade[msg.sender])
        {
            require(limit[msg.sender]!= 0,"You Exhausted your limit ......");//LIMIT SHOULD NOT BE ZERO ,IF YES THAN CONTACT FINANCIAL TEAM
            require(amt < 30 ,"Either You enter the amount greater than remaining limit or your onetime limit i.e 30 ether");//AMOUNT SHOULD BE LESS THAN YOUR ONE TIME LIMIT
            limit[msg.sender]=limit[msg.sender]-amt;
            amt=amt*1 ether;
            msg.sender.transfer(amt);
        }
        else if(B_grade[msg.sender])
        {
            require(limit[msg.sender]!= 0,"You Exhausted your limit ......");
            require(amt < 20 ,"Either You enter the amount greater than remaining limit or your onetime limit i.e 20 ether");
            limit[msg.sender]=limit[msg.sender]-amt;
            amt=amt*1 ether;
            msg.sender.transfer(amt);
        }
        else if(C_grade[msg.sender])
        {
            require(limit[msg.sender]!= 0,"You Exhausted your limit ......");
            require(amt < 10 ,"Either You enter the amount greater than remaining limit or your onetime limit i.e 10 ether");
            limit[msg.sender]=limit[msg.sender]-amt;
            amt=amt*1 ether;
            msg.sender.transfer(amt);
        }
        else if(D_grade[msg.sender])
        {
            require(limit[msg.sender]!= 0,"You Exhausted your limit ......");
            require(amt < 5 ,"Either You enter the amount greater than remaining limit or your onetime limit i.e 5 ether");
            limit[msg.sender]=limit[msg.sender]-amt;
            amt=amt*1 ether;
            msg.sender.transfer(amt);
        }
         else if(financialTeam[msg.sender])
        {
       
            amt=amt*1 ether;
            msg.sender.transfer(amt);
        }
        
        }
    
    //FOR CHECKING WALLET BALANCE
    function checkWalletBalance()public view returns(uint256 balance){
        uint256 bal = address(this).balance/1 ether;
        return bal;
    }
    
    
}
