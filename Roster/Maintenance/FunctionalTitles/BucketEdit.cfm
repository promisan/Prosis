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
<cf_screentop height="100%" label="Edit bucket" html="yes" layout="webapp" banner="gray" Line="no" scroll="no"> 

<cfquery name="FunctionId"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   FunctionOrganization
	WHERE  FunctionId = '#URL.FunctionId#'
</cfquery>

<cfquery name="Function"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM FunctionTitle
	WHERE FunctionNo = '#FunctionId.FunctionNo#'
</cfquery>

<cfquery name="Parameter"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Parameter
</cfquery>

<cfquery name="Grade"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_GradeDeployment P, Employee.dbo.Ref_PostGrade G
	WHERE  GradeDeployment IN (SELECT GradeDeployment FROM FunctionTitleGrade WHERE FunctionNo = '#FunctionId.FunctionNo#')	
	AND    G.PostGrade = P.GradeDeployment
	ORDER BY ListingOrder
</cfquery>

<cfquery name="Edition"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_SubmissionEdition
	WHERE    EnableAsRoster = 1
	ORDER BY ExerciseClass
</cfquery>

<cfquery name="Area"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Organization
</cfquery>

<cfform action="BucketSubmit.cfm?ifrm=#URL.ifrm#" method="POST" name="dialog">

<!--- Entry form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">

<tr><td height="3"></td></tr>
<cfif Grade.recordcount eq "0">

<tr><td class="labelmedium"><b><cf_tl id="Problem">: </b><cf_tl id="no grades have been enabled for this functional title." class="Message"></TD>

<cfelse>

<tr><td class="labelmedium"><cf_tl id="Title">:</TD>
	<TD style="height:25px" class="labelmedium">
	   <cfoutput>#Function.FunctionDescription#</cfoutput>
	   <cfoutput>
	    <input type="hidden" name="FunctionNo" value="#Function.FunctionNo#" size="20" maxlength="20" class="labelmedium">
	    <input type="hidden" name="FunctionId" value="#URL.FunctionID#" size="20" maxlength="20" class="labelmedium">
		</cfoutput>
       
	</TD>
	</tr>
	
<tr><td class="labelmedium"><cf_tl id="Class">:</TD>
	<TD class="labelmedium" style="height:25px">
	   <cfoutput>#Function.FunctionClass#</cfoutput>	    
	</TD>
</tr>
	
<tr><td class="labelmedium"><cf_tl id="Grade deployment">:</TD>
	<TD class="labelmedium">
	    <select name="GradeDeployment" class="regularxl" required="Yes">
		<cfoutput query="Grade">
		<option value="#GradeDeployment#" <cfif FunctionId.GradeDeployment eq "#GradeDeployment#">selected</cfif>>#GradeDeployment#</option>
		</cfoutput>
		</select>	
	</TD>
</tr>

<tr>		
    <TD class="labelmedium"><cf_tl id="Area">:</TD>
    <TD class="labelmedium">  
    	<select name="OrganizationCode" class="regularxl" required="Yes">
		<option value="<cfoutput>#Parameter.DefaultOrganization#</cfoutput>" selected>N/A</option>
		<cfoutput query="Area">
		<option value="#OrganizationCode#" <cfif #FunctionId.OrganizationCode# eq "#OrganizationCode#">selected</cfif>>#OrganizationDescription#</option>
		</cfoutput>
		</select>
	      	 
	</TD>
</TR>
	
<tr>	
    <TD class="labelmedium"><cf_tl id="Edition">:</TD>
    <TD class="labelmedium">  
    	<select name="SubmissionEdition" class="regularxl" required="Yes">
		<cfoutput query="Edition">
		<option value="#SubmissionEdition#" <cfif #FunctionId.SubmissionEdition# eq "#SubmissionEdition#">selected</cfif>>#EditionDescription#</option>
		</cfoutput>
		</select>
	      	 
	</TD>
</tr>	
	
	<script language="JavaScript">
	
	function set()
	{
	se = document.getElementsByName("source")
	se[1].click()
	}
	
	function blank()
	{
	se = document.getElementsByName("referenceno")
	se[0].value = ""
	}
	</script>
	
	<tr>
    <TD class="labelmedium"><cf_tl id="Candidate source">:</TD>
    <TD class="labelmedium">  
		<table>
		<tr>
		<td><input type="radio" class="radiol" name="source" value="Direct" onClick="javascript:blank()" checked></td>
		<td class="labelmedium"><cf_tl id="Manual"></td>
		<td><input type="radio" class="radiol" name="source" value="VA" <cfif #FunctionId.ReferenceNo# neq "Direct">checked</cfif>></td>
		<td class="labelmedium">VA</td>	
		<td class="labelmedium" style="padding-left:4px">
		<cfif FunctionId.ReferenceNo neq "Direct">
		
		    <cfinput type="Text" value="#FunctionId.ReferenceNo#" name="referenceno" message="Please enter a valid VA No" required="No" size="20" maxlength="20" class="regularxl">
		
		<cfelse>
	    
			<cfinput type="Text" name="referenceno" message="Please enter a valid VA No" required="No" size="20" maxlength="20" class="regularxl" onClick="javascript:set()">
		
		</cfif>
		</td></tr>
		</table>
	</TD>
	</TR>
			
	<tr>	
    <TD class="labelmedium" height="25"><cf_tl id="Position specific">:</TD>
    <TD class="labelmedium">  
	<input  class="radiol" type="radio" name="PostSpecific" value="0" <cfif #FunctionId.PostSpecific# eq "0">checked</cfif>>No
	<input  class="radiol" type="radio" name="PostSpecific" value="1" <cfif #FunctionId.PostSpecific# eq "1">checked</cfif>><cf_tl id="Yes">
	</TD>
	</TR>
	<cf_calendarscript>
	
	<tr>
    <TD class="labelmedium" height="22"><cf_tl id="Date Effective">:</TD>
    <TD class="labelmedium">  
	  <cf_intelliCalendarDate9
		FieldName="DateEffective" class="regularxl"
		Default="#Dateformat(FunctionId.DateEffective, CLIENT.DateFormatShow)#"
		AllowBlank="True">	
	</TD>
	</TR>
	
	<tr>
    <TD class="labelmedium" height="22"><cf_tl id="Date Expiration">:</TD>
    <TD class="labelmedium">  
	  <cf_intelliCalendarDate9
		FieldName="DateExpiration" class="regularxl"
		Default="#Dateformat(FunctionId.DateExpiration, CLIENT.DateFormatShow)#"
		AllowBlank="True">	
	</TD>
	</TR>
	
	<tr>
    <TD class="labelmedium" height="25"><cf_tl id="Officer">:</TD>
    <TD class="labelmedium">  
	<cfoutput>#SESSION.first# #SESSION.last#</cfoutput>
	</TD>
	</TR>
	
	</cfif>
	
	<cfinvoke component="Service.AccessGlobal"   
              method="global" 
              role="FunctionAdmin" 
              returnvariable="Access"> 
                                                      
    <cfif Access eq "EDIT" or Access eq "ALL">   
     			
		<tr><td colspan="2" class="linedotted"></td></tr>		
		<tr>		
			<td colspan="2" align="center">
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
			<cfif Grade.recordcount neq "0">
			<input class="button10g" type="submit" name="Delete" value=" Delete ">
		    <input class="button10g" type="submit" name="Update" value=" Update ">
			</cfif>		
			</td>		
		</tr>
      
    </cfif>
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">
