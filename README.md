<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
***
***
*** To avoid retyping too much info. Do a search and replace for the following:
*** vzaccaria, hledger-mutuo, twitter_handle, email, hledger-mutuo, Compute french-style mortgage payment rates
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!--[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url] [![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]-->

<!-- PROJECT LOGO -->
<br />
<p align="center">

  <h3 align="center">hledger-mutuo</h3>

  <p align="center">
    Compute french-style mortgage payment interest rates
    <br />
    <a href="https://github.com/vzaccaria/hledger-mutuo"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/vzaccaria/hledger-mutuo">View Demo</a>
    ·
    <a href="https://github.com/vzaccaria/hledger-mutuo/issues">Report Bug</a>
    ·
    <a href="https://github.com/vzaccaria/hledger-mutuo/issues">Request Feature</a>
  </p>
</p>

<!-- ABOUT THE PROJECT -->

## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com) -->

Just as [hledger-interest](https://hackage.haskell.org/package/hledger-interest), computes interests associated with a french-style fixed-rate mortgage (one of the most used schemes in Italy).


### Built With

- [Hledger-lib](https://hackage.haskell.org/package/hledger)

<!-- GETTING STARTED -->

## Getting Started

To get a local copy up and running follow these simple steps.

### Installation

1. Clone the repo

   ```sh
   git clone https://github.com/vzaccaria/hledger-mutuo.git
   ```
2. Install it with stack 

   ```sh
   stack install .
   ```

<!-- USAGE EXAMPLES -->

## Usage

Assume you have the following ledger file (`test.ledger`):

```ledger
2019-04-17 Mortgage start
    assets:banca          EUR1000
    liabilities:mutuo    

2019-04-01 Mortgage payment 
    assets:banca            EUR-5.06
    liabilities:mutuo       

2019-05-04 Mortgage payment 
    assets:banca:popso      EUR-5.06
    liabilities:mutuo
```

To compute the interest associated with the rates (2% annual rate over 20 years) run:

```
hledger-mutuo -f ./test.ledger -s expenses:mutuo -t liabilities:mutuo liabilities:mutuo -a 0.02 -m 240
```

to produce the following transactions:

```ledger
2020-04-01 Mortgage payment interest n.  1 (capital = 3.39)
    liabilities:mutuo        EUR-1.67
    expenses:mutuo            EUR1.67

2020-05-04 Mortgage payment interest n.  2 (capital = 3.40)
    liabilities:mutuo        EUR-1.66
    expenses:mutuo            EUR1.66
```

Note that with the french scheme you'll pay interest upfront.

## Contributing

Contributions are what make the open source community such an amazing place to
be learn, inspire, and create. Any contributions you make are **greatly
appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- CONTACT -->

## Contact

Vittorio Zaccaria - [@_vzaccaria_](https://twitter.com/_vzaccaria_) - vittorio.zaccaria@gmail.com

Project Link:
[https://github.com/vzaccaria/hledger-mutuo](https://github.com/vzaccaria/hledger-mutuo)

<!-- ACKNOWLEDGEMENTS -->

## Acknowledgements

- You?


<!--<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]:
  https://img.shields.io/github/contributors/vzaccaria/repo.svg?style=for-the-badge
[contributors-url]: https://github.com/vzaccaria/repo/graphs/contributors
[forks-shield]:
  https://img.shields.io/github/forks/vzaccaria/repo.svg?style=for-the-badge
[forks-url]: https://github.com/vzaccaria/repo/network/members
[stars-shield]:
  https://img.shields.io/github/stars/vzaccaria/repo.svg?style=for-the-badge
[stars-url]: https://github.com/vzaccaria/repo/stargazers
[issues-shield]:
  https://img.shields.io/github/issues/vzaccaria/repo.svg?style=for-the-badge
[issues-url]: https://github.com/vzaccaria/repo/issues
[license-shield]:
  https://img.shields.io/github/license/vzaccaria/repo.svg?style=for-the-badge
[license-url]: https://github.com/vzaccaria/repo/blob/master/LICENSE.txt
[linkedin-shield]:
  https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/vzaccaria-->
