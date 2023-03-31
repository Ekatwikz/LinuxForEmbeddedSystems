#!/usr/bin/env python3

from my_email_util import send_email
from time import gmtime, strftime

print("Sending shutdown email...")
send_email('System shutdown!',
    f"{__file__} at {strftime('%d/%m/%Y %H:%M:%S', gmtime())}:\nLe system is die! :O",
    'ekatwikz@gmail.com',

    'smtp.office365.com',
    587,
    'startupscript@outlook.com',
    'donthackmE!')
print("Shutdown email sent.")

