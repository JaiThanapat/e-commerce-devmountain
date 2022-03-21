const ProductDeployERC20 = artifacts.require("ProductDeployERC20");

module.exports = async function (deployer) {
  await deployer.deploy(ProductDeployERC20);
  const product = await ProductDeployERC20.deployed();

  console.log('Product deployed to: ', product.address);
};
