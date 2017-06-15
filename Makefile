LOCALURL				= http://html5.apieskloof.net/

all:
	hugo -v

local:
	hugo -v --baseUrl=$(LOCALURL)

clean:
	$(RM) -rf ./public/*
