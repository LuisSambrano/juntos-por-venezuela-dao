const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Wallet", function() {
  let Wallet;
  let wallet;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function() {
    Wallet = await ethers.getContractFactory("Wallet");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    wallet = await Wallet.deploy(owner.address);

    await wallet.deployed();
  });

  describe("Despliegue", function() {
    it("Debería asignar la dirección del propietario al desplegar", async function() {
      expect(await wallet.owner()).to.equal(owner.address);
    });
  });

  describe("Transacciones", function() {
    it("Debería registrar correctamente las transacciones entrantes", async function() {
      await owner.sendTransaction({to: wallet.address, value: ethers.utils.parseEther("1.0")});
      expect(await ethers.provider.getBalance(wallet.address)).to.equal(ethers.utils.parseEther("1.0"));
    });

    it("Solo el propietario puede enviar transacciones", async function() {
      await expect(wallet.connect(addr1).send(addr2.address, ethers.utils.parseEther("0.5"))).to.be.revertedWith("Operación permitida solo para el propietario");
    });

    it("El propietario puede enviar transacciones", async function() {
      await wallet.connect(owner).send(addr1.address, ethers.utils.parseEther("0.5"));
      expect(await ethers.provider.getBalance(wallet.address)).to.equal(ethers.utils.parseEther("0.5"));
    });
  });

  // Aquí puedes agregar más pruebas basándote en las funciones específicas de tu contrato.
});
