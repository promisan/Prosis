
	<cfquery name="InsertPosition" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		INSERT INTO Employee.dbo.Position
			  (PositionParentId, 
			   OrgUnitOperational, 
			   OrgUnitAdministrative, 
			   OrgUnitFunctional,
			   MissionOperational, 
			   Mission, 
			   MandateNo, 
			   FunctionNo, 
			   FunctionDescription, 
			   Postgrade, 
			   PostType, 
			   PostClass, 
			   LocationCode, 
			   Source, 
			   SourcePostNumber, 
			   VacancyActionClass, 
			   DateEffective, 
			   DateExpiration, 
			   SourcePositionNo, 
			   Remarks,
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName)
		SELECT A.PositionParentId,
		       A.OrgUnitOperational,
		       <!--- P.OrgUnitOperational, --->
		       P.OrgUnitAdministrative,
			   P.OrgUnitFunctional,
			   P.MissionOperational,
			   '#URL.Mission#',
			   '#man#',
		       A.FunctionNo, 
			   A.FunctionDescription,
			   P.PostGrade, 
			   P.PostType, 
			   P.PostClass, 
			   P.LocationCode,
			   P.Source,
			   P.SourcePostNumber,
			   P.VacancyActionClass,
			   #STR#, 
			   #END#,
			   P.PositionNo,
			   P.Remarks,
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#'
		FROM   Employee.dbo.Position P, 
		       Employee.dbo.PositionParent A
		WHERE  P.Mission            = '#URL.Mission#' 
		AND    P.MandateNo          = '#Form.MissionTemplate#'
		AND    P.DateExpiration    >= #STR1#
		
		AND    A.SourcePositionNo   = P.PositionNo
		AND    A.MandateNo          = '#man#'
		
	</cfquery>	
			
	<!--- Loaning 
	  15/11/2005 correction, positions borrowed to another mission will return to the parent organization --->
	
	<cfquery name="ReturnPosition" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		UPDATE Employee.dbo.Position
		SET    MissionOperational  = PP.Mission,
		       OrgUnitOperational  = PP.OrgUnitOperational,
			   FunctionNo          = PP.FunctionNo,
			   FunctionDescription = PP.FunctionDescription,
			   PostGrade           = PP.PostGrade
		FROM   Employee.dbo.Position P, Employee.dbo.PositionParent PP
		WHERE  P.PositionParentId = PP.PositionParentId
		AND    PP.Mission         = '#URL.Mission#' 
		AND    PP.MandateNo       = '#man#'
		AND    P.Mission != P.MissionOperational
	</cfquery>
		
	<!--- Following are the steps to upgrade Position.OrgUnitOperational values with the corresponding
	      orgunit values in the newly created set of Organization records for the new fin period --->
		  
	<!--- define conversion 1 of 3  - write temp table containing Position OrgUnit/OrgUnitCode values for new fin pd --->
	
	<CF_DropTable dbName="userQuery" tblName="#SESSION.acc#tmpOrg11">
	<CF_DropTable dbName="userQuery" tblName="#SESSION.acc#tmpOrg12">
	
	<cfquery name="TmpTable11" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		SELECT O.OrgUnit, O.OrgUnitCode 
		INTO   UserQuery.dbo.#SESSION.acc#tmpOrg11
		FROM   Employee.dbo.Position P, Organization O
		WHERE  P.Mission    = '#URL.Mission#' 
		  AND  P.MandateNo  = '#man#'
		  AND  P.OrgUnitOperational = O.OrgUnit
	</cfquery>
	
	<!--- define conversion 2 of 3  - write 2nd temp table adding Organization.OrgUnit value in new fin pd that matches the same orgunit in the previous
	                                  fin pd. --->
	
	<cfquery name="TmpTable12" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		SELECT P.OrgUnit as OrgUnitOld, P.OrgUnitCode, O.OrgUnit
		INTO  UserQuery.dbo.#SESSION.acc#tmpOrg12
		FROM  UserQuery.dbo.#SESSION.acc#tmpOrg11 P, 
		      Organization O
		WHERE O.OrgUnitCode = P.OrgUnitCode
		AND   O.Mission     = '#URL.Mission#' 
		AND   O.MandateNo   = '#man#'
	</cfquery>
	
	<!--- define conversion 3 of 3  --->
	
	<!--- now update operational orgunit coding in Person table --->
	
	<cfquery name="UpdatePosition" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		UPDATE   Employee.dbo.Position
		SET      OrgUnitOperational   = O.OrgUnit
		FROM     Employee.dbo.Position Pos INNER JOIN userQuery.dbo.#SESSION.acc#tmpOrg12 O ON Pos.OrgUnitOperational =  O.OrgUnitOld
		WHERE    Pos.Mission = '#URL.Mission#' 
		AND      Pos.MandateNo = '#man#'  
	</cfquery>
	
	<CF_DropTable dbName="userQuery" tblName="#SESSION.acc#tmpOrg11">
	<CF_DropTable dbName="userQuery" tblName="#SESSION.acc#tmpOrg12">