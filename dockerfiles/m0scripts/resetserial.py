from serial import Serial
import platform

def get_serialports(filter_hwid=False):
    try:
        from serial.tools.list_ports import comports
    except ImportError:
        raise exception.GetSerialPortsError(os.name)

    result = []
    for p, d, h in comports():
        if not p:
            continue
        if platform.system() == "Windows":
            try:
                d = unicode(d, errors="ignore")
            except TypeError:
                pass
        if not filter_hwid or "VID:PID" in h:
            result.append({"port": p, "description": d, "hwid": h})

    if filter_hwid:
        return result

    # fix for PySerial
    if not result and platform.system() == "Darwin":
        for p in glob("/dev/tty.*"):
            result.append({"port": p, "description": "n/a", "hwid": "n/a"})
    print "port is %s" % result
    return result


def TouchSerialPort(port):
	#port='COM3' #adjust this in case your device differs
	ser = Serial() #open serial connection
	ser.port=port #setting the port accordingly

	#in case your usual baudrate isn't 9600 reset will not work, therefore we will open a resetable connection
	#thanks to mattvenn.net for suggesting to add this step!
	ser.baudrate=9600
	ser.open(); ser.close()

	ser.baudrate=1200 # set the reset baudrate
	ser.open(); ser.close()
	#don't forget to sleep some reset time


