# Scan And Repair (SNR) Pseudo Code

### Changelog 18/10/23
	# Ran tests of the current code in Windows Sandbox
	# Running tests helped me find and make multiple fixes
	# Made Optimizations to the code
	# Merged Differences between forks of the code

### Changelog 13/10/23
    # Made each area of scan and repair a callable script block
    # Added more documentation by comments in each Segment
    # Made Fixes and Updates

### Changelog 12/10/23
    # Optimised script
    # Removed redundant variables
    # Made Fixes


# Setup

	$hostname = hostname
	
	$currentTime = Get-Date -Format 'dd_MM_yy_HHmm'
	
	$FileHost = "$hostname - $currentTime"
	
	
	
	# Create necessary directories
	
	$directories = @("Hardware", "Operating System", "Storage", "Network")
	
	foreach ($dir in $directories) {        # For each variable in the array
	
		mkdir "$FileHost\$dir"          # Creates a directory with the given name
	
	}

	# Hardware
$HardwareScan = {
	# Gets a report of the machine's battery and exports to a viewable html file
	powercfg /batteryreport /output "$Filehost\Hardware\$filename-BatteryReport.html"
}
&$HardwareScan
	# Operating System
$OperatingSystem = {
	# SFC Scan
	# Runs and SFC Scan
	sfc /scannow
	# Copys the contents of and exports the Machines existing CBS Log to an output file
	Copy-Item -Path "C:\Windows\Logs\CBS\CBS.log" -Destination "$Filehost\Operating System\SFC_Results.txt"
	
	
	
	# Dism Scan
	
	DISM /Online /Cleanup-Image /CheckHealth
	
	DISM /Online /Cleanup-Image /ScanHealth
	
	DISM /Online /Cleanup-Image /RestoreHealth /Source:repairSource\install.wim
	
	# Copys the contents of and exports the Machines existing DISM Log to an output file
	Copy-Item -Path "C:\Windows\Logs\DISM\dism.log" -Destination "$Filehost\Operating System\DISM_Results.txt"
}
&$OperatingSystem
	
	# Storage
