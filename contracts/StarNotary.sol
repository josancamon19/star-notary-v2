pragma solidity >=0.4.21 <0.8.11;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721 {
    struct Star {
        string name;
    }

    constructor() ERC721("STAR", "STAR") {}

    mapping(uint256 => Star) public stars;
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string memory _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);
        stars[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(
            bytes(stars[_tokenId].name).length > 0,
            "The star should be created"
        );

        require(
            ownerOf(_tokenId) == msg.sender,
            "You can't sale the Star you don't owned"
        );
        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        // Is available?
        require(starsForSale[_tokenId] > 0, "The star should be up for sale");

        // Do you have the money?
        uint256 starCost = starsForSale[_tokenId];
        require(msg.value > starCost, "You need to have enough Ether");

        address ownerAddress = ownerOf(_tokenId);
        address payable ownerAddressPayable = payable(ownerAddress);

        // Send token to sender
        transferFrom(ownerAddress, msg.sender, _tokenId);

        // transfer the star cost to the owner
        ownerAddressPayable.transfer(starCost);

        // Extra balance is being sent back to the buyer
        if (msg.value > starCost) {
            payable(msg.sender).transfer(msg.value - starCost);
        }

        starsForSale[_tokenId] = 0;
    }

    // Implement Task 1 lookUptokenIdToStarInfo
    function lookUptokenIdToStarInfo(uint256 _tokenId)
        public
        view
        returns (string memory)
    {
        //1. You should return the Star saved in tokenIdToStarInfo mapping
    }

    // Implement Task 1 Exchange Stars function
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        //1. Passing to star tokenId you will need to check if the owner of _tokenId1 or _tokenId2 is the sender
        //2. You don't have to check for the price of the token (star)
        //3. Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId1)
        //4. Use _transferFrom function to exchange the tokens.
    }

    // Implement Task 1 Transfer Stars
    function transferStar(address _to1, uint256 _tokenId) public {
        //1. Check if the sender is the ownerOf(_tokenId)
        //2. Use the transferFrom(from, to, tokenId); function to transfer the Star
    }
}
