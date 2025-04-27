# Windows Event Log Parser Script
PS C:\Windows\System32> # Analyzes Application log for errors and warnings
PS C:\Windows\System32> 
PS C:\Windows\System32> # Configuration                
PS C:\Windows\System32> $logName = "Application" # Can change to System or Security
PS C:\Windows\System32> $outputCsv = "$env:PFT\Desktop\EventLogReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
PS C:\Windows\System32> $errorLog = "$env:PFT\Desktop\EventLogErrors_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt" 
PS C:\Windows\System32> $timeSpan = (Get-Date).AddDays(-7) # Last 7 days to ensure events                     
PS C:\Windows\System32> $levels = 2, 3 # 2=Error, 3=Warning                              
PS C:\Windows\System32> 
PS C:\Windows\System32> # Initialize error log
PS C:\Windows\System32> $logContent = "Event Log Analysis Errors - $(Get-Date)`n----------------------------------------`n"
PS C:\Windows\System32> 
PS C:\Windows\System32> # Ensure output directory exists
PS C:\Windows\System32> $outputDir = Split-Path $outputCsv -Parent                                            
PS C:\Windows\System32> if (-not (Test-Path $outputDir)) {
>> New-Item -ItemType Directory -Path $outputDir | Out-Null
>> }
PS C:\Windows\System32> 
PS C:\Windows\System32> # Query event log              
PS C:\Windows\System32> try {                     
>> Write-Host "Querying $logName log for Error and Warning events..." -ForegroundColor Cyan
>> $filter = @{
>> LogName = $logName
>> Level = $levels
>> StartTime = $timeSpan
>> }
>> $events = Get-WinEvent -FilterHashtable $filter -MaxEvents 100 -ErrorAction Stop
>> Write-Host "Found $($events.Count) events." -ForegroundColor Cyan
>> } catch {
>> $errorMsg = "Error querying $logName log: $_"
>> Write-Host $errorMsg -ForegroundColor Red
>> $logContent += "$errorMsg`n"
>> $events = @() # Initialize empty array to prevent foreach error
>> }
Querying Application log for Error and Warning events...
Found 64 events.
PS C:\Windows\System32> # Process events into custom objects
PS C:\Windows\System32> $results = if ($events) {      
>> foreach ($event in $events) {
>> [PSCustomObject]@{
>> TimeCreated = $event.TimeCreated
>> EventID = $event.Id
>> Level = $event.LevelDisplayName
>> Source = $event.ProviderName
>> Message = ($event.Message -replace "`n", " ").Substring(0, [math]::Min(200, $event.Message.Length))
>> }
>> }
>> } else {
>> Write-Host "No events to process." -ForegroundColor Yellow
>> $logContent += "No events found in $logName log for the specified criteria. `n"
>> @() # Return empty arrat
>> }
PS C:\Windows\System32> 
PS C:\Windows\System32> # Display and save results     
PS C:\Windows\System32> if ($results) {                
>> $results | Sort-Object TimeCreated -Descending | Format-Table -AutoSize
>> $results | Export-Csv -Path $outputCsv -NoTypeInformation
>> Write-Host "Analysis complete. Report saved to: $outputCsv" -ForegroundColor Green
>> } else {
>> Write-Host "No results to display or save." -ForegroundColor Yellow
>> }

