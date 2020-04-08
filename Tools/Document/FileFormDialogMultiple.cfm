<cfparam name="CLIENT.DocumentServerPath" default = "">

<cfparam name="url.host"    		default="#SESSION.rootDocumentPath#\">
<cfparam name="url.mode"    		default="attachment">
<cfparam name="url.box"			    default="att1">
<cfparam name="url.dir"     		default="VacCandidate">
<cfparam name="url.id"      		default="cdaf0b9e-1018-0668-4387-e8c390bee314">
<cfparam name="url.id1"			    default="">
<cfparam name="url.reload"  		default="undefined">
<cfparam name="url.documentserver"  default="No">

<cfquery name="Attachment" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
    FROM      Ref_Attachment
	WHERE     DocumentPathName = '#URL.DIR#'	
</cfquery>

<cfif Attachment.recordcount eq 1>

 <cfif URL.DocumentServer neq "No">

		<cfquery name="Parameter" 
		datasource="AppsInit">
			SELECT * 
			FROM Parameter
			WHERE HostName = '#CGI.HTTP_HOST#'
		</cfquery>
	
		<!---- a Document server has been enabled for this IP (e.g. Xythos) 
		CHECK IF THE SERVER IS UP AND IF HE DOES NOT FIND IT, SKIP THE MODE AND MAKE THE DOCUMENTSERVER =1 
		---->	

		<cfif Parameter.DocumentServer neq "">
			<cfset DocumentServerIsOp="1">					
		<cfelse>
			<cfset DocumentServerIsOp="0">
		</cfif>
			
<cfelse>
	
	<cfset DocumentServerIsOp="0">	
		
</cfif>

<cfoutput>

	<script>
	
		 function dialogclose() {
		 
		      try {										    
				parent.document.getElementById("att_#url.box#_refresh").click()			
				parent.document.getElementById('#url.box#_holdercontent_close').click()							
			  } catch(e) {}			
			  
			   try {										    
				parent.document.getElementById("att_#url.box#_refresh").click()			
				parent.ColdFusion.Window.destroy('attachdialog',true)							
			  } catch(e) {}					
		      
		 }
	
		function check() {
		
		if (document.attach.uploadedfile.value == "") {
		   alert("You must select a file to upload.")
		   return false }
		
		<cfoutput>
		
				<cfif DocumentServerIsOp eq "1">
		
					if (document.attach.DocumentServer.value == "") {
					   document.getElementById('busy').className='hide'			   
					   alert("You must select a Document server destination.")
					   return false 
					}
					
				</cfif>
		</cfoutput>	
		   
		}
		
		function browse() {
		
			ret = window.showModalDialog("Xythos/Tree.cfm?Dir=<cfoutput>#URL.DIR#</cfoutput>", window, "unadorned:yes; edge:raised; status:no; dialogHeight:300px; dialogWidth:370px; help:no; scroll:yes; center:yes; resizable:no");
			if (ret) {
				ColdFusion.navigate('FileDocumentSet.cfm?DSP='+ret,'dFile');
				document.getElementById("DocumentServerPath").value = ret;
			}
		}			
		
	</script>

</cfoutput>

<cf_screentop label="Attach documents" scroll="no" html="no" banner="gray" layout="webapp">

<table width="100%" height="100%" style="background-color:e4e4e4" cellspacing="0" cellpadding="0">

	<cfif DocumentServerIsOp eq "1">
	
	<TR>
		<TD align = "center">
			<B><cf_tl id="Document Server"></B>:
			<cfoutput>
			<input type="text" name="DocumentServerPath" id="DocumentServerPath" value="#Client.DocumentServerPath#" size="48" class="regularh" readonly>
			<button name="ServerBrowse" id="ServerBrowse" onclick="javascript:browse()" class="regularh">Save as...</button>
			</cfoutput>
						
		</TD>
	</TR>
	</cfif>	

	<tr><td>
	
	<!---	
	<cf_tableround mode="modal" totalwidth="" totalheight="">
	--->
	
		<cfif attachment.AttachExtensionFilter eq "NONE" or attachment.AttachExtensionFilter eq "">
		
			<cfset filter = "*.*">
			
		<cfelse>
		
			<cfset filter = attachment.AttachExtensionFilter>
		
		</cfif>			
	
		<cf_tl id="Selected Files" var="vSelectFiles">
		<cf_tl id="clear" var="vClear">
		<cf_tl id="delete" var="vDelete">
		<cf_tl id="Attach documents" var="vTitle">
		<cf_tl id="Associate Files" var="vUpload">
	
		<cffileupload
			addbuttonlabel    = "#vSelectFiles#"
			align             = "center"
			bgcolor           = "dadada"
			style             = "selectcolor:gray"
			clearbuttonlabel  = "#vClear#"
			deletebuttonlabel = "#vDelete#"
			height            = "348"
			hideUploadButton  = "false"
			extensionfilter   = "#filter#"
			maxfileselect     = "#Attachment.AttachMultipleFiles#"
			maxuploadsize     = "#Attachment.AttachMultipleSize#"
			onUploadComplete  = "dialogclose"
			name              = "LoadFile"	
			progressbar       = "true"
			stoponerror       = "true"			
			title             = "#vSelectFiles#"
			uploadbuttonlabel = "#vUpload#"
			url               = "FileFormSubmit.cfm?host=#url.host#&mode=#url.mode#&Box=#URL.Box#&DIR=#URL.DIR#&ID=#URL.ID#&ID1=#URL.ID1#&reload=#URL.reload#&pdfconvert=true&DocumentServer=#url.DocumentServer#"
			width             = "500"
			wmode             = "transparent">	
			
		</cffileupload>
	
	<!---	
	</cf_tableround>
	--->
			
	</td>
	
	</tr>
		
</table>	


<cfdiv id="dFile">

<cfelse>
	<table width="100%" bgcolor="white" cellspacing="0" cellpadding="0">
	<tr>
		<td width = "100%">
		Error, configuration library could not be located
		</td>
	</tr>
	</table>
	
</cfif>


