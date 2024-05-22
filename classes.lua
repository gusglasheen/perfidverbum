local Tile = {
    letter = "e",
    points = 0,
    special = "None"
}

function Tile.new(letter, points, special)
    local self = setmetatable({}, Tile)
    self.letter = letter
    self.points = points
    self.special = special
    return self
end