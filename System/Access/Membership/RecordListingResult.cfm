
<cfquery name="Entities" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Mission
</cfquery>	

<cfparam name="URL.Search" default="">

	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	   SELECT U.*,O.HierarchyCode, O.OrgUnitName
	   
	   FROM (
				SELECT AccountOwner, 
				       (SELECT Description
					    FROM   Organization.dbo.Ref_AuthorizationRoleOwner
						WHERE  Code = AccountOwner) as AccountOwnerName,
				       AccountMission, 		  
					   U.Account, 
					   U.LastName, 					  
					   eMailAddress, 
					   Remarks, 
					   R.Description as AccountGroupName,
					   U.OfficerLastName, 
					   U.OfficerFirstName, 
					   
					   <cfif entities.recordcount gte "3">
					   
					  	   '0' as OrgUnit,
					   
					   <cfelse>
					   
						   <!--- we check if the usergroup is connected to a single parent within 
						   an entity to provide
						   better information as to what the usergroup is intended --->				   
						  					   
						   (SELECT    TOP 1 P.OrgUnit
						    FROM      Organization.dbo.Organization AS O INNER JOIN
			                          Organization.dbo.Organization AS P 
									             ON O.HierarchyRootUnit = P.OrgUnitCode 
			                                   AND O.Mission = P.Mission 
					    					   AND O.MandateNo = P.MandateNo
									  
							WHERE     O.OrgUnit IN  (SELECT   OrgUnit
							                         FROM     Organization.dbo.OrganizationAuthorization F
						                             WHERE    F.OrgUnit     = O.OrgUnit										  
											         AND      F.UserAccount = U.Account)
											  
							GROUP BY  P.OrgUnit
							HAVING    COUNT(DISTINCT P.OrgUnit) = 1) as OrgUnit,
											
						</cfif>
											   			   
					   U.Created, 
					   
					   (SELECT count(*) 
					    FROM   UserNamesGroup 
						WHERE  AccountGroup = U.Account) as Members
					  			   
				FROM   UserNames U INNER JOIN 
				       Ref_AccountGroup R ON R.AccountGroup = U.AccountGroup
					   
				WHERE  U.AccountType = 'Group'
								
				<cfif url.mission neq "">		
				AND    U.AccountMission = '#url.mission#'
				</cfif>
				
				<cfif url.application neq "">
				
				AND    EXISTS  (SELECT 'X'
	    					    FROM   Organization.dbo.OrganizationAuthorization AS OA INNER JOIN
				                       Organization.dbo.Ref_AuthorizationRole AS R ON OA.Role = R.Role
								WHERE  OA.UserAccount = U.Account 
								AND    R.SystemModule IN (SELECT  SystemModule
									                      FROM    System.dbo.Ref_ApplicationModule
									                      WHERE   Code = '#url.application#')    
								)						  
										
				</cfif>
				
				<cfif SESSION.isAdministrator eq "No"> 
				
				AND (
					 U.AccountOwner IN (
					                    SELECT ClassParameter 
				                        FROM   Organization.dbo.OrganizationAuthorization
			                    	    WHERE  Role = 'AdminUser' 
									    AND    AccessLevel IN ('1','2')
									    AND    UserAccount = '#SESSION.acc#'
									   )
				     OR 	
					 				   
				     U.AccountMission IN (SELECT Mission 
					                      FROM   Organization.dbo.OrganizationAuthorization 
								          WHERE  UserAccount = '#SESSION.acc#'
								          AND    Role = 'OrgUnitManager'
										  AND    AccessLevel IN ('2','3'))
				   
				   )
				
				</cfif>
				
				AND    (U.Account LIKE '%#URL.Search#%' 
				             OR U.LastName LIKE '%#URL.Search#%' 
							 OR U.Remarks LIKE '%#URL.Search#%')
								
				) as U LEFT OUTER JOIN Organization.dbo.Organization O ON U.OrgUnit = O.OrgUnit
				
		ORDER BY U.AccountOwner, 
		         U.AccountMission, 
				 O.HierarchyCode, 
				 U.AccountGroupName, 
				 U.LastName 
				
	</cfquery>
	
