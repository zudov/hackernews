{-# LANGUAGE OverloadedStrings #-}
module Web.HackerNews.Poll where

import           Control.Applicative ((<*>), (<$>))
import           Control.Monad       (MonadPlus (mzero))
import           Data.Aeson          (FromJSON (parseJSON), Value (Object),
                                      (.:))
import           Data.Text           (Text)
import           Data.Time           (UTCTime)

import           Web.HackerNews.Util (fromSeconds)

------------------------------------------------------------------------------
-- | Types
data Poll = Poll {
    pollBy    :: Text
  , pollId    :: PollId
  , pollKids  :: [Int]
  , pollParts :: [Int]
  , pollScore :: Int
  , pollText  :: Text
  , pollTime  :: UTCTime
  , pollTitle :: Text
  , pollType  :: Text
  } deriving (Show, Eq)

data PollOpt = PollOpt {
    pollOptBy     :: Text
  , pollOptId     :: PollOptId
  , pollOptParent :: Int
  , pollOptScore  :: Int
  , pollOptText   :: Text
  , pollOptTime   :: UTCTime
  , pollOptType   :: Text
  } deriving (Show, Eq)

newtype PollOptId
  = PollOptId Int
  deriving (Show, Eq)

newtype PollId
  = PollId Int
  deriving (Show, Eq)

------------------------------------------------------------------------------
-- | JSON Instances
instance FromJSON Poll where
  parseJSON (Object o) =
     Poll <$> o .: "by"
          <*> (PollId <$> o .: "id")
          <*> o .: "kids"
          <*> o .: "parts"
          <*> o .: "score"
          <*> o .: "text"
          <*> (fromSeconds <$> o .: "time")
          <*> o .: "title"
          <*> o .: "type"
  parseJSON _ = mzero

instance FromJSON PollOpt where
  parseJSON (Object o) =
     PollOpt <$> o .: "by"
             <*> (PollOptId <$> o .: "id")
             <*> o .: "parent"
             <*> o .: "score"
             <*> o .: "text"
             <*> (fromSeconds <$> o .: "time")
             <*> o .: "type"
  parseJSON _ = mzero