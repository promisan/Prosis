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
<!--- designed for CMP only --->
<!--- --------------------- --->

<cfset mission = "CMP">

<cfoutput>

<table width="98%" height="100%" frame="hsides" border="0" bordercolor="d1d1d1" cellspacing="0" cellpadding="0" align="center">

	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#StatementAllCost">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#StatementCost">

	<cfquery name="Statement"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT 
             OP.ProgramCode AS PhaseCode, 
			 OP.ProgramName AS Phase, 
			 SUM(T.AmountBaseDebit) AS Debit, 
			 SUM(T.AmountBaseCredit) AS Credit, 
             OP.ListingOrder
	INTO     UserQuery.dbo.#SESSION.acc#StatementAllCost		 
	FROM     TransactionLine T INNER JOIN
             Journal J ON T.Journal = J.Journal AND J.Mission = '#mission#' INNER JOIN
                      Ref_Account G ON G.GLAccount = T.GLAccount INNER JOIN
                      Program.dbo.Program P ON T.ProgramCode = P.ProgramCode INNER JOIN
                      Program.dbo.Program OP ON LEFT(P.ProgramHierarchy, 7) = OP.ProgramHierarchy
	WHERE     (G.AccountType = 'Debit') AND (G.AccountClass = 'Result') 
	AND     J.Mission = '#mission#'
	AND     J.Journal IN
                       (SELECT   Journal
                        FROM     Journal
					WHERE 
					GLCategory IN ('Actuals','Obligation')
					AND (SystemJournal != 'Opening' OR SystemJournal IS NULL))
    GROUP BY OP.ListingOrder, OP.ProgramCode, OP.ProgramName	
	</cfquery>

	<cfquery name="Statement"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT PhaseCode,
				Phase,
				Debit,
				Credit,
				ListingOrder
		INTO UserQuery.dbo.#SESSION.acc#StatementCost
		FROM UserQuery.dbo.#SESSION.acc#StatementAllCost
		UNION
		SELECT 'P5576' as PhaseCode,
			   '#mission# General' as Phase,
			   SUM(Amount) as Debit,
			   0 as Credit,
			   0 as ListingOrder
		FROM  TransactionHeader
		WHERE TransactionSource= 'IMIS'	
		AND   Mission = '#mission#'
	</cfquery>
	
	<cfquery name="Cost1"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE .dbo.#SESSION.acc#StatementCost
	SET Debit = 0.0
	WHERE Debit is null 
	</cfquery>

	<cfquery name="Cost2"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE .dbo.#SESSION.acc#StatementCost
	SET Debit = (Debit - Credit), Credit = 0.0
	WHERE Credit is not null
	</cfquery>

	<cfquery name="GTotals"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	Phase,
			PhaseCode,
			Round(SUM(Debit)/1000,0) as Amounts			
	FROM   dbo.#SESSION.acc#StatementCost
	GROUP BY ListingOrder, PhaseCode, Phase 
	</cfquery>
				
	<cfquery name="GrandTotal" 
	dbtype="query" >
	SELECT SUM(Amounts) as Total
		FROM GTotals
	</cfquery>	
	
	
