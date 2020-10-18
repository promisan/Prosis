		
<!--- parameters --->

<cfquery name="Param" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
    FROM      Parameter	
</cfquery>

<cfif Param.DisableDocument eq "1">

	<table width="100%" 
	     cellspacing="0" 
		 cellpadding="0">

			<tr><td height="24" class="labelit" bgcolor="ffffcf" align="center">Please note that Document Management Facility was temporarily disabled.</td></tr>
			
	</table>
		
<cfelse>

	<cfparam name="attributes.refresh"         default="yes"> 	
	<cfparam name="row"                        default="0">
	
	<cf_tl class="message" id="Remove document" var="1">
		
	<CFParam name="Attributes.mode"            default="attachment">
	<CFParam name="Attributes.List"            default="regular"> <!--- hightlight document row --->
	
	<CFParam name="Attributes.ButtonHeight"    default="22">	
	<CFParam name="Attributes.Label"           default="attach">
	
	<CFParam name="Attributes.DocumentServer"  default="No">		
	<CFParam name="Attributes.DocumentHost"    default="#SESSION.rootDocumentPath#\"> <!--- default as defined in parameter.dbo.parameter --->	
				
	<cfif Attributes.DocumentHost eq "">
	   <cfset attributes.documenthost = "#SESSION.rootDocumentPath#\">	
	</cfif>			
		
	<!--- check if the attachment feature is registered --->
		
	<cfif attributes.documentHost neq "report" 
	    and Attributes.DocumentPath neq "" 
		and not find(Attributes.DocumentPath,"\")
		and not find(Attributes.DocumentPath,"/")>
		
		<cfquery name="Attachment" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
		    FROM      System.dbo.Ref_Attachment
			WHERE     DocumentPathName = '#Attributes.DocumentPath#'	
		</cfquery>
		
		<cfif Attachment.recordcount eq "0">
		
			<cfquery name="Insert" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO System.dbo.Ref_Attachment
					(DocumentPathName, DocumentFileServerRoot)
				VALUES
					('#Attributes.DocumentPath#','#attributes.DocumentHost#')		
			</cfquery>
			
		<cfelseif Attachment.DocumentFileServerRoot eq "">
		
			<cfquery name="Update" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE   System.dbo.Ref_Attachment
				SET      DocumentFileServerRoot = '#attributes.DocumentHost#'
				WHERE    DocumentPathName       = '#Attributes.DocumentPath#'			
			</cfquery>	
			
		<cfelse>	
			
			<cfset Attributes.DocumentHost = Attachment.DocumentFileServerRoot>
			<cfif Attachment.AttachMultiple eq "1">
				<cfset Attributes.Mode = "attachmentmultiple">			
			</cfif>	
		
		</cfif>		
	
	</cfif>								
	
	<CFParam name="Attributes.insert"          default="no">
	<CFParam name="Attributes.remove"          default="no">
	
	<CFParam name="Attributes.row"             default="1">	   <!--- not clear for which is is used 1/8/2013 --->
	
	<CFParam name="Attributes.loadscript"      default="yes">
	<CFParam name="Attributes.embedgraphic"    default="yes">
	<CFParam name="Attributes.pdfscript"       default="">
	
	<!--- main container settings --->
	<CFParam name="Attributes.ShowSize"        default="1">       <!--- shows the size of the attachment in the listing --->
	<CFParam name="Attributes.Listing"         default="1">   <!--- show the listing box --->
	<CFParam name="Attributes.Color"           default="white">
	
	<CFParam name="Attributes.box"             default="documentbox">  <!--- id --->
	<CFParam name="Attributes.rowheader"       default="no">	
	<CFParam name="Attributes.width"           default="100%">
	<CFParam name="Attributes.style"           default="">  <!--- style of the mian box --->
	<CFParam name="Attributes.align"           default="center">	
	<CFParam name="Attributes.memo"            default="">
	<CFParam name="Attributes.border"          default="0">
	<CFParam name="Attributes.maxfiles"        default="200">
	<CFParam name="Attributes.attachdialog"    default="Yes">	
	<CFParam name="Attributes.inputsize"       default="500">
	<CFParam name="Attributes.presentation"    default="default">
	
	<!--- log the attached document as part of the database action --->
	<CFParam name="Attributes.logdocument"     default="No">
	<CFParam name="Attributes.refresh"         default="No">
	
	<cfif attributes.loadscript eq "yes">
		<cfinclude template="FileLibraryScript.cfm">
	</cfif>	
	
	<cfset mode           = Attributes.mode> 
	<cfset DocumentPath   = Attributes.DocumentPath> 
	<cfset subdirectory   = Attributes.subdirectory> 
	<cfset filter         = Attributes.filter> 
	<cfset Memo           = Attributes.Memo> 
	<cfset DocumentHost   = Attributes.DocumentHost> 
	<cfset ShowSize       = Attributes.ShowSize>
	<cfset Listing        = Attributes.Listing>
	<cfset List           = Attributes.List> 
	<cfset ShowSize       = Attributes.ShowSize>
	<cfset Listing        = Attributes.Listing>
	<cfset MaxFiles       = Attributes.MaxFiles> 
	<cfset insert         = Attributes.Insert>
	<cfset remove         = Attributes.remove>
	<cfset Color          = Attributes.Color>
	<cfset embedgraphic   = Attributes.embedgraphic>
	<cfset attbox         = Attributes.box>
	<cfset rowheader      = Attributes.rowheader>
	<cfset boxw           = Attributes.width>
	<cfset align          = Attributes.Align>
	<cfset border         = Attributes.border>
	<cfset attachdialog   = Attributes.attachdialog>
	<cfset inputsize      = Attributes.InputSize>
	<cfset pdfscript      = Attributes.PDFScript>
	<cfset DocumentServer = Attributes.documentserver>
	<cfset Presentation   = Attributes.presentation>
			
	<cfset cnt = "0">
	
	<cfif mode eq "Report">
	    <cfset rt = "">
	<cfelse>
		<cfset rt = "#documenthost#">
	</cfif>	
			
	<cfoutput>		
		
	<table width="#boxw#" border="0" cellspacing="0" cellpadding="0" style="#attributes.style#" bgcolor="#attributes.color#">
	
	<tr><td id="#attributes.box#_holder"></td></tr>
		
	<tr class="labelit">
	    <cfif attributes.listing eq "1">
			<td id="att_<cfoutput>#attributes.box#</cfoutput>">			
		<cfelse>
			<td>			
		</cfif>
										
		<cfinclude template="FileLibraryShow.cfm">					
						
		</td>
	</tr>
	</table>
	
	</cfoutput>
			
	<cfset caller.row = row>	

</cfif>



