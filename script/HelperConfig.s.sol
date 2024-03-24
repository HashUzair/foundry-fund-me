// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MocksV3Aggregator.sol";


contract HelperConfig is Script{

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

struct NetworkConfig { 
    address priceFeed;  // ETH/USD price feed address
} 
    constructor() { 
        if (block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }else if (block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        }
        else {
            activeNetworkConfig = get0CreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory){
        //price feed address
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }

    function get0CreateAnvilEthConfig() public returns (NetworkConfig memory){
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAL, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}

