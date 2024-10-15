async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
  
    const MyToken = await ethers.getContractFactory("MyToken");
    const myToken = await MyToken.deploy(ethers.parseEther("1000"));
    console.log("MyToken deployed to:", myToken.target);


    const TweetHandler = await ethers.getContractFactory("TweetHandler");
    const tweetHandler = await TweetHandler.deploy(myToken.target);
    console.log("TweetHandler deployed to:", tweetHandler.target);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
