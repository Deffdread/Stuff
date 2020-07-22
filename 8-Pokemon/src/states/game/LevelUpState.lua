

LevelUpState = Class{__includes = BaseState}

function LevelUpState:init(playerPokemon)
    self.playerPokemon = playerPokemon
    
    self.HP = self.playerPokemon.HP
    self.attack = self.playerPokemon.attack
    self.defense = self.playerPokemon.defense
    self.speed = self.playerPokemon.speed

    self.HPIncrease, self.attackIncrease,self.defenseIncrease,self.speedIncrease = self.playerPokemon:levelUp()

    self.levelMenu = Menu {
        x = VIRTUAL_WIDTH - 256,
        y = VIRTUAL_HEIGHT - 128 - 64 - 24, --64 for menu, 24 for player combat information
        width = 256,
        height = 128,
        items = {
            {
                text = 'HP: ' .. self.HP .. ' + ' .. self.HPIncrease .. ' = ' .. self.playerPokemon.HP,
                onSelect = function()

                end
            },
            {
                text = 'Attack: ' .. self.attack .. ' + ' .. self.attackIncrease .. ' = ' .. self.playerPokemon.attack,
                onSelect = function()

                end
            },
            {
                text = 'Defense: ' .. self.defense .. ' + ' .. self.defenseIncrease .. ' = ' .. self.playerPokemon.defense,
                onSelect = function()

                end
            },
            {
                text = 'Speed: ' .. self.speed .. ' + ' .. self.speedIncrease .. ' = ' .. self.playerPokemon.speed,
                onSelect = function()

                end
            }
        },
        canInput = false
    }
end

function LevelUpState:update(dt)
    self.levelMenu:update(dt)

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateStack:push(FadeInState({
            r = 255/255, g = 255/255, b = 255/255
        }, 1, 
        function()
    
            -- resume field music
            gSounds['victory-music']:stop()
            gSounds['field-music']:play()
            
            -- pop off the battle state
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:push(FadeOutState({
                r = 255/255, g = 255/255, b = 255/255
            }, 1, function() end))
        end))

    end
end

function LevelUpState:render()
    self.levelMenu:render()
end