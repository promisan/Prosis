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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cftry>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#InBudget">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#InExpenditure">

<cfquery name="InBudget" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    DISTINCT A.ProgramCode, R.Fund, Line.ObjectCode
	INTO      UserQuery.dbo.#SESSION.acc#InBudget
	FROM      ProgramAllotment A INNER JOIN
	          ProgramAllotmentDetail Line ON A.ProgramCode = Line.ProgramCode AND A.Period = Line.Period AND A.EditionId = Line.EditionId INNER JOIN
	          Ref_AllotmentEdition R ON A.EditionId = R.EditionId INNER JOIN
	          Organization.dbo.Ref_MissionPeriod M ON R.EditionId = M.EditionId
	WHERE     M.Mission = '#URL.Mission#'
	AND       M.Period IN (#preservesingleQuotes(persel)#)
</cfquery>

<cfquery name="InExpenditure" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  F.RequisitionNo,
	        F.Fund, 
	        F.ProgramCode, 
			F.ObjectCode, 
			F.Percentage, 
			F.Percentage * Line.RequestAmountBase AS Amount
	INTO    UserQuery.dbo.#SESSION.acc#InExpenditure	
	FROM    RequisitionLine Line INNER JOIN
            RequisitionLineFunding F ON Line.RequisitionNo = F.RequisitionNo
	WHERE   Line.Mission = '#URL.Mission#'
	AND     Line.Period IN (#preservesingleQuotes(persel)#)
</cfquery>	

<cfquery name="Orphan" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     Exp.RequisitionNo, Exp.Fund, Exp.ProgramCode, Exp.ObjectCode, Exp.Amount, Bud.ProgramCode AS Match
	FROM       #SESSION.acc#InExpenditure Exp LEFT OUTER JOIN
               #SESSION.acc#InBudget	 Bud ON Exp.Fund = Bud.Fund AND Exp.ProgramCode = Bud.ProgramCode AND Exp.ObjectCode = Bud.ObjectCode
    GROUP BY Exp.RequisitionNo, Exp.Fund, Exp.ProgramCode, Exp.ObjectCode, Exp.Amount, Bud.ProgramCode
    HAVING      (Bud.ProgramCode IS NULL)
</cfquery>	

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#InBudget">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#InExpenditure">

<cfif Orphan.recordcount gt "0">	

	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">
	
	<tr><td><cf_tl id="REQ032"></td></tr>
	
	<tr><td>
	
	<table width="400" cellspacing="0" cellpadding="0" align="left" bgcolor="FFE1E1" class="formpadding">	
	<cfoutput query="Orphan">
	<tr>
	<td>#RequisitionNo#</td>
	<td>#ProgramCode#</td>
	<td>#Fund#</td>
	<td>#ObjectCode#</td>
	<td align="right">#numberFormat(Amount,"__.__")#</td>
	</tr>
	</cfoutput>
	</table>
	
	</td>
	</tr>
	<cfoutput>
	<tr><td><img src="#SESSION.root#/Images/finger.gif" align="absmiddle" alt="" border="0">&nbsp;<cf_tl id="REQ033"></td></tr>
	</cfoutput>
	
	</table>

</cfif>

<cfcatch></cfcatch>

</cftry>
	 
