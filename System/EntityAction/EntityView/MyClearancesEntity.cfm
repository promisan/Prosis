
<!--- ------------------------------------------------ --->
<!--- actions to be shown for an entity upon expansion --->
<!--- ------------------------------------------------ --->
<cfparam name="URL.EntityGroup" default="">
<cfparam name="URL.Mission"     default="">
<cfparam name="URL.Owner"       default="">
<cfparam name="URL.me"          default="false">

<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Action2_#fileNo#">	


<cfif url.me eq "true">
	
		<cf_myClearancesPrepare mode="variable" entity="#URL.entitycode#" role="0">
	
	<cfelse>
	
		<cf_myClearancesPrepare mode="variable" entity="#url.entityCode#" role="1">
	
	</cfif>

 	   	   	   
<cfparam name="URL.Sorting" default="overdue">

<!--- ------------------------------------------- --->
<!--- pending activities with last date of action --->
<!--- ------------------------------------------- --->

<cfquery name="Due" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 
	 SELECT     OA.ActionId, 
	 
	            <!--- last action taken --->
	 
	             (SELECT   TOP 1 OfficerDate 
				  FROM     OrganizationObjectAction
				  WHERE    ObjectId = OA.ObjectId
				  AND      ActionStatus IN ('2','2Y','2N') 
				  ORDER BY OfficerDate DESC) AS DateLast
				  
	 INTO       userQuery.dbo.#SESSION.acc#Action2_#FileNo#
	 
	 FROM       OrganizationObjectAction OA INNER JOIN OrganizationObject O ON OA.ObjectId = O.ObjectId

	 WHERE      OA.ActionStatus = '0'	 		
	 			
				<!--- we take the result from the initial opening as the basis showing
				      same actions or less based on processing --->
					  
				<!--- 16/8 I don't think it is needed hanno	  
	            OA.ActionId IN (#preservesingleQuotes(session.myclear)#) OR 
				--->
				
	<cfif actions neq "">
		<!--- incrementally added --->				
		AND OA.ActionId IN (#preservesinglequotes(actions)#)
	</cfif>
		    
	<cfif URL.EntityGroup neq "">
	 	AND O.EntityGroup = '#URL.EntityGroup#'
	</cfif>
	<cfif URL.Mission neq "">
		AND O.Mission = '#URL.Mission#'
	</cfif>
	<cfif URL.Owner neq "">
	 	AND O.Owner = '#URL.Owner#'
	</cfif>

</cfquery>	


<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Action">	

<cfquery name="Search" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 
 	SELECT  E.EntityCode, 
            E.EntityDescription,
			O.ObjectReference, 
			O.ObjectReference2, 
			O.ObjectURL, 
			O.EntityGroup, 
			O.PersonNo,
			O.Mission as MissionOwner,
			Org.OrgUnit, 
			Org.OrgUnitName, 
			Org.Mission, 
            OA.ActionId, 
			OA.ObjectId, 
			OA.OfficerDate, 
			OA.OfficerFirstName, 
			OA.OfficerLastName, 
			O.OfficerUserId as InceptionOfficer,
			O.OfficerLastName as InceptionLastName,
			O.OfficerFirstName as InceptionFirstName,
			O.Created as InceptionDate,
			O.ObjectDue,
			D.DateLast, 
			P.ActionDescription, 
			P.ActionReference, 
            OA.ActionStatus, 
			OA.ActionFlowOrder, 
			OA.ActionCode, 
			P.ActionLeadTime, 
			
			(SELECT count(*) 
			 FROM   OrganizationObjectActionAccess
			 WHERE  ObjectId   = O.ObjectId
			 AND    ActionCode = OA.ActionCode) as FlyAccess,
			 
			(SELECT count(*) 
			 FROM   OrganizationObjectMail
			 WHERE  ObjectId   = O.ObjectId
			 AND    ActionCode = OA.ActionCode) as MailAccess, 
			 
			(CASE WHEN OA.ActionTakeAction = 0 THEN P.ActionTakeAction ELSE OA.ActionTakeAction END) as ActionTakeAction, 
			
			(CASE WHEN O.ObjectDue is not NULL 
			      THEN CONVERT(int,getDate()-ObjectDue)
				  ELSE CONVERT(int,getDate()-DateLast)
			 END) as Due
			
	FROM    OrganizationObjectAction OA INNER JOIN
            OrganizationObject O ON OA.ObjectId = O.ObjectId INNER JOIN
            userQuery.dbo.#SESSION.acc#Action2_#fileno# D ON OA.ActionId = D.ActionId INNER JOIN
            Ref_Entity E ON O.EntityCode = E.EntityCode LEFT OUTER JOIN
            Organization Org ON OA.OrgUnit = Org.OrgUnit INNER JOIN
            Ref_EntityActionPublish P ON OA.ActionCode = P.ActionCode 
					  AND OA.ActionPublishNo = P.ActionPublishNo 					  
					  
	WHERE   P.EnableMyClearances = 1		
	AND     O.Operational    = 1	
	AND     O.ObjectStatus   = 0
	AND     E.ProcessMode   != '9'	
	 <!--- hide concurrent action that was completed --->
	AND     OA.ActionStatus != '2'		
	AND     E.EntityCode = '#URL.EntityCode#' 
	<cfif url.sorting eq "overdue">
	ORDER BY Due DESC, O.Created 
	<cfelseif url.sorting eq "submitted">
	ORDER BY O.Created
	<cfelseif url.sorting eq "step">
	ORDER BY OA.ActionCode
	<cfelseif url.sorting eq "owner">
	ORDER BY O.Mission
	<cfelse>
	ORDER BY DateLast
	</cfif>	
	 
</cfquery>		

<!---
<cfoutput>3. #cfquery.executiontime#</cfoutput>
--->

<cfparam name="url.mode" default="myclearance">

<table width="100%" cellspacing="0" cellpadding="0" style="overflow-x:auto">
<tr><td>

<cfset nav = "110">

<cfif url.mode eq "Dialog">

<cfelse>
		
	<cfquery name="Total" dbtype="query">
		SELECT     *
		FROM       Search
		WHERE      EntityCode = '#EntityCode#'
	</cfquery>	

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="<cfif total.recordcount lt #nav#>navigation_table</cfif>">
		
	<tr class="labelmedium line">
	 
	 <cfoutput>
	
	  <td style="min-width:90px" height="35"></td> 
	  <td width="65%" style="border:1px solid silver;padding:2px;font-size:11px"><cf_tl id="Document"><br><cf_tl id="Reference"></td>			  
	  <td style="border:1px solid silver;padding:2px;font-size:11px" width="10%" align="center"><cf_tl id="Action"><br><cf_tl id="Overdue"><br>(<cf_tl id="hours">)</td>
	  <td style="border:1px solid silver;padding:2px;font-size:11px" width="10%" align="center"><cf_tl id="Workflow"><br><cf_tl id="Overdue"><br>(<cf_tl id="days">)</td>
	  <td style="border:1px solid silver;padding:2px;font-size:11px" width="10%" align="center"><cf_tl id="Document"><br><cf_tl id="Overdue"><br>(<cf_tl id="days">)</td>
	  </cfoutput>
	</tr>
			
	<cfquery name="Overdue"
	  dbtype="query">
		SELECT count(*)
		FROM   Search
		WHERE  EntityCode = '#EntityCode#'
		AND    due > ActionLeadTime+5
	</cfquery>		
		
	<tr><td colspan="6" height="28">
	
		<table align="right" cellspacing="0" cellpadding="0" class="formspacing">
		
		<tr>
							
			<cfoutput>
										
				<td align="right" class="labelit"><cf_tl id="Group">:</td>
				<td style="padding-left:4px">
				
				<cfparam name="url.sorting" default="overdue">
		
				<select name="#url.entitycode#sorting" id="#url.entitycode#sorting" onchange="ColdFusion.navigate('#SESSION.root#/system/entityaction/entityview/MyClearancesEntity.cfm?entitycode=#url.entitycode#&sorting='+document.getElementById('#url.entitycode#sorting').value+'&entitygroup=#URL.entitygroup#','c#url.entitycode#')" class="regularxl">
						<option value="overdue" <cfif url.sorting eq "overdue">SELECTED</cfif>><cf_tl id="Overdue"></option>
						<option value="submitted" <cfif url.sorting eq "submitted">SELECTED</cfif>><cf_tl id="Submitted"></option> 
						<option value="step" <cfif url.sorting eq "step">SELECTED</cfif>><cf_tl id="Action"></option>
						<option value="owner" <cfif url.sorting eq "owner">SELECTED</cfif>><cf_tl id="Owner"></option>
						<option value="last" <cfif url.sorting eq "last">SELECTED</cfif>><cf_tl id="Last Action"></option>				
				</select>
				
				</td>
				
				<td style="padding-left:8px" onclick="ColdFusion.navigate('#SESSION.root#/system/entityaction/entityview/MyClearancesEntity.cfm?entitycode=#url.entitycode#&sorting='+document.getElementById('#url.entitycode#sorting').value,'c#url.entitycode#')" style="cursor:pointer">						
					<img src="#SESSION.root#/Images/Refresh_Red.png" alt="reload view" width="24" height="24" align="absmiddle">					 					 					
				</td>
				
				<td style="padding-left:8px" onclick="more('#url.EntityCode#')" style="cursor:pointer">
					<img src="#session.root#/images/Delete.png" width="18" height="18" alt="close" border="0">											
				</td>
				
			</cfoutput>	 
			
		</tr>
		
		</table>
		
	</td>
	</tr>
	
	<cfif search.recordcount eq "0">
	
		<tr><td colspan="6"
	        align="center"
	        style="color: Green;" class="labelmedium"><cf_tl id="There are no more records pending for your action" class="message">></td>
		</tr>
	
	<cfelse>
	
		<script>
			document.getElementById('quickfilter').className = "regular"
			document.getElementById('filtersearch').value = ""
		</script>
				
		<cfoutput query="Search">						
			   <cfinclude template="MyClearancesEntityDetail.cfm">			   			  				
		</cfoutput>
	
	</cfif>	
	
	</table>	

</cfif>

<cfoutput>
	<script>
		ptoken.navigate('#SESSION.root#/system/entityaction/entityview/MyClearancesEntitySummary.cfm?total=#Total.Recordcount#&Overdue=#Overdue.recordcount#','#url.entitycode#summary')
	</script>
</cfoutput>

</td></tr>

</table>

<cfif total.recordcount lt nav>
	<cfset ajaxonload("doHighlight")>
</cfif>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Action2_#fileno#">	
