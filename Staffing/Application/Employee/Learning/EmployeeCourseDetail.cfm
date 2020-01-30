
<cfquery name="Attendance" 
	datasource="AppsLearning" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     PersonCourse PC INNER JOIN
		         Ref_CourseResult R ON PC.CourseResult = R.Code
		WHERE    (PC.PersonNo = '#URL.PersonNo#') AND (PC.CourseCode = '#URL.Code#')
		ORDER BY PC.DateCompleted 
	</cfquery>
	
<table width="100%" align="center"  cellspacing="0" cellpadding="0">

    <cfoutput query="Attendance">
    
		<tr bgcolor="f8f8f8" class="labelit">
		<TD height="20" align="center" width="5%">
			
		 <img src="#SESSION.root#/Images/select4.gif" name="img5_#url.code#_#currentrow#" 
			  onMouseOver="document.img5_#url.code#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img5_#url.code#_#currentrow#.src='#SESSION.root#/Images/select4.gif'"
			  style="cursor: pointer" border="0" align="absmiddle" width="11" height="11"
			  onClick="recordadd('#recordid#','#url.code#')">
		</TD>
		<td width="15%" align="left"><a href="javascript:recordadd('#recordid#','#url.code#')">#dateformat(DateCompleted,CLIENT.DateFormatShow)#</a></td>
		<td width="20%" align="left">#courseResult#</td>
		<td width="15%" align="left">#OfficerFirstName# #OfficerLastName#</td>				
		<td></td>
		</tr>
		<cfif coursememo neq "">
		    <tr class="labelit">
			<td bgcolor="ffffdf" align="right">
				<img src="#SESSION.root#/Images/join.gif" align="absmiddle">
			</td>
			<td bgcolor="ffffdf" style="padding-left:5px" colspan="5">#CourseMemo#</td>
			</tr>
		</cfif>
	
	</cfoutput>
	
</table>