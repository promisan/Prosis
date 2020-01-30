
<cfoutput>
	<link href="#SESSION.root#/#client.style#" rel="stylesheet" type="text/css">
	<link href="#SESSION.root#/print.css" rel="stylesheet" type="text/css" media="print">
</cfoutput>

<cfparam name="URL.ID2"    default="HRPO">
<cfparam name="URL.Tree"   default="#URL.ID2#">
<cfparam name="URL.Period" default="P07-08">
<!---
<cfparam name="url.Date"   default="31/10/2007">
--->

<cfquery name="Audit"
datasource="appsProgram">	
SELECT  * 
FROM    Ref_Audit
WHERE   Period = '#URL.Period#'
AND     AuditDate <= getDate()
ORDER BY AuditDate DESC
</cfquery>

<cfset date= Audit.AuditDate>

<!--- 
1. Create a table with maximum possible scores
2. Update table with actual score
3. Update table column with
4. Overall
5. Drill down to categories
--->

<cfoutput>
<script>
function reload(tree,date) {
	window.location = "#SESSION.root#/programRem/Application/Indicator/Score/ScoreView.cfm?tree="+tree+"&date="+date
}

function maximize(itm){
	 
	 se   = document.getElementsByName(itm)
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 count = 0
		 
	 if (icM.className == "regular") {
		
	 icM.className = "hide";
	 icE.className = "regular";
	 
	 while (se[count]) {
	   se[count].className = "hide"
	   count++ }
	 
	 } else {
	 	 
	 while (se[count]) {
	 se[count].className = "regular"
	 count++ }
	 icM.className = "regular";
	 icE.className = "hide";			
	 }
  }  
  
  
function indicator(org,cat,nme,ser) {

      frm = document.getElementById("c"+ser);	  	
	  if (frm.className == "hide") {
	      frm.className = "regular"				  
	      ColdFusion.navigate('#SESSION.root#/programREM/Application/Indicator/Score/ScoreViewDetail.cfm?orgunit='+org+'&date=#date#&tree=#URL.Tree#&period=#url.period#&programcategory='+cat+'&programname='+nme,'content'+ser)	
	  } else {
	     frm.className = "hide"
	  }	  
		  
}
	  
function more(bx,act,id) {
 	
	se   = document.getElementById("e"+bx);	
	frm  = document.getElementById("i"+bx);
		 		 
	if (se.className=="hide") {
	     se.className   = "regular";		
		 window.open("#SESSION.root#/ProgramREM/Application/Indicator/Audit/IndicatorAuditGraph.cfm?h=200&time=#now()#&id=" + id + "&period=#URL.Period#", "i"+bx)        	 }	 
	 else {
	   	 se.className  = "hide"
	 }
		 		
  }		  

	
</script>

</cfoutput>

<cfquery name="Period"
datasource="appsProgram">	
SELECT * FROM Ref_Period
WHERE Period = '#URL.Period#'
</cfquery>

<!--- take the last date for the summary --->


<cfinclude template="ScoreViewPrepare.cfm">

<!--- Phase 4 update Missing : PENDING --->

<!--- if manual update manual and update external is external is 99999 --->
<cfquery name="Result"
datasource="appsQuery">	
	SELECT * 
	FROM   ProgramIndicatorWeight#fileNo#
	ORDER BY HierarchyCode, OrgUnitName,ProgramCategory,ProgramName
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td>
	
<cfoutput>	
  
<table border="0" width="99%" align="center" cellspacing="0" cellpadding="0">

<tr><td colspan="9" height="36" align="left">
	<b><font face="Verdana" size="2" color="002350"><b>Indicator Consolidated View for #Period.Description#</b>
	</td>
</tr>

</cfoutput>

<tr><td height="1" colspan="9" bgcolor="C0C0C0"></td></tr>

<tr>
	<td class="labelit">Area</td>
	<td class="labelit" align="right">Indicators</td>
	<td class="labelit" align="right" width="80">Overall Average</td>
	<td class="labelit" align="right" width="80">Initial Score</td>
	<td class="labelit" align="right" width="80">Compliance</td>
	<td class="labelit" align="right" width="80">Score<br>Adjusted</td>
	<td class="labelit" align="right" width="80">Compliance</td>
	<td class="labelit" align="right" width="80">Not<br>reported</td>
