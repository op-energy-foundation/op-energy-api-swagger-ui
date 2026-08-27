{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeOperators              #-}
module API
  ( api
  , realMain
  ) where

import           Control.Lens
import           Data.Proxy
import           Data.Swagger
import           Servant ( Server, serve )
import           Servant.API
import           Servant.Swagger
import           Servant.Swagger.UI
import           Network.Wai(Application)
import           Network.Wai.Handler.Warp(run)

import qualified Data.OpEnergy.API as BlockspanAPI
import qualified Data.OpEnergy.Account.API as AccountAPI
import qualified Config as Config

type API
  = BlockspanAPI.WebSocketBackendAPI
  :<|> AccountAPI.AccountAPI
  :<|> AccountAPI.BlockTimeAPI

type SwaggerAPI = "api" :> SwaggerSchemaUI "swagger-ui" "swagger.json"

api :: Proxy API
api = Proxy

apiSwagger :: Swagger
apiSwagger = toSwagger api
  & info.title   .~ "composed op-energy API"
  & info.version .~ "1.0"
  & info.description ?~ "API"
  & info.license ?~ ("MIT" & url ?~ URL "http://mit.com")

-- | Runs HTTP server on a port defined in config in the State datatype
runServer :: Config.Config-> IO ()
runServer config = do
  run apiPort app
  where
    !apiPort = fromIntegral $! Config.apiPort config
    app :: Application
    app = serve api serverSwaggerBackend
      where
        api :: Proxy SwaggerAPI
        api = Proxy
        serverSwaggerBackend :: Server SwaggerAPI
        serverSwaggerBackend = (swaggerSchemaUIServerT apiSwagger)

realMain :: IO ()
realMain = do
  config <- Config.configFromEnvironment
  runServer config

