//#define SERVER_HOST "msee140lnx10.ecn.purdue.edu"
#define SERVER_HOST @"msee140lnx10.ecn.purdue.edu"
#define SERVER_PORT @"8005"
//#define OBDKEY_HOST @"localhost"
#define OBDKEY_HOST @"192.168.0.74"
#define OBDKEY_PORT @"23"

#define TIMEOUT 5

#define SPEED_PID 0x0D
#define SPEED_LEN 1
#define THROTTLE_POSITION_PID 0x11
#define THROTTLE_POSITION_LEN 1
#define RPM_PID 0x0C
#define RPM_LEN 2
#define ENGINE_LOAD_PID 0x04
#define ENGINE_LOAD_LEN 1
#define COOLANT_TEMP_PID 0x05
#define COOLANT_TEMP_LEN 1
#define FUEL_PRESSURE_PID 0x0A
#define FUEL_PRESSURE_LEN 1