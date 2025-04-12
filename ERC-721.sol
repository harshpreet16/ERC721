// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
interface ERC721 /* is ERC165 */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`_from` == 0) and destroyed
    ///  (`_to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256);

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address);

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external payable;

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender` assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external;

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) external view returns (address);

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

interface ERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
} 

///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.

interface ERC721Metadata /* is ERC721 */ {
    /// @notice A descriptive name for a collection of NFTs in this contract
    function name() external view returns (string memory _name);

    /// @notice An abbreviated name for NFTs in this contract
    function symbol() external view returns (string memory _symbol);

    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
    /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}


/// @title ERC-721 implementation
/// @author Harshpreet
/// @notice you can create NFT and tranfer it
/// @dev name,symbol,contractowner to be fixed
contract MYERC721 is ERC721, ERC165, ERC721Metadata {
    string private _name;
    string private _symbol;

    uint256 public countToken;

    /// @notice mapping for the owner of any of the token
    /// @dev token id => owner
    mapping(uint256 => address) private _owners;
    /// @notice mapping to store the NFT balance
    /// @dev owner => token count
    mapping(address => uint256) private _balances;
    /// @notice mapping to store the approvals
    /// @dev token id => approved address
    mapping(uint256 => address) private _tokenApprovals;
    /// notice mapping for the operator for all NFTs
    /// @dev owner => (operator => yes/no)
    mapping(address => mapping(address => bool)) private  _operatorApprovals;
    /// @notice checking matadata with tokenid
    /// @dev token id => token uri
    mapping(uint256 => string) private _tokenUris;

    /// @notice initialisation of name and symbol
    /// @dev initilisation of name, symbol and contract owner
    constructor(string memory _tokenName,string memory _tokenSymbol){
        _name=_tokenName;
        _symbol=_tokenSymbol;
    }

    /// @notice name of the token
    /// @dev addition of the name 
    function name() public view returns(string memory){
        return _name;
    }

    /// @notice symbol of the token
    /// @dev symbol of the token is added
    function symbol() public view returns(string memory){
        return _symbol;
    }

    /// @notice user can check their NFT balance
    /// @dev checking of zero address or else will be zero
    /// @param _owner address of the user who want to check their balance
    /// @return balance of the owner passed through parameter
    function balanceOf(address _owner) public view returns(uint256){
        require(_owner !=address(0)," zero address");
        return _balances[_owner];
    }

    /// @notice check who is the owner of a particular token with tokenId
    /// @dev checking if the token have the owner , and if no then it is token id is invalid
    /// @param _tokenId to check the owner
    /// @return the owner of the particular token
    function ownerOf(uint256 _tokenId) public view returns(address){
        require(_owners [_tokenId]!= address(0)," Invalid token id");
        return _owners[_tokenId];
    }

    /// @notice transfer function to transfer of NFT 
    /// @notice this checks some normal conditions like zero address and approvals and then transfer
    /// @notice byte data is optional
    /// @notice this function will also check for the receiver
    /// @dev check conditions before transfer like for recipient zero address and approval
    /// @dev delete the before approval as previous approved address can still transfer the token and update balances
    /// @param _from the nft sending address, _to the address to be sent, _tokenId with the tokenId
    function safeTransferFrom(address _from, address _to, uint256 _tokenId,bytes memory  ) public payable {
        require(_from !=address(0) && _to != address(0),"Zero Address" );
        require(ownerOf(_tokenId) == _from || _tokenApprovals[_tokenId] == msg.sender || _operatorApprovals[ownerOf(_tokenId)][msg.sender], "Not Authorized");
        delete _tokenApprovals[_tokenId];
        _balances[_from] = _balances[_from] - 1;
        _balances[_to] = _balances[_to] + 1;
        _owners[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice here also you can transfer your NFT by checking the normal conditions
    /// @notice here optional byte data is not present
    /// @dev after checking some essential conditions, then transfer and update balance
    /// @param _from the nft sending address, _to the address to be sent, _tokenId with the tokenId
    function safeTransferFrom(address _from,address _to,uint256 _tokenId) public payable {
        require(_from !=address(0) && _to != address(0),"Zero Address" );
        require(ownerOf(_tokenId) == _from || _tokenApprovals[_tokenId] == msg.sender || _operatorApprovals[ownerOf(_tokenId)][msg.sender], "Not Authorized");
        delete _tokenApprovals[_tokenId];
        _balances[_from] = _balances[_from] - 1;
        _balances[_to] = _balances[_to] + 1;
        _owners[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice Here you can transfer your NFT by checking conditions
    /// @dev after checking some essential conditions, then transfer and update balance
    /// @param _from the nft sending address, _to the address to be sent, _tokenId with the tokenId
    function transferFrom(address _from, address _to, uint256 _tokenId) public payable{
        require(_from !=address(0) && _to != address(0),"Zero Address" );
        require(ownerOf(_tokenId) == _from || _tokenApprovals[_tokenId] == msg.sender || _operatorApprovals[ownerOf(_tokenId)][msg.sender], "Not Authorized");
        delete _tokenApprovals[_tokenId];
        _balances[_from] = _balances[_from] - 1;
        _balances[_to] = _balances[_to] + 1;
        _owners[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice here the address gets approved, so that they can send of behalf of the owner
    /// @dev check the owner of the token , or operator approval can only approve the address
    /// @param _approved address who will get approval to spend for _tokenId
    function approve(address _approved, uint256 _tokenId) public payable{
        require(ownerOf(_tokenId)==msg.sender || _operatorApprovals[ownerOf(_tokenId)][msg.sender],"Not Authorized");
        _tokenApprovals[_tokenId]= _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    /// @notice checking for the approved address 
    /// @dev cheking for tokenid existance, if exists then give approved address 
    /// @param _tokenId whose we want to see the approved address
    /// @return the approval address, no approved then zero address
    function getApproved(uint256 _tokenId) public view returns(address) {
        require(ownerOf(_tokenId)!=address(0)," invalid tokenid");
        return _tokenApprovals[_tokenId];
    }

    /// @notice Approval for all the tokens
    /// @notice Approve or remove operator as an operator for the caller.
    /// @dev check operator is approved to do transaction
    /// return the operator approval
    function setApprovalForAll(address _operator, bool _approved) public {
        _operatorApprovals[msg.sender][_operator]=_approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /// @notice check if a address is approved for all tokens
    /// @dev owner with operator can checks for the approved operator
    /// @param _owner for the owner who has given permission to the _operator for the token supply
    /// @return true for the approved , false foe not approved
    function isApprovedForAll(address _owner, address _operator) public view returns (bool){
        return _operatorApprovals[_owner][_operator];
    }

    /// @notice mint function to create new NFT
    /// @dev only contract owner can create NFT and cannot be transfered to zero address
    /// @dev update the balance of the _to which is a receiver and increase nexttokenidmint for the next token provider
    /// @dev _uri for the tokenuri for metadata 
    /// @param _to for the receiving address and _uri for the tokenuri metadata
    function mintTo(address _to, string memory _uri) public {
        require(_to != address(0),"Receiver cannot be zero address");
        _owners[countToken]=_to;
        _balances[_to]= _balances[_to]+1;
        _tokenUris[countToken]=_uri;
        countToken++;
    }

    /// @notice checking for specific interface is supported by smart contract for other contract
    /// @dev it checks that interface id should be equal to erc721 interface id which is 0x80ac58cd
    /// @param interfaceId should be same as that of the interface id
    /// @return true if it matches our contract is erc721 compliant else false
    function supportsInterface(bytes4 interfaceId) public pure returns (bool){
        return interfaceId == type(ERC721).interfaceId || interfaceId == type(ERC165).interfaceId || interfaceId == type(ERC721Metadata).interfaceId;
    }
    
    /// @notice checks what metadata uri is passed with tokenId
    /// @dev take the tokenid and returns the metadata involved in it
    /// @param _tokenId passed for the retrival of particular metadata of this tokenid
    /// @return the token uri of the tokens
    function tokenURI(uint256 _tokenId) public view returns (string memory){
        return string.concat("https://ipfs/", _tokenUris[_tokenId]);
    }
  
}