const { assert } = require("chai");

let kleinContract
let kleinAddress = "0x88AE96845e157558ef59e9Ff90E766E22E480390"
let wrapperContract
let whaleOwnerAddress = "0x00d7e4903c6d88deeb29eecd9e7e853a31c46554"
let registryAddress = "0x0000000000000000000000000000000000000001"

async function impersonate(address){
  await network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [address]}
  )
}

async function stopImpersonate(address){
  await hre.network.provider.request({
    method: "hardhat_stopImpersonatingAccount",
    params: [address]}
  )
}

async function reset(){
  await network.provider.request({
    method: "hardhat_reset",
    params: [{
      forking: {
        jsonRpcUrl: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_KEY}`,
        blockNumber: 12063200
      }
    }]
  })
}

async function getwhaleOwner(edition){
  return (await kleinContract.records(edition)).addr
}

async function attachKlein(){
  const kleinContractAddress = "0x88AE96845e157558ef59e9Ff90E766E22E480390"
  const kleinArtifact = await artifacts.readArtifact("Klein");
  const Klein = new ethers.Contract(kleinContractAddress, kleinArtifact.abi, await getDefaultProvider());
  kleinContract = Klein.attach(kleinContractAddress)
}

async function deployWrapper(){
  const WrappedIKB = await ethers.getContractFactory("WrappedIKB");
  wrapperContract = await WrappedIKB.deploy(kleinAddress, registryAddress);
}

async function getDefaultProvider(){
  return (await getDefaultSigner()).provider
}

async function getDefaultSigner(){
  return (await ethers.getSigners())[0]
}

async function getSigner(address){
  const balance = await hre.ethers.provider.getBalance(address)

  const oneEth = hre.ethers.utils.parseEther("1")

  if (balance.lt(oneEth)){
    await (await ethers.getSigners())[0].sendTransaction({
      to: address,
      value: ethers.utils.parseEther("2")
    })
  }

  return await hre.ethers.provider.getSigner(address)
}

function toNumber(BN){
  return BN.toNumber()
}

beforeEach(function(done){
  reset()
  .then(attachKlein)
  .then(deployWrapper)
  .then(()=>impersonate(whaleOwnerAddress)).then(done)
})


describe("IKB Wrapper", function() {
  describe("wrapAll", function(){
    it("should mint new NFTs for each owned record if all approved", async function() {
      this.timeout(300000)
      const whaleOwner = await getSigner(whaleOwnerAddress)
      const editions = (await kleinContract.getHolderEditions(whaleOwnerAddress)).map(toNumber)
      assert.equal(editions.length, 10, 'Test did not reset correctly')

      // Wrapper does not have minted editions
      for (let edition of editions){
        try {
          await wrapperContract.ownerOf(edition)
          throw new Error(`Wrapper has edition ${edition} minted`)
        } catch(e){
          assert(/owner query for nonexistent token/.test(e.message),`Incorrect error. Got ${e.message}`)
        }
      }

      assert.equal(toNumber(await wrapperContract.balanceOf(whaleOwnerAddress)), 0, 'Wrapper did not properly reset')

      try {
        await wrapperContract.connect(whaleOwner).wrapAll()
        throw new Error('Wrapper expected to throw before approval')
      } catch(e){
        assert(/must approve all IKB tokens to be transfered/.test(e.message),`Incorrect error. Got ${e.message}`)
      }

      await kleinContract.connect(whaleOwner).approve(wrapperContract.address, editions.length)
      await wrapperContract.connect(whaleOwner).wrapAll()

      assert.equal(toNumber(await wrapperContract.balanceOf(whaleOwnerAddress)), editions.length, 'Wrapper did not mint correct number of tokens')
      assert.equal(toNumber(await kleinContract.balanceOf(whaleOwnerAddress)), 0, 'Klein did clear additions for record owner')
      assert.equal(toNumber(await kleinContract.balanceOf(wrapperContract.address)), editions.length, 'Klein did not assign all editions to wrapper contract')

      for (let edition of editions){
        assert.equal((await wrapperContract.ownerOf(editions[0])).toLowerCase(), whaleOwnerAddress.toLowerCase(), 'Wrapper did not mint correctly')
        assert.equal((await kleinContract.records(edition)).addr.toLowerCase(), wrapperContract.address.toLowerCase(), 'Klein did not assign edition ownership to Wrapper')
      }
    });
  })

  describe("wrapSpecific", function(){
    it("should mint specific approved NFTS", async function(){
      this.timeout(300000)
      const whaleOwner = await getSigner(whaleOwnerAddress)

      const allEditions = (await kleinContract.getHolderEditions(whaleOwnerAddress)).map(toNumber)
      const specificEdition = allEditions[0]

      assert.equal(allEditions.length, 10, 'Test did not reset correctly')

      await kleinContract.connect(whaleOwner).specificApprove(wrapperContract.address, specificEdition)

      await wrapperContract.connect(whaleOwner).wrapSpecific(specificEdition)

      assert.equal(toNumber(await wrapperContract.balanceOf(whaleOwnerAddress)), 1, 'Wrapper did not mint correct number of tokens')

      assert.equal(toNumber(await kleinContract.balanceOf(whaleOwnerAddress)), allEditions.length-1, 'Klein did clear additions for record owner')

      assert.equal(toNumber(await kleinContract.balanceOf(wrapperContract.address)), 1, 'Klein did not assign all editions to wrapper contract')

      assert.equal((await wrapperContract.ownerOf(specificEdition)).toLowerCase(), whaleOwnerAddress.toLowerCase(), 'Wrapper did not mint correctly')

      assert.equal((await kleinContract.records(specificEdition)).addr.toLowerCase(), wrapperContract.address.toLowerCase(), 'Klein did not assign edition ownership to Wrapper')
    })
  })

  describe("unwrapAll", function(){
     it("should transfer back and burn all tokens", async function(){

       // Setup
       this.timeout(300000)

       const whaleOwner = await getSigner(whaleOwnerAddress)
       const editions = (await kleinContract.getHolderEditions(whaleOwnerAddress)).map(toNumber)

       assert.equal(editions.length, 10, 'Test did not reset correctly')

       await kleinContract.connect(whaleOwner).approve(wrapperContract.address, editions.length)

       await wrapperContract.connect(whaleOwner).wrapAll()

       assert.equal(toNumber(await kleinContract.balanceOf(wrapperContract.address)), editions.length, 'Klein did not assign all editions to wrapper contract')

       await wrapperContract.connect(whaleOwner).unwrapAll()

       // Tests

      assert.equal(toNumber(await wrapperContract.balanceOf(whaleOwnerAddress)), 0, 'Wrapper did not burn correct number of tokens')
      assert.equal(toNumber(await kleinContract.balanceOf(whaleOwnerAddress)), editions.length, 'Klein did clear additions for record owner')
      assert.equal(toNumber(await kleinContract.balanceOf(wrapperContract.address)), 0, 'Klein did not assign all editions away from wrapper contract')

      for (let edition of editions){
        try {
          await wrapperContract.ownerOf(editions)
          assert.fail('Wrapper contract did not burn correctly')
        } catch(e){
          assert(/owner query for nonexistent token/.test(e.message),`Incorrect error. Got ${e.message}`)
        }

        assert.equal((await kleinContract.records(edition)).addr.toLowerCase(), whaleOwnerAddress.toLowerCase(), 'Klein did not assign edition ownership to Wrapper')
      }

      })
  })

  describe("unwrapSpecific", function(){
     it("should transfer back and burn specific tokens after wrap all", async function(){

       // Setup
       this.timeout(300000)

       const whaleOwner = await getSigner(whaleOwnerAddress)
       const allEditions = (await kleinContract.getHolderEditions(whaleOwnerAddress)).map(toNumber)
       const specificEdition = allEditions[0]

       assert.equal(allEditions.length, 10, 'Test did not reset correctly')

       await kleinContract.connect(whaleOwner).approve(wrapperContract.address, allEditions.length)

       await wrapperContract.connect(whaleOwner).wrapAll()

       assert.equal(toNumber(await kleinContract.balanceOf(wrapperContract.address)), allEditions.length, 'Klein did not assign all editions to wrapper contract')

       await wrapperContract.connect(whaleOwner).unwrapSpecific(specificEdition)

        // Tests

        assert.equal(toNumber(await wrapperContract.balanceOf(whaleOwnerAddress)), allEditions.length - 1, 'Wrapper did not burn correct number of tokens')
        assert.equal(toNumber(await kleinContract.balanceOf(whaleOwnerAddress)), 1, 'Klein did clear additions for record owner')
        assert.equal(toNumber(await kleinContract.balanceOf(wrapperContract.address)), allEditions.length - 1, 'Klein did not assign all editions away from wrapper contract')

        try {
          await wrapperContract.ownerOf(specificEdition)
          assert.fail('Wrapper contract did not burn correctly')
        } catch(e){
          assert(/owner query for nonexistent token/.test(e.message),`Incorrect error. Got ${e.message}`)
        }

        assert.equal((await kleinContract.records(specificEdition)).addr.toLowerCase(), whaleOwnerAddress.toLowerCase(), 'Klein did not assign edition ownership to Wrapper')

     })
     it("should transfer back and burn specific tokens after wrap specific", async function(){

       // Setup
       this.timeout(300000)

       const whaleOwner = await getSigner(whaleOwnerAddress)
       const allEditions = (await kleinContract.getHolderEditions(whaleOwnerAddress)).map(toNumber)
       const specificEdition = allEditions[allEditions.length-1] // last one just to test

       assert.equal(allEditions.length, 10, 'Test did not reset correctly')

       await kleinContract.connect(whaleOwner).specificApprove(wrapperContract.address, specificEdition)

       await wrapperContract.connect(whaleOwner).wrapSpecific(specificEdition)

       assert.equal(toNumber(await kleinContract.balanceOf(wrapperContract.address)), 1, 'Klein did not assign all editions to wrapper contract')

       await wrapperContract.connect(whaleOwner).unwrapSpecific(specificEdition)


        // Tests

        assert.equal(toNumber(await wrapperContract.balanceOf(whaleOwnerAddress)), 0, 'Wrapper did not burn correct number of tokens')
        assert.equal(toNumber(await kleinContract.balanceOf(whaleOwnerAddress)), allEditions.length, 'Klein did clear additions for record owner')
        assert.equal(toNumber(await kleinContract.balanceOf(wrapperContract.address)), 0, 'Klein did not assign all editions away from wrapper contract')

        try {
          await wrapperContract.ownerOf(specificEdition)
          assert.fail('Wrapper contract did not burn correctly')
        } catch(e){
          assert(/owner query for nonexistent token/.test(e.message),`Incorrect error. Got ${e.message}`)
        }

        assert.equal((await kleinContract.records(specificEdition)).addr.toLowerCase(), whaleOwnerAddress.toLowerCase(), 'Klein did not assign edition ownership to Wrapper')

     })
  })

  describe("setTokenURI", function(){
    const TOKENURI = "ABC"
    describe('when tokenURI is 0 and not set and called by owner', function(){
      it('should work', async function(){
        await wrapperContract.setTokenUri(0, TOKENURI)
        assert.equal( await wrapperContract.tokenURIs(0), TOKENURI)
      })
    })
    describe('when tokenURI is sequential and not set and called by owner', function(){
      it('should work', async function(){
        await wrapperContract.setTokenUri(0, TOKENURI)
        await wrapperContract.setTokenUri(1, TOKENURI)
        assert.equal( await wrapperContract.tokenURIs(1), TOKENURI)
      })
    })
    describe('when tokenURI is set', function(){
      it('should fail', async function(){
        await wrapperContract.setTokenUri(0, TOKENURI)
        try {
          await wrapperContract.setTokenUri(0, TOKENURI)
        } catch(e){
          assert(/already been set/.test(e.message),`Incorrect error. Got ${e.message}`)
          return
        }
        assert.fail('Wrapper contract should have thrown')
      })
    })

    describe('when tokenURI is not sequential', function(){
      it('should fail', async function(){
        try {
          await wrapperContract.setTokenUri(22, TOKENURI)
        } catch(e){
          assert(/sequentially/.test(e.message),`Incorrect error. Got ${e.message}`)
          return
        }

        assert.fail('Wrapper contract should have thrown')
      })
    })

    describe('when not called by owner', function(){
      it('should fail', async function(){
        try {
          await wrapperContract.connect(await getSigner(whaleOwnerAddress)).setTokenUri(0, TOKENURI)
        } catch(e){
          assert(/caller is not the owner/.test(e.message),`Incorrect error. Got ${e.message}`)
          return
        }
        assert.fail('Wrapper contract should have thrown')
      })
    })
  })

  describe("setTokenURIs", function(){
    const TOKENURIS = ["ABC","DEF"]
    describe('when tokenURI is 0 and not set and called by owner', function(){
      it('should work', async function(){
        await wrapperContract.setTokenURIs([0], [TOKENURIS[0]])
        assert.equal( await wrapperContract.tokenURIs(0), TOKENURIS[0])
      })
    })
    describe('when tokenURIs are sequential and not set and called by owner', function(){
      it('should work', async function(){
        await wrapperContract.setTokenURIs([0], [TOKENURIS[0]])
        await wrapperContract.setTokenURIs([1,2], TOKENURIS)
        assert.equal( await wrapperContract.tokenURIs(1), TOKENURIS[0])
        assert.equal( await wrapperContract.tokenURIs(2), TOKENURIS[1])
      })
    })
    describe('when tokenURI is set', function(){
      it('should fail', async function(){
        await wrapperContract.setTokenURIs([0], [TOKENURIS[0]])
        try {
          await wrapperContract.setTokenURIs([0], [TOKENURIS[0]])
        } catch(e){
          assert(/already been set/.test(e.message),`Incorrect error. Got ${e.message}`)
          return
        }
        assert.fail('Wrapper contract should have thrown')
      })
    })

    describe('when tokenURI is not sequential', function(){
      it('should fail', async function(){
        try {
          await wrapperContract.setTokenURIs([11,12], TOKENURIS)
        } catch(e){
          assert(/sequentially/.test(e.message),`Incorrect error. Got ${e.message}`)
          return
        }

        assert.fail('Wrapper contract should have thrown')
      })
    })

    describe('when not called by owner', function(){
      it('should fail', async function(){
        try {
          await wrapperContract.connect(await getSigner(whaleOwnerAddress)).setTokenURIs([0,1], TOKENURIS)
        } catch(e){
          assert(/caller is not the owner/.test(e.message),`Incorrect error. Got ${e.message}`)
          return
        }
        assert.fail('Wrapper contract should have thrown')
      })
    })
  })

  describe("setContractURI", function(){
    const CONTRACTURI = "ABC"
    describe('when not called by owner', function(){
      it('should fail', async function(){
        try {
          await wrapperContract.connect(await getSigner(whaleOwnerAddress)).setContractURI(CONTRACTURI)
        } catch(e){
          assert(/caller is not the owner/.test(e.message),`Incorrect error. Got ${e.message}`)
          return
        }
        assert.fail('Wrapper contract should have thrown')
      })
    })
    describe('when called by the owner', function(){
      describe('when passed in contractURI is empty', function(){
        it('should fail', async function(){
          try {
            await wrapperContract.setContractURI("")
          } catch(e){
            assert(/new contractURI string cannot be blank/.test(e.message),`Incorrect error. Got ${e.message}`)
            return
          }
          assert.fail('Wrapper contract should have thrown')
        })
      })
      describe('when contractURI is not set', function(){
        it('should work', async function(){
          await wrapperContract.setContractURI(CONTRACTURI)
          assert.equal( await wrapperContract.contractURI(), CONTRACTURI)
        })
      })
      describe('when passed in contractURI is not empty', function(){
        it('should fail', async function(){
          await wrapperContract.setContractURI(CONTRACTURI)
          try {
            await wrapperContract.setContractURI(CONTRACTURI)
          } catch(e){
            assert(/contractURI already set/.test(e.message),`Incorrect error. Got ${e.message}`)
            return
          }
          assert.fail('Wrapper contract should have thrown')
        })
      })
    })
  })
});