<cfoutput>
<script language="JavaScript1.2">
function drill(lnk) {
   window.open("#SESSION.root#/" + lnk + "?ts="+new Date().getTime(), "drill", "unadorned:yes; edge:raised; status:yes; dialogHeight:790px; dialogWidth:890px; help:no; scroll:no; center:yes; resizable:no");
}	
</script>
</cfoutput>

  <tr>
  <td align="left">&nbsp;&nbsp;<font size="2">OVERALL TOTAL (excluding planned costs): <cfoutput><font size="3"><b>#NumberFormat(GrandTotal.Total,"_,_")#</cfoutput></font></td>
  <td align="right">
    <A HREF ="javascript:drill('Gledger/Inquiry/Statement/StatementSelect.cfm')">
	     <font size="1" color="0080FF">Click here for Details</font>&nbsp;&nbsp;
	</A>
  </td>
  </tr>
  
  <tr><td colspan="2" class="line"></td></tr>
  
  <cfquery name="ObjectGroup"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   P.AccountGroup, P.Description, round(SUM((L.AmountBaseDebit - L.AmountBaseCredit)/1000),0) AS Total
	FROM     TransactionLine L INNER JOIN
             Journal J ON L.Journal = J.Journal INNER JOIN
             Ref_Account G ON L.GLAccount = G.GLAccount INNER JOIN
             Ref_AccountGroup P ON G.AccountGroup = P.AccountGroup
		 
	WHERE     (G.AccountType = 'Debit') AND (G.AccountClass = 'Result')
	AND     J.Mission = '#mission#'
	AND J.Journal IN
                       (SELECT   Journal
                        FROM     Journal
					WHERE 
					GLCategory IN ('Actuals','Obligation')
					AND (SystemJournal != 'Opening' OR SystemJournal IS NULL))
					--->
	GROUP BY P.AccountGroup, P.Description
	
	HAVING round(SUM((L.AmountBaseDebit - L.AmountBaseCredit)/1000),0) > 500	
	
	ORDER BY P.AccountGroup
  </cfquery>	
  
  <tr>
  <td colspan="2" height="20" align="center"><font size="2">Object Class with expenditures over USD 500.000</b>  <font size="2">(USD$1000)</font>
  </td>
  </tr>
  
  <tr><td colspan="2" class="line"></td></tr>
    
  <tr><td align="center" colspan="2">
     
  	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png"
           chartheight="140"
           chartwidth="840"
           showxgridlines="yes"
           seriesplacement="default"
           fontsize="9"
           fontbold="Yes"
           labelformat="number"
           tipstyle="mouseOver"
           tipbgcolor="ffffaf"
		   url="javascript:ColdFusion.navigate('#SESSION.root#/portal/topics/Financials/TopicDetail.cfm?objectclass=$ITEMLABEL$&mission=#mission#','detail')"
           showmarkers="yes"
           markersize="30"
           pieslicestyle="sliced"
           backgroundcolor="ffffff">
			 
		<cfchartseries
            type="bar"
             query="ObjectGroup"
             itemcolumn="Description"
             valuecolumn="Total"
             seriescolor="##00CCC6"			             
             markerstyle="snow"/>
		</cfchart>
  
  </td></tr>
  
  <!--- box for showing details --->    
  <tr><td colspan="2" id="detail"></td></tr>
  
    
  <tr>
  
  <cfloop index="itm" list="Obligation,Actuals" delimiters=",">
  
    <td align="center">
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#StatementAllCost">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#StatementCost">

	<cfquery name="Statement"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT 
             OP.ProgramCode AS PhaseCode, 
			 OP.ProgramName AS Phase, 
			 SUM(T.AmountBaseDebit) AS Debit, 
			 SUM(T.AmountBaseCredit) AS Credit, 
             OP.ListingOrder
	INTO     UserQuery.dbo.#SESSION.acc#StatementAllCost		 
	FROM     TransactionLine T INNER JOIN
             Journal J ON T.Journal = J.Journal AND J.Mission = '#mission#' INNER JOIN
                      Ref_Account G ON G.GLAccount = T.GLAccount INNER JOIN
                      Program.dbo.Program P ON T.ProgramCode = P.ProgramCode INNER JOIN
                      Program.dbo.Program OP ON LEFT(P.ProgramHierarchy, 7) = OP.ProgramHierarchy
	WHERE     (G.AccountType = 'Debit') AND (G.AccountClass = 'Result') 
	AND     J.Mission = '#mission#'
	AND J.Journal IN
                       (SELECT   Journal
                        FROM     Journal
					WHERE  GLCategory = '#itm#'
                        AND (SystemJournal != 'Opening' OR SystemJournal IS NULL))
    GROUP BY OP.ListingOrder, OP.ProgramCode, OP.ProgramName	
	</cfquery>

	<cfquery name="Statement"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT PhaseCode,
				Phase,
				Debit,
				Credit,
				ListingOrder
		INTO UserQuery.dbo.#SESSION.acc#StatementCost
		FROM UserQuery.dbo.#SESSION.acc#StatementAllCost
		UNION
		SELECT 'P5576' as PhaseCode,
			   '#mission# General' as Phase,
			   SUM(Amount) as Debit,
			   0 as Credit,
			   0 as ListingOrder
		FROM  TransactionHeader
		WHERE TransactionSource= 'IMIS'	
		AND   Mission = '#mission#'
	</cfquery>
	
	<cfquery name="Cost1"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE .dbo.#SESSION.acc#StatementCost
	SET Debit = 0.0
	WHERE Debit is null 
	</cfquery>

	<cfquery name="Cost2"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE .dbo.#SESSION.acc#StatementCost
	SET Debit = (Debit - Credit), Credit = 0.0
	WHERE Credit is not null
	</cfquery>

	<cfquery name="GTotals"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	Phase as #itm#Phase,
			PhaseCode as #itm#PhaseCode,
			Round(SUM(Debit)/1000,0) as #itm#		
	FROM   dbo.#SESSION.acc#StatementCost
	GROUP BY ListingOrder, PhaseCode, Phase 
	</cfquery>
				
	<cfquery name="GrandTotal" 
	dbtype="query" >
	Select SUM(#itm#) as Total
		from GTotals
	</cfquery>	

  <table>
  
    <tr><td colspan="4" class="line"></td></tr>
  
  	<cfif itm eq "Actuals">
  
  	<tr>
  	  <td colspan="2" align="center" valign="top">
	    <font size="2"><b>Disbursements by Phase</b></font>&nbsp;<font size="1">(USD$1000)</font>
	  </td>
    </tr>
	
	<cfelse>
	
	<tr>
  	  <td colspan="2" align="center">
	    <font size="2"><b>Outstanding Obligations by Phase</b></font>&nbsp;<font size="1">(USD$1000)</font>
	  </td>
    </tr>
		
	</cfif>
  	
	<tr><td colspan="4" class="line"></td></tr>
  
    <tr>
    <td colspan="2" align="center">
			
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png" 			       
	         chartheight="200" 
			 chartwidth="350" 
			 showxgridlines="yes" 
			 showygridlines="yes"
			 gridlines="6" 
			 showborder="no" 
			 fontsize="9" 
			 fontbold="yes" 
			 fontitalic="no" 
			 xaxistitle="" 
			 pieslicestyle="sliced"
			 yaxistitle="" 
			 show3d="yes"
			 rotated="no" 
			 sortxaxis="no" 
			 showlegend="yes" 
			 tipbgcolor="##FFFFCC" 
			 showmarkers="yes" 
			 markersize="30" 
			 backgroundcolor="##ffffff">			
		
		<cfchartseries type="pie"
             query="GTotals"
             itemcolumn="#itm#Phase"
             valuecolumn="#itm#"
             seriescolor="##00CCC6"
			 colorlist="##66CC66,##FF0000,##3399FF,##CCCC66" 					     
		     markerstyle="snow"/>
             
		</cfchart>
						
						
	</td>
	</tr>
	
	</table>
	
	</cfloop>
	
	</td>
</tr>	
		
<!--- first portion finished --->

<tr>

<cfloop index="prg" list="1_P5552,2_P5567" delimiters=",">
	<td align="center">
	<table>
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#StatementCost">
	
	<cfquery name="Design"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT 
	            OP.ProgramCode AS PhaseCode, 
				OP.ProgramName AS Phase, 
				SUM(CASE GLCategory WHEN 'Actuals' THEN T.AmountBaseDebit ELSE NULL END) AS ActualsDebit, 
				SUM(CASE GLCategory WHEN 'Actuals' THEN T.AmountBaseCredit ELSE NULL END) AS ActualsCredit, 
				SUM(CASE GLCategory WHEN 'Obligation' THEN T.AmountBaseDebit ELSE NULL END) AS ObligationDebit, 
				SUM(CASE GLCategory WHEN 'Obligation' THEN T.AmountBaseCredit ELSE NULL END) AS ObligationCredit, 
	            OP.ListingOrder
		INTO    UserQuery.dbo.#SESSION.acc#StatementCost		
	    FROM    TransactionLine T INNER JOIN
	            Journal J ON T.Journal = J.Journal AND J.Mission = '#mission#' INNER JOIN
	            Ref_Account G ON G.GLAccount = T.GLAccount INNER JOIN
	            Program.dbo.Program P ON T.ProgramCode = P.ProgramCode INNER JOIN
	            Program.dbo.Program OP ON P.ParentCode = OP.ProgramCode
	    WHERE   (G.AccountType = 'Debit') 
		AND     (G.AccountClass = 'Result')	
	    AND     (LEFT(OP.ProgramHierarchy, 7) = '#prg#')
		AND     J.Mission = '#mission#'
		GROUP BY OP.ListingOrder, OP.ProgramCode, OP.ProgramName   
		</cfquery>
		
			
	<cfquery name="Update"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE dbo.#SESSION.acc#StatementCost
		SET    Phase = 'General', 
		       ListingOrder = '0'
		WHERE  Phase = 'Design Phase' 
		</cfquery>	
		
	<cfloop index="itm" list="Actuals,Obligation" delimiters=",">
	
	<cfquery name="Cost1"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE dbo.#SESSION.acc#StatementCost
		SET #itm#Debit = 0.0
		WHERE #itm#Debit is null 
		</cfquery>
	
	<cfquery name="Cost2"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE dbo.#SESSION.acc#StatementCost
		SET #itm#Debit = (#itm#Debit - #itm#Credit), #itm#Credit = 0.0
		WHERE #itm#Credit is not null
		</cfquery>
		
	</cfloop>	
	
		<cfquery name="Design"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	Phase,
				PhaseCode,
				Round(SUM(ActualsDebit)/1000,0) as ActualsAmounts,	
				Round(SUM(ObligationDebit)/1000,0) as ObligationAmounts			
		FROM   dbo.#SESSION.acc#StatementCost
		GROUP BY ListingOrder, PhaseCode, Phase  
		</cfquery>	
		
		<cfquery name="DesignTot" 
		dbtype="query" >
			SELECT 
			SUM(ActualsAmounts) as Actuals, 
			SUM(ObligationAmounts) as Obligation
			from Design
		</cfquery>			
		
		<tr>
	  
	    	<td colspan="2" align="left">
			   <cfif prg eq "1_P5552">
		    	  <b>Design Phase</b></font>
			   <cfelse>
			      <b>Construction Phase</b></font>
			   </cfif>	   
		    </td>
	    </tr>	
		
		<tr><td colspan="2" class="line" height="1"></td></tr>
		
			
		<tr>
	  
	    	<td>
	    	   Disbursements: </td><td><b>#numberformat(DesignTot.Actuals,'_,_')# (in red)</b>
			   </b></font>
		    </td>
	    </tr>	
		
		<tr>
	  
	    	<td>
	    	  Outstanding Obligations:</td><td> <b>#numberformat(DesignTot.Obligation,'_,_')# (in yellow)</b></font>
		    </td>
	    </tr>	
				
		<tr><td align="center" colspan="2">
		
		
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png" 
		         chartheight="160" 
				 chartwidth="340" 
				 showxgridlines="yes" 
				 showygridlines="yes"				
				 showborder="no" 
				 fontsize="9" 
				 fontbold="yes" 
				 fontitalic="no" 
				 xaxistitle="" 
				 yaxistitle="" 
				 show3d="no" 
				 rotated="no" 
				 seriesplacement="stacked"
				 sortxaxis="no" 
				 showlegend="no" 
				 tipbgcolor="##FFFFCC" 
				 showmarkers="yes" 
				 markersize="30" 
				 backgroundcolor="##ffffff">
				 
				<cfchartseries
	             type="bar"
	             query="Design"
	             itemcolumn="Phase"
	             valuecolumn="ActualsAmounts"
	             seriescolor="##FF0000"	           
	             markerstyle="snow">
				 
				 <cfchartseries
	             type="bar"
	             query="Design"
	             itemcolumn="Phase"
	             valuecolumn="ObligationAmounts"
	             seriescolor="yellow"	            
	             markerstyle="snow"/>
				 
			</cfchart>
		
		</td>
		</tr>
		
		</table>
		</td>
		
</cfloop>

</tr>	
		
</table>
	
</cfoutput>	
