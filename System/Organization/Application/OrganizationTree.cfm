
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfparam name="URL.unitselect" default="0">

<!--- query --->

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr valign="top"><td height="100%">

<table width="100%" align="center">

<cfoutput>

<cfif url.mode eq "regular">

	<!--- check for tree role manager --->

	<cfinvoke component = "Service.Access"  
	   method           = "RoleAccess" 
	   role             = "'TreeRoleManager'"
	   mission          = "#url.id2#"	   
	   returnvariable   = "access">	
	   
	<cfif access eq "GRANTED">
				
		<tr><td style="padding:4px;padding-left:7px" class="labelmedium">			
			<a href="MissionEdit.cfm?id2=#url.id2#" target="right" title="Tree Configuration Settings">
			<cf_tl id="Settings and Modules">
		    </a></td>
		</tr>
		
		<tr><td style="padding:4px;padding-left:7px" class="labelmedium">			
			<a href="AuthorizationListing.cfm?scope=tree&id2=#url.id2#" target="right" title="Tree Configuration Settings">
			<cf_tl id="Authorization">
		    </a>
			</td>
		</tr>
		
		<tr class="line"><td></td></tr>
	
	</cfif>
		
</cfif>	  

</cfoutput>

<cfform>

<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT   *
      FROM     Ref_Mandate
   	  WHERE    Mission = '#URL.ID2#' 
	  ORDER BY DateEffective DESC
  </cfquery>
  
<cfif Mandate.RecordCount eq 1>  
	   	  
	<tr><td align="center" valign="top" height="100%">

			<table width="96%" height="100%" align="center">
			<tr><td valign="top" style="padding-top:5px">
			
			<cf_UItree name="tree#Mandate.Mandateno#" bold="No" format="html" required="No">
			     <cf_UItreeitem
				  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.id2#','#Mandate.Mandateno#','OrganizationListing.cfm','MAN','#url.id2#','#URL.ID2#','#Mandate.Mandateno#','#url.mode#','','#url.unitselect#')">
		    </cf_UItree>
					
			</td></tr>
			</table>
			
	</td></tr> 	

<cfelse>
	
	<cfoutput query="Mandate">
				   	  
	<tr><td align="center" valign="top">
			<table width="96%" align="center">
			<tr valign="top"><td >	
			
			<cf_UItree name="tree#mandateNo#" format="html" required="No">
			     <cf_UItreeitem
				  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.id2#','#Mandateno#','OrganizationListing.cfm','MAN','#url.id2#','#URL.ID2#','#Mandate.Mandateno#','#url.mode#','','#url.unitselect#')">
			</cf_UItree>
			
			</td></tr>
			</table>
	</td></tr> 	
	<tr><td class="line" height="1"></td></tr> 
	 
	</cfoutput>

</cfif>

</cfform>

</table>

</td></tr>

</table>
