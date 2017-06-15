REMOTEHOST				= mirage
REMOTEDIR				= ~/neorobot7
REMOTEURL				= http://robot7.co.za/
LOCALURL				= http://html5.apieskloof.net/
GIT_COMMIT_SHA			=
GIT_COMMIT_SHA_SHORT 	=
	
all:
	@echo "Use: either 'make local' or 'make remote'"

remote:
#	GIT_COMMIT_SHA=`git rev-parse --verify HEAD` 
#	GIT_COMMIT_SHA_SHORT=`git rev-parse --short HEAD`
	hugo -v --baseUrl=$(REMOTEURL)
	rsync -avz --delete ./public/ $(REMOTEHOST):$(REMOTEDIR)

local:
	hugo -v --baseUrl=$(LOCALURL)

clean:
	$(RM) -rf ./public/*
