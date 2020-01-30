
<cfoutput>

<table width="100%" border="0" bordercolor="silver">

<tr>
	 <td width="30" valign="middle">
	   	  <img src="#SESSION.root#/Images/select4.gif" alt="Grant access" name="arrow" id="arrow" border="0" style="cursor: pointer;" 
		  onClick="javascript:userlocateN('programindicator','#URL.TargetId#','ProgramAuditor','#url.i#')">
	 </td>
	 <td class="labelmedium" colspan="3"><a href="javascript:userlocateN('programindicator','#URL.TargetId#','ProgramAuditor','#url.i#')"><font color="0080FF"><b>Press here</b> to identify the designated indicator measurement reviewer</a></td>
</tr>  
	
<cfquery name="Target" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   PI.IndicatorCode, Pe.OrgUnit, Org.Mission
  FROM     ProgramIndicator PI INNER JOIN
              ProgramPeriod Pe ON PI.ProgramCode = Pe.ProgramCode AND PI.Period = Pe.Period INNER JOIN
              Organization.dbo.Organization Org ON Pe.OrgUnit = Org.OrgUnit
  WHERE    TargetId = '#URL.TargetId#'		   
</cfquery>			 
	
<cfquery name="Fly" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  DISTINCT U.Account, 
                U.PersonNo, 
				U.FirstName, 
				U.LastName, 
	            U.AccountGroup, 
				U.eMailAddress, 
				A.*
FROM    OrganizationAuthorization A,System.dbo.UserNames U 
WHERE   A.UserAccount    = U.Account
AND     A.Role           = 'ProgramAuditor'
AND     A.ClassParameter = '#Target.IndicatorCode#'
AND     A.AccessLevel < '8'
AND     ((A.OrgUnit     = '#Target.OrgUnit#') 
	OR (A.OrgUnit is NULL and A.Mission = '#Target.Mission#')
	OR (A.OrgUnit is NULL and A.Mission is NULL))
ORDER BY U.LastName, U.FirstName
</cfquery>

<cfif Fly.recordCount gt "0">
			
	<tr>
	   <td colspan="4" class="regular">
		<table width="100%">
		<tr class="labelit">
		    <td></td>
			<td>Actor</td>
			<td>Date</td>
			<td>Delegated by</td>
			<td></td>
			<cfif Fly.recordCount gt "1">
			<td></td>
			<td>Actor</td>
			<td>Date</td>
			<td>Delegated by</td>
			<td></td>
			</cfif>
		</tr>
		<cfif Fly.recordCount gt "1">
		<tr><td colspan="10" class="line"></td></tr>
		<cfelse>
		<tr><td colspan="5" class="line"></td></tr>
		</cfif>
			
		<cfset r = 0>
		
		<cfloop query="FLY">
		
			<cfif r eq 0>
				<tr class="labelit">		
			</cfif>
			    <td>#CurrentRow#.&nbsp;</td>
				<td>#FLY.LastName#, #FLY.FirstName#</td>
				<td>#DateFormat(FLY.Created, CLIENT.DateFormatShow)#</td>
				<td>#FLY.OfficerLastName#</td>
				<td>
				<cfif FLY.OrgUnit neq "">
		            <cf_img icon="delete" onclick="revertaccess('#Url.TargetId#','#Target.OrgUnit#','#Target.IndicatorCode#','ProgramAuditor','#FLY.Account#','#url.i#')">				
				</cfif>
				</td>
				<cfset r = r + 1>
			
			<cfif r eq "2">
			    <cfset r = 0>
				</tr>
			</cfif>	
		
		</cfloop>
		
		</table>
	   
	   </td>
	   
	</tr>	 

</cfif>

</table>	
	
</cfoutput>	