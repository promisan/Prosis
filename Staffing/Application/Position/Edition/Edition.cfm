
<!--- initially populate --->

<cfparam name="url.id1" default="">

<cfquery name="Owner" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT M.MissionOwner
    FROM  Employee.dbo.PositionParent P, Organization.dbo.Ref_Mission M
	WHERE P.PositionParentId = '#url.id#'	
</cfquery>

<cfquery name="SaveGuard" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM PositionParentEdition
	WHERE SubmissionEdition NOT IN (SELECT SubmissionEdition 
	                                FROM Applicant.dbo.Ref_SubmissionEdition)	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterOwner
	WHERE  Owner = '#owner.MissionOwner#'	
</cfquery>

<cfif Parameter.DefaultRoster neq "">
	
	<cfquery name="Default" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    INSERT INTO PositionParentEdition
		(PositionParentId,SubmissionEdition,OfficerUserId,OfficerLastName,OfficerFirstName)
		
	    SELECT PositionParentId,
		       '#Parameter.DefaultRoster#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'
		FROM   PositionParent
		WHERE  Mission IN (SELECT Mission 
		                   FROM   Organization.dbo.Ref_Mission 
						   WHERE  MissionOwner = '#owner.MissionOwner#')
						   
		AND    PositionParentId NOT IN (SELECT PositionParentId 
		                                FROM   PositionParentEdition
				 					    WHERE  SubmissionEdition IN (SELECT SubmissionEdition 
									                                 FROM   Applicant.dbo.Ref_SubmissionEdition
																     WHERE  Owner = '#owner.MissionOwner#')		
									  )							   		   
		   
	</cfquery>

</cfif>

<cfquery name="EditionList" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM   Ref_SubmissionEdition R
	WHERE  Owner = '#owner.MissionOwner#'
	AND    SubmissionEdition NOT IN (SELECT SubmissionEdition 
	                                 FROM   Employee.dbo.PositionParentEdition
									 WHERE  PositionParentId = '#url.id#')
</cfquery>

<cfquery name="Detail" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*, A.EditionDescription, A.Owner, A.PostType, A.DateEffective, A.DateExpiration
    FROM   PositionParentEdition R, 
	       Applicant.dbo.Ref_SubmissionEdition A 
	WHERE  R.SubmissionEdition = A.SubmissionEdition
	AND    PositionParentId = '#URL.ID#'
</cfquery>

<cfform action="../Edition/EditionSubmit.cfm?ID=#URL.ID#&id1=#url.id1#" method="POST" name="role">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="e4e4e4">
			    
	  <tr>
	    <td valign="center" width="100%" class="regular">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
			
		<cfoutput>
		<cfloop query="Detail">
																
			<cfif URL.ID1 eq SubmissionEdition>
										
				<TR class="labelmedium">
							    					   						 						  
				   <td height="35">#EditionDescription#
				   <input type="hidden" name="SubmissionEdition" value="#SubmissionEdition#">				  				  
				   </td>
				   <td>#OfficerUserId# (#dateformat(created,CLIENT.DateFormatShow)#)</td>				   
				   <td align="center">
				      <input type="checkbox" name="Operational" value="1" <cfif "1" eq Detail.Operational>checked</cfif>>
				   </td>
				   <td colspan="2" align="right"><input type="submit" style="width:40" value="Save" class="button10g">&nbsp;</td>
	
			    </TR>	
						
			<cfelse>
			
				<TR class="labelmedium">
				   <td height="20" width="30%">#EditionDescription#</td>
				   <td width="30%" align="right">#OfficerUserId# (#dateformat(created,CLIENT.DateFormatShow)#)</td>
				   <td align="center"><cfif operational eq "0">Disabled</cfif></td>
				   <td width="40" colspan="2" align="right">		
					   <table cellspacing="0" cellpadding="0" class="formpadding">
					   <tr>
					   
					    <td>
						  <cf_img icon="edit" onclick="ColdFusion.navigate('../Edition/Edition.cfm?ID=#URL.ID#&ID1=#submissionedition#','editionbox')">
						</td>
						
						<cfif detail.recordcount gt "1">
							<td style="padding-left:4px">							
							  <cf_img icon="delete" onclick="ColdFusion.navigate('../Edition/EditionPurge.cfm?ID=#URL.ID#&ID1=#submissionedition#','editionbox')">							 
							</td>
						</cfif>
						
					   </tr>
					  </table>					
				  </td>
				   
			    </TR>	
			
			</cfif>
		
		<tr><td height="1" colspan="5" class="linedotted"></td></tr>
		
		</cfloop>
		</cfoutput>
						
		<cfif URL.ID1 eq "" and editionList.recordcount gte "1">
												
			<tr><td height="3"></td></tr>
						
			<TR>			
			 	   
			<td colspan="3" height="30">
			   										
				   <cfselect name="SubmissionEdition" class="regularxl" style="width:320px">
				   <cfoutput query="EditionList">
				     <option value="#SubmissionEdition#">#EditionDescription#</option>
				   </cfoutput>
			   	   </cfselect>

			</td>	  			 
		  
			<td colspan="2" align="right">
			    <input type="submit" class="button10g" name="add" value="Add" style="height:25px;width:60">
			</td>
			    
			</TR>
				
			<tr><td height="3"></td></tr>
					
		</cfif>	
		
		</table>
		
		</td>
		</tr>
									
</table>

</cfform>	