$StorageProcedure = {
		# Get List of Disks Connected to Machine 
		# Comes with name, serial number, health status, storage size, parition style. etc
	Get-Disk | format-table -auto | out-file -FilePath "$Filehost\Storage\DiskReport.txt"
	
	
	$initialFreeSpace = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq "C:\" } | Select-Object -ExpandProperty Free
	
	Clear-RecycleBin
	# Remove system and user temp files
	
	$tempPaths = @("C:\Windows\Temp", "C:\Users\*\AppData\Local\Temp", "C:\Temp\")  # Stores directories to an array
	
	foreach ($path in $tempPaths) {
		# For each item in the array run the below code that clears the contents of the directory at that variable
		Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
	
	}
	
	
	
	# Run cleanmgr.exe
	Start-Process cleanmgr.exe -Wait
	
	
	
	# Calculate and log the amount of cleaned space
	$finalFreeSpace = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq "C:\" } | Select-Object -ExpandProperty Free
	$cleanedSpace = $initialFreeSpace - $finalFreeSpace
	"Cleaned: $($cleanedSpace / 1GB) GB" >> "$Filehost\Storage\TotalCleaned.txt"
	
	$StorageComments= {
		# Ideas to Implement 
			# Run a scan on the system storage for corrupted files
			# Restrict to local drives (Network drives get ignored)
		
			# Combine the two commands into one pipeline to optimize the code
		
				#    Get-WmiObject -Query "Select * From Win32_LogicalDisk Where DriveType = '3'" | ForEach-Object {
		
					# chkdsk $_.DeviceID /r /f | Out-File -Append -FilePath "$FileHost\Storage\Repair.log"
		
					# Repair-Volume -DriveLetter $_.DeviceID -Scan -OfflineScanAndFix | Out-File -Append -FilePath "$FileHost\Storage\Repair.log"
		
		
		
		
				# ^^ need to look for powershell variant that allows chdisk.  OR use cmd /c to call a batch command in powershell
		
			
		
				# Storage Features to add
		
					# Hard Disk Sentinel? 
		
						# for Drive smart status?
		
						# Export results
		
						# CCleaner                                                                       - Would not work in an msp environment
		
						# Run automatically and clean any and all junk files 
		
		
		
					# WizTree / WindirStat                                                          - Review of Documentation of both softwares is needed
		
						# Run Be4 and After the above Inputs&Export results / graphs  
		
							# Depending on the msp environment this may be achievable 
		
								# Would need to run as admin or in a portable file rather than full install
		
								# Above Lines Contain Notes
			}
			&$StorageComments
}
&$StorageProcedure
	
$NetworkProcedures = {
    # Runs Ipconfig and gets a list of all network configs saved to the device
    ipconfig /all | Out-File -FilePath "$FileHost\Network\ipconfig.log"
    # Runs arp to get a list of all visible network addresses from machine
    arp -a -v | Out-File -FilePath "$FileHost\Network\arp.log"


}

&$NetworkProcedures
	
	
	
	
	# Network
	
		# IPconfig
	
			# Export Results                                                    ipconfig /all | Out-File -filepath " Network\ipconfig.txt
	
		# ARP 
	
			# arp -a -v | Out-File -Filepath "Network\ArpResult.txt"
	
				# Run a whois / tracert to identify machine ids
	
				# For for each address visible from the network devices
	
					# Tracert
	
					# Localised NMap - top 10 ports // 
	
						# If a more indepth scan repair and report is cited or developed
	
							# Run to scan top 100-1000 ports
	
			
	
							# Export results
	
				# Enumerate Devices Visible
	
					# Match eligible devices up with ipconfig
	
						# For example if any visible addresses match dns server
	
						# match network route gateway thing (router)                
	
		# Ping Requests
	
			# Ping localhost / Network Gateway
	
			# Ping 8.8.8.8
	
			# Ping other common dns hosts
	
			# Ping DNS Gateway ( Pulled from IP config )
	
		# Get a map of the machines view of the network
	
			# Use network mapping tool here?
	
			# Export as a graph / table on some level
	
		
	
		
	
		# Run a speed test                                              - Not going to work in an msp environment as this would get ratelimited by any firewall system for hogging bandwidth
	
			# Export results to network subsect report
	
		
	
		# If any issues are noticed here
	
			# Ie. connected but no internet             - Run Ping to a Domain or URL to check for this
	
	
	
			# Or possible incorrect configs             - Also unsure how to check for this as you would need a "correct config" to crossreference | Could be base on a preset "list" of common configs or if there are any signs of misconfig 
	
	
	
				# Run Network Flush                     - ipconfig /flushdns ...
	
	
	
				# Include the code for standard ip config flushes
	
					# ipconfig /release
	
					# ipconfig /flushdns
	
					# ipconfig /renew
	
					
	
			# Note any networks/ network settings of concern
	
				# This can include
	
					# Public networks like free wifi - Check for Networks without authentication or outdate / insecure configurations ie. open unauthed networks
	
					# Possible Rogue APs                                    - Unsure how this could be identified - might be too ambitious
	
					# Network configurations that could cause issues        - Would have been covered in the previous "possible incorrect configs or the "if any issues are noticed here"
	
					# Previous network traffic to possibly compromised websites     - Would need to review windows firewall logs. - unsure if local machines record network activity to that extend - would also need a connection to the internet
	
					# Deauth Packets received / sent                        - would be recorded by an onprem firewall - too ambitius
	
	
	
	
	
			# Compile final network report
	
		# Export to Mega Report
	
	
	
			
	
	##IDEAS TO IMPLEMENT?###
	
		# Pull and run tronscript?  [Smart idea, would need to look into deeper functions of this] - Running after as a "final clean" would need to call specific argument so redundant cleanups are not Run
	
		# Pull and run ClamAV scan? [^^]
	
	
	
		# Grab and export reliability reports & battery scan - Battery Report can be done easily
	
		
	
		# Grab a specs list where possible and export 
	
	
	
	# Common issue resolutions like printer spooler resets????
	
		# Check printer configurations
	
		# Confirm drivers based on printer name / settings
	
		# Needs web request to pull printer driver versions?
	
	
	
	## report idea ###
	
		# Get all exported reports and compile
	
		# into dedicated sectors or compile all into a mega report
	
		# Mega report including all work done including times and 
	
		# commands where required including detailed results
	
	## report idea ###
	
	 
	
		# Utilise the "progress saving" function from TronScript that 
	
		# Logs what segment it is up to so if there is a reboot or the progress gets interrupted
	
		# you can return to the scripts by rerunning it and it will continue as normal