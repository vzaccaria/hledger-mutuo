{-# LANGUAGE DeriveDataTypeable #-}
{-# OPTIONS_GHC -fno-cse #-}

module Main where

import Control.Exception
import Data.Decimal
import Data.List (sortOn)
import qualified Data.Text as T
import Hledger.Data
import Hledger.Data.Journal
import Hledger.Mutuo.Config
import Hledger.Mutuo.FrenchMortgage
import Hledger.Query
import Hledger.Read
import Hledger.Utils
import System.Console.CmdArgs
import System.Environment
import System.Exit
import System.IO

showTransactions ts =
  mapM_ (putStr . T.unpack . showTransaction) (sortOn tdate ts)

opts =
  HledgerMutuo
  { file = "-" &= name "f" &= typ "FILE"
  , source = "" &= name "s" &= typ "ACCOUNT"
  , target = "" &= name "t" &= typ "ACCOUNT"
  , account = "" &= typ "ACCOUNT" &= args
  , annualRate = 0.0141 &= typ "RATE" &= help "Annual rate, 0.014 = 1.4%"
  , fixExpense = 4 &= typ "AMOUNT" &= help "Fixed expenses for each month"
  , mortgageMonthLength =
      239 &= typ "INTEGER" &= help "Mortgage length in months"
  } &=
  summary "hledger-mutuo v1"

main = do
  v <- cmdArgs opts
  runFrenchCompute v
