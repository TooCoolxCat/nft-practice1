    import { Contract, providers, utils } from "ethers";
    import Head from "next/head";
    import React, { useEffect, useRef, useState } from "react";
    import Web3Modal from "web3modal";
    import { abi, NFT_CONTRACT_ADDRESS } from "../constants";
    import styles from "../styles/Home.module.css";

    export default function Home() {
      // walletConnected keep track of whether the user's wallet is connected or not
      const [walletConnected, setWalletConnected] = useState(false);
      // get wallet address
      const [address, setAddress] = useState("0");
      // loading is set to true when we are waiting for a transaction to get mined
      const [loading, setLoading] = useState(false);
      
      const [whitelistMintStarted, setWhitelistMintStarted] = useState(false);
      const [whitelistMintEnded, setWhitelistMintEnded] = useState(false);

      // tokenIdsMinted keeps track of the number of tokenIds that have been minted
      const [tokenIdsMinted, setTokenIdsMinted] = useState("0"); 
      // Create a reference to the Web3 Modal (used for connecting to Metamask) which persists as long as the page is open
      const web3ModalRef = useRef();

      /**
       * presaleMint: FashionList Mint an NFT 
       */

      const presaleMint = async () => {
        try {
          console.log("Presale mint");
          const signer = await getProviderOrSigner(true);
          // Get the address associated to the signer which is connected to  MetaMask
          const address = await signer.getAddress();
          const merkleProof = merkleTree.getHexProof(address);

          const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, signer);
          const tx = await nftContract.whitelistMint(merkleProof)(   
            {
            // value signifies the cost of one LW3Punks which is "0.01" eth.
            // We are parsing `0.01` string to ether using the utils library from ethers.js
            value: utils.parseEther("0.00"),    
          }
          );

          setLoading(true);
          // wait for the transaction to get mined
          await tx.wait();
          setLoading(false);
          window.alert("You successfully minted a TooCool Dolander!");
        }
        catch (err) {
          console.error(err);
        }
      };
      /**
       * publicMint: Mint an NFT
       */
      const publicMint = async () => {
        try {
          console.log("Public mint");
          // We need a Signer here since this is a 'write' transaction.
          const signer = await getProviderOrSigner(true);
          // Create a new instance of the Contract with a Signer, which allows
          // update methods
          const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, signer);
          // call the mint from the contract to mint the LW3Punks
          const tx = await nftContract.whitelistMint({
            // value signifies the cost of one LW3Punks which is "0.01" eth.
            // We are parsing `0.01` string to ether using the utils library from ethers.js
            value: utils.parseEther("0.01"),
          });
          setLoading(true);
          // wait for the transaction to get mined
          await tx.wait();
          setLoading(false);
          window.alert("You successfully minted a TooCool Dolander!");
        } catch (err) {
          console.error(err);
        }
      };

      /*
        connectWallet: Connects the MetaMask wallet
      */
      const connectWallet = async () => {
        try {
          // Get the provider from web3Modal, which in our case is MetaMask
          // When used for the first time, it prompts the user to connect their wallet
          await getProviderOrSigner();
          setWalletConnected(true);
         
        } catch (err) {
          console.error(err);
        }
      };
  
      /**
       * getTokenIdsMinted: gets the number of tokenIds that have been minted
       */
      const getTokenIdsMinted = async () => {
        try {
          // Get the provider from web3Modal, which in our case is MetaMask
          // No need for the Signer here, as we are only reading state from the blockchain
          const provider = await getProviderOrSigner();
          // We connect to the Contract using a Provider, so we will only
          // have read-only access to the Contract
          const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, provider);
          // call the tokenIds from the contract
          const _tokenIds = await nftContract.tokenIds();
          console.log("tokenIds", _tokenIds);
          //_tokenIds is a `Big Number`. We need to convert the Big Number to a string
          setTokenIdsMinted(_tokenIds.toString());
        } catch (err) {
          console.error(err);
        }
      };

      const checkIfPresaleStarted = async () => {
        try {
          const provider = await getProviderOrSigner();

          const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, provider);

          const _whitelistMintStarted = await nftContract.whitelistMintStarted();
          //_whitelistMintedStarted = false then do the following
          if (!_whitelistMintStarted){
            console.log(_whitelistMintStarted);
            window.alert("Presale has not started yet");
          }      
        } catch (err) {
          console.error(err);
        }
      };

      const checkIfPresaleEnded = async () => {
        try {
          const provider = await getProviderOrSigner();

          const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, provider);

          const _whitelistMintEnded = await nftContract.whitelistMintEnded();
          //_whitelistMintedEnded = true then do the following
          if (_whitelistMintEnded){
            window.alert("Presale has ended");
          }      
        } catch (err) {
          console.error(err);
        }
      };

      /**
       * Returns a Provider or Signer object representing the Ethereum RPC with or without the
       * signing capabilities of metamask attached
       *
       * A `Provider` is needed to interact with the blockchain - reading transactions, reading balances, reading state, etc.
       *
       * A `Signer` is a special type of Provider used in case a `write` transaction needs to be made to the blockchain, which involves the connected account
       * needing to make a digital signature to authorize the transaction being sent. Metamask exposes a Signer API to allow your website to
       * request signatures from the user using Signer functions.
       *
       * @param {*} needSigner - True if you need the signer, default false otherwise
       */
      const getProviderOrSigner = async (needSigner = false) => {
        // Connect to Metamask
        // Since we store `web3Modal` as a reference, we need to access the `current` value to get access to the underlying object
        const provider = await web3ModalRef.current.connect();
        const web3Provider = new providers.Web3Provider(provider);

        // If user is not connected to the Mumbai network, let them know and throw an error
        const { chainId } = await web3Provider.getNetwork();
        if (chainId !== 4) {
          window.alert("Change the network to Rinkeby");
          throw new Error("Change network to Rinkeby");
        }

        if (needSigner) {
          const signer = web3Provider.getSigner();
          return signer;
        }
        return web3Provider;
      };

      // useEffects are used to react to changes in state of the website
      // The array at the end of function call represents what state changes will trigger this effect
      // In this case, whenever the value of `walletConnected` changes - this effect will be called
      useEffect(() => {
        // if wallet is not connected, create a new instance of Web3Modal and connect the MetaMask wallet
        if (!walletConnected) {
          // Assign the Web3Modal class to the reference object by setting it's `current` value
          // The `current` value is persisted throughout as long as this page is open
          web3ModalRef.current = new Web3Modal({
            network: "Rinkeby",
            providerOptions: {},
            disableInjectedProvider: false,
          });

          connectWallet();

           // Check if presale has started and ended
          const _whitelistMintStarted = checkIfPresaleStarted();
          // if started = false, then check if it has ended
          if (!_whitelistMintStarted) {
            checkIfPresaleEnded();
          }
          else if (_whitelistMintStarted){
            getOwner();
          }

          getTokenIdsMinted();


          //end of merkle tree
          // set an interval to get the number of token Ids minted every 5 seconds
          setInterval(async function () {
            await getTokenIdsMinted();
          }, 5 * 1000);
        }
      }, [walletConnected]);

      /*
        renderButton: Returns a button based on the state of the dapp
      */
      const renderButton = () => {
        // If wallet is not connected, return a button which allows them to connect their wallet
        if (!walletConnected) {
          return (
            <button onClick={connectWallet} className={styles.button}>
              Connect your wallet
            </button>
          );
        }

        // If connected user is not the owner but presale hasn't started yet, tell them that
        // if whitelistMintStarted = false
        if (!whitelistMintStarted) {
          return (
            <div>
              <div className={styles.description}>Presale hasnt started!</div>
            </div>
          );
        }

         // If presale started, but hasn't ended yet, allow for minting during the presale period
         // if started = true, ended = false, then presale mint
        if (whitelistMintStarted && !whitelistMintEnded) {
          return (
            <div>
              <div className={styles.description}>
                Presale has started!!! If your address is whitelisted, Mint a TooCool Dolander 🥳
              </div>
              <button className={styles.button} onClick={presaleMint}>
                Presale Mint 🚀
              </button>
            </div>
          );
        }

        // If presale started and has ended, its time for public minting
        // if started = true ended =true , then public mint
        if (whitelistMintStarted && whitelistMintEnded) {
          return (
            <button className={styles.button} onClick={publicMint}>
              Public Mint 🚀
            </button>
          );
        }

        // If we are currently waiting for something, return a loading button
        if (loading) {
          return <button className={styles.button}>Loading...</button>;
        }
        

        return (
          <button className={styles.button} onClick={publicMint}>
            Wanna be TooCool? 
          </button>
        );
      };

      return (
        <div>
          <Head>
            <title>TooCool Dolander</title>
            <meta name="description" content="TooCool Dolander-Dapp" />
            <link rel="icon" href="/favicon.ico" />
          </Head>
          <div className={styles.main}>
            <div>
              <h1 className={styles.title}>TooCool Dolander!</h1>
              <div className={styles.description}>
                Its an NFT collection on Ethereum.
              </div>
              <div className={styles.description}>
                {tokenIdsMinted}/333 have been minted
              </div>
              {renderButton()}
            </div>
            <div>
              {/* <img className={styles.image} src="./LW3punks/1.png" /> */}
            </div>
          </div>

          <footer className={styles.footer}>Made with &#10084;</footer>
        </div>
      );
    }