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
<cfparam name="Attributes.Alias"      default="">
<cfparam name="Attributes.Base"       default="">
<cfparam name="Attributes.Condition"  default="">

<cfparam name="Attributes.Group1"       default="">
<cfparam name="Attributes.Group2"       default="">

<cfparam name="Attributes.Grp1Nme"      default="">
<cfparam name="Attributes.Grp1Hdr"      default="">
<cfparam name="Attributes.Grp1Ser"      default="">
<cfparam name="Attributes.Grp1Ord"      default="">
<cfparam name="Attributes.Grp1Rec"      default="">
<cfparam name="Attributes.Grp1Wid"      default="">
<cfparam name="Attributes.Grp2Nme"      default="">
<cfparam name="Attributes.Grp2Hdr"      default="">
<cfparam name="Attributes.Grp2Ser"      default="">
<cfparam name="Attributes.Grp2Ord"      default="">
<cfparam name="Attributes.Grp2Rec"      default="">
<cfparam name="Attributes.Grp2Wid"      default="">

<cfparam name="Attributes.XaxLbl"     default="">
<cfparam name="Attributes.XaxOrd"     default="">
<cfparam name="Attributes.XaxFld"     default="">
<cfparam name="Attributes.YaxLbl"     default="">
<cfparam name="Attributes.YaxOrd"     default="">
<cfparam name="Attributes.YaxFld"     default="">

<cfparam name="Attributes.Formula_1_L"   default="">
<cfparam name="Attributes.Formula_1_C"   default="">
<cfparam name="Attributes.Formula_1_T"   default="">
<cfparam name="Attributes.Formula_2_L"   default="">
<cfparam name="Attributes.Formula_2_C"   default="">
<cfparam name="Attributes.Formula_2_T"   default="">

<cfparam name="Attributes.FormulaT"      default="">

<cfset Alias     = "#Attributes.Alias#">
<cfset Base      = "#Attributes.Base#">
<cfset Condition = "#Attributes.Condition#">

<cfset XLbl      = "#Attributes.XaxLbl#">
<cfset XOrd      = "#Attributes.XaxOrd#">
<cfset XFld      = "#Attributes.XaxFld#">

<cfset YLbl      = "#Attributes.YaxLbl#">
<cfset YOrd      = "#Attributes.YaxOrd#">
<cfset YFld      = "#Attributes.YaxFld#">

<cfparam name="Group1"    default="#Attributes.Group1#">
<cfparam name="Group2"    default="#Attributes.Group2#">

<cfparam name="Grp1Nme"   default="#Attributes.Grp1Nme#">
<cfparam name="Grp1Hdr"   default="#Attributes.Grp1Hdr#">
<cfparam name="Grp1Ser"   default="#Attributes.Grp1Ser#">
<cfparam name="Grp1Ord"   default="#Attributes.Grp1Ord#">
<cfparam name="Grp1Rec"   default="#Attributes.Grp1Rec#">
<cfparam name="Grp1Wid"   default="#Attributes.Grp1Wid#">
<cfparam name="Grp2Nme"   default="#Attributes.Grp2Nme#">
<cfparam name="Grp2Hdr"   default="#Attributes.Grp2Hdr#">
<cfparam name="Grp2Ser"   default="#Attributes.Grp2Ser#">
<cfparam name="Grp2Ord"   default="#Attributes.Grp2Ord#">
<cfparam name="Grp2Rec"   default="#Attributes.Grp2Rec#">
<cfparam name="Grp2Wid"   default="#Attributes.Grp2Wid#">

<cfset formula_1_L    = "#Attributes.Formula_1_L#">
<cfset formula_1_C    = "#Attributes.Formula_1_C#">
<cfset formula_1_T    = "#Attributes.Formula_1_T#">

<cfset formula_2_L    = "#Attributes.Formula_2_L#">
<cfset formula_2_C    = "#Attributes.Formula_2_C#">
<cfset formula_2_T    = "#Attributes.Formula_2_T#">

<cfset formulaT       = "#Attributes.FormulaT#">

<cfset baselink = "">

