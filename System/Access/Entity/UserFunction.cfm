
<!---

User-> determine mission -> should function -> present user groups

apply group access

option to reset user for entity for 

mission 
	usergroup access
all access

--->


<script>
function formvalidate() {
	document.userfunction.onsubmit() 
	if( _CF_error_messages.length == 0 ) {       
		ptoken.navigate('UserFunctionSubmit.cfm?id=#url.id#','process','','','POST','userfunction')
	 }   
}	 
</script>

<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  		
		SELECT    P.Mission, PA.FunctionNo, PA.FunctionDescription, PA.Incumbency, PA.AssignmentClass, PA.AssignmentType, PA.PersonNo, O.OrgUnitName
	    FROM      PersonAssignment AS PA INNER JOIN
	              Position AS P ON PA.PositionNo = P.PositionNo INNER JOIN
	              Organization.dbo.Organization O ON PA.OrgUnit = O.OrgUnit
	    WHERE     PA.PersonNo = (SELECT PersonNo FROM System.dbo.UserNames WHERE Account = '#url.id#')
	    AND       PA.AssignmentStatus IN ('0', '1') 
	    AND       PA.DateEffective  < GETDATE() 
	    AND       PA.DateExpiration > GETDATE() 
	    AND       PA.Incumbency     > 0 
	    AND       PA.AssignmentType = 'Actual'
	
</cfquery>  

<cfif get.recordcount eq "0">
	
	<table align="center">
	   <tr class="labelmedium2"><td style="padding-top:20px;font-size:18px"><cf_tl id="We can not determine the assignment of this user"></td></tr>
	</table>

<cfelse>
	
	<cfoutput>
	
	<form name="userfunction" id="userfunction" onsubmit="return false">
	
	    <input type="hidden" name="Mission" value="#get.Mission#">
	
		<table style="width:96%" align="center">
		
		   <tr class="labelmedium2 line">
			   <td colspan="2" style="font-size:18px;padding-top:20px">This user is currently assigned to #get.Mission# in unit <b>#get.OrgUnitName#</b> for the function of <b>#get.FunctionDescription#</b> </td>
		   </tr>
			 
		    <!--- show relevant user function profiles --->
			
			<tr><td colspan="2" style="height:25px;">The following user profiles have been set for this entity, please select one or more to set access</td></tr>
								
				<cfquery name="Functions" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			  		
						SELECT   *, (SELECT count(*) 
						             FROM   MissionProfileUser 
									 WHERE  ProfileId = M.ProfileId 
									 AND    UserAccount = '#url.id#') as Counted
					    FROM     MissionProfile M
					    WHERE    M.Mission   = '#get.Mission#'
						AND      Operational = 1
						ORDER BY ListingOrder				   
				</cfquery>  
			
			<cfloop query="Functions">
			<tr class="labelmedium">
				<td style="width:40px">
				<input type="checkbox" class="radiol" id="profileid" name="profileid" <cfif counted gte "1">checked</cfif> value="#Profileid#" 
				   onclick="showusergroup(this.checked,this.value,'#currentrow#','#url.id#')"></td>
				<td style="height:30px;cursor:pointer;font-size:18px;font-weight:bold">#FunctionName#</td>
			</tr>
			<tr class="line"><td style="padding-left:40px" colspan="2" id="detail#currentrow#"></td></tr>
			</cfloop>
			
			<tr><td colspan="2">
			
			<!--- show the current access pattern, usersgroups, manual, other entities --->
			
			<table>
			 <tr class="labelmedium">
			 
			 	 <td><cf_tl id="Revoke other access"></td>
				 <td style="padding-left:10px">
				 <input type="checkbox" class="radiol" name="clean" value="1" checked>
				 </td>				 
				 
				 <!--- will be hidden after you select clean y/n --->
			     <td style="padding-left:10px" id="usergroup">

					 <table>
					 <tr class="labelmedium">
						 <td><cf_tl id="Only usergroup"></td>
						 <td style="padding-left:10px"><input type="checkbox" class="radiol" name="grouponly" value="1" checked> </td>
					 </tr>
					 </table>
				 
				 </td>
				 
				 <cf_tl id="Reset and apply" var="1">
				 <td style="padding-left:10px" id="process">
				 <input class="button10g" style="width:300px" type="button" name="apply" value="#lt_text#" onclick="formvalidate('#url.id#')">
				 </td>
				 
			 </tr>
			</table>
			
			</td></tr>
			 
		 </table>
	 
	 </form>
	 
	 <!--- remove from usergroups of this entity [ all entities ]) optionally remove other manual access 
	     add to usergroup, sync usergroup --->
	 
	 
	 </cfoutput>

</cfif>