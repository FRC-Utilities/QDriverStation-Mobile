# QDriverStation Mobile

The Mobile QDriverStation is an application for mobile devices that allows you to operate FRC robots using [LibDS](https://github.com/frc-utilities/libds-c). 

This application uses the latest features provided by Qt, it **requires** Qt 5.7 or greater in order to compile.

### Features

The Mobile QDriverStation allows the user to:

- Use different communication protocols (2014, 2015 and 2016)
- Switch between Teleop, Autonomous and Test modes
- See NetConsole output 
- Reboot your robot and restart the robot code
- See the robot's voltage, CPU usage, RAM usage and Disk usage
- Use custom robot addresses (e.g. if mDNS is not supported on your mobile OS)

#### Joystick

This application implements a virtual joystick with the following features:

- Two thumbs
- Two triggers
- Twelve buttons

The joystick mappings are the same as an Xbox 360 controller, so there should be no need to change your robot code for the QDriverStation to work.

#### User Interface

This application implements two user interfaces:

- One following Google's Material Design guidelines
- Another one following Microsoft's Universal UI guidelines

You are free to use the UI style that best fits your needs.

### License

This project is released under the [MIT License](LICENSE.md).
