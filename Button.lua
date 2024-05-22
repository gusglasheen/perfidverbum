local love = require("love")


function Button(text, func, func_params, button_x, button_y, width, height, text_x, text_y)
    return {
        width = width or 100,
        height = height or 100,
        func = func or function () print("This button does nothing") end,
        func_params = func_params,
        button_x = button_x or 0,
        button_y = button_y or 0,
        text_x = text_x or 0,
        text_y = text_y or 0,
        text = text,

        checkPressed = function (self, mouse_x, mouse_y)
            if CheckCollision(self.button_x, self.button_y, self.width, self.height, mouse_x, mouse_y, 0, 0) then
                if self.func_params then
                    self.func(self.func_params)
                else
                    self.func()
                end
            end
        end,

        draw = function(self)
            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)

            love.graphics.setColor(0, 0, 0)
            love.graphics.print(self.text, self.text_x + self.button_x, self.text_y + self.button_y)
            
        end
    }
end

return Button

