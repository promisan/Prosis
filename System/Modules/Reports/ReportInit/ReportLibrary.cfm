
<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="6"></td></tr>		
		<tr><td colspan="1" class="labelmedium">Report Library Files</font></td></tr>
		<tr><td colspan="1" height="1" class="linedotted"></td>
		<tr><td height="6"></td></tr>		

<tr><td>

<cfquery name="Line" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ReportControl
		WHERE  Controlid = '#URL.ControlId#' 
</cfquery>

<cfif Line.Operational eq "0">	
	
		<cf_filelibraryN
		    Mode="report"	
			DocumentHost="report"	    
			DocumentPath="#url.path#"
			SubDirectory="" 
			Filter=""
			LoadScript="No"
			Insert="yes"
			Remove="yes"
			width="99%"		
			AttachDialog="yes"
			align="left"
			border="1">	
			
				
<cfelse>
	
		<cf_filelibraryN
			Mode="report"	
			DocumentHost="report"	    	    	
			DocumentPath="#url.path#"
			SubDirectory="" 
			Filter=""
			LoadScript="No"
			Insert="no"
			Remove="no"
			reload="true"			
			width="99%"
			align="left"
			border="1">	
	
</cfif>	

</td></tr>
</table>

