import React, { Component } from "react";
import GatheringContract from "./contracts/Gathering.json";
import getWeb3 from "./utils/getWeb3";

import "./App.css";

class App extends Component {
    state = {
        user: null,
        userAddress: null,
        web3: null,
        accounts: null, 
        contract: null,
        contractAddress: null
    };

    componentDidMount = async () => {
        try {
        // Get network provider and web3 instance.
        const web3 = await getWeb3();

        // Use web3 to get the user's accounts.
        const accounts = await web3.eth.getAccounts();

        // Get the contract instance.
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = GatheringContract.networks[networkId];
        const instance = new web3.eth.Contract(
            GatheringContract.abi,
            deployedNetwork && deployedNetwork.address,
        );
        const contractAddress = instance.address;

        // Set web3, accounts, and contract to the state, and then proceed with an
        // example of interacting with the contract's methods.
        this.setState({ web3, accounts, contract: instance, contractAddress: contractAddress }, this.runApp);
        } catch (error) {
        // Catch any errors for any of the above operations.
        alert(
            `Failed to load web3, accounts, or contract. Check console for details.`,
        );
        console.error(error);
        }
    };

    runApp = async () => {
        const { accounts, contract } = this.state;

        // Stores a given value, 5 by default.
        // await contract.methods.set(5).send({ from: accounts[0] });
        await contract.methods.addUser(accounts[0], "User");

        // Get the value from the contract to prove it worked.
        // const response = await contract.methods.get().call();
        const currentUser = await contract.methods.users()[];
        const userAddress = accounts[0];

        // Update state with the result.
        // this.setState({ storageValue: response });
        this.setState({ user: currentUser, userAddress: userAddress});
    };

    render() {
        if (!this.state.web3) {
            return <div>Loading Web3, accounts, and contract...</div>;
        }

        return (
        <div className="App">
            <p>Contract Address: {this.state.contract}</p>
            <p>User Address: {this.state.userAddress}</p>
            <p>Username: {this.state.user[0]} </p>
            <h1>Gather</h1>
            <p>Where people come together</p>
            <h2>Start a Gathering</h2>
        </div>
        );
    }
}

export default App;
