
<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT E.*
    FROM  Ref_EntityStatus E
	WHERE E.EntityCode = '#URL.EntityCode#'
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
	
<cfform action="ObjectStatusSubmit.cfm?EntityCode=#URL.EntityCode#&ID2=#URL.ID2#" method="POST" enablecab="Yes" name="action">

	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="right">
	 <tr><td height="4"></td></tr>   
	  <tr>
	    <td width="100%" class="regular">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
			
	    <TR class="line labelmedium">
		   <td width="40" align="center">Code</td>
		   <td width="80%">Description</td>
		   <td width="6%" align="center">Active</td>
		   <td width="7%" align="right" colspan="2" style="padding-right:4px">
		     <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="javascript:ColdFusion.navigate('ObjectStatus.cfm?EntityCode=#URL.EntityCode#&ID2=new','ista')"><font color="0080FF">[add]</font></a>
			 </cfif>			
			 </cfoutput>
		   </td>		   
	    </TR>	
		
		<tr><td colspan="6" height="1" class="linedotted"></td></tr>
					
		<cfoutput query="Detail">
						
		<cfset cd = EntityCode>
		<cfset nm = EntityStatus>
		<cfset de = StatusDescription>
		<cfset op = Operational>
		
		<cfset sel = url.id2>
														
		<cfif sel eq EntityStatus and len(sel) eq len(EntityStatus)>
						
		    <input type="hidden" name="EntityCode" id="EntityCode" value="#cd#">
												
			<TR class="navigation_row">
			   <td style="padding-left:3px" align="center" class="labelmedium">#nm#</td>
			   <td>
			   	   <cfinput type="Text" value="#de#" name="StatusDescription" message="You must enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
	           </td>
			    <td align="center"><input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq #op#>checked</cfif>></td>
			   <td colspan="2" align="right" style="padding-right:4px"><input type="submit" style="height:18;width:60" value="Update" class="button10s"></td>
		    </TR>	
					
		<cfelse>
		
			<TR class="navigation_row linedotted labelmedium">
			   <td align="center" height="17">#nm#</td>
			   <td>#de#</td>
			   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td width="15" align="right" style="padding-top:4px;padding-right:3px">
			   
			   	<cf_img icon="edit" navigation="Yes" onClick="javascript:ColdFusion.navigate('ObjectStatus.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','ista')">
			   
			   </td>
			   <td width="15" align="left" style="padding-top:4px">
			   
			   <cfquery name="Detail" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  OrganizationObject
					WHERE EntityCode  = '#EntityCode#'
					AND   EntityStatus = '#EntityStatus#'
					AND   Operational  = 1
			   </cfquery>
				   
			    <cfif Detail.recordcount eq "0">				
					<cf_img icon="delete" navigation="Yes" onClick="ColdFusion.navigate('ObjectStatusPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','ista')">			   							
				</cfif>
				<a>
			  </td>
			   
		    </TR>	
			
		
		</cfif>
				
		</cfoutput>
									
		<cfif URL.ID2 eq "new">
							
			<TR>
			<td height="25">
			    <cfinput type="Text" value="" name="EntityStatus" message="You must enter a status code" required="Yes" size="1" maxlength="10" class="regularxl">
	        </td>
			
			<td width="70%">
			   <cfinput type="Text" name="StatusDescription" message="You must enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
			</td>
			
			<td align="center">
				<input class="radiol" type="checkbox" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="2" align="right" style="padding-right:4px"><input style="height:18;width:60" type="submit" value=" Add " class="Button10s"></td>
			    
			</TR>	
											
		</cfif>	
					
		</table>
		
		</td>
		</tr>
						
	</table>	

</cfform>

<cfset ajaxonload("doHighlight")>