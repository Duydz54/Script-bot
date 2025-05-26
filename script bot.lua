local keyRequired = "GIOVIP2025" -- <<< THAY ĐỔI key tại đây
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- GUI Chính
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MainScriptUI"

-- GUI Nhập Key
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0, 300, 0, 150)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", keyFrame)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.PlaceholderText = "Enter Key Here"
keyBox.Size = UDim2.new(1, -20, 0, 40)
keyBox.Position = UDim2.new(0, 10, 0, 20)
keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.Font = Enum.Font.SourceSansBold
keyBox.TextScaled = true
Instance.new("UICorner", keyBox)

local submitBtn = Instance.new("TextButton", keyFrame)
submitBtn.Text = "Submit"
submitBtn.Size = UDim2.new(1, -20, 0, 40)
submitBtn.Position = UDim2.new(0, 10, 0, 80)
submitBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.Font = Enum.Font.SourceSansBold
submitBtn.TextScaled = true
Instance.new("UICorner", submitBtn)

-- Hàm Mở GUI Chính (Teleport + Aimbot)
local function launchScript()
	keyFrame:Destroy()

	-- === Aimbot ===
	local aimBtn = Instance.new("TextButton", gui)
	aimBtn.Size = UDim2.new(0, 150, 0, 50)
	aimBtn.Position = UDim2.new(0.5, -75, 0.9, -25)
	aimBtn.BackgroundColor3 = Color3.new(0, 0, 0)
	aimBtn.TextColor3 = Color3.new(1, 1, 1)
	aimBtn.Text = "NPC Lock: OFF"
	aimBtn.Font = Enum.Font.Fantasy
	aimBtn.TextScaled = true
	Instance.new("UICorner", aimBtn)

	local npcLock = false
	local toggleLoop
	local function getClosestNPC()
		local closest, dist = nil, math.huge
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
				if obj.Humanoid.Health > 0 and obj.Name ~= "Horse" then
					local d = (obj.Head.Position - player.Character.HumanoidRootPart.Position).Magnitude
					if d < dist then
						dist = d
						closest = obj
					end
				end
			end
		end
		return closest
	end

	aimBtn.MouseButton1Click:Connect(function()
		npcLock = not npcLock
		aimBtn.Text = npcLock and "NPC Lock: ON" or "NPC Lock: OFF"
		if npcLock then
			toggleLoop = RunService.RenderStepped:Connect(function()
				local npc = getClosestNPC()
				if npc then
					camera.CFrame = CFrame.new(camera.CFrame.Position, npc.Head.Position)
				end
			end)
		else
			if toggleLoop then toggleLoop:Disconnect() end
		end
	end)

	-- === Teleport Menu ===
	local locations = {
		["Fort"] = Vector3.new(100, 10, 200),
		["Castle"] = Vector3.new(300, 10, 100),
		["Tesla Lab"] = Vector3.new(500, 10, -100),
		["Train"] = Vector3.new(700, 10, 0),
		["End"] = Vector3.new(900, 10, 200),
		["Sterling"] = Vector3.new(1200, 10, 350)
	}

	local menu = Instance.new("Frame", gui)
	menu.Position = UDim2.new(0, 10, 0, 200)
	menu.Size = UDim2.new(0, 200, 0, 250)
	menu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	menu.Visible = true
	Instance.new("UICorner", menu)

	local openBtn = Instance.new("TextButton", menu)
	openBtn.Size = UDim2.new(1, 0, 0, 30)
	openBtn.Text = "Open/Close"
	openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	openBtn.TextColor3 = Color3.new(1, 1, 1)
	openBtn.Font = Enum.Font.SourceSansBold
	openBtn.TextScaled = true
	Instance.new("UICorner", openBtn)

	local y = 40
	for name, pos in pairs(locations) do
		local btn = Instance.new("TextButton", menu)
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.Position = UDim2.new(0, 0, 0, y)
		btn.Text = "Teleport to " .. name
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.SourceSans
		btn.TextScaled = true
		Instance.new("UICorner", btn)
		y += 35

		btn.MouseButton1Click:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
			end
		end)
	end

	openBtn.MouseButton1Click:Connect(function()
		menu.Visible = not menu.Visible
	end)
end

-- Kiểm tra key khi ấn Submit
submitBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == keyRequired then
		launchScript()
	else
		StarterGui:SetCore("SendNotification", {
			Title = "Sai Key!",
			Text = "Vui lòng thử lại.",
			Duration = 2
		})
	end
end)
