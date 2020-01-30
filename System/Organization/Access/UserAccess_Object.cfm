
 <!--- global roles --->
 <input type="hidden" name="class" id="class" value="1">
   
 <!--- create entity table --->
 
 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity">
 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity1">
  
 <!--- define object steps --->
        	
  <cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *	
    FROM    OrganizationObject O
	WHERE   O.ObjectId = '#URL.ID2#'	
  </cfquery> 
       	
  <cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  DISTINCT R.EntityCode,
		        R.EntityDescription, 
		        O.EntityGroup, 
				O.Mission,
				O.OrgUnit,
				R.Role,
				E.ActionCode, 
				E.ActionDescription, 
				E.ActionType,
				EP.ActionOrder
		INTO    userQuery.dbo.#SESSION.acc#Entity 
	    FROM    OrganizationObject O, 
				Ref_EntityActionPublish EP,
				Ref_EntityAction E,
				Ref_Entity R
		WHERE   O.ObjectId = '#URL.ID2#'
		AND     O.ActionPublishNo = EP.ActionPublishNo
		AND     EP.ActionCode = E.ActionCode
		AND     R.EntityCode = O.EntityCode 
		AND     E.EnableAccessFly = 1
		AND     O.Operational  = 1
		ORDER BY EP.ActionOrder 
  </cfquery>      
  
  <cfsavecontent variable="user">    
	<cfoutput>
	SELECT    A.*	
	FROM      Organization.dbo.OrganizationAuthorization A
    WHERE     A.UserAccount = '#URL.ACC#' 
	AND       A.ClassIsAction = 1	
    </cfoutput>   
  </cfsavecontent>
    
  <cfquery name="EntityAccessGranted" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT    DISTINCT E.*, 
	          CASE WHEN A.AccessId is NULL THEN 0 ELSE 1 END AS Granted	
	INTO      userQuery.dbo.#SESSION.acc#Entity1 		  
	FROM      userQuery.dbo.#SESSION.acc#Entity  E LEFT OUTER JOIN
		      (#preservesingleQuotes(user)#) as A ON E.ActionCode = A.ClassParameter 
			  AND E.EntityGroup = A.GroupParameter 
			  AND E.Role = A.Role 
			  <cfif Object.Mission neq "">
			  AND E.Mission = A.Mission
			  </cfif>					  
			  <cfif Object.OrgUnit neq "">
			  AND E.OrgUnit = A.OrgUnit
			  </cfif>			 
  </cfquery> 	
  	
  <cfquery name="AccessList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     E.*,
	           A.AccessLevel, 
			   '0' as RecordStatus, 
			   1 as number 
    FROM       OrganizationObjectActionAccess A RIGHT OUTER JOIN 
			   userQuery.dbo.#SESSION.acc#Entity1 E ON A.ActionCode  = E.ActionCode				   
	    AND    A.ObjectId    = '#URL.ID2#'
		AND    A.UserAccount = '#URL.Acc#'	
	ORDER BY   E.ActionOrder
  </cfquery>
    
  <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity">	
  <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity1">   
  	
	<table width="100%" class="navigation_table formpadding">
	
	<cfoutput query="AccessList" group="EntityCode">
	
	<tr class="labelmedium"><td colspan="5" style="font-weight:200;font-size:20px;font-height:35px;padding-left:4px">#EntityDescription#</td></tr>
	
		<cfoutput>
		<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#ActionCode#">
		<input type="hidden" name="#ms#_groupparameter_#CurrentRow#" id="#ms#_groupparameter_#CurrentRow#" value="#EntityGroup#">
			
		<tr class="Linedotted labelit navigation_row">	
		 <td style="font-size:13px;padding-left:8px; word-wrap: break-word;">#ActionDescription#</td>
		 <td>#ActionType#</td>
	     <td>#ActionCode#</td> 
		 <td width="30%" align="center" class="labelit">
		      <cfset accesslvl = AccessLevel>
		      <cfif Granted eq "0">
				  <cfinclude template="UserAccessSelectAction.cfm">
			  <cfelse>
			  <cf_tl id="Granted">
				  <input type="hidden" name="#ms#_AccessLevel_#CurrentRow#"     id="#ms#_AccessLevel_#CurrentRow#"     value="">
				  <input type="hidden" name="#ms#_AccessLevel_old_#CurrentRow#" id="#ms#_AccessLevel_old_#CurrentRow#" value="">     
			  </cfif>
		  </td>
		</tr>	
		</cfoutput>
	</cfoutput>
    </table>
		
	<cfset class = AccessList.recordcount>
	
	<cfset ajaxonload("doHighlight")>
	
