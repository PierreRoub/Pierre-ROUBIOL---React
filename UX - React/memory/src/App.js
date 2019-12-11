import React, {useState} from 'react';
import { Web3Provider } from 'react-web3';
//import web3 from 'web3';
import logo from './logo.svg';
import './App.css';
import ReactDOM from 'react-dom';
import Ranch2 from './Ranch/build/contracts/Ranch.json';
import Ranch from './Ranch/contracts/Ranch.sol';
import PropTypes from 'prop-types';

 function SomeComponent(props, context) {
 // const web3Context = context.web3;
  const ethereum = window.ethereum;
  const[addr, setAddr]= useState('')
  //const Ranch = window.Ranch;
  //const web3 = new web3 (web3.givenProvider || "http://localhost:8545");
  //const chainId = web3.eth.getChainId();

  if (ethereum) {
    ethereum.on('accountsChanged', function(accounts) {
      setAddr(accounts[0])
    })
  }

  return (
    <div>
      Hello Web3
      <header className="App-header">
        Your Ethereum address: {addr}

        
      </header>
    </div>
  );
}

SomeComponent.contextTypes = {
  web3: PropTypes.object
};

export default SomeComponent;

ReactDOM.render(
  <Web3Provider>
  <SomeComponent/>
  </Web3Provider>,
  document.getElementById('root'));


/*function App() {
  return (
    
    <div className="App">
      <header className="App-header">
        Test: 
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
          
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
      
    </div>
  );
}

export default App;*/
