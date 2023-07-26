// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/**
 * @title Wallet para la DAO "Juntos por Venezuela"
 * @dev Este contrato permite depositar y retirar ethers, y sólo el propietario puede retirar ethers.
 * @notice Este es un contrato básico, es probable que requiera modificaciones para cumplir con todas las necesidades de la DAO.
 */

contract Wallet {
    // Dirección del propietario de la Wallet. En este caso, es la dirección de Luis Sambrano.
    address payable private owner;

    // Eventos que se emiten cuando se depositan o retiran fondos.
    event FundsDeposited(address from, uint amount);
    event FundsWithdrawn(address to, uint amount);

    constructor() {
        // Inicializa al propietario de la Wallet en el despliegue del contrato.
        owner = payable(0x99311B8f50728f1Ed7FD22b9de58d91379238B42);
    }

    /**
     * @dev Permite a cualquier persona depositar ethers en la Wallet.
     * @notice La cantidad depositada debe ser mayor que 0.
     */
    function deposit() public payable {
        require(msg.value > 0, "No se puede depositar 0 ethers.");
        emit FundsDeposited(msg.sender, msg.value);
    }

    /**
     * @dev Permite al propietario retirar una cierta cantidad de ethers de la Wallet.
     * @notice Solo el propietario puede retirar fondos.
     * @param amount La cantidad de ethers a retirar.
     */
    function withdraw(uint amount) public {
        require(msg.sender == owner, "Solo el propietario puede retirar fondos.");
        require(address(this).balance >= amount, "Balance insuficiente en la billetera.");
        owner.transfer(amount);
        emit FundsWithdrawn(owner, amount);
    }

    /**
     * @dev Consulta el balance actual de la Wallet.
     * @return El balance de la Wallet en ethers.
     */
    function balanceOf() public view returns(uint) {
        return address(this).balance;
    }
}