</tr>

<cfoutput query="Result" group="OrgUnitName">

<cfquery name="Tree"
datasource="appsQuery">	
	SELECT sum(Indicators) as Indicators,
		   sum(MaxScore) as Maxscore, 
	       sum(ResultExternal) as ResultExternal,
		   sum(ResultManual) as ResultManual,
		   sum(MissingAudits) as MissingAudits
	FROM ProgramIndicatorWeight#fileNo#
	WHERE OrgUnit = '#OrgUnit#'
</cfquery>

<tr bgcolor="ECF5FF" style="cursor: pointer;" onClick="maximize('d#OrgUnit#')" onMouseOver="document.d#OrgUnit#Exp.src='#SESSION.root#/Images/expand-over.gif';document.d#OrgUnit#Min.src='#SESSION.root#/Images/collapse-over.gif'" onMouseOut="document.d#OrgUnit#Exp.src='#SESSION.root#/Images/expand5.gif';document.d#OrgUnit#Min.src='#SESSION.root#/Images/collapse5.gif'">
<td width="300">
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
	<td width="20">
	
	 			<img src="#SESSION.root#/Images/expand5.gif" alt="Expand" 
		       	 name="d#OrgUnit#Exp" border="0" class="regular" 
				 align="absmiddle" style="cursor: pointer;">
					
				<img src="#SESSION.root#/Images/collapse5.gif" 
				name="d#OrgUnit#Min" alt="Collapse" border="0" 
				align="absmiddle" class="hide" style="cursor: pointer;">
	</td>
	<td class="labelit">&nbsp;<b>#OrgUnitName#</td>
	</td></tr>
	</table>
</td>
<td align="right"><b>#Tree.Indicators#</td>
<td align="right"><b>#numberformat(Tree.MaxScore,"__,_")#</td>
<td align="right"><b>#Tree.ResultExternal#</td>
<td align="right"><b>#numberformat(Tree.ResultExternal/Tree.MaxScore*100,"__._")# %</td>
<td align="right"><b>#Tree.ResultManual#</td>
<td align="right"><b>#numberformat(Tree.ResultManual/Tree.MaxScore*100,"__._")# %</td>
<td align="right">0</td>
</tr>

<tr><td colspan="9" height="1" class="line"></td></tr>

<cfoutput group="ProgramCategory">

<tr class="hide" id="d#OrgUnit#">
<td colspan="8" bgcolor="ECF5FF">&nbsp;#ProgramCategoryName#</td>
</tr>

<cfoutput>

	<cfif result eq "0">
		<cfset color = "ffffcf">
	<cfelse>
		<cfset color = "ffffff">
	</cfif>

	<tr bgcolor="#color#" id="d#OrgUnit#" class="hide">
	<td width="300">
	
		<table cellspacing="0" cellpadding="0">
		<tr>
			<td width="40"></td>
			<td><a href="javascript:indicator('#orgunit#','#programcategory#','#programname#','#currentrow#')">#ProgramName#</a></td>
		</tr>
		</table>
		
	</td>
	<td align="right">#Indicators#</td>
	<td align="right">#numberformat(MaxScore,"__,_")#</td>
	<td align="right"><cfif result eq "1">#ResultExternal#</cfif></td>
	<td align="right"><cfif result eq "1">#numberformat(ResultExternal/MaxScore*100,"__._")# %</cfif></td>
	<td align="right"><cfif result eq "1">#ResultManual#</cfif></td>
	<td align="right"><cfif result eq "1">#numberformat(ResultManual/MaxScore*100,"__._")# %</cfif></td>
	<td align="right">0</td>
	</tr>
	
	<tr id="d#OrgUnit#" class="hide">
	    
		<td colspan="8">
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr id="c#currentrow#" class="hide">
				<td id="content#currentrow#"></td>
			</tr>
		</table>
		</td>
	</tr>

</cfoutput>

</cfoutput>

</cfoutput>


</table>
</td></tr>
</table>

<CF_DropTable dbName="AppsQuery" 
      tblName="ProgramIndicatorScore#fileNo#"> 

<CF_DropTable dbName="AppsQuery" 
      tblName="ProgramIndicatorWeight#fileNo#"> 
	  

