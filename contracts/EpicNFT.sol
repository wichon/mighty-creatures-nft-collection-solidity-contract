// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";


contract EpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 constant MAX_NFTS_TO_MINT = 50;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string svgBase = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 450 350'>";
  string svgPayload = "<rect width='100%' height='100%' class='bg'/><text x='50%' y='50%' class='msg' dominant-baseline='middle' text-anchor='middle'>";
  string svgNftTokenIdLabelPrefix = "<style>.serie { font-family: 'Fira Code', monospace; font-size: 10px; fill: white;}</style><text x='95%' y='95%' class='serie' dominant-baseline='bottom' text-anchor='end'>Mighty Creature: ";
  // TODO: Decouple svg content and styles 
  string svgBgStyleLeft = "<style>.bg {";
  string svgBgStyleRight = "}</style>";
  string svgFontStyleLeft = "<style>.msg {";
  string svgFontStyleRight = "font-family: 'Fira Code', monospace; font-size: 24px; }</style>";
  

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["Mighty", "Worthy", "Fearless", "Brave", "Heroic", "Angry", "Sad", "Happy", "Curious", "Gorgeous", "Robust", "Potent", "Tough", "Polite", "Gentle"];
  string[] secondWords = ["Cat", "Dog", "Eagle", "Dolphin", "Shark", "Lion", "Tiger", "Pig", "Goat", "Orca", "Bat", "Rat", "Sloth", "Sheep", "Crab"];
  string[] thirdWords = ["OfDoom", "OfDarkness", "OfMisfortune", "OfSuffering", "OfWar", "OfSin", "OfEvil", "OfMisery", "OfAgony", "OfPlague", "FromSpace", "FromTheAbyss", "FromTheVoid", "FromTheDepths", "FromHell"];
  string[2][] backgroundAndFontColorPairs = [["#2a2c37", "#50fa7b"], ["#2c2122", "#ff9580"], ["#24202e", "#9580ff"], ["#2c2a21", "#ffff80"], ["#2a2c37", "#f2f2f2"]];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  uint256 private seed;

  constructor() ERC721 ("MightyRandomCreatures", "Mighty") {
    seed = block.timestamp + block.difficulty;
  }

  function buildNftTokenIdLabel() public view returns (string memory) {
    return string(abi.encodePacked(svgNftTokenIdLabelPrefix, Strings.toString(_tokenIds.current() + 1), "/", Strings.toString(MAX_NFTS_TO_MINT), "</text>"));
  }

  function pickSvgBgStyle() public view returns (string memory) {
    uint256 rand = random("BG_COLOR");
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % backgroundAndFontColorPairs.length;
    string memory color = backgroundAndFontColorPairs[rand][0];
    return string(abi.encodePacked(svgBgStyleLeft, " fill: ", color, "; ", svgBgStyleRight));
  }

  function pickSvgFontStyle() public view returns (string memory) {
    uint256 rand = random("BG_COLOR");
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % backgroundAndFontColorPairs.length;
    string memory color = backgroundAndFontColorPairs[rand][1];
    return string(abi.encodePacked(svgFontStyleLeft, " fill: ", color, "; ", svgFontStyleRight));
  }

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord() public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random("FIRST_WORD");
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord() public view returns (string memory) {
    uint256 rand = random("SECOND_WORD");
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord() public view returns (string memory) {
    uint256 rand = random("THIRD_WORD");
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal view returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input, seed)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    require(
      newItemId < (MAX_NFTS_TO_MINT - 1),
      "Max number of NFTs for this collection has been reached :(."
    );

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord();
    string memory second = pickRandomSecondWord();
    string memory third = pickRandomThirdWord();
    string memory combinedWord = string(abi.encodePacked(first, second, third));
    string memory svgBgStyle = pickSvgBgStyle();
    string memory svgFontStyle = pickSvgFontStyle();
    string memory svgNftTokenIdLabel = buildNftTokenIdLabel();

    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(svgBase, svgBgStyle, svgFontStyle, svgPayload, first, second, third, "</text>", svgNftTokenIdLabel, "</svg>"));
    console.log("\n---------- Generated SVG  ----------");
    console.log(finalSvg);
    console.log("--------------------\n");

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "Wichon`s cool collection of NFTs representing mighty random creatures!.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------- Encoded URI -----------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    // We'll be setting the tokenURI later!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();

    /*
      * Generate a new seed for the next user that sends a wave
      */
    seed = (block.difficulty + block.timestamp + seed + newItemId);

    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function getNumberOfMintedNFTs() public view returns (uint256) {
    return _tokenIds.current();
  }

  function getMaxNFTSToMint() public pure returns (uint256) {
    return MAX_NFTS_TO_MINT;
  }
}