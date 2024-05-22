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

_G.bagLocation = {}

bagLocation.x = (17*40)
bagLocation.y = 40



--Tile constructor, location can be "hand", "word", or "board"
--if hand/word, index has one value; if board, index has two values
function Tile(letter, special, location, index, width, height)
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
            bag = (location == "bag")
        },
        index = index,
        width = width or TileWidth,
        height = height or TileHeight,
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
                        print(Selection.letter)
                        self:swap(Selection)
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
                    self.x = handLocation.x + (self.index[1] - 1)*self.width
                    self.y = handLocation.y
                elseif self.location["board"] then
                    self.x = boardLocation.x + (self.index[1] - 1)*self.width
                    self.y = boardLocation.y + (self.index[2] - 1)*self.width
                elseif self.location["word"] then
                    self.x = wordLocation.x + (self.index[1] - 1)*self.width
                    self.y = wordLocation.y
                elseif self.location["bag"] then
                    self.x = bagLocation.x + (self.index[1] - 1)*self.width
                    self.y = bagLocation.y + (self.index[2] - 1)*self.height
                end
            end
        end,
        draw = function (self)
            if self.letter == "e" then
                self.letter = " "
                self.points = " "
            end
            local ratio = self.width/TileWidth
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", (self.x), self.y, self.width, self.height)
            love.graphics.print(self.letter, self.x + 10*ratio, self.y + 4*ratio, 0, letterSize.x*ratio, letterSize.y*ratio)
            love.graphics.print(self.points, self.x + 30*ratio, self.y + 25*ratio, 0, 1*ratio, 1*ratio)
            if self.letter == " " then
                self.letter = "e"
                self.points = 0
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
        --Swaps members of two tiles without creating any other instance
        swap = function(self, other)
            print(other)
            local templetter = self.letter
            local tempspecial = self.special
            local temppoints = self.points

            self.letter = other.letter
            self.special = other.special
            self.points = other.points

            other.letter = templetter
            other.special = tempspecial
            other.points = temppoints
            print("Finished swap")
        end,
    }
   

end

return Tile