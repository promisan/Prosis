<!--
    Copyright © 2025 Promisan

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

<cfquery name="Extend" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO PersonExtension
                 (PersonNo, 
				  Mission, 
				  MandateNo, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)
	SELECT    DISTINCT Ass.PersonNo AS personNo, 
	                   M.Mission AS Mission, 
					   M.MandateNo AS MandateNo, 
					   '#SESSION.acc#' AS Expr1, 
					   '#SESSION.last#' AS Expr2, 
					   '#SESSION.first#' AS Expr3
	FROM      Position Pos INNER JOIN
              Organization.dbo.Ref_Mandate M ON Pos.Mission = M.Mission AND Pos.MandateNo = M.MandateNo INNER JOIN
              PersonAssignment Ass ON Pos.PositionNo = Ass.PositionNo AND M.DateExpiration = Ass.DateExpiration
	WHERE     M.Mission   = '#URL.Mission#' 
	AND       M.MandateNo = '#URL.MandateNo#' 
	AND       Ass.PersonNo NOT IN
                          (SELECT   PersonNo
                            FROM    PersonExtension
                            WHERE   Mission   = '#URL.Mission#' 
							AND     MandateNo = '#URL.MandateNo#')
	AND       AssignmentStatus IN ('0','1') 						
</cfquery>		

<script language="JavaScript">
	history.go()
	try { ProsisUI.closeWindow('mybox'); } catch(e) {}	
</script>

