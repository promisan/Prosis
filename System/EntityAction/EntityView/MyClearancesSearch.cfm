
<!--- search --->

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Action2">	

<cfquery name="Due" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
     SELECT     OA.ActionId, 
	 
	            (SELECT TOP 1 OfficerDate 
				 FROM     OrganizationObjectAction
				 WHERE    ObjectId = OA.ObjectId
				 AND      ActionStatus IN ('2','2Y','2N') 
				 ORDER BY OfficerDate DESC) AS DateLast
				 
	 INTO       userQuery.dbo.#SESSION.acc#Action2
	 FROM       OrganizationObjectAction OA
	 WHERE      OA.ActionId IN (#preservesingleQuotes(SESSION.myclear)#)  	
</cfquery>	

<cfquery name="Search" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 
	 SELECT     TOP 80 E.EntityCode, 
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
				D.DateLast, 
				P.ActionDescription, 
				P.ActionReference, 
	            OA.ActionStatus, 
				OA.ActionFlowOrder, 
				OA.ActionCode, 
				P.ActionLeadTime, 
				P.ActionTakeAction,				
				
				(CASE WHEN O.ObjectDue is not NULL 
			      THEN CONVERT(int,getDate()-ObjectDue)
				  ELSE CONVERT(int,getDate()-DateLast)
    			 END) as Due
			
				
	FROM        OrganizationObjectAction OA 
	            INNER JOIN OrganizationObject O ON OA.ObjectId = O.ObjectId 
				INNER JOIN userQuery.dbo.#SESSION.acc#Action2 D ON OA.ActionId = D.ActionId 
				INNER JOIN Ref_Entity E ON O.EntityCode = E.EntityCode 
				LEFT OUTER JOIN  Organization Org ON OA.OrgUnit = Org.OrgUnit 
				INNER JOIN Ref_EntityActionPublish P ON 				    
	                 OA.ActionPublishNo = P.ActionPublishNo AND 
					 OA.ActionCode = P.ActionCode
					 
	 WHERE      P.EnableMyClearances = 1		
	 AND        O.Operational        = 1	
	 AND        O.ObjectStatus       = 0
	 AND        E.ProcessMode       != '9'
	 
	 AND        (O.ObjectReference LIKE '%#URL.Val#%' OR O.ObjectReference2 LIKE '%#URL.Val#%') 
	 
	 ORDER BY   E.EntityCode, Due DESC 
</cfquery>		

<table width="98%" cellspacing="0" cellpadding="0" align="center">

<cfif search.recordcount eq "0">

<tr><td colspan="7" align="center" class="labelmedium">No Actions found</td></tr>

<cfelse>
			
	<tr><td colspan="7" class="labelmedium"><cf_tl id="Search Results"></td></tr>	
	<tr><td height="1" colspan="7" class="linedotted"></td></tr>	
	<cfoutput query="Search">	
		<cfinclude template="MyClearancesEntityDetail.cfm">
	</cfoutput>

</cfif>	

</table>	

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Action2">	  