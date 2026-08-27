module Config
  ( Config(..)
  , defaultConfig
  , configFromEnvironment
  ) where

import           Data.Word(Word32)
import qualified System.Environment as IO
import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import qualified Text.Read as Read

data Config = Config
  { apiPort :: Word32
  }
  deriving (Show)

defaultConfig :: Config
defaultConfig = Config
  { apiPort = 8998
  }

configFromEnvironment
  :: IO Config
configFromEnvironment = Config
    <$> ((fmap (maybe
                 ( apiPort defaultConfig)
                 ( maybe
                   (apiPort defaultConfig)
                   id
                   . Read.readMaybe
                   . Text.unpack
                 )
               )
          $! lookupEnv "API_PORT"
        ))
  where
  lookupEnv k = do
    emv <- IO.lookupEnv k
    case emv of
      Nothing -> return Nothing
      (Just v0) -> do
        let
            v = Text.pack v0
        Text.putStrLn $! Text.pack k <> ": \"" <> v <> "\""
        return $! Just v


