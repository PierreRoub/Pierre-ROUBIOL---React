pragma solidity >=0.4.21 <0.6.0;

import "./Ranch.sol";
import "./ERC721.sol";
import "./IERC721.sol";
import "../math/SafeMath.sol";

contract arene {
    using SafeMath for uint256;
    address public ERC721address;
    address public Ranchaddress;
    ERC721 ERC721Instance = ERC721(ERC721address);
    Ranch RanchInstance = Ranch(Ranchaddress); 

    struct Acheteur {
        address utilisateur;
        string name;
        uint256 money;
        uint[] possession;
    }

    Acheteur[] public Acheteurs;
    event declaredAcheteur(uint acheteurId);

    function declareAcheteur(string memory _name, uint256 _money, uint[] memory _possession) public {
        Acheteur memory _Acheteur;
        _Acheteur.utilisateur=msg.sender;
        _Acheteur.name=_name;
        _Acheteur.money=_money;
        _Acheteur.possession=_possession;
        Acheteurs.push(_Acheteur) -1;
        uint acheteurId=Acheteurs.length-1;
        emit declaredAcheteur(acheteurId);
    }

    function depot(uint tokenId) public {
        // approve(to, tokenId);
        ERC721Instance.transferFrom (msg.sender, address(this), tokenId);
    }

    function retrait(uint tokenId) public {
        ERC721Instance.transferFrom (address(this), msg.sender, tokenId);
    }

    function miseEnVente(uint tokenId, uint256 price) public {
        RanchInstance.putPrice(tokenId, price);
    }

    function achat(uint acheteurId, uint vendeurId, uint tokenId) public {
        require (RanchInstance.getPrice(tokenId) >0 );
        require (Acheteurs[acheteurId].money >= RanchInstance.getPrice(tokenId));
        ERC721Instance.transferFrom(Acheteurs[vendeurId].utilisateur, Acheteurs[acheteurId].utilisateur, tokenId);
        Acheteurs[acheteurId].money = Acheteurs[acheteurId].money - RanchInstance.getPrice(tokenId);
        Acheteurs[vendeurId].money = Acheteurs[vendeurId].money + RanchInstance.getPrice(tokenId);
    }

    function reproduction(uint tokenMale, uint tokenFemelle, string memory name, bool sort /* oui car on peut choisir le sexe désormais*/) public {
        RanchInstance.breedAnimal(tokenFemelle, tokenMale, name, sort);
    }

    function bagarre(uint tokenId1, uint tokenId2) public {
        if (RanchInstance.getStrength(tokenId1) >= /* ici si il leur force est égal alors le numéro 1 gagne arbitrairement */ RanchInstance.getStrength(tokenId2)) {
            RanchInstance.deadAnimal(tokenId2);
            RanchInstance.addStrength(tokenId1, RanchInstance.getStrength(tokenId2));} // on ajoute le force du perdant au vainqueur
        else {
            RanchInstance.deadAnimal(tokenId1);
            RanchInstance.addStrength(tokenId2, RanchInstance.getStrength(tokenId1));}
    }

}