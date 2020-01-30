
<cfinvoke component = "Service.Access"  
	 method         = "roster" 
	 returnvariable = "rosterAccess"
	 role           = "'AdminRoster','RosterClear'">
	 
<cfoutput>

<script language="JavaScript">

function gjp(fun,grd) {   
    window.open("#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionGradePrint.cfm?ID=" + fun + "&ID1=" + grd, "_blank", "toolbar=no, status=yes, scrollbars=yes, resizable=yes"); 
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
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "regular";		
	 }
 }
 
function first() {
	window.location = "Search1.cfm?docno=#url.docno#&ID=#URL.ID#&Owner=#URL.Owner#&Mode=#URL.Mode#&Status=#URL.Status#"
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
             dbo.OccGroup O ON F.OccupationalGroup = O.OccupationalGroup
     WHERE   F1.SubmissionEdition IN (SELECT SelectId
                                	 FROM    RosterSearchLine
                                	 WHERE   SearchId = #URL.ID#
                                 	 AND     SearchClass = 'Edition')
	 AND     F.FunctionRoster = '1'		
	 
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

	<cf_waitEnd>
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
 
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" 
onLoad="javascript: try {document.forms.functionselect.occupationalgroup.focus()} catch(e) {};">

<cf_screentop html="No" label="Roster Bucket Select" height="100%" scroll="Yes">


<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td valign="top" height="100%">

<cfform action="Search2Submit.cfm?docno=#url.docno#&ID=#URL.ID#&Owner=#URL.Owner#&mode=#URL.Mode#&status=#url.status#" method="POST" name="functionselect" style="height:100%">

<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td valign="top" height="100%">

	<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	 
	 <tr>
	    <td height="31" valign="top">
		
				
			<cfif occgroup.recordcount gte "2">
			
		    	<select id="occupationalgroup" name="occupationalgroup" size="1" class="regularxl">
				<!--- <option value="" selected>All groups</option> --->
			    <cfoutput query="OccGroup">
				<option value="#OccupationalGroup#" <cfif initocc eq OccupationalGroup>selected</cfif>>
		    		#Description# 
				</option>
				</cfoutput>
			    </select>			
							
			<cfelse>
			
				<input type="hidden" id="occupationalgroup" name="occupationalgroup" value="<cfoutput>#occgroup.occupationalgroup#</cfoutput>">	
				
			</cfif>	
		  
		</td>
		<td align="right">
		<input type="reset"  value="Reset" class="button10s" style="height:21;width:130px">	
		</td>
	 </tr> 	
	 
	 <tr><td height="1" colspan="2" class="linedotted"></td></tr>
	 
	 <tr><td colspan="2" height="25" align="left" class="labelit" style="padding-left:5px">
	 <cfif URL.DocNo neq "">
	     <font color="C0C0C0">Recruitment Search is limited to listed buckets of associated occupational group</i></font>
	 <cfelse>
		 <cf_tl id="Select one or more buckets from occupational group" class="Message">
	 </cfif>	 
	</td></tr>
	 
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	   
	<tr><td colspan="2" height="100%" valign="top">
		<cf_divscroll style="height:100%">
		   <cfdiv id="base" bind="url:Search2Detail.cfm?id=#url.id#&owner=#url.owner#&mode=#url.mode#&occ={occupationalgroup}">
		</cf_divscroll>
	
	</td></tr>
	
	<tr><td height="1" valign="bottom"></td></tr>
	<tr><td height="1" colspan="2"  class="line"></td></tr>
	
	</table>	

</td>
</tr>

<tr><td colspan="2" height="35">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr>
	<td align="center" valign="middle">
	
	<button name="Prior" id="Prior" style="width: 160px;height:27" class="button10g" value="Next" type="button" onClick="first()">
	    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/prev.gif" align="absmiddle" alt="" border="0">&nbsp;Back
	</button>
			
	<button name="Prios" id="Prios" style="width: 160px;height:27" 
	    class="button10g" value="Prior" type="submit">&nbsp;Search Criteria
	    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/next.gif" border="0" align="absmiddle"> 
	</button>
		
	</td></tr>
	</table>

</td></tr>

</table>	

</CFFORM>


</td></tr>

</table>
