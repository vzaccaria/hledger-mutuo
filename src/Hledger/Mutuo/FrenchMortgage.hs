module Hledger.Mutuo.FrenchMortgage where

import           Data.Decimal
import           Data.List            (sortOn)
import qualified Data.Text            as T
import           Hledger.Data
import           Hledger.Data.Journal
import           Hledger.Mutuo.Config
import           Hledger.Query
import           Hledger.Read
import           Hledger.Utils

data FrenchMortgageData = FMD
  { mCapital    :: Amount
  , mRate       :: Decimal
  , mFixExpense :: Amount
  , mMonths     :: Integer
  }
-- computeConfig :: HledgerMutuo -> FrenchMortgageData
-- someFunc :: IO ()
-- someFunc = putStrLn "someFunc"
