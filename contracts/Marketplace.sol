// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0;

contract HarmonyMarketplace {
    string public name;
    uint public productCount = 0;
    uint public indexCount = 0;
    mapping(uint => Product) private products;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price
    );

    event ProductDeleted(
        uint id,
        string name,
        uint price
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address owner
    );

    constructor() {
        name = "Harmony Marketplace";
    }

    // Create product
    function createProduct(string memory _name, uint _price) public {
        // Require a valid name
        require(bytes(_name).length > 0);
        // Require a valid price
        require(_price > 0);
        // Increment product and index count
        productCount ++;
        indexCount ++;
        // Create the product
        products[indexCount] = Product(indexCount, _name, _price, payable(msg.sender), false);
        // Trigger an event
        emit ProductCreated(indexCount, _name, _price);
    }

    // Delete listed product
    function deleteProduct(uint _id) public {
        Product memory product = products[_id];
        // Require msg.sender to be product owner
        require(product.owner == msg.sender);
        // Decrement product count
        productCount --;
        // Delete the product
        delete products[_id];
        // Trigger an event
        emit ProductDeleted(_id, product.name, product.price);
    }

    // Purchase a listed Product
    function purchaseProduct(uint _id) public payable {
        // Fetch the product
        Product memory _product = products[_id];
        // Fetch the owner
        address payable _seller = _product.owner;
        // Make sure the product has a valid id
        require(_product.id > 0 && _product.id <= indexCount);
        // Require that there is enough Ether in the transaction
        require(msg.value >= _product.price);
        // Require that the product has not been purchased already
        require(!_product.purchased);
        // Require that the buyer is not the seller
        require(_seller != msg.sender);
        // Transfer ownership to the buyer
        _product.owner = payable(msg.sender);
        // Mark as purchased
        _product.purchased = true;
        // Update the product
        products[_id] = _product;
        // Pay the seller by sending them Ether
        payable(_seller).transfer(msg.value);
        // Trigger an event
        emit ProductPurchased(indexCount, _product.name, _product.price, msg.sender);
    }
    
    // Product Id to details
    function productDetails(uint _id) public view returns(string memory, uint, address, bool ){
        // Fetch the product
        Product memory _product = products[_id];
        string memory name = _product.name;
        uint price = _product.price;
        address owner = _product.owner;
        bool purchased = _product.purchased;
        // returns details
        return (name, price, owner, purchased);
        

    }

}