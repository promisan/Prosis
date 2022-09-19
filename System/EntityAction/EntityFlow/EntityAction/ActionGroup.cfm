	
<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT E.*
    FROM  Ref_EntityGroup E
	WHERE E.EntityCode = '#URL.EntityCode#'
	ORDER BY Owner,EntityGroupName
</cfquery>

<cfquery name="MyOwner" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_AuthorizationRoleOwner
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
		
<cfform action="ActionGroupSubmit.cfm?EntityCode=#URL.EntityCode#&ID2=#URL.ID2#" method="POST" enablecab="Yes" name="action">

	<table width="98%" align="right">
	    
	  <tr>
	    <td width="100%">
	    <table width="100%" class="navigation_table formpadding">
			
	    <TR class="linedotted fixlengthlist labelmedium2">		   
		   <td><cf_tl id="Code"></td>
		   <td><cf_tl id="Owner"></td>
		   <td><cf_tl id="Description"></td>
		   <td align="center" style="width:30px">Op.</td>
		   <td style="width:30px"></td>
		   <td align="right" style="width:30px">
	         <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="javascript:ptoken.navigate('ActionGroup.cfm?EntityCode=#URL.EntityCode#&ID2=new','igrp')">[add]</a>
			 </cfif>
			 </cfoutput>
		   </td>
		  
	    </TR>			
					
		<cfoutput query="Detail">
								
		<cfset cd = EntityCode>
		<cfset nm = EntityGroup>
		<cfset ow = Owner>
		<cfset de = EntityGroupName>
		<cfset op = Operational>
												
		<cfif URL.ID2 eq nm>
		
		    <input type="hidden" name="EntityCode" id="EntityCode" value="<cfoutput>#cd#</cfoutput>">
												
			<TR class="fixlengthlist">
			   
			   <td>#nm#</td>
			   <td>
			      <select name="Owner" id="Owner" class="regularxl" style="width:100%">
				   <option value="">All</option>
				   <cfloop query="MyOwner">
				   <option value="#Code#" <cfif ow eq "#Code#">selected</cfif>>#Code#</option>
				   </cfloop>
			   </select>					   
			   </td>
			   <td style="padding-left:2px"><cfinput type="Text" value="#de#" name="EntityGroupName" message="You must enter a description" required="Yes" style="width:100%" size="50" maxlength="50" class="regularxl"></td>
			 
			    <td align="center">
			      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq #op#>checked</cfif>>
				</td>
				
			    <td colspan="2" align="right" style="padding-left:5px;padding-right:4px"><input type="submit" value="Update" style="width:80" class="button10g"></td>
		    </TR>	
					
		<cfelse>
		
			<cfset edit = "javascript:ptoken.navigate('ActionGroup.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','igrp')">
					
			<TR class="navigation_row linedotted fixlengthlist">
			    
			    <td>#nm#</td>
				<td>#ow#</td>
			    <td>#de#</td>
				<td align="right"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
			    <td align="right">
				   <cf_img icon="edit" navigation="Yes" onclick="#edit#">			   
			    </td>
			    <td align="right" style="padding-right:3px">
			   
				   <cfquery name="Detail" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT *
				    FROM  OrganizationObject
					WHERE EntityCode  = '#EntityCode#'
					AND   EntityGroup = '#EntityGroup#'
					AND   Operational  = 1
				   </cfquery>
					   
				    <cfif Detail.recordcount eq "0">					
						<cf_img icon="delete" navigation="Yes" onclick="ptoken.navigate('ActionGroupPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','igrp')">					  
					</cfif>
					
			  </td>
			   
		    </TR>	
			
		
		</cfif>
				
		</cfoutput>
									
		<cfif URL.ID2 eq "new">
				
			<TR>
			
				<td height="25" style="padding-right:3px">
				    <cfinput type="Text" value="" name="EntityGroup" message="You must enter a code" required="Yes" size="20" maxlength="20" class="regularxl">
		        </td>
						
				<td>
				  <select name="Owner" id="Owner" class="regularxl" style="width:100%">
					   <option value="">All</option>
					   <cfoutput query="MyOwner">
					   <option value="#Code#">#Code#</option>
					   </cfoutput>
				   </select>		
				</td>			
				
				<td style="padding-left:3px">
				   <cfinput type="Text" name="EntityGroupName" message="You must enter a description" required="Yes" size="50" maxlength="50" class="regularxl">
				</td>			
				
				<td align="center">
				   <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
				</td>
									   
				<td colspan="2" align="right" style="padding-left:5px;padding-right:4px">
				    <input type="submit" value="Add" style="width:50px" class="button10g">
				</td>
			    
			</TR>	
		
		</cfif>	
					
		</table>
		</td>
		</tr>
									
	</table>
	
</cfform>	

<cfset ajaxonload("doHighlight")>	


