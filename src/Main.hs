{-# LANGUAGE DeriveDataTypeable #-}
{-# OPTIONS_GHC -fno-cse #-}

module Main where

import Hledger.Mutuo

import Control.Exception
import qualified Data.Text as T
import Hledger.Data.Journal
import Hledger.Query
import Hledger.Read
import Hledger.Utils
import System.Environment
import System.Exit
import System.IO

import System.Console.CmdArgs

data HledgerMutuo = HledgerMutuo
  { file :: FilePath
  , source :: String
  , target :: String
  , account :: String
  } deriving (Show, Data, Typeable)

opts =
  HledgerMutuo
  { file = "-" &= name "f" &= typ "FILE"
  , source = "" &= name "s" &= typ "ACCOUNT"
  , target = "" &= name "t" &= typ "ACCOUNT"
  , account = "" &= typ "ACCOUNT" &= args
  } &=
  summary "hledger-mutuo v1"

main = do
  let ledgerInputOptions = definputopts {ignore_assertions_ = True}
  v <- cmdArgs opts
  j <- readJournalFiles ledgerInputOptions [file v] >>= either fail return
  let result =
        filterJournalTransactions (Acct (toRegex' (T.pack $ account v))) j
  print result
