_G.love = require("love")

_G.Values = {A = 1, B = 3, C = 3, D = 2, E = 1, F = 4, G = 2, H = 4, I = 1, J = 8, K = 5, L = 1, M = 3, N = 1, O = 1, P = 3, Q = 10, R = 1, S = 1, T = 1, U = 1, V = 4, W = 4, X = 8, Y = 4, Z = 10, b = 0, e = -1}
_G.TileWidth = 40
_G.TileHeight = 40

_G.handLocation = {}

handLocation.x = 1000
handLocation.y = 400

_G.boardLocation = {}

boardLocation.x = TileWidth
boardLocation.y = TileWidth

_G.wordLocation = {}

wordLocation.x = handLocation.x
wordLocation.y = handLocation.y - 100

_G.letterSize = {}

letterSize.x = 2
letterSize.y = 2


--Tile constructor, location can be "hand", "word", or "board"
--if hand/word, index has one value; if board, index has two values
function Tile(letter, special, location, index)
    return {
        letter = letter,
        points = Values[letter],
        special = special,
        x = 0,
        y = 0,
        location = {
            hand = (location == "hand"),
            board = (location == "board"),
            word = (location == "word"),
        },
        index = index,
        width = TileWidth,
        height = TileHeight,
        selected = false,


        checkPressed = function (self, mouse_x, mouse_y)
            if CheckCollision(self.x, self.y, self.width, self.height, mouse_x, mouse_y, 0, 0) then
                print("Tile at (" ..self.x .. ", ".. self.y .. ")  Pressed")
                if self.selected ~= true then
                    if Selection == nil then
                        if self.location["hand"] then
                            self.selected = true
                            Selection = self
                        end
                    else
                        local temp = self.letter
                        self.letter = Selection.letter
                        Selection.letter = temp
                        Selection.selected = false
                        Selection = nil
                    end
                end
            end
        end,
        update = function (self, cursor_x, cursor_y)
            if self.selected then
                self.x = cursor_x
                self.y = cursor_y
            else
                if self.location["hand"] then
                    self.x = handLocation.x + (self.index[1] - 1)*TileWidth
                    self.y = handLocation.y
                elseif self.location["board"] then
                    self.x = boardLocation.x + (self.index[1] - 1)*TileWidth
                    self.y = boardLocation.y + (self.index[2] - 1)*TileWidth
                elseif self.location["word"] then
                    self.x = wordLocation.x + (self.index[1] - 1)*TileWidth
                    self.y = wordLocation.y
                end
            end
        end,
        draw = function (self)
            if self.location["hand"] then
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle("line", (self.x), self.y, TileWidth, TileHeight)
                love.graphics.print(self.letter, self.x + 10, self.y + 4, 0, letterSize.x, letterSize.y)
                love.graphics.print(self.points, self.x + 30, self.y + 25, 0, 1, 1)
            elseif self.location["word"] then
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle("line", (wordLocation.x + (index[1] - 1)*TileWidth), wordLocation.y, TileWidth, TileHeight)
                love.graphics.print(self.letter, wordLocation.x + (index[1] - 1)*TileWidth + 10, wordLocation.y + 4, 0, letterSize.x, letterSize.y)
                love.graphics.print(self.points, wordLocation.x + (index[1] - 1)*TileWidth + 30, wordLocation.y + 25, 0, 1, 1)
            elseif self.location["board"] then
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle("line", (boardLocation.x + (index[1] - 1)*TileWidth), boardLocation.y + (index[2] - 1)*TileHeight, TileWidth, TileHeight)
                love.graphics.print(self.letter, boardLocation.x + (index[1] - 1)*TileWidth + 10, boardLocation.y + 4 + (index[2] - 1)*TileHeight, 0, letterSize.x, letterSize.y)
                love.graphics.print(self.points, boardLocation.x + (index[1] - 1)*TileWidth + 30, boardLocation.y + 25 + (index[2] - 1)*TileHeight, 0, 1, 1)
            end
        end,
        setState = function(self, location, index)
            self.location = {
                hand = (location == "hand"),
                board = (location == "board"),
                word = (location == "word"),
            }
            self.index = index
        end,
    }
   

end

return Tile