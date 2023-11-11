// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShippingContract {
    address public buyer;
    address public seller;
    bool public isShipped;
    string public trackingNumber;
    uint256 public deliveryDeadline;
    uint256 public refundDeadline;
    uint256 public refundFeePercentage;
    uint256 public shippingFee;
    uint256 public minPrice;

    enum State { AWAITING_PAYMENT, AWAITING_SHIPMENT, SHIPPED, COMPLETE, REFUNDED }

    State public state;

    event ItemPurchased(address indexed _buyer, uint256 _amount);
    event ItemShipped(address indexed _seller, string _trackingNumber);
    event ItemReceived(address indexed _buyer);
    event RefundRequested(address indexed _buyer);
    event RefundProcessed(address indexed _buyer);

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can call this function");
        _;
    }

    modifier inState(State _state) {
        require(state == _state, "Invalid state transition");
        _;
    }

    constructor(
        address _seller,
        uint256 _deliveryDeadline,
        uint256 _refundDeadline,
        uint256 _refundFeePercentage,
        uint256 _shippingFee,
        uint256 _minPrice
    ) {
        buyer = msg.sender;
        seller = _seller;
        isShipped = false;
        state = State.AWAITING_PAYMENT;
        deliveryDeadline = _deliveryDeadline;
        refundDeadline = _refundDeadline;
        refundFeePercentage = _refundFeePercentage;
        shippingFee = _shippingFee;
        minPrice = _minPrice;
    }

    function purchaseItem() external payable inState(State.AWAITING_PAYMENT) {
        require(msg.value >= minPrice, "Payment must be greater than or equal to the minimum price");
        uint256 totalPrice = msg.value + shippingFee;
        uint256 refundFee = (totalPrice * refundFeePercentage) / 100;

        state = State.AWAITING_SHIPMENT;
        emit ItemPurchased(msg.sender, totalPrice);

        // Deduct refund fee and transfer the remaining amount to the seller
        uint256 amountToSeller = totalPrice - refundFee;
        payable(seller).transfer(amountToSeller);
    }

    function shipItem(string memory _trackingNumber) external onlySeller inState(State.AWAITING_SHIPMENT) {
        isShipped = true;
        trackingNumber = _trackingNumber;
        state = State.SHIPPED;
        emit ItemShipped(msg.sender, _trackingNumber);
    }

    function confirmReceived() external onlyBuyer inState(State.SHIPPED) {
        state = State.COMPLETE;
        emit ItemReceived(msg.sender);
    }

    function requestRefund() external onlyBuyer inState(State.AWAITING_SHIPMENT) {
        require(block.timestamp <= refundDeadline, "Refund request period has ended");

        // Calculate and deduct refund fee
        uint256 refundAmount = address(this).balance;
        uint256 refundFee = (refundAmount * refundFeePercentage) / 100;

        // Transfer the remaining amount to the buyer
        payable(buyer).transfer(refundAmount - refundFee);

        state = State.REFUNDED;
        emit RefundRequested(msg.sender);
    }

    function processRefund() external onlySeller inState(State.REFUNDED) {
        emit RefundProcessed(buyer);
    }
}
