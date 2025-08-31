<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
	<!--- MM 050616 - modified next query to read records from PositionParent (except PositionNo).  Did this by joining Position and PositionParent.
	                  previously, only table Position was being read --->
					  
	<cfquery name="InsertPositionParent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
	INSERT INTO Employee.dbo.PositionParent
			  (OrgUnitOperational, 
			   OrgUnitAdministrative, 
			   OrgUnitFunctional,
			   Mission, 
			   MandateNo, 
			   FunctionNo, 
			   FunctionDescription, 
			   ApprovalDate,
			   ApprovalReference,
			   ApprovalPostGrade, 
			   Postgrade, 
			   PostType, 
			   Fund,
			   DateEffective, 
			   DateExpiration, 
			   SourcePositionNo,
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName)
			   
	SELECT    PP.OrgUnitOperational, 
		      P.OrgUnitAdministrative,
			  P.OrgUnitFunctional,
			  '#URL.Mission#',
			  '#man#',
		      PP.FunctionNo, 
			  PP.FunctionDescription,
			  PP.ApprovalDate,
		      PP.ApprovalReference,
			  PP.ApprovalPostGrade,
			  P.PostGrade, 
			  P.PostType, 
			  PP.Fund,
			  #STR#, 
			  #END#,
			  P.PositionNo,
			  '#SESSION.acc#', 
			  '#SESSION.last#', 
			  '#SESSION.first#'
	FROM  Employee.dbo.Position P INNER JOIN Employee.dbo.PositionParent PP ON P.PositionParentId = PP.PositionParentId
	WHERE P.Mission         = '#URL.Mission#' 
	AND   P.MandateNo       = '#Form.MissionTemplate#'
	AND   P.DateExpiration >= #STR1#
	
	<!---
	AND	  PP.PositionParentId NOT IN
			(
			SELECT 	PositionParentId
			FROM   	Employee.dbo.Position
			WHERE  	Mission   = '#URL.Mission#' 	
			AND 	MandateNo = '#Form.MissionTemplate#'
			AND	   	SourcePostNumber IN		
				(
				SELECT  	SourcePostNumber
				FROM    	Employee.dbo.Position
				WHERE      	Mission   = '#URL.Mission#' 
				AND 		MandateNo = '#Form.MissionTemplate#'
				AND 		SourcePostNumber > ''
				GROUP BY 	SourcePostNumber
				HAVING      COUNT(PositionNo) > 1
				) 
	)
	
	--->
	
	UNION	
	
	SELECT PP.OrgUnitOperational, 
	       P.OrgUnitAdministrative,
		   P.OrgUnitFunctional,
		   '#URL.Mission#',
		   '#man#',
	       PP.FunctionNo, 
		   PP.FunctionDescription,
		   PP.ApprovalDate,
		   PP.ApprovalReference,
		   PP.ApprovalPostGrade,
		   P.PostGrade, 
		   P.PostType, 
		   PP.Fund,
		   #STR#, 
		   #END#,
		   P.PositionNo,
		   '#SESSION.acc#', 
		   '#SESSION.last#', 
		   '#SESSION.first#'
	FROM    Employee.dbo.Position P INNER JOIN 
	        Employee.dbo.PositionParent PP ON P.PositionParentId = PP.PositionParentId
	WHERE   P.Mission = '#URL.Mission#' 
	AND     P.MandateNo = '#Form.MissionTemplate#'
	AND     P.DateExpiration >= #STR1#
	
	<!---
	
	AND	    P.PositionParentId IN

	(
	SELECT 	po.PositionParentId
	FROM    Employee.dbo.Position po INNER JOIN
		(
		SELECT 	SourcePostNumber, MAX(DateEffective) AS MaxDateEffective
		FROM    Employee.dbo.Position
		WHERE   Mission   = '#URL.Mission#' 
		AND 	MandateNo = '#Form.MissionTemplate#'
		AND 	SourcePostNumber > ''
		GROUP BY SourcePostNumber
		HAVING  COUNT(PositionNo) > 1
		) sub1 ON po.SourcePostNumber = sub1.SourcePostNumber AND po.DateEffective = sub1.MaxDateEffective
	WHERE 	po.Mission   = '#URL.Mission#' 
	AND 	po.MandateNo = '#Form.MissionTemplate#'
	)
	
	--->
	
	</cfquery>
	
	<!--- Start of MM addition 050610 
	we determined that PositionParent needs to be updated separately to prevent position
	ownership from being transferred to the "borrowing" org unit (in cases when position is on loan
	at time of triggering new fin period)
	--->
	
	<!--- define conversion 2.1 - write temp table containing PositionParent OrgUnit/OrgUnitCode values for new fin pd --->
		
	<cfquery name="TmpTable21" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		SELECT   O.OrgUnit, O.OrgUnitCode 
		INTO     userquery.dbo.#SESSION.acc#tmpOrg21
		FROM     Employee.dbo.PositionParent P, Organization O
		WHERE    P.Mission            = '#URL.Mission#' 
		  AND    P.MandateNo          = '#man#'
		  AND    P.OrgUnitOperational = O.OrgUnit
		GROUP BY O.OrgUnit, O.OrgUnitCode 
	</cfquery>
	
	<!--- define conversion 2.2  - write 2nd temp table adding Organization.OrgUnit value in NEW fin pd that matches the same orgunit in the previous
	                               fin pd. --->
	
	<cfquery name="TmpTable22" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		SELECT   P.OrgUnit as OrgUnitOld, P.OrgUnitCode, O.OrgUnit AS OrgUnitNew
		INTO     userquery.dbo.#SESSION.acc#tmpOrg22
		FROM     userquery.dbo.#SESSION.acc#tmpOrg21 P, Organization O
		WHERE    O.OrgUnitCode = P.OrgUnitCode
		AND      O.Mission     = '#URL.Mission#' 
		AND      O.MandateNo   = '#man#'
		GROUP BY P.OrgUnit, P.OrgUnitCode, O.OrgUnit
	</cfquery>
	
	<!--- now update PositionParent (post owner) operational orgunit coding --->
	
	<cfquery name="UpdatePositionParent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		UPDATE   Employee.dbo.PositionParent
		SET      OrgUnitOperational = O.OrgUnitNew
		FROM     Employee.dbo.PositionParent PP INNER JOIN userquery.dbo.#SESSION.acc#tmpOrg22 O ON PP.OrgUnitOperational =  O.OrgUnitOld
		WHERE    PP.Mission   = '#URL.Mission#' 
		AND      PP.MandateNo = '#man#'  
	</cfquery>
	
	<!--- end of MM addition 050610 --->
		