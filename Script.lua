-- Inicialização do Menu
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ButtonsFrame = Instance.new("Frame")

-- Função para verificar se o objeto é um jogador
local function isPlayer(obj)
    return game.Players:GetPlayerFromCharacter(obj) ~= nil
end

-- Função para eliminar todos os inimigos que não sejam jogadores
local function eliminarInimigos()
    for _, obj in pairs(game.Workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and not isPlayer(obj) then
            -- Verifica se o objeto não é um jogador e tem um humanoide (inimigo NPC)
            obj.Humanoid.Health = 0
        end
    end
end

-- Função para destacar (ESP) objetos interativos
local function adicionarESPInterativos()
    for _, obj in pairs(game.Workspace:GetChildren()) do
        -- Verificar se o objeto é interativo, como por exemplo, um item coletável ou uma porta
        if obj:IsA("Model") and obj:FindFirstChild("ClickDetector") then
            -- Cria um BillboardGui para mostrar um texto acima do objeto
            local esp = Instance.new("BillboardGui", obj)
            esp.Adornee = obj
            esp.AlwaysOnTop = true
            esp.ExtentsOffset = Vector3.new(0, 3, 0)
            esp.Size = UDim2.new(0, 200, 0, 50)

            -- Cria um TextLabel para o nome do objeto
            local label = Instance.new("TextLabel", esp)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = obj.Name
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextStrokeTransparency = 0.5
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
        end
    end
end

-- Função para criar botões no menu
local function criarBotao(nome, funcao)
    local Botao = Instance.new("TextButton")
    Botao.Size = UDim2.new(0, 100, 0, 50)
    Botao.Text = nome
    Botao.Parent = ButtonsFrame
    Botao.MouseButton1Click:Connect(funcao)
end

-- Configuração visual do menu
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Superbox Menu"
Title.TextColor3 = Color3.new(1, 1, 1)

ButtonsFrame.Parent = MainFrame
ButtonsFrame.Size = UDim2.new(1, 0, 1, -50)
ButtonsFrame.Position = UDim2.new(0, 0, 0, 50)

-- Adicionando botões com funcionalidades
criarBotao("Eliminar Inimigos", eliminarInimigos)
criarBotao("ESP Interativos", adicionarESPInterativos)

-- Função para tornar o menu móvel
local dragging
local dragInput
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Executa as funções de acordo com os botões clicados no menu
