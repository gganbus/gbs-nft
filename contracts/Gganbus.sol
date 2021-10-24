pragma solidity ^0.5.6;

import "./klaytn-contracts/token/KIP17/KIP17Full.sol";
import "./klaytn-contracts/token/KIP17/KIP17Mintable.sol";
import "./klaytn-contracts/token/KIP17/KIP17Pausable.sol";
import "./klaytn-contracts/ownership/Ownable.sol";

contract Gganbus is Ownable, KIP17Full("Gganbus", "GGANBUS"), KIP17Mintable, KIP17Pausable {

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "KIP17Metadata: URI query for nonexistent token");

        if (tokenId == 0) {
            return "https://api.gganbus.com/gganbus/0";
        }

        string memory baseURI = "https://api.gganbus.com/gganbus/";
        string memory idstr;

        uint256 temp = tokenId;
        uint256 digits;
        while (temp != 0) {
            digits += 1;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (tokenId != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(tokenId % 10)));
            tokenId /= 10;
        }
        idstr = string(buffer);

        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, idstr)) : "";
    }

    function massMint(uint256 start, uint256 end) external onlyMinter {
        for (uint256 i = start; i <= end; i += 1) {
            mint(msg.sender, i);
        }
    }

    function bulkTransfer(address[] calldata tos, uint256[] calldata ids) external {
        uint256 length = ids.length;
        for (uint256 i = 0; i < length; i += 1) {
            transferFrom(msg.sender, tos[i], ids[i]);
        }
    }
}
