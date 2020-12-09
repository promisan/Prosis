
<CFParam name="Attributes.mode"            default="attachment">
<CFParam name="Attributes.target"          default="">
<CFParam name="Attributes.filter"          default="">
<CFParam name="Attributes.attachdialog"    default="Yes">	
<CFParam name="Attributes.pdfscript"       default="">
<CFParam name="Attributes.memo"            default="">

<cfquery name="Attachment" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
    FROM      Ref_Attachment
	WHERE     DocumentPathName = '#Attributes.DocumentPath#'	
</cfquery>
				
<cfif Attachment.recordcount eq "1">

    <cfparam name="Attributes.DocumentHost"    
	         default="#attachment.documentfileserverroot#">
			 
<cfelse>

	<cfparam name="Attributes.DocumentHost"    
	         default="#SESSION.rootDocumentPath#\">
</cfif>		

<cfdirectory action="LIST"
   directory="#Attributes.DocumentHost#\#attributes.DocumentPath#\#attributes.SubDirectory#"
   name="GetFiles"
   filter="#attributes.Filter#*.*"
   listinfo="name">  
      
<cfif attributes.target neq "" and getfiles.recordcount eq "0">

		<cfsavecontent variable="selectme">
        		style="height:20px;cursor: pointer;border: 1px solid silver"
				onMouseOver="this.className='highlight1'"
				onMouseOut="this.className='regular'"
		</cfsavecontent>

		<cfoutput>
		    
			<table><tr>
			<td align="center" width="120" 
				onclick="addfile('#attributes.mode#','#Replace(attributes.DocumentHost,'\','\\','all')#','#attributes.DocumentPath#','#attributes.Subdirectory#','#attributes.Filter#','#attributes.target#','1','No','#attributes.attachdialog#','#attributes.pdfscript#','#attributes.memo#')" #selectme#>				
				<img src="#SESSION.root#/Images/Attach.png" width="24" height="23"
					alt="Attach document" 
				     alt="Attach document" 
					 border="0"
					 align="absmiddle">
				<span style="padding-top:2px"><cf_tl id="Attach"></span>
			</td>
			</tr></table>
		</cfoutput>	

</cfif>   

<CFSET Caller.Files = getfiles.recordcount>   
