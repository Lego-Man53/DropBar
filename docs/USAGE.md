# Using DropBar

## Send files with the floating drop area

1. Open DropBar from Applications. A **Drop** item appears in the menu bar and a floating drop area opens.
2. Open Finder or use a file on your Desktop. Select one or more files.
3. Drag the selection onto **Drop files here**. The border highlights and the message changes to **Release to AirDrop**.
4. Release the files. Apple's AirDrop chooser opens.
5. Click the intended device and let the recipient accept if prompted.

Closing the floating area keeps DropBar running. Click **Drop** to show it again. The area stays visible when Finder becomes active. It hides when the AirDrop chooser opens.

## Other ways to send

- **Direct drop:** drag files onto the **Drop** menu bar item. Use the floating area if the screen edge interferes.
- **File picker:** click inside the floating area, or right-click **Drop → AirDrop Files…**, select files, and click **AirDrop**.
- **Finder:** right-click **Drop → Open AirDrop in Finder** to open Apple's own AirDrop interface.

DropBar sends local files and folders when the system AirDrop service accepts them. Text snippets, web links, browser downloads still in progress, and promised attachments dragged directly from some apps are not supported; save those files in Finder first. Download cloud-only files before sharing them. Sending does not move or delete the original.

## Quit

Right-click **Drop** in the menu bar and choose **Quit DropBar**. Closing the floating window only hides that window.

## Troubleshooting

### Dragging toward the menu bar opens all windows or the Desktop

The screen edge or a configured Hot Corner can invoke macOS Mission Control or Desktop behavior. Click **Drop** first, then drag into the larger floating drop area below the menu bar. You do not need to change system settings.

### No receiving devices appear

Keep the devices nearby and awake. Check Wi-Fi and Bluetooth on both. Ensure the receiver's AirDrop setting permits you to discover it; **Contacts Only** requires the appropriate contact details, while an iPhone or iPad can temporarily use **Everyone for 10 Minutes**. See [Apple's AirDrop guide](https://support.apple.com/en-gb/guide/mac-help/-mh35868/mac).

If Finder's AirDrop cannot see the device either, troubleshoot AirDrop itself first. DropBar uses the same system service.

### A file is unavailable or the drop is rejected

Download the file from iCloud Drive, OneDrive, or another cloud provider first. Check that it still exists and can be opened in Finder. Save mail attachments or browser content to a local file before dropping. Try one ordinary local file to isolate the problem.

### The Drop item is missing

Open DropBar from Applications. Exit full-screen mode or reveal the menu bar if it is hidden. On Macs with a notch or many menu bar items, available space may be limited. Closing the floating panel does not remove the menu bar item.

### Nothing happens, or AirDrop fails

Try the file picker in DropBar and then Finder's AirDrop with the same file. Quit and reopen DropBar. If only DropBar fails, [report a bug](https://github.com/Lego-Man53/DropBar/issues/new/choose) with your macOS version, Mac chip, source app, and exact steps. Avoid attaching private files or screenshots containing personal information.

## Privacy and permissions

DropBar has no analytics, accounts, server, or transfer history. It passes the files you select or drop to Apple's `NSSharingService`; macOS handles discovery, recipient selection, and transfer. This does not make claims about Apple's own service implementation or diagnostics. DropBar does not request Accessibility or Screen Recording permission and does not change network settings. macOS may request normal access to a selected file's location.
