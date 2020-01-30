
<cfparam name="url.delete" default="">
		
		
	<cfif url.delete neq "">
		<cftry>
			<cffile action = "delete" file = "#SESSION.rootDocumentPath#\EmployeeFiles\#SESSION.acc#\#url.delete#">

		<cfcatch></cfcatch>
		</cftry>
		
	</cfif>
	
	
	<cftry>
		<cfdirectory directory="#SESSION.rootDocumentPath#\EmployeeFiles\#SESSION.acc#" name="mydirectory" sort="name DESC, datelastmodified">
		
		<cfset cntf = "0">
		
		<cfoutput query="mydirectory" maxrows="12">
			<cfif mydirectory.name contains ".">
			
				<cfset cntf = cntf+1>
			
				<cfif cntf lte "4">
					<cfset class="fileitemfirstrow">
				<cfelseif cntf gte "5" and cntf lte "8">
					<cfset class="fileitemcenter">
				<cfelse>
					<cfset class="fileitemlastrow">
				</cfif>
				
					<cfset FileExt=ListLast(mydirectory.name,".")>
					
					<cfif mydirectory.name neq "#SESSION.acc#_notes.txt">
					
					<div class="fileitem #class#" id="#mydirectory.name#" 
					title="File Name: #mydirectory.name# &##13;Size: #NumberFormat( mydirectory.size/1024, "99.99" )#KB &##13;Last Modified: #mydirectory.dateLastModified# &##13;&##13;<cf_tl id="To Download right-click Save target as" class="message">">
						<div class="widrelwrapper">
						<a href="#SESSION.rootDocument#/EmployeeFiles/#SESSION.acc#/#mydirectory.name#" target="_blank" class="downloadfile">
						<cfif FileExt neq "">
							<cfif FileExt eq "doc" or FileExt eq "docx">
								<img src="images/icons/WordIcon.png">
							<cfelseif FileExt eq "xls" or FileExt eq "xlsx">
								<img src="images/icons/ExcelIcon.gif">
							<cfelseif FileExt eq "ppt" or FileExt eq "pptx">
								<img src="images/icons/PowerPointIcon.png">
							<cfelseif FileExt eq "pdf">
								<img src="images/icons/PDFIcon.png">
							<cfelseif FileExt eq "jpg" or FileExt eq "jpeg" or FileExt eq "png">
								<img src="images/icons/JPGIcon.png">				
							<cfelseif FileExt eq "gif">
								<img src="images/icons/GIFIcon.png">
							<cfelseif FileExt eq "txt">
								<img src="images/icons/TXTIcon.png">
							<cfelseif FileExt eq "zip">
								<img src="images/icons/ZIPIcon.gif">
							<cfelse>
								<img src="images/icons/FileIcon.png">
							</cfif>
						<cfelse>
							<img src="images/icons/FileIcon.png">
						</cfif>
						</a>
						<span>#Left(mydirectory.name, 7)#</span>
						<div class="filedelete" onclick="filedelete(this)">X</div>
						</div>
					</div>
					
					</cfif>
			</cfif>

		</cfoutput>
	
		<cfcatch></cfcatch>
	</cftry>