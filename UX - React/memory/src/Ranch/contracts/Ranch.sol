pragma solidity >=0.4.21 <0.6.0;

import "./ERC721.sol";
import "../math/SafeMath.sol";

contract Ranch is ERC721 {
    using SafeMath for uint256;
    address private _moderator;

    address payable public beneficiary;


    struct Animal 
    {
        address creator;
        string name;
        string kind;
        int age;
        uint256 strength;
        bool sort;   // true = female,  false= male
        bool alive;
        uint256 price;
    }

    Animal[] public Animals;

    event RegisterBreederedAdded(address indexed account);
    event declaredAnimal(uint objectNumber);

    string public name;
    uint public compteur;
    

    constructor () public {
        name = "PierreRoub";
    }

    mapping (address => bool) public _registerBreeder;
    mapping (uint256 => address) public _tokenOwner;

    modifier onlyOwner() {
        require(msg.sender == _moderator, "Owner 0x0");
        _;
    }

    function owner() public view returns (address) {
        return _moderator;
    }

    modifier isRegister(address _address) {
        require(_registerBreeder[_address], "not in registerBreeder");
        _;
    }

    function addRegisterBreeder(address _address) public onlyOwner() {
        require(!_registerBreeder[_address], "aldready in registerBreeder");
        _registerBreeder[_address] = true;
        emit RegisterBreederedAdded(_address);
    }

    function isInRegister(address _address) public view returns (bool) {
        return _registerBreeder[_address];
    }

    function payer() public payable {
        uint frais =0.1 ether;
        require (msg.value == frais);
        address payable monPortefeuille = address(0x6059834065bC63B286708bE7cC136953cf1724FB);
        monPortefeuille.transfer(msg.value);
    }

    function declareAnimal(string memory _name, string memory _kind, int _age, uint256 _strength, bool _sort) public {
        Animal memory _Animal;
        require(isInRegister(msg.sender));
        payer();
        _Animal.creator = msg.sender;
        _Animal.name = _name;
        _Animal.kind = _kind;
        _Animal.age = _age;
        _Animal.strength = _strength;
        _Animal.sort = _sort;
        _Animal.alive = true;
        _Animal.price=0;
        Animals.push(_Animal) - 1;
        uint objectNumber = Animals.length - 1;
        compteur = objectNumber;
        _tokenOwner[objectNumber] = msg.sender;
        emit declaredAnimal(objectNumber);
    }

    function putPrice(uint _animalNumber, uint256 price) public {
        require(_tokenOwner[_animalNumber] == msg.sender);
        Animals[_animalNumber].price = price;
    }

    function getPrice(uint _animalNumber) public view returns (uint256) {
        uint256 price = Animals[_animalNumber].price;
        return price;
    }

    function deadAnimal(uint _animalNumber) public {
        require(_tokenOwner[_animalNumber] == msg.sender);
        Animals[_animalNumber].alive = false;
    }

    function breedAnimal(uint _femaleNumber, uint _maleNumber, string memory _name,bool _sort ) public 
    {
        require((Animals[_femaleNumber].sort == true) && (Animals[_maleNumber].sort == false));
        require((_tokenOwner[_femaleNumber] == msg.sender) || (_tokenOwner[_maleNumber] == msg.sender));
        /*bool sort;
        random = new Random();
        int genre = random.nextInt(2);
        if (genre == 0) {
            sort = true;
            }
        else {
            sort=false;
            }*/
        declareAnimal (_name, Animals[_femaleNumber].kind, 0, Animals[_maleNumber].strength,_sort);
    }

    function getStrength(uint _animalNumber) public view returns (uint256) {
        uint256 strength = Animals[_animalNumber].strength;
        return strength;
    }

    function addStrength (uint _animalNumber, uint256 add) public {
        Animals[_animalNumber].strength = Animals[_animalNumber].strength + add;
    }

}

