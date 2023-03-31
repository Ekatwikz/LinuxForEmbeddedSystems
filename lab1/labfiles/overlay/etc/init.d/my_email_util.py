import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email(subject: str, body: str, to_email: str, smtp_server: str, smtp_port: int, smtp_username: str, smtp_password: str) -> None:
    """Send an email using the specified SMTP server.

    Parameters:
    subject (str): The subject line of the email.
    body (str): The body of the email.
    to_email (str): The email address of the recipient.
    smtp_server (str): The hostname of the SMTP server.
    smtp_port (int): The port number of the SMTP server.
    smtp_username (str): The username for authenticating with the SMTP server.
    smtp_password (str): The password for authenticating with the SMTP server.

    Returns:
    None: This function does not return anything.
    """

    # Set up connection to SMTP server
    server = smtplib.SMTP(smtp_server, smtp_port)
    server.starttls()
    server.login(smtp_username, smtp_password)

    # Compose email
    msg = MIMEMultipart()
    msg['From'] = smtp_username
    msg['To'] = to_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    # Send email
    server.sendmail(smtp_username, to_email, msg.as_string())

    # Close connection to SMTP server
    server.quit()
