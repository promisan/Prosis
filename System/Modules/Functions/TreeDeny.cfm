
<cfparam name="URL.ID1" default="">

<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM   Ref_ModuleControl L
	WHERE  SystemFunctionId = '#URL.ID#'
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mission A 
	WHERE  Mission NOT IN (SELECT Mission 
	                       FROM   System.dbo.Ref_ModuleControlDeny 
						   WHERE  SystemFunctionId = '#URL.ID#')
	<cfif lcase(Line.SystemModule) neq "selfservice">
	AND Mission IN (SELECT Mission 
	                FROM   Ref_MissionModule 
					WHERE  SystemModule = '#Line.SystemModule#')					 
	</cfif>
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM   Ref_ModuleControlDeny R
	WHERE  SystemFunctionId = '#URL.ID#'
</cfquery>

<cfform action="#session.root#/System/Modules/Functions/TreeDenySubmit.cfm?ID=#URL.ID#&ID1=#URL.ID1#" method="POST" name="fund">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			    
		  <tr>
		    <td width="100%">
			
		    <table width="100%" border="0" cellpadding="0" cellspacing="0">
		
			<cfoutput>
			<cfloop query="Detail">
			
			<cfset rl = Mission>
															
			<cfif URL.ID1 eq rl>
										
				<TR class="labelmedium2 line">
							    					   						 						  
				   <td style="font-size:17px">#Mission#</td>
				   <td></td>
				   <td></td>
				   <td colspan="2" align="right">
				   <input type="submit" value="Update" class="button10p"></td>
	
			    </TR>	
						
			<cfelse>
			
				<TR class="labelmedium2 line">
				   <td style="font-size:17px" width="60%" height="20">#rl#</td>
				   <td></td>
				   <td width="30%" align="right">#OfficerUserId# (#dateformat(created,CLIENT.DateFormatShow)#)</td>
				   <td width="40"></td>
				   <td align="right" style="padding-right:10px">
				     <cf_img icon="delete" onclick="javascript:ptoken.navigate('#session.root#/System/Modules/Functions/TreeDenyPurge.cfm?ID=#URL.ID#&ID1=#rl#','itree')">					
				  </td>
				   
			    </TR>	
			
			</cfif>
						
			</cfloop>
			</cfoutput>
							
			<cfif URL.ID1 eq "" and Mission.Recordcount gt "0">
													
				<tr><td height="3"></td></tr>
							
				<TR>
				
				<td height="30">
				   <cfselect name="Mission" class="regularxxl">
		           <cfoutput query="Mission">
				     <option value="#Mission#">#Mission#</option>
				   </cfoutput>
			   	   </cfselect>
				   <input type="submit" value="Add" class="button10s" style="WIDTH:60">
				</td>
				
				<td></td><td></td>
									   
				<td colspan="2" align="right"></td>
				</TR>	
					
				<tr><td height="3"></td></tr>
						
			</cfif>	
			
			</table>
			
			</td>
			</tr>
								
	</table>		
	
</cfform>	