TimeCreated         EventID Level   Source
-----------         ------- -----   ------             
27/04/2025 13:33:54    1000 Error   Application Error  
27/04/2025 13:33:53    1026 Error   .NET Runtime       
24/04/2025 18:34:47    1008 Warning Microsoft-Windows… 
24/04/2025 18:34:46    1008 Warning Microsoft-Windows… 
24/04/2025 18:34:46    1008 Warning Microsoft-Windows… 
24/04/2025 18:26:48    1008 Warning Microsoft-Windows… 
24/04/2025 18:26:46    1008 Warning Microsoft-Windows… 
24/04/2025 18:26:46    1008 Warning Microsoft-Windows… 
24/04/2025 17:25:50    1000 Error   Application Error  
24/04/2025 17:25:50    1026 Error   .NET Runtime       
24/04/2025 17:25:50       0 Error   SupportAssistAgent 
24/04/2025 17:25:31    1008 Warning Microsoft-Windows… 
24/04/2025 17:25:30    1008 Warning Microsoft-Windows…
24/04/2025 17:25:30    1008 Warning Microsoft-Windows… 
24/04/2025 17:25:29    1008 Warning Microsoft-Windows… 
24/04/2025 17:25:29    1008 Warning Microsoft-Windows… 
24/04/2025 17:25:28    1008 Warning Microsoft-Windows… 
24/04/2025 17:19:50      63 Warning Microsoft-Windows… 
24/04/2025 17:19:50      63 Warning Microsoft-Windows… 
24/04/2025 17:19:50      63 Warning Microsoft-Windows… 
24/04/2025 12:30:21    1026 Error   .NET Runtime       
24/04/2025 12:30:20    1026 Error   .NET Runtime       
24/04/2025 12:21:17    1026 Error   .NET Runtime       
24/04/2025 12:21:15    1026 Error   .NET Runtime       
24/04/2025 11:56:29    1026 Error   .NET Runtime       
24/04/2025 11:56:27    1026 Error   .NET Runtime       
24/04/2025 11:53:22    1026 Error   .NET Runtime       
24/04/2025 11:53:20    1026 Error   .NET Runtime       
24/04/2025 11:52:20    1026 Error   .NET Runtime       
24/04/2025 11:52:17    1026 Error   .NET Runtime       
24/04/2025 11:51:52    1026 Error   .NET Runtime       
24/04/2025 11:51:49    1026 Error   .NET Runtime       
24/04/2025 11:49:40    1026 Error   .NET Runtime       
24/04/2025 11:49:38    1026 Error   .NET Runtime       
24/04/2025 11:35:54    1026 Error   .NET Runtime       
24/04/2025 11:35:51    1026 Error   .NET Runtime       
24/04/2025 11:32:40    1026 Error   .NET Runtime       
24/04/2025 11:29:43    1026 Error   .NET Runtime       
24/04/2025 11:26:39    1026 Error   .NET Runtime       
24/04/2025 11:26:06    1026 Error   .NET Runtime       
24/04/2025 11:20:25    1026 Error   .NET Runtime       
24/04/2025 11:16:38    1026 Error   .NET Runtime       
23/04/2025 18:48:59    1008 Warning Microsoft-Windows… 
23/04/2025 18:48:59    1008 Warning Microsoft-Windows… 
23/04/2025 18:48:59    1008 Warning Microsoft-Windows… 
23/04/2025 18:47:11      63 Warning Microsoft-Windows…
23/04/2025 18:47:11      63 Warning Microsoft-Windows… 
23/04/2025 18:47:11      63 Warning Microsoft-Windows… 
23/04/2025 18:32:19       0         Dell Firmware Upd… 
23/04/2025 18:32:15       0         Dell Firmware Upd… 
23/04/2025 18:32:09       0         Dell Firmware Upd… 
23/04/2025 09:04:49    1000 Error   Application Error  
23/04/2025 09:04:30    1008 Warning Microsoft-Windows… 
23/04/2025 09:04:29    1008 Warning Microsoft-Windows… 
23/04/2025 09:04:29    1008 Warning Microsoft-Windows… 
21/04/2025 11:09:16    1008 Warning Microsoft-Windows… 
21/04/2025 11:09:11    1008 Warning Microsoft-Windows… 
21/04/2025 11:09:11    1008 Warning Microsoft-Windows… 
21/04/2025 11:05:52      63 Warning Microsoft-Windows… 
21/04/2025 11:05:52      63 Warning Microsoft-Windows…
21/04/2025 11:05:52      63 Warning Microsoft-Windows… 
21/04/2025 11:05:41      63 Warning Microsoft-Windows… 
21/04/2025 11:05:41      63 Warning Microsoft-Windows… 
21/04/2025 11:05:41      63 Warning Microsoft-Windows… 

Analysis complete. Report saved to: \Desktop\EventLogReport_20250427_235418.csv
PS C:\Windows\System32> # Save error log
PS C:\Windows\System32> $logContent | Out-File -FilePath $errorLog -Encoding UTF8                             
PS C:\Windows\System32> Write-Host "Errors logged to: $errorLog" -ForegroundColor Cyan
Errors logged to: \Desktop\EventLogErrors_20250427_235436.txt
