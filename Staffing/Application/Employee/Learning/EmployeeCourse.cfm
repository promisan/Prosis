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
<cf_screentop height="100%" html="No" scroll="Yes" menuaccess="context">

<cfparam name="URL.Status" default="9">

<cf_FileLibraryScript>

<cfajaximport tags="cfform">

<cfwindow name="dialog" title="Record Course Attendance" height="400" width="550" bodystyle="overflow: hidden;" center="True"></cfwindow>

<cfoutput>
	
	<script language="JavaScript">
	
		function recordadd(id,code) {
			ColdFusion.Window.show('dialog')		
			ColdFusion.navigate('EmployeeCourseEntry.cfm?id='+id+'&code='+code+'&personno=#URL.ID#','dialog') 	
		}
		
		function dialoghide() {
	    	ColdFusion.Window.hide('dialog')	
		}
		
	</script>

</cfoutput>

<cfset openmode = "show">

<cfinclude template="../PersonViewHeaderToggle.cfm">

<cfquery name="Assignment" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
    FROM     PersonAssignment PA, Position P
	WHERE    PA.PersonNo     = '#PersonNo#'
	AND      PA.PositionNo   = P.PositionNo
	AND      PA.AssignmentStatus IN ('0','1')	
	ORDER BY PA.DateEffective DESC		
</cfquery>		
							
<!--- Query returning search results --->
<cfquery name="Required" 
datasource="AppsLearning" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		SELECT    *
		FROM      Course
		<cfif Assignment.PostType neq "">
		WHERE     Code IN
                    (SELECT  CourseCode
                     FROM    CourseRequirement
                     WHERE   PostType = '#Assignment.PostType#')
		</cfif>			 
</cfquery>	

<cfquery name="Other" 
datasource="AppsLearning" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		SELECT    *
		FROM      Course
		WHERE     Code NOT IN
                       (SELECT  CourseCode
                        FROM    CourseRequirement
                        WHERE   PostType = '#Assignment.PostType#')
		AND       Code IN 
						(SELECT CourseCode 
		                 FROM	PersonCourse
						 WHERE  PersonNo = '#URL.ID#')			
</cfquery>						  

<table><td height="1"></td></table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
  <tr><td>
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
	
	<tr><td colspan="2" style="font-size:24px;padding-left:18px;font-weight:200" height="22" class="labelmedium">Required Courses</td></tr>	
	
	<tr>
	  <td width="100%" colspan="2">
	  <table border="0" cellpadding="0" cellspacing="0" align="center" width="98%" class="formpadding navigation_table">
	   <tr class="labelmedium line">
	    <td width="30"></td>
		<td width="30"></td>	
	    <td width="45%" align="left">Name</td>
		<td width="20%" align="left">Level</td>
		<TD width="30%" align="left">Type</TD>		
		
	</TR>
	
	<cfset last = '1'>
	
	<cfoutput query="Required">
	
	<TR class="labelmedium line navigation_row" bgcolor="white">
	<td></td>
	<td align="center" height="24">
	
	<cf_img icon="add" onClick="recordadd('','#code#')">
	
	<!---
	
	<img src="#SESSION.root#/Images/insert1.gif" name="img7_#code#_#currentrow#" alt="Insert"
				  onMouseOver="document.img7_#code#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img7_#code#_#currentrow#.src='#SESSION.root#/Images/insert1.gif'"
				  style="cursor: pointer;" border="0" align="absmiddle" width="15" height="15"
				  onClick="recordadd('','#code#')">	
				  
				  --->
    </td>
	<TD>#CourseName#</TD>
	<TD>#CourseLevel#</TD>
	<TD>#CourseType#</TD>	
	</tr>
		
	<cfquery name="Attendance" 
	datasource="AppsLearning" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     PersonCourse PC INNER JOIN
		         Ref_CourseResult R ON PC.CourseResult = R.Code
		WHERE    PC.PersonNo = '#URL.ID#' AND PC.CourseCode = '#Code#'
		ORDER BY PC.DateCompleted
	</cfquery>
				
	<cfif Attendance.recordcount gte "1">
	
	<tr>
	<td></td>
	<td></td>
	<td colspan="3" align="left" style="padding-left:40px">
	    <cfdiv bind="url:EmployeeCourseDetail.cfm?personno=#url.id#&code=#code#" id="#Code#"/>						
	</td>
	</tr>
	
	<cfelse>
	
	<tr>
	<td colspan="5" align="left" id="#Code#">
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
	<tr><td align="center" class="labelit">
			<a href="javascript:recordadd('','#code#')"><font color="0080C0">Press here to record a course attendance record</font></a>
	</td></tr>
	</table>
	</td>
	</tr>
		
	</cfif>
	
	</cfoutput>
	
	</TABLE>

</td>

</table>