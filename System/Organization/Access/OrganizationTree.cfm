
<cfset url.id4 = url.class>

<cfquery name="Unit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  R.*
	FROM    Ref_AuthorizationRole R
	WHERE   Role = '#URL.ID4#' 
</cfquery>

<cfset unitlevel = Unit.OrgUnitLevel>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="paddong:6px">

<tr><td height="100%">

<cf_divscroll>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  
	<cfswitch expression="#Unit.OrgUnitLevel#">
	
	   <cfcase value="Warehouse">
	   
	   <tr><td height="5"></td></tr>
	   
		    <cfform>
		
			<tr><td valign="top" height="35" style="padding-top:5px;padding-left:4px">
	   
	           <cf_OrganizationAccessTreeDataWhs mission = "#URL.Mission#">	  
		   
		   </td>
		   
		   </tr>
		   
		   </cfform>
		 	   
	   </cfcase>
	   
	   <cfcase value="Parent">
	   
	    <cfform>
		
		<tr><td valign="top" class="labelmedium" style="padding-top:10px;height:35;padding-left:4px;font-size:25px">
					   
	   	    <cfoutput>
				
				<img src="#SESSION.root#/Images/Logos/System/Tree.png" height="27" width="27" alt="" align="absmiddle" border="0" onclick="mission()">
				&nbsp;&nbsp;
				<a href="javascript:mission()" title="Select in order to grant access for this tree globally">Global #Mission# access</a></b>			
		   </cfoutput>
		
		</td></tr>
		
		<tr><td height="1" class="linedotted"></td></tr>
	   
		 <cfquery name="Mandate" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
				      FROM Ref_Mandate
				   	  WHERE Mission = '#URL.Mission#' 
					   ORDER BY DateEffective DESC
				  </cfquery>
				  
				<cfif Mandate.RecordCount eq 1>  
					   	  
					<tr><td align="center" height="100%">
							<table width="98%" align="center" height="100%">
							<tr><td height="100%" valign="top">
													
							<cf_UItree name="idorg" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
							     <cf_UItreeitem
								  bind="cfc:Service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#URL.Mission#','#Mandate.Mandateno#','OrganizationListing.cfm','FIN','#URL.Mission#','#URL.Mission#','#Mandate.Mandateno#','#URl.ID4#','parent')">
							    </cf_UItree>
																
							</td></tr>
							</table>
					</td></tr> 	
				
				<cfelse>
					
					<cfloop query="Mandate">
					   	  
					<tr><td align="center" height="100%">
									
							<table width="98%" align="center" height="100%">
							<tr><td height="100%" valign="top">
													
							<cf_UItree name="tree#mandateNo#" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
							     <cf_UItreeitem
								  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#URL.Mission#','#Mandateno#','OrganizationListing.cfm','MAN','#URL.Mission#','#URL.Mission#','#Mandate.Mandateno#','#URl.ID4#','parent')">
							</cf_UItree>
																
							</td></tr>
							</table>
					</td></tr> 	
					 
					 </cfloop>
				
				</cfif>
			
			</cfform> 
			
					   
	   </cfcase>
	    
	   <cfdefaultcase>  
		
				<cfform>
				
				<tr><td height="3"></td></tr>
										
				<tr><td class="labelmedium" style="height:35">
							
				<cfoutput>		
				
				    <table class="formspacing">
					<tr>
					 <td style="padding-left:10px;padding-top:3px">
					   <img src="#SESSION.root#/Images/Logos/System/Tree.png" height="29" width="29"  alt="" style="cursor:pointer" onclick="mission()" align="absmiddle" border="0">
					 </td>
					 <td class="labelmedium" style="font-size:21px;padding-left:6px">
						<a href="javascript:mission()">Global #Mission# access</a>
					 </td>
					</tr>
					</table>
							
				</cfoutput>
				
				</td></tr>
				<tr class="line"><td height="1"></td></tr>
							
				<cfquery name="Mandate" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
				      FROM Ref_Mandate
				   	  WHERE Mission = '#URL.Mission#' 
					   ORDER BY DateEffective DESC
				  </cfquery>
				  
				<cfif Mandate.RecordCount eq 1>  
					   	  
					<tr><td height="100%" align="center">
							<table width="98%" height="100%" align="center">
							<tr><td height="100%" valign="top">
													
							<cf_UItree name="idorg" bold="No" format="html" required="No">
							     <cf_UItreeitem
								  bind="cfc:Service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#URL.Mission#','#Mandate.Mandateno#','OrganizationListing.cfm','FIN','#URL.Mission#','#URL.Mission#','#Mandate.Mandateno#','#URl.ID4#')">
							    </cf_UItree>
															
							</td></tr>
							</table>
					</td></tr> 	
				
				<cfelse>
					
					<cfloop query="Mandate">
					   	  
					<tr class="line"><td align="center" height="100%">
							<table height="100%" width="98%" align="center">
							<tr><td height="100%" valign="top">
													
							<cf_UItree name="tree#mandateNo#" fontsize="11" bold="No" format="html" required="No">
							     <cf_UItreeitem
								  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#URL.Mission#','#Mandateno#','OrganizationListing.cfm','MAN','#URL.Mission#','#URL.Mission#','#Mandate.Mandateno#','#URl.ID4#')">
							    </cf_UItree>
															
							</td></tr>
							</table>
					</td></tr> 	
					 
					 </cfloop>
				
				</cfif>
				
				</cfform>
		
		</cfdefaultcase>  
		
	</cfswitch>
		
	</table>
	
	</cf_divscroll>

</td></tr>
</table>