<table width="97%" align="left" class="navigation_table">

	<tr class="labellarge line fixrow">
	    <td width="5%"></td>
	    <TD><cf_tl id="Account"></TD>
		<TD><cf_tl id="Memo"></TD>		
		<TD align="center" width="5%">M</TD>
		<TD><cf_tl id="Officer"></TD>
	    <TD><cf_tl id="Created"></TD>
		<TD></TD>	
	</TR>
		
	<cfif searchresult.recordcount eq "0">
	
	     <tr><td align="center" colspan="7" class="labellarge" style="font-weight:200;padding-top:10px"><cf_tl id="There are no records to show in this view"></td></tr>
	
	</cfif>
	
	<cfoutput query="SearchResult" group="AccountOwner">
		
		<tr><td height="2"></td></tr>
				
		<cfoutput group = "AccountMission">		
		
			<tr>
			<td class="labellarge" style="padding-top:16px;font-size:24px;height:38px;padding-left:22px;font-weight:200" 
			colspan="8">
			
			 <cfif url.search neq "">
				<cfset ref = replaceNoCase(AccountOwnerName, url.search,"<u><font color='red'>#url.search#</font></u>", "ALL")> 
			<cfelse>
			    <cfset ref = AccountOwnerName>	
			</cfif>
			#ref#
			
			<cfif AccountMission eq ""><cf_tl id="Global"><cfelse>
			
				<cfif url.search neq "">
					<cfset ref = replaceNoCase(AccountMission, url.search,"<u><font color='red'>#url.search#</font></u>", "ALL")> 
				<cfelse>
			        <cfset ref = AccountMission>	
				</cfif>
				/ #ref#
			
			</cfif>
		
		<cfoutput group = "HierarchyCode">	
		
		 <cfif entities.recordcount lte "10">	
			<tr style="background-color:white">
				<td colspan="8" style="height:42px;padding-top:5px;padding-left:25px;font-size:26px">
						   		
				<cfif orgunitname eq ""><cf_tl id="Multiple"><cfelse>#OrgUnitName#</cfif>		
				
				</td>
			</tr>	
		 </cfif>	
				
		<cfoutput group = "AccountGroupName">		
			
			<tr class="fixrow2 navigation_row labelmedium2">
			
			<td colspan="8" style="height:31px;padding-top:5px;padding-left:27px;font-size:16px;">#AccountGroupName#</td></tr>						
												
				<cfoutput>
												
				<TR bgcolor="white" class="navigation_row line labellarge">
					<td align="center" style="padding-left:40px;padding-top:8px">				
					    <cf_img icon="expand" toggle="yes" onclick="more('#Account#','#currentRow#')">														
					</td>
	
					<TD style="padding-left:10px">
					<a class="navigation_action" href="javascript:ShowUser('#URLEncodedFormat(Account)#')">					
					<cfif url.search neq "">
						<cfset ref = replaceNoCase(LastName, url.search,"<u><font color='6688aa'>#url.search#</font></u>", "ALL")> 
					<cfelse>
					    <cfset ref = LastName>	
					</cfif>
					#ref#	
					
					<cfif url.search neq "">
							<cfset ref = replaceNoCase(Account, url.search,"<u><font color='6688aa'>#url.search#</font></u>", "ALL")> 
						<cfelse>
						    <cfset ref = Account>	
						</cfif>					
						(#ref#)		
									
					</a>
					</TD>
										
					<TD style="padding-right:4px">#left(Remarks,70)#</TD>
					<td align="center" style="padding-right:8px">#Members#</td>
					<TD style="font-size:13px">#OfficerLastName#</TD>
					<TD style="font-size:13px">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
					<TD style="padding-top:2px;padding-left:3px">	
						<cf_img icon="delete" onclick="purgegroup('#account#')">		   			
					</TD>
				</TR>	
					
				<tr id="#CurrentRow#" class="hide">
				        <td></td>
						<td colspan="6"><cfdiv id="s#CurrentRow#"/></td>
						<td></td>
				</tr>	
													
				</cfoutput>						
				</cfoutput>	
			</cfoutput>				
		</cfoutput>
	</cfoutput>
	
	</TABLE>
	
<cfset ajaxonload("doHighlight")>
	
 <script>
	 Prosis.busy('no')		
 </script>
	