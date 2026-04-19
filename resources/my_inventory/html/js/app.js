window.addEventListener('message', function(event) {
    if (event.data.type === "OPEN_INVENTORY") {
        document.body.style.display = "block";
        const itemDiv = document.getElementById('items');
        itemDiv.innerHTML = ''; // ล้างของเก่า
        
        event.data.items.forEach(item => {
            itemDiv.innerHTML += `<p>${item.label} x${item.count}</p>`;
        });
    }
});

function closeInv() {
    document.body.style.display = "none";
    // ส่งคำสั่งกลับไปหา Lua เพื่อปิดเมาส์
    fetch(`https://${GetParentResourceName()}/closeInventory`, {
        method: 'POST',
        body: JSON.stringify({})
    });
}