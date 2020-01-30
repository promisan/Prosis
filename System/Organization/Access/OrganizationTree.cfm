
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
		
		<tr><td valign="top" class="labelmedium" style="padding-top:10px;height:35;padding-left:4px">
		   
	   	    <cfoutput>
				
				<img src="#SESSION.root#/Images/Logos/System/Tree.png" height="20" width="20" alt="" align="absmiddle" border="0" onclick="mission()">&nbsp;&nbsp;
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
													
							<cftree name="idorg" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
							     <cftreeitem 
								  bind="cfc:Service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#URL.Mission#','#Mandate.Mandateno#','OrganizationListing.cfm','FIN','#URL.Mission#','#URL.Mission#','#Mandate.Mandateno#','#URl.ID4#','parent')">  		 
							    </cftree>	
																
							</td></tr>
							</table>
					</td></tr> 	
				
				<cfelse>
					
					<cfloop query="Mandate">
					   	  
					<tr><td align="center" height="100%">
									
							<table width="98%" align="center" height="100%">
							<tr><td height="100%" valign="top">
													
							<cftree name="tree#mandateNo#" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
							     <cftreeitem 
								  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#URL.Mission#','#Mandateno#','OrganizationListing.cfm','MAN','#URL.Mission#','#URL.Mission#','#Mandate.Mandateno#','#URl.ID4#','parent')">  		 
							    </cftree>	
																
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
					 <td style="padding-left:10px">
					   <img src="#SESSION.root#/Images/Logos/System/Tree.png" height="18" width="18"  alt="" style="cursor:pointer" onclick="mission()" align="absmiddle" border="0">
					 </td>
					 <td class="labelmedium" style="padding-left:6px">
						<a href="javascript:mission()"><font color="0080C0">Global #Mission# access</a></b>
					 </td>
					</tr>
					</table>
							
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
					   	  
					<tr><td height="100%" align="center">
							<table width="98%" height="100%" align="center">
							<tr><td height="100%" valign="top">
													
							<cftree name="idorg" bold="No" format="html" required="No">
							     <cftreeitem 
								  bind="cfc:Service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#URL.Mission#','#Mandate.Mandateno#','OrganizationListing.cfm','FIN','#URL.Mission#','#URL.Mission#','#Mandate.Mandateno#','#URl.ID4#')">  		 
							    </cftree>	
															
							</td></tr>
							</table>
					</td></tr> 	
				
				<cfelse>
					
					<cfloop query="Mandate">
					   	  
					<tr><td align="center" height="100%">
							<table height="100%" width="98%" align="center">
							<tr><td height="100%" valign="top">
													
							<cftree name="tree#mandateNo#" fontsize="11" bold="No" format="html" required="No">
							     <cftreeitem 
								  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#URL.Mission#','#Mandateno#','OrganizationListing.cfm','MAN','#URL.Mission#','#URL.Mission#','#Mandate.Mandateno#','#URl.ID4#')">  		 
							    </cftree>	
															
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
	
