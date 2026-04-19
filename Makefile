run:
	docker run -d \
		--name FiveM \
		-e LICENSE_KEY=cfxk_FISfOgTNULuVnW73OPpX_1TSdvN \
		-p 30120:30120 -p 30120:30120/udp -p 40120:40120 \
		-v $(pwd)/config:/config \
		-v $(pwd)/txData:/txData \
		-v $(pwd)/resources:/config/resources \
		-ti \
		spritsail/fivem