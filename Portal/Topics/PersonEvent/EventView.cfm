<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
<cfoutput>
			
		<table width="100%" style="height:320;border:0px solid silver">
		
			<tr>			
				<td>	
				
				<cfif session.acc eq "dpknyep2">
				
					<cfset actor = "">
					
				<cfelse>
				
					<cfset actor = session.acc>
				
				</cfif>	
				
				<cfset sort = "ActionEffective">
				
			    <cfif url.orgunit eq "0">
					<cfset org ="">
				<cfelse>
				    <cfset org = url.orgunit>
				</cfif>
																																														
				<cf_securediv id="divPersonEventDetail_#thisDivName#"
					 bind="url:#session.root#/Portal/Topics/PersonEvent/EventContent.cfm?mission=#url.mission#&period=#url.period#&orgunit=#org#&actor=#actor#&sort=#sort#&divname=#thisDivName#">					
																	 
				</td>
			</tr>
						
			<tr><td style="padding-left:10px;padding-right:10px;padding-bottom:5px" id="PersonEventDetail_#thisDivName#"></td></tr>
			
		</table>
	
</cfoutput>