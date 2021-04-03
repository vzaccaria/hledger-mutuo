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
  { mAccount      :: AccountName
  , mSource       :: AccountName
  , mTarget       :: AccountName
  , mCapital      :: Amount
  , mRate         :: Decimal
  , mFixExpense   :: Amount
  , mMonths       :: Integer
  , mTransactions :: [Transaction]
  } deriving (Show)

_showTransaction ts = (putStr . T.unpack . showTransaction) ts

showTransactions ts =
  mapM_ (putStr . T.unpack . showTransaction) (sortOn tdate ts)

getAccountAmount acnName t =
  let ps = [p | p <- tpostings t, paccount p == acnName]
      -- get the first (and hopefully unique one.
      p = ps !! 0
      --
      (Just am) = unifyMixedAmount $ pamount p
  in am

getRootAmount acnName ts = getAccountAmount acnName (ts !! 0)

kMonthlyRatio :: FrenchMortgageData -> Integer -> (Amount, Amount)
kMonthlyRatio f k =
  let r = monthlyPayment f
      i = (mRate f) / 12
      n = mMonths f
      cc = 1 / ((1 + i) ^ (n + 1 - k))
      cap = setAmountInternalPrecision 2 $ multiplyAmount cc r
      int = r - cap
  in (cap, int)

monthlyPayment :: FrenchMortgageData -> Amount
monthlyPayment f =
  let i = (mRate f) / 12
      n = mMonths f
      coeff = i / (1 - 1 / ((1 + i) ^ n))
  in setAmountInternalPrecision 2 $ multiplyAmount (-1 * coeff) (mCapital f)

processTransaction f (k, t) =
  let (cap, _) = kMonthlyRatio f k
      am = getAccountAmount (mAccount f) t
      int = (am - cap)
      p1 =
        nullposting
        { paccount = (mTarget f)
        , pamount = Mixed [-1 * int]
        , ptype = RegularPosting
        , ptransaction = Just rt
        }
      p2 =
        nullposting
        { paccount = (mSource f)
        , pamount = negate (pamount p1)
        , ptype = RegularPosting
        , ptransaction = Just rt
        }
      rt =
        t
        { tpostings = [p1, p2]
        , tdescription =
            T.pack $
            (T.unpack $ tdescription t) ++
            " interest n.  " ++
            show k ++ " (capital = " ++ show (aquantity cap) ++ ")"
        }
  in rt

unrollTransactions :: FrenchMortgageData -> [Transaction]
unrollTransactions f =
  let ts = tail $ mTransactions f
      ts' = map (processTransaction f) (zip [1 ..] ts)
  in ts'

runFrenchCompute :: HledgerMutuo -> IO ()
runFrenchCompute v = do
  fmd <- computeConfig v
  showTransactions $ unrollTransactions fmd

computeConfig :: HledgerMutuo -> IO FrenchMortgageData
computeConfig v = do
  let ledgerInputOptions = definputopts {ignore_assertions_ = True}
  j <- readJournalFiles ledgerInputOptions [file v] >>= either fail return
  let acnName = (T.pack $ account v)
      srcName = (T.pack $ source v)
      tarName = (T.pack $ target v)
      jnl = filterJournalTransactions (Acct (toRegex' acnName)) j
      ts = sortOn tdate (jtxns jnl)
      aRootAmount = getRootAmount acnName ts
      dAnnualRate = (realFracToDecimal 8 (annualRate v))
      aFixExpense =
        aRootAmount {aquantity = (realFracToDecimal 2 $ fixExpense v)}
      fmdConfig =
        FMD
          acnName
          srcName
          tarName
          aRootAmount
          dAnnualRate
          aFixExpense
          (mortgageMonthLength v)
          ts
  return fmdConfig
