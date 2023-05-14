# .Net methods to hide the console for .ps1 not .exe
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}
Hide-Console

#Adding the style of the form
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#Creation of the form
$form = New-Object Windows.Forms.Form
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $False
$form.MinimizeBox = $False
$form.Text = "Scheduled shutdown"
$form.Size = New-Object System.Drawing.Size(400,370)
$form.BackColor= "#afafaf"


$label_shutdown = New-Object System.Windows.Forms.Label
$label_shutdown.Size = New-Object System.Drawing.Size(230,50)
$label_shutdown.Location = New-Object System.Drawing.Point(95,50)
$label_shutdown.Text = "Scheduled shutdown in :"
$label_shutdown.Font = New-Object System.Drawing.Font("Century", 14);

$button_ok = New-Object System.Windows.Forms.Button
$button_ok.Text = "OK"
$button_ok.Size = New-Object System.Drawing.Size(150,40)
$button_ok.Location = New-Object System.Drawing.Size(215,220)
$button_ok.BackColor= "#FFFFFF"

$button_cancel = New-Object System.Windows.Forms.Button
$button_cancel.Text = "Cancel"
$button_cancel.Size = New-Object System.Drawing.Size(150,40)
$button_cancel.Location = New-Object System.Drawing.Size(20,220)
$button_cancel.BackColor= "#FFFFFF"

$textbox_hour = New-Object System.Windows.Forms.Textbox
$textbox_hour.Size = New-Object System.Drawing.Size(50,25)
$textbox_hour.Location = New-Object System.Drawing.Size(130,130)

$label_hour = New-Object System.Windows.Forms.Label
$label_hour.Size = New-Object System.Drawing.Size(50,20)
$label_hour.Location = New-Object System.Drawing.Point(180,130)
$label_hour.Text = "h"
$label_hour.Font = New-Object System.Drawing.Font("Century", 12);

$textbox_min = New-Object System.Windows.Forms.Textbox
$textbox_min.Size = New-Object System.Drawing.Size(50,25)
$textbox_min.Location = New-Object System.Drawing.Size(200,130)

$label_min = New-Object System.Windows.Forms.Label
$label_min.Size = New-Object System.Drawing.Size(40,20)
$label_min.Location = New-Object System.Drawing.Point(250,130)
$label_min.Text = "min"
$label_min.Font = New-Object System.Drawing.Font("Century", 12);

$label_sign = New-Object System.Windows.Forms.Label
$label_sign.Size = New-Object System.Drawing.Size(100,30)
$label_sign.Location = New-Object System.Drawing.Point(335,310)
$label_sign.Text = "batbod"
$label_sign.Font = New-Object System.Drawing.Font("Pristina", 13);

$label_date = New-Object System.Windows.Forms.Label
$label_date.Size = New-Object System.Drawing.Size(100,30)
$label_date.Location = New-Object System.Drawing.Point(20,20)
$Label_date.Text = Get-Date -Format "HH:mm"
$label_date.Font = New-Object System.Drawing.Font("Century", 13)

#Conversion in seconds
$button_ok.Add_Click({
$min = $textbox_min.Text
$min = $min -as [int] 
$hour = $textbox_hour.Text
$hour = $hour -as [int]
shutdown -f -s -t (($hour *3600)+($min * 60)) 
})

$button_cancel.Add_Click({shutdown -a})

$Form.controls.AddRange(@($label_shutdown,$button_ok,$button_cancel,$textbox_min,$label_min,$textbox_hour,$label_hour,$label_sign,$label_date))
$form.ShowDialog()
