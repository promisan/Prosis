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

<cfinvoke component = "Service.Access"  
	 method         = "roster" 
	 returnvariable = "rosterAccess"
	 role           = "'AdminRoster','RosterClear'">
	 
<cfoutput>

<script language="JavaScript">

function gjp(fun,grd) {   
    ptoken.open("#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionGradePrint.cfm?ID=" + fun + "&ID1=" + grd, "_blank", "toolbar=no, status=yes, scrollbars=yes, resizable=yes"); 
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2 navigation_row line labelmedium2 fixlengthlist";
	 }else{
		
     itm.className = "navigation_row line labelmedium2 fixlengthlist";		
	 }
 }
 
function first() {
	ptoken.location('Search1.cfm?docno=#url.docno#&ID=#URL.ID#&Owner=#URL.Owner#&Mode=#URL.Mode#&Status=#URL.Status#')
}

</script>  

</cfoutput>

<cfparam name="URL.wparam" default="ALL">
<cfset failed = "0">
<cfset Fun = "">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
  FROM    Ref_ParameterOwner
  WHERE   Owner = '#URL.Owner#'
</cfquery>

<cfparam name="URL.docNo" default="">


<cfoutput>-----#url.wparam#-----</cfoutput>

<cfif URL.mode eq "Vacancy" and url.wparam neq "FULL">
	
	<cfquery name="DefineOcc" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT F.OccupationalGroup
	    FROM   FunctionTitle F, Vacancy.dbo.Document D
		WHERE  F.FunctionNo = D.FunctionNo
		AND    D.DocumentNo = '#URL.DocNo#' 
	</cfquery>
	
	<cfset Occ = DefineOcc.OccupationalGroup>
	
<cfelse>

	<cfset Occ = "">	

</cfif>

<cfquery name="OccGroup" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT     DISTINCT O.*
     FROM    dbo.FunctionTitle F INNER JOIN
             dbo.FunctionOrganization F1 ON F.FunctionNo = F1.FunctionNo INNER JOIN
             dbo.Ref_Organization R ON F1.OrganizationCode = R.OrganizationCode INNER JOIN
             dbo.OccGroup O ON F.OccupationalGroup = O.OccupationalGroup INNER JOIN
			 dbo.Ref_SubmissionEdition E ON F1.SubmissionEdition = E.SubmissionEdition
     WHERE   F1.SubmissionEdition IN (SELECT SelectId
                                	 FROM    RosterSearchLine
                                	 WHERE   SearchId = #URL.ID#
                                 	 AND     SearchClass = 'Edition')
									 
	 AND    (F.FunctionRoster = '1' OR F1.ReferenceNo IN ('Direct','direct') OR F1.PostSpecific = 0 OR E.EnableAsRoster = 1)									 
	 	 
	 <cfif occ neq "">
	 
	 AND     O.OccupationalGroup = '#occ#'		
	 			 
	 <cfelseif rosterAccess eq "NONE" and URL.Mode neq "Limited" and URL.Mode neq "Vacancy" and getAdministrator("*") eq "No">	
			 
	 <!--- give access to logical buckets for which a person has been granted access through one of more vacancies ---> 			
	 		 
	 AND  F1.FunctionId IN 
	 		(SELECT DISTINCT Bucket.FunctionId
			FROM     RosterAccessAuthorization A INNER JOIN
        			 FunctionOrganization FO ON A.FunctionId = FO.FunctionId INNER JOIN
                  	 FunctionOrganization Bucket ON FO.FunctionNo = Bucket.FunctionNo AND FO.OrganizationCode = Bucket.OrganizationCode AND FO.GradeDeployment = Bucket.GradeDeployment					
			WHERE    A.UserAccount = '#SESSION.acc#')					
			
	 </cfif>
     ORDER BY Description 
</cfquery>

<cfif OccGroup.recordcount eq "0">

	<cf_message message="Problem, you have no access to retrieve rostered candidates">
	<cfabort>

