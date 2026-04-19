RegisterCommand('inv', function()
    SetNuiFocus(true, true) -- เปิดเมาส์
    SendNUIMessage({
        type = "OPEN_INVENTORY",
        items = {
            { name = "water", label = "น้ำดื่ม", count = 2 },
            { name = "bread", label = "ขนมปัง", count = 5 }
        }
    })
end)

-- Callback สำหรับปิดหน้ากระเป๋า
RegisterNUICallback('closeInventory', function(data, cb)
    SetNuiFocus(false, false) -- ปิดเมาส์กลับเข้าเกม
    cb('ok')
end)