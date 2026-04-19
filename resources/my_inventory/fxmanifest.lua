fx_version 'cerulean'
game 'gta5'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/app.js',
    -- 'html/css/style.css', -- ถ้าเพิ่ม CSS ให้เอาคอมเม้นต์ออก
    -- 'html/img/*.png'      -- ถ้ามีรูปภาพ ให้เอาคอมเม้นต์ออก
}

client_scripts {
    'client/main.lua'
}