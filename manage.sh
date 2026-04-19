#!/bin/bash

# ============================================================
#  FiveM Server Management Script (Dev & Pro)
# ============================================================

CONTAINER_NAME="FiveM"
LICENSE_KEY="cfxk_FISfOgTNULuVnW73OPpX_1TSdvN"
IMAGE="spritsail/fivem"

# ดึง Path ปัจจุบัน
BASE_DIR=$(pwd)
CONFIG_DIR="$BASE_DIR/config"
TXDATA_DIR="$BASE_DIR/txData"
RESOURCE_DIR="$BASE_DIR/resources"

# สีสำหรับแสดงผล
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================
#  Functions
# ============================================================

setup() {
    echo -e "${CYAN}[*] เริ่มต้นตั้งค่าโครงสร้างโฟลเดอร์...${NC}"
    
    # สร้างโฟลเดอร์ที่จำเป็น
    mkdir -p "$CONFIG_DIR" "$TXDATA_DIR" "$RESOURCE_DIR"
    
    # สร้าง server.cfg พื้นฐานถ้ายังไม่มี
    if [ ! -f "$CONFIG_DIR/server.cfg" ]; then
        echo -e "${YELLOW}[!] ไม่พบ server.cfg กำลังสร้างไฟล์เริ่มต้นให้...${NC}"
        cat <<EOT > "$CONFIG_DIR/server.cfg"
# Basic FiveM Config
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

ensure mapmanager
ensure chat
ensure spawnmanager
ensure sessionmanager
ensure fivem

# Your Scripts
ensure my_inventory
EOT
    fi

    # ตั้งสิทธิ์ไฟล์ (สำคัญมากสำหรับ Docker Linux)
    sudo chmod -R 777 "$BASE_DIR"
    
    echo -e "${GREEN}[✓] Setup เรียบร้อย! กรุณาตรวจสอบ License Key ในไฟล์ manage.sh ก่อนรัน${NC}"
}

up() {
    echo -e "${CYAN}[*] กำลังเริ่ม FiveM Container...${NC}"

    # ลบคอนเทนเนอร์เก่า (ถ้ามี)
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        docker rm -f "$CONTAINER_NAME"
    fi

    # รัน Docker พร้อม Mapping โฟลเดอร์
    docker run -d \
        --name "$CONTAINER_NAME" \
        --restart=always \
        -e LICENSE_KEY="$LICENSE_KEY" \
        -p 30120:30120 \
        -p 30120:30120/udp \
        -p 40120:40120 \
        -v "$CONFIG_DIR":/config \
        -v "$TXDATA_DIR":/txData \
        -v "$RESOURCE_DIR":/config/resources \
        -ti \
        "$IMAGE"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}==============================================${NC}"
        echo -e "${GREEN}[✓] FiveM Server กำลังทำงาน!${NC}"
        echo -e "${CYAN} - Game Port: 30120${NC}"
        echo -e "${CYAN} - txAdmin Port: 40120${NC}"
        echo -e "${CYAN} - Connect: localhost:30120 (ในเกม)${NC}"
        echo -e "${GREEN}==============================================${NC}"
    else
        echo -e "${RED}[✗] ไม่สามารถเริ่ม FiveM ได้ กรุณาเช็ค Docker Log${NC}"
    fi
}

down() {
    echo -e "${YELLOW}[*] กำลังหยุด FiveM...${NC}"
    docker stop "$CONTAINER_NAME" && docker rm "$CONTAINER_NAME"
    echo -e "${GREEN}[✓] หยุดและลบ Container เรียบร้อย${NC}"
}

logs() {
    docker logs -f "$CONTAINER_NAME"
}

# ============================================================
#  Main Logic
# ============================================================

case "$1" in
    setup)   setup ;;
    up)      up ;;
    down)    down ;;
    restart) down; up ;;
    logs)    logs ;;
    *)
        echo "วิธีใช้: $0 {setup|up|down|restart|logs}"
        exit 1
esac