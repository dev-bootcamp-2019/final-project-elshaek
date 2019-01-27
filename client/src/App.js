import React, { Component } from "react";
import GatherContract from "./contracts/Gather.json";
import getWeb3 from "./utils/getWeb3";

import "./App.css";

class App extends Component {
    state = {
        storageValue: 0,
        web3: null,
        accounts: null,
        contract: null,
        contractAddress: null,
        gatheringCount: 0
    };

    componentDidMount = async () => {
        try {
            // Get network provider and web3 instance.
            const web3 = await getWeb3();

            // Use web3 to get the user's accounts.
            const accounts = await web3.eth.getAccounts();

            // Get the contract instance.
            const networkId = await web3.eth.net.getId();
            const deployedNetwork = GatherContract.networks[networkId];
            const instance = new web3.eth.Contract(
                GatherContract.abi,
                deployedNetwork && deployedNetwork.address
            );
            const contractAddress = instance.options.address;

            // Set web3, accounts, and contract to the state, and then proceed with an
            // example of interacting with the contract's methods.

            this.setState({ web3, accounts, contract: instance, contractAddress: contractAddress, userAddress: accounts[0]}, this.runApp);
        } catch (error) {
        // Catch any errors for any of the above operations.
            alert(
                `Failed to load web3, accounts, or contract. Check console for details.`,
            );
            console.error(error);
        }
    };

    runApp = async () => {
        const { accounts, contract, contractAddress, userAddress } = this.state;

        // let gatheringCount = contract.methods.users(userAddress).send({ from: userAddress })[2];

        await contract.methods.addUser(accounts[0], "User").send({ from: userAddress });
        

        // Stores a given value, 5 by default.
        // await contract.methods.set(5).send({ from: accounts[0] });

        // Get the value from the contract to prove it worked.
        // const response = await contract.methods.get().call();

        // Update state with the result.
        // this.setState({ storageValue: response });
        // this.setState({ contractAddress: contractAddress, userAddress: userAddress, gatheringCount: gatheringCount });
        this.setState({ contractAddress: contractAddress, userAddress: userAddress });
    };

    handleAddGathering() {
        const contract = this.state.contract;
        const account = this.state.accounts[0];
        
        contract.methods.organizeNewGathering("New Gathering").send({ from: account })
        .then(result => {
            return this.setState({ gatheringCount: result.events.LogNewGathering.returnValues[0] })
        });   
    }

    render() {
        if (!this.state.web3) {
            return <div>Loading Web3, accounts, and contract...</div>;
        }
        return (
        <div className="App">
            <p>Contract Address: {this.state.contractAddress}</p>
            <p>User Address: {this.state.userAddress}</p>
            <h1>Gather</h1>
            <p>Where people come together</p>
            <h2>My Gatherings: {this.state.gatheringCount} gatherings organized</h2>
            <button onClick={this.handleAddGathering.bind(this)}>Add gathering</button>
        </div>
        );
    }
}

export default App;
