param(
    [int] $tres = '1',
	[string] $xml = 'M:\regHKLM.xml',
    [string] $csv = 'M:\winupdates.csv'
)

# Set variables
$global:csvfileName:string
$global:xmlfileName:string



#1.1.	Сохранить в текстовый файл на диске список запущенных(!) служб. 
#Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
function Write-RunningServiceToFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, HelpMessage="Enter file path with name to save and get content")]
        $txtfileName ='m:\myservices.txt'
    )
    Get-Service | Where-Object {$_.Status -eq "Running"} | Out-File -FilePath $txtfileName
}

function Read-DiskContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, HelpMessage="Enter disk name to get content")]
        $disk='c:'
    )
    Get-ChildItem -Path $disk
}

function Read-FileContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, HelpMessage="Enter file path with name to save and get content")]
        $txtfileName ='c:\myservices.txt'
    )
    Get-Content $txtfileName
}

#1.2.	Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
function Measure-SumOfNumericVariables {
    [CmdletBinding()]
    param()
    (Get-Variable | ForEach-Object { if($_.Value -is [int]) {$_.Value}} | Measure-Object -Sum).Sum
}

#1.3.	Вывести список из 10 процессов занимающих дольше всего процессор.Результат записывать в файл.
function Get-LongestProcesses {
    [CmdletBinding()]
    param()
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
}

#1.3.1.	Организовать запуск скрипта каждые 10 минут
function Set-CustomScheduleTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, HelpMessage="Enter New-JobTrigger settings")]
        $scheduleTask = (New-JobTrigger -Once -At $(Get-Date) -RepetitionInterval(New-TimeSpan -Minutes 10) -RepetitionDuration(New-TimeSpan -Hours 1))
    )
    Register-ScheduledJob -Name StartMyScript -FilePath C:\Scripts\task3_0-1.4.ps1 -Trigger $scheduleTask
}

#1.4.	Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)
function Measure-SizeOfFiles {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, HelpMessage="Enter directory to get files size")]
        $directory='c:\windows\'
    )
    (Get-ChildItem $directory -File -Recurse -Exclude *.tmp | Measure-Object -Sum Length).Sum / 1GB
}

#Write-RunningServiceToFile
#Measure-SizeOfFiles ("m:\vm hd")

#1.5.	Создать один скрипт, объединив 3 задачи:
#1.5.1.	Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
function Write-WinUpdatesToCSV {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, HelpMessage="Enter csv file path with name to save content")]
        $global:csvfileName='M:\winupdates.csv'
    )
    Get-HotFix | Export-Csv $global:csvfileName
}

#1.5.2.	Сохранить в XML-файле информацию о записях одной ветви реестра HKCU:\SOFTWARE\Microsoft.
function Write-HKCUtoXML {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, HelpMessage="Enter xml file path with name to save content")]
        $global:xmlfileName = 'M:\regHKCU.xml'
    )
    Get-ChildItem HKCU:\SOFTWARE\Microsoft | Export-Clixml $global:xmlfileName
}

#1.5.3.	Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка разными цветами
function Read-Content {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, HelpMessage="Enter csv file path with name to read content")]
           [int]$CSVorXML = '3'
           #$CSVorXML = '1' SCV file
           #$CSVorXML = '2' xml
           #$CSVorXML = '3' dual
    )
    Switch ($CSVorXML) {
        1 {Import-Csv $global:csvfileName | Write-Host -ForegroundColor red}
        2 {Import-clixml $global:xmlfileName | Write-Host -ForegroundColor Green}
        3 {
            Import-Csv $global:csvfileName  | Write-Host -ForegroundColor red
            Import-clixml $global:xmlfileName  | Write-Host -ForegroundColor Green
        }
        Default {Write-Host 'Out of range'; exit}
    }
}

#1.5.	Создать один скрипт, объединив 3 задачи:



Write-WinUpdatesToCSV ($csv)
Write-HKCUtoXML ($xml)
Read-Content ($tres)

