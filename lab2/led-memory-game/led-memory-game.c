#include "led-memory-game.h"

int main(int argc, char** argv) {
    struct gpiod_chip *chip;
    struct gpiod_line *led1_line,
                      *led2_line,
                      *button1_line,
                      *button2_line;
    int led1_val = 0,
        led2_val = 0;

    // Open the GPIO chip
    chip = ERR_NULL(gpiod_chip_open_by_number(0));

    // Open the GPIO line for the LED
    led1_line = ERR_NULL(gpiod_chip_get_line(chip, LED1_NUM));
    led2_line = ERR_NULL(gpiod_chip_get_line(chip, LED2_NUM));

    // Reserve the LED line for output
    ERR_NEG1(gpiod_line_request_output(led1_line, "led", led1_val));
    ERR_NEG1(gpiod_line_request_output(led2_line, "led", led2_val));

    // Open the GPIO lines for the buttons
    button1_line = ERR_NULL(gpiod_chip_get_line(chip, BUTTON1_NUM));
    button2_line = ERR_NULL(gpiod_chip_get_line(chip, BUTTON2_NUM));

    // Configure the buttons' GPIO lines for event monitoring
    ERR_NEG1(gpiod_line_request_falling_edge_events(button1_line, "button1"));
    ERR_NEG1(gpiod_line_request_falling_edge_events(button2_line, "button2"));

    // Get the file descriptors for the button event signals
    int button1_fd = ERR_NEG1(gpiod_line_event_get_fd(button1_line));
    int button2_fd = ERR_NEG1(gpiod_line_event_get_fd(button2_line));

    // Set up the poll structures for the button file descriptors
    struct pollfd buttonFDs[2];
    buttonFDs[0].fd = button1_fd;
    buttonFDs[0].events = POLLIN;
    buttonFDs[1].fd = button2_fd;
    buttonFDs[1].events = POLLIN;

    printf("Starting poll loop...\n");
    // Loop forever, toggling the LED on button presses
    while (true) {
        // Wait for events on the button file descriptors
        //printf("Polling...\n");
        poll(buttonFDs, 2, -1);
        //printf("Returned from poll\n");

        // Check if button 1 was pressed
        if (buttonFDs[0].revents) {
            if (ERR_NEG1(gpiod_line_get_value(button1_line))) {
                continue;
            }
            printf("Button1 falling edge\n");

            ERR_NEG1(myNanoSleep(DEBOUNCE_SECONDS * GIGA)); // basic debounce strategy?
            if (!ERR_NEG1(gpiod_line_get_value(button1_line))) {
                printf("Button1 debounce complete\n");

                led1_val = !led1_val;
                ERR_NEG1(gpiod_line_set_value(led1_line, led1_val));
            }
        }

        // Check if button 2 was pressed
        if (buttonFDs[1].revents) {

            if (ERR_NEG1(gpiod_line_get_value(button2_line))) {
                continue;
            }
            printf("Button2 falling edge\n");

            ERR_NEG1(myNanoSleep(DEBOUNCE_SECONDS * GIGA));
            if (!ERR_NEG1(gpiod_line_get_value(button2_line))) {
                printf("Button2 debounce complete\n");

                led2val = !led2_val;
                ERR_NEG1(gpiod_line_set_value(led2_line, led2_val));
            }
        }
    }

    // Release the GPIO lines and close the GPIO chip
    gpiod_line_release(led1_line);
    gpiod_line_release(button1_line);
    gpiod_line_release(button2_line);
    gpiod_chip_close(chip);
    return 0;
}

int oldmain(int argc, char **argv) {
    struct gpiod_chip *chip;
    struct gpiod_line *line;
    int LED1_NUM = 24; // GPIO number for the LED
    int val = 0; // current value of the LED

    // Open the GPIO chip
    chip = ERR_NULL(gpiod_chip_open_by_number(0));

    // Open the GPIO line for the LED
    line = ERR_NULL(gpiod_chip_get_line(chip, LED1_NUM));

    // Set the GPIO line to output mode
    ERR_NEG(gpiod_line_request_output(line, "led", val));

    // Blink the LED
    while (1) {
        val = !val;
        ERR_NEG(gpiod_line_set_value(line, val));
        myNanoSleep(GIGA * 1.2);
    }

    // Release the GPIO line and close the GPIO chip
    // TODO: goto on ERRs?
release_line:
    gpiod_line_release(line);
close_chip:
    gpiod_chip_close(chip);
    return 0;
}

// simplified from my: https://github.com/Ekatwikz/katwikOpsys/blob/main/src/randAndSleep.c
// sliightly easier than dealing with the struct imo?
static int myNanoSleep (long nanoseconds) {
    struct timespec time;
    time.tv_sec = nanoseconds / GIGA; // int division
    time.tv_nsec = nanoseconds % GIGA;

    return nanosleep(&time, &time);
}
