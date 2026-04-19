#!/bin/bash

# ============================================================
#  FiveM Server Management Script (With Firewall Control)
# ============================================================

CONTAINER_NAME="FiveM"
LICENSE_KEY="cfxk_FISfOgTNULuVnW73OPpX_1TSdvN"
IMAGE="spritsail/fivem"

# Path Setup
BASE_DIR=$(pwd)
CONFIG_DIR="$BASE_DIR/config"
TXDATA_DIR="$BASE_DIR/txData"
RESOURCE_DIR="$BASE_DIR/resources"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================
#  Core Functions
# ============================================================

setup() {
    echo -e "${CYAN}[*] เริ่มต้นตั้งค่าโครงสร้าง...${NC}"
    mkdir -p "$CONFIG_DIR" "$TXDATA_DIR" "$RESOURCE_DIR"
    sudo chmod -R 777 "$BASE_DIR"
    echo -e "${GREEN}[✓] Setup เรียบร้อย${NC}"
}

up() {
    echo -e "${CYAN}[*] กำลังเริ่ม FiveM...${NC}"
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        docker rm -f "$CONTAINER_NAME"
    fi

    docker run -d \
        --name "$CONTAINER_NAME" \
        --restart=always \
        -e LICENSE_KEY="$LICENSE_KEY" \
        -p 30120:30120 -p 30120:30120/udp -p 40120:40120 \
        -v "$CONFIG_DIR":/config \
        -v "$TXDATA_DIR":/txData \
        -v "$RESOURCE_DIR":/config/resources \
        -ti "$IMAGE"
    
    echo -e "${GREEN}[✓] FiveM Online!${NC}"
}

down() {
    echo -e "${YELLOW}[*] กำลังหยุด FiveM...${NC}"
    docker stop "$CONTAINER_NAME" && docker rm "$CONTAINER_NAME"
    echo -e "${GREEN}[✓] หยุดเรียบร้อย${NC}"
}

# ============================================================
#  Firewall Management (UFW)
# ============================================================

fw_open() {
    echo -e "${CYAN}[*] กำลังเปิดพอร์ต Firewall (30120, 40120)...${NC}"
    sudo ufw allow 30120/tcp
    sudo ufw allow 30120/udp
    sudo ufw allow 40120/tcp
    sudo ufw reload
    echo -e "${GREEN}[✓] เปิดพอร์ตเรียบร้อยแล้ว${NC}"
}

fw_close() {
    echo -e "${RED}[*] กำลังปิดพอร์ต Firewall...${NC}"
    sudo ufw delete allow 30120/tcp
    sudo ufw delete allow 30120/udp
    sudo ufw delete allow 40120/tcp
    sudo ufw reload
    echo -e "${YELLOW}[✓] ปิดพอร์ตเรียบร้อยแล้ว${NC}"
}

fw_status() {
    echo -e "${CYAN}[*] สถานะ Firewall ปัจจุบัน:${NC}"
    sudo ufw status numbered
}

# ============================================================
#  Main Logic
# ============================================================

case "$1" in
    setup)          setup ;;
    up)             up ;;
    down)           down ;;
    restart)        down; up ;;
    logs)           docker logs -f "$CONTAINER_NAME" ;;
    fw:open)        fw_open ;;
    fw:close)       fw_close ;;
    fw:status)      fw_status ;;
    *)
        echo "วิธีใช้: $0 {setup|up|down|restart|logs|fw:open|fw:close|fw:status}"
        exit 1
esac