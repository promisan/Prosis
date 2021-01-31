<cf_compression>

<!--- --------------------------------------------------------------- --->	
<!--- this detail was designed for Insight, it has to be made generic --->
	 	 
<cfparam name="URL.ClaimId" default="">
<cfparam name="URL.Mode" default="Regular">

<cfif URL.claimid neq "">
		
	<cfquery name="Details" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT C.Mission,
		       DocumentNo,
		       CaseNo,
			   ClaimMemo,
			   ActionStatus,
			   CaseNo,
			   DocumentDate,
			   S.Description as status, 
			   O.OrgUnit,
			   O.OrgUnitname
		FROM   Claim C INNER JOIN
               Ref_Status S ON C.ActionStatus = S.Status LEFT OUTER JOIN
               Organization.dbo.Organization O ON C.OrgUnitClaimant = O.OrgUnit
		WHERE  ClaimId='#URL.ClaimId#' 
		AND    StatusClass = 'clm'		
	</cfquery>	
	
	<cfquery name="Parameter" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Ref_ParameterMission
			WHERE Mission = '#Details.Mission#'	
	</cfquery>		
			
	<cfquery name="Finance" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *, CC.Description
		FROM   ClaimLine CL, Ref_ClaimCategory CC
		where ClaimId='#URL.ClaimId#' and CL.ClaimCategory=CC.code
	</cfquery>
		
	<cfloop index="itm" list="f001,f002,f003,f005,f005a,f006,f007,f008,f009,f011,f012,f013">
	
	    <cftry>
		
		<cfquery name="qry_#itm#" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		SELECT DocumentItemValue as value
		FROM OrganizationObjectInformation 
		WHERE (ObjectId in (SELECT ObjectId 
							FROM   OrganizationObject 
							WHERE  ObjectKeyValue4='#URL.ClaimId#' ))
		AND (DocumentId IN 
					(SELECT   DocumentId 
						FROM  Ref_EntityDocument 
						WHERE EntityCode = 'ClmAircraft' 
						AND   DocumentCode = '#itm#')
		) 	
		</cfquery>
		
		<cfcatch>
			<cfparam name="qry_#itm#.value" default="undefined">
		</cfcatch>
		
		</cftry>
	
	</cfloop>	
	
	<cfoutput>
		
	<cfif url.mode eq "Regular">
	
	<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
	 <tr><td height="6"></td></tr>
	
	<cfelse>
		
	<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="0"
       align="center">
	   
	   <tr>
	   <td height="20" align="left" bgcolor="000000" 
	    background="#SESSION.root#/Images/background_bluecorporate2.jpg" style="border: 1px inset;">
	   <font color="black"><b>&nbsp;#Details.DocumentNo#</font>
	   </td>
	   </tr>
	   <tr><td height="6"></td></tr>
	
	</cfif>
		
	<tr>
	<td> 
		
			<table width="99%" align="center" class="formpadding">
			
			<tr>
			<td height="4" colspan="3"></td>
			<td height="4" colspan="3"></td>
			</tr>
			
			<tr class="labelmedium2">
			<td width="20">-</td>
			<td width="140"><cf_tl id="Claim No">:</td>
			<td width="30%"><B>#Details.DocumentNo#</td>
			<td width="20">-</td>		
			<td width="120"><cf_tl id="Surveyor">:
			
			<cfquery name="Surveyor" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT DISTINCT U.*
				FROM   OrganizationObjectActionAccess OA INNER JOIN
	            	   System.dbo.UserNames U ON OA.UserAccount = U.Account
				WHERE Objectid IN (SELECT Objectid FROM OrganizationObject WHERE ObjectKeyValue4 = '#URL.ClaimId#')
			</cfquery>	 			
			
			</td>
			<td width="32%" class="labelit">
			<cfloop query="Surveyor">
			<b>#FirstName# #LastName#</b><cfif currentrow neq recordcount>,</cfif>
			</cfloop>
			</td>
			</tr>
			
			<tr>
			<td colspan="3" class="line"></td>
			<td colspan="3" class="line"></td>
			</tr>
			
			<tr class="labelmedium2">
			<td width="20">-</td>
			<td width="140"><cf_tl id="Name of assured">:</td>
			<td width="30%"><B><a href="javascript:orgunit('#details.orgunit#','#Parameter.addresstype#')">#Details.OrgUnitName#</a></td>
			<td width="20">-</td>		
			<td width="120"><cf_tl id="Aircraft type">:</td>
			<td width="32%"><B>#qry_f001.value#</td>
			</tr>
			
			<tr id="r#details.orgunit#" class="hide">
			
			<td></td><td colspan="5" id="#details.orgunit#"></td></tr>
			
			<tr>
			<td colspan="3" class="line"></td>
			<td colspan="3" class="line"></td>
			</tr>
			
			<tr class="labelmedium2">
			<td>-</td>
			<td><cf_tl id="Aircraft Registration">:</td>
			<td><B>#qry_f002.value#</td>
			<td>-</td>
			<td>Date of Loss:</td>			
			<td><B>#qry_f003.value#</td>
			</tr>
			
			<tr>
			<td colspan="3" class="line"></td>
			<td colspan="3" class="line"></td>
			</tr>
			
			<tr class="labelmedium2">
			<td>-</td>
			
			<cfset jvlink = "ProsisUI.createWindow('map_qry_f005a', 'Location', '',{x:100,y:100,height:625,width:620,modal:true,center:true});ColdFusion.navigate('#SESSION.root#/Tools/EntityAction/HeaderFields/ObjectHeaderMAP.cfm?name=Location&coordinates=#qry_f005a.value#','map_qry_f005a')">				
			
			<td>Location of Loss: </td>
			<td>#qry_f005.value# #qry_f006.value# <cfif qry_f005a.value neq ""><a href="javascript:#jvlink#"><font color="379BFF">see MAP</a></cfif></td>
			<td>-</td>		
			<td>Agreed Value: </td>
			<td><b>#qry_f013.value# <cftry> #numberformat(qry_f007.value,',.__')# <cfcatch> #qry_f007.value#</cfcatch></cftry></td>			
			</tr>
			
			<tr>
			<td colspan="3" class="line"></td>
			<td colspan="3" class="line"></td>
			</tr>
	
			<tr class="labelmedium2">
			<td>-</td>
			<td><cf_tl id="Policy Deductible">: </td>
			<td><b>#qry_f013.value# <cftry> #numberformat(qry_f008.value,',.__')# <cfcatch> #qry_f008.value#</cfcatch></cftry></td>
			<td>-</td>
			<td><cf_tl id="Policy Type">: </td>
			<td><b>#qry_f009.value#</td>
			</tr>
			
			<tr>
			<td colspan="3" class="line"></td>
			<td colspan="3" class="line"></td>
			</tr>
			
			<cfquery name="Organization" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     CO.ClaimRole, O.OrgUnit, O.OrgUnitName, OA.Contact, R.Description, R.UserClass
				FROM         ClaimOrganization CO LEFT OUTER JOIN
		                      Organization.dbo.Organization O ON CO.OrgUnit = O.OrgUnit RIGHT OUTER JOIN
		                      Ref_ClaimRole R ON CO.ClaimRole = R.ClaimRole LEFT OUTER JOIN
		                      Organization.dbo.vwOrganizationAddress OA ON O.OrgUnit = OA.OrgUnit AND OA.AddressType = 'Office'
				WHERE     (CO.ClaimId = '#URL.ClaimId#') 
				AND (R.ClaimRole IN ('LUnderwriter', 'Broker'))		
				ORDER BY R.ClaimRole DESC
			</cfquery>	
			
			<cfloop query="Organization">
									
			<tr class="labelmedium2">
			<td>-</td>
			<td>#Description#:</td>
			<td>
			    <cfif orgunit neq "">
			    <a href="javascript:orgunit('#orgunit#','#Parameter.addresstype#')">
				<b>#OrgUnitName#</b>
				</a>
				<cfelse>
				N/A
				</cfif>	
				</td>
			<td>-</td>
			<td> <cf_tl id="Contact">: </td>			
			
			<cfquery name="Contact" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT CO.ClaimRole, O.OrgUnit, O.OrgUnitName, OA.Contact, R.Description
				FROM   ClaimOrganization CO LEFT OUTER JOIN
		               Organization.dbo.Organization O ON CO.OrgUnit = O.OrgUnit RIGHT OUTER JOIN
		               Ref_ClaimRole R ON CO.ClaimRole = R.ClaimRole LEFT OUTER JOIN
		               Organization.dbo.vwOrganizationAddress OA ON O.OrgUnit = OA.OrgUnit AND OA.AddressType = 'Office'
				WHERE  CO.ClaimId = '#URL.ClaimId#' 
				AND    R.UserClass = '#UserClass#'		
				AND    R.OrgUnitClass = 'Contact'
				ORDER BY R.ClaimRole DESC
			</cfquery>				
			
			<td>
			<cfif Contact.OrgUnitName neq ""><b>#Contact.OrgUnitName#</b><cfelse>N/A</cfif></td>
			</tr>
			
			<cfif orgUnit neq "">
				<tr id="r#orgunit#" class="hide">
				<td></td><td colspan="5">
					<cfdiv id="#orgunit#">			
				</td>
				</tr>
			</cfif>
			
			<tr>
			<td colspan="3" class="line"></td>
			<td colspan="3" class="line"></td>
			</tr>		
			
			</cfloop>
						
			<tr class="labelmedium2">
			<td>-</td>
			<td><cf_tl id="Broker claim reference">: </td>
			<td><b>#qry_f011.Value#</td>
			<td>-</td>		
			<td><cf_tl id="Policy Slip information">: </td>
			<td><b>#qry_f012.value#</td>
			</tr>	
			
			<tr>
			<td colspan="3" class="line"></td>
			<td colspan="3" class="line"></td>
			</tr>	
								
			</table>	
		</td>
	</tr>
	</table>
		
	</cfoutput>

</cfif>
