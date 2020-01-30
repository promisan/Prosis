
<cfquery name="Observation" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Observation
	  WHERE  ObservationId IN (SELECT ObjectKeyValue4 
	                           FROM   Organization.dbo.OrganizationObject
							   WHERE  ObjectId = '#URL.ObjectId#' 							  
							 )	 
	  OR    ObservationId = '#URL.ObjectId#'						 
</cfquery>

<cfif Observation.recordcount eq "0">
	
	<table width="100%" align="center" height="40" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="labelit" style="padding-left:30px"><font color="FF0000">Template object not supported</font></td></tr>
	</table>

<cfelse>
	
	<cfoutput>
	
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		
			<tr><td height="2"></td></tr>
			
			<cfset url.box = "b#url.box#">
			
			<cfset link = "#SESSION.root#/tools/entityaction/details/template/TemplateFile.cfm?box=#url.box#||actioncode=#ActionCode#||observationid=#observation.observationid#">
					
			<tr><td height="20" colspan="6" align="left" class="labelmediumcl">
			
			   <cf_selectlookup
			    class    = "Template"
			    box      = "#url.box#"
				title    = "Record a Template subject of modification"
				link     = "#link#"		
				width="800"	
				dbtable  = "Control.dbo.ObservationTemplate"
				des1     = "PathName"
				des2     = "FileName">
						
			</td>
			</tr> 				
			
			<tr bgcolor="ffffff">
		    <td width="100%" colspan="2" class="labelit" id="#url.box#">				
				<cfdiv bind="url:#SESSION.root#/tools/entityaction/details/template/TemplateFile.cfm?box=#url.box#&Observationid=#observation.ObservationId#&ActionCode=#ActionCode#"/>		
			</td>
			</tr>  
			
			<tr><td colspan="6" bgcolor="DADADA"></td></tr> 		
		
	    </table>
	      
	</cfoutput>

</cfif>