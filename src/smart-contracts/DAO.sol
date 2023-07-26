// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract JuntosPorVenezuelaDAO {
    // Propietario del contrato
    address public owner = 0x99311B8f50728f1Ed7FD22b9de58d91379238B42;

    // Estructura para las propuestas
    struct Proposal {
        string description;
        uint voteCount;
    }

    // Direcciones de los miembros
    address[] public members;

    // Propuestas de los miembros
    Proposal[] public proposals;

    // El constructor establece al propietario del contrato
    constructor() {
        require(msg.sender == owner, "Only the owner can deploy this contract");
        members.push(owner);  // El propietario es el primer miembro
    }

    // Función para añadir miembros al DAO
    function addMember(address newMember) public onlyOwner {
        members.push(newMember);
    }

    // Función para crear propuestas de cambios
    function createProposal(string memory description) public onlyMembers {
        proposals.push(Proposal({
            description: description,
            voteCount: 0
        }));
    }

    // Función para votar por una propuesta
    function vote(uint proposalIndex) public onlyMembers {
        proposals[proposalIndex].voteCount += 1;
    }

    // Modificador que permite que sólo el propietario del contrato pueda realizar ciertas acciones
    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Modificador que permite que sólo los miembros del DAO puedan realizar ciertas acciones
    modifier onlyMembers {
        require(isMember(msg.sender), "Only members can perform this action");
        _;
    }

    // Función privada para verificar si una dirección es miembro del DAO
    function isMember(address member) private view returns (bool) {
        for (uint i = 0; i < members.length; i++) {
            if (members[i] == member) {
                return true;
            }
        }
        return false;
    }

    // Agrega más funcionalidades según sea necesario para la DAO
}
