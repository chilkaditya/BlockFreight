// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CargoShippingContract {
    address public shipper;
    address public recipient;
    address public carrier;
    uint256 public departureTime;
    uint256 public arrivalTime;
    uint256 public cargoValue;
    enum CargoStatus { InTransit, Delivered, Received }
    CargoStatus public status;

    event CargoStatusChanged(CargoStatus newStatus);

    modifier onlyShipper() {
        require(msg.sender == shipper, "Only the shipper can call this function");
        _;
    }

    modifier onlyCarrier() {
        require(msg.sender == carrier, "Only the carrier can call this function");
        _;
    }

    modifier inTransit() {
        require(status == CargoStatus.InTransit, "Cargo must be in transit for this operation");
        _;
    }

    constructor(address _recipient, uint256 _cargoValue) {
        shipper = msg.sender;
        recipient = _recipient;
        cargoValue = _cargoValue;
        status = CargoStatus.InTransit;
        departureTime = block.timestamp;
        emit CargoStatusChanged(status);
    }

    function setCarrier(address _carrier) public onlyShipper {
        carrier = _carrier;
    }

    function updateArrivalTime(uint256 _arrivalTime) public onlyCarrier inTransit {
        arrivalTime = _arrivalTime;
    }

    function markDelivered() public onlyCarrier {
        status = CargoStatus.Delivered;
        emit CargoStatusChanged(status);
    }

    function markReceived() public {
        require(msg.sender == recipient, "Only the recipient can mark cargo as received");
        status = CargoStatus.Received;
        emit CargoStatusChanged(status);
    }
}
