
<cf_divscroll>

<cfparam name="URL.ID2"            default="Template">
<cfparam name="URL.ID3"            default="0000">
<cfparam name="URL.Mission"        default="#URL.ID2#">
<cfparam name="URL.Mandate"        default="#URL.ID3#">
<cfparam name="URL.Param1"                 default="">
<cfparam name="URL.Param2"                 default="">
<cfparam name="URL.FormName"               default="">
<cfparam name="URL.fldfunctionno"          default="functionno">
<cfparam name="URL.fldfunctiondescription" default="functiondescription">

<input type="hidden" name="mission" value="<cfoutput>#URL.Mission#</cfoutput>">

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM Ref_Mandate
   WHERE Mission = <cfqueryparam
				 value="#URL.Mission#"
				 cfsqltype="CF_SQL_VARCHAR" 
				 maxlength="30">
</cfquery>

<cfparam name="URL.Owner" default="">
   
<table width="100%" height="100%">
  <tr>  
  <td width="100%" height="100%" colspan="2" valign="top">

<table width="100%" height="100%" align="center" class="navigation_table">

<cfif URL.ID0 eq "OCC">
   <cfset cond = "O.OccupationalGroup = '#URL.ID1#' AND F.FunctionClass = '#url.functionclass#' AND (F.ParentFunctionNo is NULL or F.ParentFunctionNo = '')">
<cfelse>
   <cfset cond = "F.FunctionNo = '#URL.ID1#'">
</cfif>
 
<!--- Query returning search results --->

<cfquery name="Level01" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT 
	       F.FunctionNo, 
		   F.FunctionClass, 
		   F.FunctionDescription,
		   max(Child.FunctionNo) as Child
	FROM   FunctionTitle F INNER JOIN
	       OccGroup O ON F.OccupationalGroup = O.OccupationalGroup LEFT OUTER JOIN
	       FunctionTitle Child ON F.FunctionNo = Child.ParentFunctionNo LEFT OUTER JOIN
	       FunctionOrganization FO ON F.FunctionNo = FO.FunctionNo
	WHERE #preserveSingleQuotes(cond)#
	AND   O.Status = '1'
	AND   F.FunctionOperational = '1' 
	
	GROUP BY F.FunctionNo, 
		     F.FunctionClass, 
		     F.FunctionDescription
	ORDER BY F.FunctionDescription
</cfquery>

<table width="100%" class="navigation_table">

<TR class="line labelmedium2 fixrow">
    <td height="20" ></td>
    <TD></TD>
    <TD><cf_tl id="Id"></TD>
	<TD width="56%"><cf_tl id="Description"></TD>
	<TD><cf_tl id="Class"></TD>
	<TD><cf_tl id="Bucket"></TD>   
</TR>

<cfoutput query="Level01">

<CFSET des = Replace("#FunctionDescription#", "'", "", "ALL" )> 

<TR class="navigation_row line labelmedium2">
	
	<td colspan="2" style="padding-top:2px;padding-left:7px">
	    <cf_img icon="select" onclick="Selected('#FunctionNo#','#des#','#url.fldfunctionno#','#url.fldfunctiondescription#')" navigation="Yes">	
	</td>
	<td>#FunctionNo#</TD>
	<td>#FunctionDescription#</TD>
	<td>#FunctionClass#</TD>
	<td align="center"><cfif Child neq "">*</cfif>&nbsp;</td>
	
</TR>

   <cfif Child neq "">

	   <cfquery name="Level02" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT DISTINCT 
			       FunctionTitle.FunctionNo, 
				   FunctionTitle.FunctionClass, 
				   FunctionTitle.FunctionDescription, 
				   FunctionOrganization.FunctionId AS Roster
		    FROM   FunctionTitle LEFT OUTER JOIN
		           FunctionOrganization ON FunctionTitle.FunctionNo = FunctionOrganization.FunctionNo
			WHERE  ParentFunctionNo = '#Level01.FunctionNo#'		
			AND    FunctionOperational = '1' 
	   </cfquery>
	   
	    <cfloop query="Level02">
			
		<CFSET des = Replace("#FunctionDescription#", "'", "", "ALL" )> 
	   
	    <tr bgcolor="white" class="navigation_row line labelmedium2">
	 	 <td colspan="2" style="padding-top:3px;padding-left:17px">	
		   <cf_img icon="open" navigation="Yes" onclick="Selected('#FunctionNo#','#des#','#url.fldfunctionno#','#url.fldfunctiondescription#')">		
		</td>
		<td>#FunctionNo#</font></TD>
		<td>#FunctionDescription#</font></TD>
		<td>#FunctionClass#</TD>
		<td align="center" style="padding-right:4px"><cfif Roster neq "">*</cfif></td>
		</tr>
			
		<cfquery name="Level03" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT DISTINCT FunctionTitle.FunctionNo, FunctionTitle.FunctionClass, FunctionTitle.FunctionDescription, FunctionOrganization.FunctionId AS Roster
		    FROM   FunctionTitle LEFT OUTER JOIN
		           FunctionOrganization ON FunctionTitle.FunctionNo = FunctionOrganization.FunctionNo
			WHERE  ParentFunctionNo = '#Level02.FunctionNo#'		
			AND    FunctionOperational = '1'
	    </cfquery>
	
		    <cfloop query="Level03">
		      
			    <CFSET des = Replace("#FunctionDescription#", "'", "", "ALL" )> 
				
			    <tr bgcolor="white"  class="navigation_row line labelmedium2">				
					<td colspan="2" class="regular" style="padding-top:3px;padding-left:25px">	
						<cf_img icon="open" navigation="Yes" onclick="Selected('#FunctionNo#','#des#','#url.fldfunctionno#','#url.fldfunctiondescription#')">		
					</td>				
					<TD>#FunctionNo#</font></TD>
					<TD>#FunctionDescription#</TD>
					<TD>#FunctionClass#</TD>
					<td align="right" style="padding-right:4px"><cfif Roster neq "">Yes</cfif></td>			
			    </TR>
				   
		    </cfloop>
		     
	    </cfloop> 
	
	</cfif>     
	
</CFOUTPUT>

</TABLE>
</td>
</tr>   
</table>
</td>
</tr>
</table>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>
