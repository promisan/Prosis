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
<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfparam name="url.mission" default="">

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#&mission=#url.mission#", "Add", "left=80, top=80, width=1100, height=900, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function categoryedit(cat) {

	var vHeight = document.body.clientHeight-50;
	var vWidth = document.body.clientWidth-200;	
	ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&mission=#url.mission#&id1="+cat, "Edit");   
}

function recordrefresh(cat) {

	if (document.getElementById('box_'+cat)) {			   
	    ptoken.navigate('RecordListingMission.cfm?code='+cat,'box_'+cat)	
	} else {
	  history.go()
	}	

}

function show(row) {
  se = document.getElementsByName('box'+row)
  cnt = 0
  if (se[0].className == "hide") {    
    while (se[cnt]) {
	  se[cnt].className = 'labelit';	 	 
	  cnt++
	} 
  } else {
     while (se[cnt]) {
	  se[cnt].className = 'hide';
	  cnt++
	 } 
  }
}

</script>	

</cfoutput>


<tr><td>

	<cf_divscroll>	

	<table width="97%" height="100%" align="center" class="navigation_table">
		
	<tr><td colspan="9">
		
		<cfquery name="MissionList"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT DISTINCT Mission
			FROM Ref_ParameterMissionCategory	
		</cfquery>
		
		<table cellspacing="0" cellpadding="0">
			<tr>
			<td class="labelit">&nbsp;Click here to filter:&nbsp;</td>
			<td class="labelmedium">
			<cfoutput>
			<a href="RecordListing.cfm?mission=&idmenu=#url.idmenu#&idrefer=#url.idrefer#"><cfif url.mission eq ""><b></cfif>ANY</b></a> 
			</cfoutput>
			   <cfif MissionList.recordcount gte "1">,</cfif>
			<cfoutput query="MissionList">
			   <a href="RecordListing.cfm?mission=#mission#&idmenu=#url.idmenu#&idrefer=#url.idrefer#"><cfif url.mission eq mission><b></cfif>#mission#</b></a> 
			   <cfif currentrow neq recordcount>|</cfif>
			</cfoutput>
			</td>
			</tr>
		</table>
	
	</td></tr>
	
	<tr><td style="height:100%">
	
	<cf_divscroll>
	
	<table style="width:100%" class="navigation_table">
	
	<tr class="labelmedium2 line fixrow">
	    <td></td>  
		<td></td> 
	    <td>Code</td>
		<td>Description</td>
		<td></td>
		<td align="center">Entry</td>
		<td>Entity</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	
	<cfquery name="SearchResult"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *,
				(SELECT TOP 1 BudgetEarmark FROM  Ref_ParameterMissionCategory
				WHERE Category = P.Code 
				AND BudgetEarmark = 1) as BudgetEarmark
		FROM    Ref_ProgramCategory P
		WHERE   (P.Parent is NULL or P.Parent = '')
		<cfif url.mission neq "">	
		AND     P.Code IN (SELECT Category 
		                FROM Ref_ParameterMissionCategory 
						WHERE Mission = '#url.mission#')
		</cfif>
		ORDER BY P.Area,P.ListingOrder
	</cfquery>
	
	<cfoutput query="SearchResult">
	
		<cfset earmark = budgetearmark>
	    
		<tr class="navigation_row line labelmedium2">
			<td style="padding-left:10px" align="left" width="40" class="navigation_action"  onclick="categoryedit('#Code#')">	 
				<cf_img icon="select">		 
			 </td>			 	 
			<td></td> 
			<td style="height:40px;padding-left:5px">#Code#</td>
			<td width="40%">#Description#</td>
			<td></td>
			<td align="center"><cfif entryMode eq 0>No</b></cfif></td>
			<td id="box_#code#" style="padding-top:2px">
				<cfinclude template="RecordListingMission.cfm">
			</td>	
			<td>#OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>		
		
		<cfquery name="Level2"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *, (SELECT count(*) FROM Ref_ProgramCategory WHERE Parent = C.Code) as Children
			FROM   Ref_ProgramCategory C
			WHERE  Parent = '#Code#'		
		</cfquery>
	
	  <cfloop query="level2"> 
		
		<tr bgcolor="ffffcf" class="labelmedium2 line navigation_row">
			<td align="left" bgcolor="ffffff" style="padding-left:20px" class="navigation_action" onclick="categoryedit('#Code#')"> 		
				<cf_img icon="select">				 
			 </td>
			<td style="padding-left:3px;padding-top:5px">
			  <cfif children gte "1">
					<cf_img icon="expand" toggle="Yes" onClick="show('#SearchResult.currentrow#_#currentrow#')" state="open">
			  </cfif>		
			</td>
			<td style="padding-left:20px">#Code#</td>
			<td >#Description#</td>
			<td ><cfif earmark eq "1">#EarmarkPercentage#%</cfif></td>
			<td align="center"><cfif entryMode eq 0><b>No</b></cfif></td>
			<td></td>
			<td>#OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		
		<cfquery name="Level3"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM Ref_ProgramCategory
			WHERE Parent = '#Level2.Code#'
		</cfquery>
	
	    <cfloop query="level3">
		
		    <tr bgcolor="ffffef" class="labelmedium line navigation_row" 
			    name="box#SearchResult.currentrow#_#Level2.currentrow#" id="box#SearchResult.currentrow#_#Level2.currentrow#" class="hide">
				<td align="right" bgcolor="white" class="navigation_action"  onclick="categoryedit('#Code#')" style="padding-left:8px">
				   <cf_img icon="select">	
				</td>
				<td>
				</td>
				<td  style="padding-left:30px">#Code#</td>
				<td>#left(Description,60)#</a></td>
				<td><cfif earmark eq "1">#EarmarkPercentage#%</cfif></td>
				<td align="center"><cfif entryMode eq 0><b>No</b></cfif></td>
				<td></td>
				<td>#OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
	    
	    </cfloop>
	     
	  </cfloop>
		
	</CFOUTPUT>	
	</table>
	</cf_divscroll>
	</td>
	</tr>
	
	</table>
	
</td></tr>
</table>	

<cfset ajaxonload("doHighlight")>