</cfif>

<cfset initocc = OccGroup.OccupationalGroup>

<cfquery name="Search" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearch
		WHERE SearchId = '#URL.ID#' 
</cfquery>  

<cfquery name="Prior" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#' 
		AND  SearchClass = 'OccGroup'
</cfquery>  

<cfif prior.recordcount eq "1">

 <cfset initocc = prior.selectid>
 
</cfif>

<cfif Search.SearchCategory eq "Vacancy">

	<cfquery name="DefineOcc" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT FunctionNo
	    FROM   Vacancy.dbo.Document D
		WHERE  D.DocumentNo = #Search.SearchCategoryId# 
	</cfquery>
	
	<cfset Fun = DefineOcc.FunctionNo>

</cfif>   

 
<body leftmargin="0" onLoad="javascript: try {document.forms.functionselect.occupationalgroup.focus()} catch(e) {};">

<cf_screentop html="No" label="Roster Bucket Select" jquery="Yes" height="100%" scroll="Yes">

<cfform action="Search2Submit.cfm?docno=#url.docno#&ID=#URL.ID#&Owner=#URL.Owner#&mode=#URL.Mode#&status=#url.status#&scope=roster" 
   method="POST" name="functionselect" style="height:97%">

<table width="98%" height="98%" align="center" class="formpadding">

<tr><td valign="top" height="100%">

	<table height="100%" width="100%" align="center">
	 
	 <tr>
	    <td height="31" valign="top" style="padding-top:5px">		
				
			<cfif occgroup.recordcount gte "2">
			
		    	<select id="occupationalgroup" name="occupationalgroup" size="1" style="height:35px;font-size:18px;border:0px;background-color:f1f1f1;" class="regularxxl">
				<!--- <option value="" selected>All groups</option> --->
			    <cfoutput query="OccGroup">
				<option value="#OccupationalGroup#" <cfif initocc eq OccupationalGroup>selected</cfif>>#Description#</option>
				</cfoutput>
			    </select>			
							
			<cfelse>
			
				<input type="hidden" id="occupationalgroup" name="occupationalgroup" value="<cfoutput>#occgroup.occupationalgroup#</cfoutput>">	
				
			</cfif>	
		  
		</td>
		<td align="right"><input type="reset"  value="Reset" class="button10s" style="height:25px;width:130px"></td>
		
	 </tr> 	
	 
	 <tr class="labelmedium2 line"><td colspan="2" align="left" style="height:40px;font-size:18px;color:gray;padding-left:5px">
	 
		 <cfif URL.DocNo neq "">
		     Attention: Recruitment Search is limited to listed buckets of associated occupational group of the recruitment track
		 <cfelse>
			 <cf_tl id="Select one or more buckets from occupational group" class="Message">
		 </cfif>	 
	 
	</td></tr>
	   
	<tr><td colspan="2" height="97%" valign="top">
	
		<cf_divscroll style="width:96%;height:99%">
		   <cf_securediv id="base" bind="url:Search2Detail.cfm?id=#url.id#&owner=#url.owner#&mode=#url.mode#&occ={occupationalgroup}">
		</cf_divscroll>
	
	</td></tr>
			
	</table>	

</td>
</tr>

<tr><td colspan="2" height="35">
	
	<table width="100%" align="center">
	
	<tr>
	<td align="center" valign="middle">
	
	<button name="Prior" id="Prior" style="width: 160px;height:27" class="button10g" value="Next" type="button" onClick="first()">
	    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/prev.gif" align="absmiddle" alt="" border="0"><cf_tl id="Back">
	</button>
			
	<button name="Prios" id="Prios" style="width: 160px;height:27" onclick="Prosis.busy('yes')" class="button10g" value="Prior" type="submit"><cf_tl id="Search Criteria">
	    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/next.gif" border="0" align="absmiddle"> 
	</button>
		
	</td></tr>
	</table>

</td></tr>

</table>	

</CFFORM>

