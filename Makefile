CXX = g++
AR = ar
RANLIB = ranlib
PLATFORM ?= `uname`

PREFIX ?= /usr/local
WirelessKitSource = WirelessKit/WirelessKit.cpp
WirelessKitHeader = WirelessKit/WirelessKit.hpp
WirelessKitObject = obj/WirelessKit.o
WirelessKitLib = lib/libWirelessKit.a

CPPFLAGS += -Os -I./WirelessKit -std=c++14 -fPIC
LDFLAGS += -lpcap -lpthread 
LINK_WIRELESSKIT = -Llib -lWirelessKit
ARFLAGS += -crv $(WirelessKitLib) $(WirelessKitObject)
RANLIBFLAGS += $(WirelessKitLib)

$(WirelessKitLib) : 
	@rm -rf ./lib
	@rm -rf ./obj
	@rm -rf ./bin
	@mkdir lib
	@mkdir obj
	@mkdir bin
	case $(PLATFORM) in RaspberryPi*) $(CXX) $(CPPFLAGS) -D__RASPBIAN__=1 -c $(WirelessKitSource) -o $(WirelessKitObject) ;; *) $(CXX) $(CPPFLAGS) -c $(WirelessKitSource) -o $(WirelessKitObject) ;; esac
	case $(PLATFORM) in Darwin*) $(AR) crv $(WirelessKitLib) $(CHANNEL_HELPER_OBJECT) $(WirelessKitObject) ;; *) $(AR) cr $(WirelessKitLib) && $(AR) crv $(WirelessKitLib) $(WirelessKitObject) ;; esac
	$(RANLIB) $(RANLIBFLAGS)

authflood : $(WirelessKitLib)
	case $(PLATFORM) in RaspberryPi*) $(CXX) $(CPPFLAGS) -D__RASPBIAN__=1 $(LDFLAGS) $(WirelessKitSource) authflood/authflood.cpp -o bin/authflood ;; *) $(CXX) $(CPPFLAGS) $(LDFLAGS) $(LINK_WIRELESSKIT) authflood/authflood.cpp -o bin/authflood ;; esac

deauth : $(WirelessKitLib)
	case $(PLATFORM) in RaspberryPi*) $(CXX) $(CPPFLAGS) -D__RASPBIAN__=1 $(LDFLAGS) $(WirelessKitSource) deauth/deauth.cpp -o bin/deauth ;; *) $(CXX) $(CPPFLAGS) $(LDFLAGS) $(LINK_WIRELESSKIT) deauth/deauth.cpp -o bin/deauth ;; esac

fakebeacon : $(WirelessKitLib)
	case $(PLATFORM) in RaspberryPi*) $(CXX) $(CPPFLAGS) -D__RASPBIAN__=1 $(LDFLAGS) $(WirelessKitSource) fakebeacon/fakebeacon.cpp -o bin/fakebeacon ;; *) $(CXX) $(CPPFLAGS) $(LDFLAGS) $(LINK_WIRELESSKIT) fakebeacon/fakebeacon.cpp -o bin/fakebeacon ;; esac
	
sniffer : $(WirelessKitLib)
	case $(PLATFORM) in RaspberryPi*) $(CXX) $(CPPFLAGS) -D__RASPBIAN__=1 $(LDFLAGS) $(WirelessKitSource) sniffer/sniffer.cpp -o bin/sniffer ;; *) $(CXX) $(CPPFLAGS) $(LDFLAGS) $(LINK_WIRELESSKIT) sniffer/sniffer.cpp -o bin/sniffer ;; esac

rsniepoison : $(WirelessKitLib)
	case $(PLATFORM) in RaspberryPi*) $(CXX) $(CPPFLAGS) -D__RASPBIAN__=1 $(LDFLAGS) $(WirelessKitSource) rsniepoison/rsniepoison.cpp -o bin/rsniepoison ;; *) $(CXX) $(CPPFLAGS) $(LDFLAGS) $(LINK_WIRELESSKIT) rsniepoison/rsniepoison.cpp -o bin/rsniepoison ;; esac

all : $(WirelessKitLib) authflood deauth fakebeacon sniffer rsniepoison
	

install :
	install -m 775 $(WirelessKitLib) $(PREFIX)/lib
	install -m 644 $(WirelessKitHeader) $(PREFIX)/include

install-demo :
	install -m 775 $(wildcard bin/*) $(PREFIX)/bin
	
uninstall-demo :
	-rm -f $(PREFIX)/bin/authflood
	-rm -f $(PREFIX)/bin/deauth
	-rm -f $(PREFIX)/bin/fakebeacon
	-rm -f $(PREFIX)/bin/sniffer
	-rm -f $(PREFIX)/bin/rsniepoison

uninstall :
	rm -f $(PREFIX)/lib/$(WirelessKitLib)
	rm -f $(PREFIX)/include/$(WirelessKitHeader)

clean :
	-rm -rf ./lib
	-rm -rf ./obj
	-rm -rf ./bin
