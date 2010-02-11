/**
 * SecuritySensors
 *
 * Reads the state of security sensors such as PIR motion detectors
 * connected to analog inputs using EOL (end-of-line) circuitry to
 * prevent tampering. The state of each input is reported back to a
 * connected host via USB.
 *
 * Note that the "checkSensor" function returns a state value that is
 * not used in this example. This is to allow the sketch to be simply
 * modified to perform logic on the return value, such as asserting
 * an output for a determined period if an input is triggered.
 *
 * Copyright 2009 Jonathan Oxer <jon@oxer.com.au>
 * Copyright 2009 Hugh Blemings <hugh@blemings.org>
 * http://www.practicalarduino.com/projects/security-sensors
 */

// Use analog inputs 0 through 3 for sensor connections A through D
byte channelAInput = 0;
byte channelBInput = 1;
byte channelCInput = 2;
byte channelDInput = 3;

// Use digital outputs 4 through 7 for status indicator LEDs A through D
byte channelALed = 4;
byte channelBLed = 5;
byte channelCLed = 6;
byte channelDLed = 7;

/**
 * Initial configuration
 */
void setup()
{
  Serial.begin(38400);  // Use the serial port to report back readings

  pinMode(channelALed, OUTPUT);   // Set up channel A
  digitalWrite(channelALed, LOW);
  pinMode(channelBLed, OUTPUT);   // Set up channel B
  digitalWrite(channelBLed, LOW);
  pinMode(channelCLed, OUTPUT);   // Set up channel C
  digitalWrite(channelCLed, LOW);
  pinMode(channelDLed, OUTPUT);   // Set up channel D
  digitalWrite(channelDLed, LOW);
}

/**
 * Main program loop
 */
void loop()
{
  byte sensorStatus;
  sensorStatus = checkSensor(channelAInput, channelALed);
  sensorStatus = checkSensor(channelBInput, channelBLed);
  sensorStatus = checkSensor(channelCInput, channelCLed);
  sensorStatus = checkSensor(channelDInput, channelDLed);

  Serial.println("");
  delay(500);   // Wait half a second before reading all channels again
}

/**
 * Checks the state of a sensor and reports it to the connected host
 */
boolean checkSensor( byte sensorInput, byte statusOutput )
{
  byte state;
  int sensorReading = analogRead(sensorInput);
  if( sensorReading < 400 ) {
    state = 0;                        // Wire shorted. Possible tampering.
    digitalWrite(statusOutput, HIGH); // Turn the associated status LED on
  } else if ( sensorReading >= 400 && sensorReading < 590 ) {
    state = 1;                        // Normal state, sensor not triggered
    digitalWrite(statusOutput, LOW); // Turn the associated status LED off
  } else if ( sensorReading >= 590 && sensorReading < 800 ) {
    state = 2;                        // Sensor triggered.
    digitalWrite(statusOutput, HIGH); // turn the associated status LED on
  } else {
    state = 3;                        // Open circuit. Cut or tamper triggered.
    digitalWrite(statusOutput, HIGH); // Turn the associated status LED on
  }
  // Output the current reading to the host via the serial connection
  Serial.print(sensorInput, DEC);
  Serial.print(": ");
  Serial.print(sensorReading, DEC);
  Serial.print(" (");
  Serial.print(state, DEC);
  Serial.print(") ");
  // Pass the current state back to the calling function
  return state;
}
