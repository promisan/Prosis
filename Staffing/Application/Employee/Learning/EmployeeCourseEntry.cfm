
<cf_screentop height="100%" layout="webapp" user="No" label="Add Course">

<cfform action="EmployeeCourseSubmit.cfm" 
   method="POST" 
   name="dialogentry">

<cfoutput>
<input type="hidden" name="PersonNo" value="#URL.PersonNo#">
<input type="hidden" name="Code" value="#URL.Code#">

<cfif url.id eq "">

	<cf_assignId>
	<input type="hidden" name="Id" value="#rowguid#">
	<cfset id = rowguid>
	
<cfelse>

	<input type="hidden" name="Id" value="#URL.Id#">
	<cfset id = url.id>
	
</cfif>

</cfoutput>   
<cfquery name="Get" 
datasource="AppsLearning" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       PersonCourse
	<cfif url.id neq "">
	WHERE RecordId = '#URL.Id#'
	<cfelse>
	WHERE 1=0
	</cfif>
	ORDER BY Created DESC
</cfquery>

<cfquery name="Course" 
datasource="AppsLearning" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       Course
	WHERE Code = '#URL.Code#'
</cfquery>

<cfquery name="Result" 
datasource="AppsLearning" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_CourseResult
</cfquery>
	
<cfoutput>	

<table width="97%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white" align="center">
<tr><td VALIGN="TOP" style="padding-top:4px">

<table width="98%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td height="25" class="labelit">Course:</td>
    <td class="labelmedium"><cfoutput>#Course.CourseName#</cfoutput></td>
</tr>

<tr>
   <td class="labelit">Date:</td>
   <td>
   <cfif url.id eq "">
   
	   	<cf_calendarscript>
   
  			 <cf_intelliCalendarDate9
						FieldName="DateCompleted" 
						Default="#dateformat(now(),CLIENT.DateFormatShow)#"
						class="regularxl"
						AllowBlank="False">	
						
   <cfelse>
   
   			 <cf_intelliCalendarDate9
						FieldName="DateCompleted" 
						Default="#dateformat(get.datecompleted,CLIENT.DateFormatShow)#"
						class="regularxl"
						AllowBlank="False">	
   
   </cfif>						
   </td>
</tr>	
<tr>
   <td class="labelit">Result:</td>
   <td><select name="CourseResult" class="regularxl">
        <cfloop query="Result">
		   <option value="#Code#" <cfif get.CourseResult eq Code>selected</cfif>>#Description#</option>
		</cfloop>
		  </td>
</tr>	
<tr>
   <td class="labelit">Memo:</td>
   <td><textarea style="width:90%;font-size:14px;padding:3px" rows="4" name="CourseMemo" class="regular" >#get.CourseMemo#</textarea></td>
</tr>		

<tr>
 
   <td colspan="2" id="#id#">
   
	<cf_filelibraryN
			DocumentPath="Course"
			SubDirectory="#id#" 
			Filter=""				
			Width="100%"
			loadscript="No"
			attachDialog="Yes"
			inputsize = "340"
			Box = "#id#"
			Insert="yes"
			Remove="yes">	
				
	</td>
</tr>				

<tr><td class="linedotted" colspan="2"></td></tr></tr>
<tr><td align="center" colspan="2">
<cfif url.id eq "">
    <input class="button10g" type="button" name="Cancel" value="Close" onClick="dialoghide()">
    <input class="button10g" type="submit" name="Update" value="Save">
<cfelse>
    <input class="button10g" type="button" name="Cancel" value="Close"  onClick="dialoghide()">
    <input class="button10g" type="button" name="Delete" value="Delete" onclick="ask()">
    <input class="button10g" type="submit" name="Update" value="Save">
</cfif>
</td></tr>
  
</table>
</cfoutput>

<td></td></table>

</cfform>
