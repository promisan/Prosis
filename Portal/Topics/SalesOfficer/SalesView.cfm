<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
<cfoutput>
			
		<table width="100%" style="height:320;border:0px solid silver">
		
			<tr>			
				<td>	
				
				<cfquery name="User" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   UserNames
						WHERE  Account = '#session.acc#'	
				</cfquery>	
				
				<cfif User.PersonNo eq "">
				
					<cfset actor = "">
					
				<cfelse>
				
					<cfset actor = User.PersonNo>
									
				</cfif>	
				
				<cfset sort = "ActionEffective">
				
			    <cfif url.orgunit eq "0">
					<cfset org ="">
				<cfelse>
				    <cfset org = url.orgunit>
				</cfif>
																																														
				<cf_securediv id="divSalesOfficerDetail_#thisDivName#"
					 bind="url:#session.root#/Portal/Topics/SalesOfficer/SalesContent.cfm?mission=#url.mission#&period=#url.period#&orgunit=#org#&actor=#actor#&sort=#sort#&divname=#thisDivName#">					
																	 
				</td>
			</tr>
						
			<tr><td style="padding-left:10px;padding-right:10px;padding-bottom:5px" id="SalesOfficerDetail_#thisDivName#"></td></tr>
			
		</table>
	
</cfoutput>