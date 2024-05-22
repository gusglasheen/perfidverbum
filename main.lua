_G.love = require("love")
_G.Tile = require("Tile")
_G.Button = require("Button")

math.randomseed(os.time())
--game table to store state--
local game = {
    state = {
        menu = false,
        running = true,
        ended = false
    }
}
--player stores data about cursor position--
local player = {
    x = 0,
    y = 0,
    clicked = false,
    tile = nil
}
--table stores all tiles on screen, separated into those in hand, word, or board--
local tiles = {
    hand = {},
    board = {},
    word = {}
}
--table stores all buttons, separated into the game state
local buttons = {
    menu_state = {},
    running_state = {},
    ended_state = {}
}
function love.load()
    _G.TileWidth = 40
    _G.TileHeight = 40
    love.graphics.setBackgroundColor(1, 1, 1)
    _G.Board = {}
    _G.Hand = {}
    _G.Word = {}
    _G.Values = {A = 1, B = 3, C = 3, D = 2, E = 1, F = 4, G = 2, H = 4, I = 1, J = 8, K = 5, L = 1, M = 3, N = 1, O = 1, P = 3, Q = 10, R = 1, S = 1, T = 1, U = 1, V = 4, W = 4, X = 8, Y = 4, Z = 10, b = 0, e = -1}
    _G.Bag = {A = 9, B = 2, C = 2, D = 4, E = 12, F = 2, G = 3, H = 2, I = 9, J = 1, K = 1, L = 4, M = 2, N = 6, O = 8, P = 2, Q = 1, R = 6, S = 4, T = 6, U = 4, V = 2, W = 2, X = 1, Y = 2, Z = 1, b = 2}
    _G.handLocation = {}
    _G.MouseSelection = {}
    MouseSelection.tile = nil
    MouseSelection.index = -1
    handLocation.x = 1000
    handLocation.y = 400
    _G.letterSize = {}
    letterSize.x = 2
    letterSize.y = 2
    _G.Selection = nil
    for i = 1, 7 do
        tiles["hand"][i] = Tile("e", "None", "hand", {i})
    end
    for i = 1, 7 do
        tiles["word"][i] = Tile("e", "None", "word", {i})
    end
    for j = 1, 15 do
        for i = 1,15 do
            tiles["board"][i + 15*(j-1)] = Tile("e", "None", "board", {i, j})
        end
    end
    buttons.running_state[1] = Button("Draw", fillRack, nil, 1000, 100, 50, 50, 10, 10)
end

function love.update(dt)
    
    --Getting Cursor Values/Click
    player.x, player.y = love.mouse.getPosition()
    player.clicked = love.mouse.isDown(1)


    for key, value in pairs(tiles) do
        for i=1,#value do
            tiles[key][i]:update(player.x, player.y)
        end
    end
end

function love.draw()
    for key, value in pairs(tiles) do
        for i=1,#value do
            tiles[key][i]:draw()
        end
    end
    for key, value in pairs(buttons) do
        for i=1,#value do
            buttons[key][i]:draw()
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state["running"] then
            for index in pairs(buttons.running_state) do
                buttons.running_state[index]:checkPressed(x, y)
            end
            for key, value in pairs(tiles) do
                for i=1,#value do
                    tiles[key][i]:checkPressed(player.x, player.y)
                end
            end
        end
    end
end

--Picks a random tile from bag, removes it, then returns new Tile object--
function _G.drawTile()
    local total = 0
    for letter in pairs(Bag) do
        total = total + Bag[letter]
    end
    local i = math.random(1, total)
    for letter in pairs(Bag) do
        if Bag[letter] >= i then
            Bag[letter] = Bag[letter] - 1
            return letter
        end
        i = i - Bag[letter]
    end
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function _G.CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end


--Fills empty spaces in hand with random tile drawn from bag
function _G.fillRack()
    for key in pairs(tiles.hand) do
        if tiles.hand[key].letter == "e" then
            tiles.hand[key] = Tile(drawTile(), tiles.hand[key].special, "hand", tiles.hand[key].index)
        end
    end
end