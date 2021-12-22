import { handleNewGravatars, createNewGravatarEvent, trySaveGravatarFromContract, saveGravatarFromContract } from "./utils"
import { test, log } from 'matchstick-as/assembly/index'
import { Gravatar } from "../generated/schema"
import { handleCreateGravatar, handleNewGravatar } from "../../src/gravity"
