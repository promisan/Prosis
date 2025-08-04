<!--
    Copyright Â© 2025 Promisan

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
<!--- Prosis template framework --->
<cfsilent>
 <proUsr>fodnykw1</proUsr>
 <proOwn>Ken Ward</proOwn>
 <proDes>SQL for financial statements CMP</proDes>
 <!--- specific comments for the current change, may be overwritten --->
 <proCom>Creation</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfset Period = replace("#Form.Period#","'","","ALL")>
<cfset Variable1 = "#Period#">

<!---
<cfquery name="Cost"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT G.GLAccount, 
	                G.Description, 
					G.AccountGroup, 
					G1.Description as AccountGroupDescription, 
					J.GLCategory,
					G.PresentationClass,
					SUM(T.AmountBaseDebit) as Debit, 
					SUM(T.AmountBaseCredit) as Credit
	INTO   UserQuery.dbo.#Answer1#
	FROM   TransactionLine T, 
	       Journal J,
	       Ref_Account G, 
		   Ref_AccountGroup G1,
		   Ref_GLCategory C
	WHERE  T.Journal       = J.Journal
	 AND   J.Mission       = 'CMP'
	 AND   G.GLAccount     = T.GLAccount
	 AND   G.AccountType   = 'Debit'
	 AND   G.AccountClass  = 'Result'
	 AND   G1.AccountGroup = G.AccountGroup
	 AND   J.GLCategory     = C.GLCategory 
	 <cfif period eq "All">
		 AND     J.Journal IN (SELECT Journal FROM Journal WHERE SystemJournal != 'Opening' or SystemJournal is NULL) 
	 <cfelse> 
		 AND     T.AccountPeriod  = '#Period#'
	 </cfif> 
		 
	GROUP BY G.GLAccount, G.Description, G.AccountGroup, G1.Description,J.GLCategory,G.PresentationClass
	ORDER BY G.GLAccount, G.Description, G.AccountGroup, G1.Description,J.GLCategory,G.PresentationClass
	</cfquery>

<cfquery name="Cost1"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE .dbo.#Answer1# 
	SET Debit = 0.0
	WHERE Debit is null
	</cfquery>

<cfquery name="Cost2"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE .dbo.#Answer1# 
	SET Debit = (Debit - Credit), Credit = 0.0
	WHERE Credit is not null
	</cfquery>

<cfquery name="Results"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	GLAccount, 
	       	Description, 
			AccountGroup, 
			AccountGroupDescription, 
			SUM(Debit) as NOVAActuals,
			PresentationClass
	INTO   dbo.#Answer2#
	FROM   dbo.#Answer1#
	GROUP BY GLAccount, Description, AccountGroup, AccountGroupDescription, PresentationClass
	ORDER BY AccountGroup, GLAccount
	</cfquery>

<cfquery name="Results"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	SUM(NOVAActuals) as TotalActuals,
			AccountGroup
	INTO   dbo.#Answer3#
	FROM   dbo.#Answer2#
	GROUP BY AccountGroup
	ORDER BY AccountGroup 
	</cfquery>
	
<cfquery name="Results"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	A.*, B.TotalActuals
	INTO   dbo.#Answer4#
	FROM   dbo.#Answer2# A Inner Join dbo.#Answer3# B
				ON A.AccountGroup = B.AccountGroup
	ORDER BY A.AccountGroup 
	</cfquery>
	
--->
<!--- IMIS --->

<cfquery name="Cost"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT G.GLAccount, 
					G.Description,
					stL.ObjectClass as AccountGroup, 
					GL.Description as AccountGroupDescription, 
					SUM(stL.AmountBase) as IMISActuals
	INTO   UserQuery.dbo.#Answer1#
	FROM Purchase.dbo.stLedgerIMIS stL INNER JOIN Ref_account G
			ON 'I'+stL.ObjectCode = G.GLAccount
		INNER JOIN Ref_AccountGroup GL
			ON GL.AccountGroup = G.AccountGroup
		WHERE G.AccountType   = 'Debit'
	 	AND   G.AccountClass  = 'Result'
<cfif #Form.Period# neq "'all'">
		AND stL.FiscalYear = '#Period#'
</cfif>		
	GROUP BY G.GLAccount, G.Description, stL.ObjectClass, GL.Description
	</cfquery>	
						
<cfquery name="Results"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	SUM(IMISActuals) as TotalIMISActuals,
			AccountGroup
	INTO   dbo.#Answer2#
	FROM   dbo.#Answer1#
	GROUP BY AccountGroup
	ORDER BY AccountGroup
	</cfquery>	
	
<cfquery name="Results"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT SUM(IMISActuals) as GrandTotalIMIS
	FROM   dbo.#Answer1#
	</cfquery>	

<cfquery name="Final"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT A.*, B.TotalIMISActuals, #Results.GrandTotalIMIS# AS GrandTotalIMIS
	INTO   dbo.#Table1#
	FROM   dbo.#Answer1# A Inner Join dbo.#Answer2# B
				ON A.AccountGroup = B.AccountGroup
	ORDER BY A.AccountGroup 
	</cfquery>

<!---
<cfquery name="Results"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select A.*, B.IMISActuals, B.TotalIMISActuals
	INTO dbo.#Table1#
	FROM   dbo.#Answer4# A Left Join dbo.#Answer7# B
				ON A.AccountGroup = B.AccountGroup 
	ORDER BY A.AccountGroup 
	</cfquery>
--->	
	
<!---
SELECT GLAccount, Description, AccountGroup, AccountGroupDescription, IMISActuals, TotalIMISActuals, GrandTotalIMIS
FROM Userquery.dbo.#Param.table1#
--->
