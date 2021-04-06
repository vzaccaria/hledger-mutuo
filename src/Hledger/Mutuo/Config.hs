{-# LANGUAGE DeriveDataTypeable #-}
{-# OPTIONS_GHC -fno-cse #-}

module Hledger.Mutuo.Config where

import Data.Decimal
import Hledger.Data
import Hledger.Data.Journal
import Hledger.Query
import Hledger.Read
import Hledger.Utils
import System.Console.CmdArgs

data HledgerMutuo = HledgerMutuo
  { file :: FilePath
  , source :: String
  , target :: String
  , account :: String
  , annualRate :: Double
  , fixExpense :: Double
  , mortgageMonthLength :: Integer
  } deriving (Show, Data, Typeable)
