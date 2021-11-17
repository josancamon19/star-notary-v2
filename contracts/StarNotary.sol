pragma solidity >=0.4.21 <0.8.11;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721 {
    struct Star {
        string name;
    }

    constructor() ERC721("STAR", "STAR") {}

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string memory _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
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
}