<cfloop index="ax" list="X,Y" delimiters=",">
	
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_Pivot#ax#">	
	
	<cfset tbl = "userquery.dbo.#SESSION.acc#_Pivot#ax#">
	
	<cfquery name="CreateAx" 
	datasource="#alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 	SELECT   IDENTITY (int, 1, 1) AS SerialNo, 
		         '#evaluate("#ax#Lbl")#' AS FieldLabel,
				 '#evaluate("#ax#Ord")#' AS FieldName, 
				 #evaluate("#ax#Fld")# AS FieldHeader,		         
				 #evaluate("#ax#Ord")# AS FieldValue			 
		INTO     #tbl#
		FROM     #Base#
		WHERE    1=1 #preservesinglequotes(Condition)#
		GROUP BY #evaluate("#ax#Fld")# <cfif evaluate("#ax#Ord") neq evaluate("#ax#Fld")>,#evaluate("#ax#Ord")#</cfif>
		ORDER BY #evaluate("#ax#Ord")# 
	</cfquery>	
	
	<cfquery name="#Ax#ax" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
			SELECT     *
			FROM #tbl#		
			WHERE FieldValue is not NULL	
			ORDER BY SerialNo	
	</cfquery>	
	
	<cfif baselink eq "">
	   <cfset select    = "#tbl#.serialNo as #Ax#axArray">
	   <cfset dimens    = "#tbl#">
	   <cfset baselink  = "#Base#.#evaluate('#ax#Ord')# = #tbl#.FieldValue">
	   <cfset groupby   = "#tbl#.serialNo">
	<cfelse>
	   <cfset select    = "#select#, #tbl#.serialNo as #Ax#axArray">	
	   <cfset dimens    = "#dimens#, #tbl#">
	   <cfset baselink  = "#baselink# AND #Base#.#evaluate('#ax#Ord')# = #tbl#.FieldValue">	
	   <cfset groupby   = "#groupby#, #tbl#.serialNo">
	</cfif>

</cfloop>

<cfset formula = queryNew("Presentation,FieldName,FieldValue,FieldHeader,FieldSummary,FieldWidth,FieldDataType", "CF_SQL_VARCHAR,CF_SQL_VARCHAR, CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR")>

<cfloop index="row" from="1" to="2">

	<cfif evaluate('formula_#row#_C') neq "">
	
	<cfset queryaddrow(formula, 1)>		
	<cfset querysetcell(formula, "Presentation", "Formula#row#", row)>	
	<cfset querysetcell(formula, "FieldHeader", "#evaluate('formula_#row#_L')#", row)>
	<cfset querysetcell(formula, "FieldName", "#evaluate('formula_#row#_C')# as CellValue#row#", row)>
	<cfset querysetcell(formula, "FieldValue", "CellValue#row#", row)>
	<cfset querysetcell(formula, "FieldSummary", "'#evaluate('formula_#row#_T')#' as Cell#row#", row)>
	<cfset querysetcell(formula, "FieldWidth", "70", row)>
	<cfset querysetcell(formula, "FieldDataType", "amount0", row)>
	
	</cfif>

</cfloop>

<cfset formulaC = "">
<cfset formulaT = "">

<cfloop query="Formula">

	<cfif #evaluate('formula_#currentrow#_T')# neq "">
	
		<cfset row = currentrow>
		
		<!--- artificial weight = 1 --->
		
		<cfset wt =  "#evaluate('formula_#row#_T')#(CellValue#row#) as CellWeightValue#row#, 1 as CellWeight#row#">
		
		<cfif formulaC eq "">
		   <cfset formulaB  = "#FieldName#">
		   <cfset formulaC  = "#FieldValue#">
		   <cfset formulaT  = "#FieldSummary#, #evaluate('formula_#row#_T')#(CellValue#row#) as CellValue#row#, #wt#">	  
		<cfelse>
		   <cfset formulaB  = "#formulaB#,#FieldName#">
		   <cfset formulaC  = "#formulaC#,#FieldValue#">
		   <cfset formulaT  = "#formulaT#,#FieldSummary#, #evaluate('formula_#row#_T')#(CellValue#row#) as CellValue#row#, #wt#">	  
		</cfif>
	
	</cfif>

</cfloop>

<cfquery name="CrossTabData" 
	datasource="#alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   #select#,	         
			 #preservesingleQuotes(formulaB)# 
	FROM     #base#, #dimens#
	WHERE    #baselink# #preservesinglequotes(condition)# 
	GROUP BY #groupby#
</cfquery>

<cfset node       = "1">
<cfset group      = "1">
<cfset mode       = "0">
<cfset hidegraph  = "1">
<cfset client.wc  = "100">
<cfset controlid  = "">
<cfset format     = "HTML">
<cfset client.pvtdrill = "1">

<link href="<cfoutput>#SESSION.root#/tools\pivot\crosstab.css</cfoutput>" rel="stylesheet" type="text/css">

<div style="height:100%; width:100%; padding:4px;position:absolute; overflow-x: auto; scrollbar-face-color: d4d4d4; overflow-y: auto;">	

	<table cellspacing="0" cellpadding="0" style="border:1px dashed silver;">
		<cfinclude template = "CrossTab_Header.cfm">
		<cfinclude template = "CrossTab_Total.cfm">
		<cfinclude template = "CrossTab_Row.cfm">
	</table>
	
</div>		


	