
<cfparam name="url.PostType" default="">
<cfparam name="url.action" default="">

<cfquery name="PostGrade"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT  PG.PostGradeParent, P.Description ParentDescription, PG.PostGrade, PTG.PostType
	FROM    Ref_PostGrade PG
	INNER   JOIN Ref_PostGradeParent P
			ON PG.PostGradeParent = P.Code
	LEFT 	JOIN Ref_PostTypeGrade PTG
			ON PG.PostGrade = PTG.PostGrade AND PTG.PostType = '#url.posttype#'
	WHERE   PG.PostGradePosition = 1		
	ORDER   BY P.ViewOrder, PostGradeParent, PG.PostOrder 
	
</cfquery>


<cfform method="POST" name="posttype_#url.posttype#" onsubmit="return false">
<table border="0" width="90%" cellspacing="0" cellpadding="0" bordercolor="e0e0e0" align="center" class="formpadding">					
		<tr><td eight="10"></td></tr>
		<cfset columns = 9>
		
		<cfset group = 0>
		
		<cfoutput query="PostGrade" group="PostGradeParent">
		
			<cfset current = 0>
			<cfset group = group + 1 >
			<tr>
				<td colspan="2">
					<input type="checkbox" name="postgradeparent" onclick="toogleGroup('#url.posttype#_#group#',this.checked); submitPostType('#url.posttype#');">
					<font face="Calibri" size="2"><b>#ParentDescription#</b></font>
				</td>
			</tr>
		
		
			<tr valign="top">
				<td valign="top" width="25" >
					<img src="#SESSION.root#/images/join.gif">
				</td>
				<td align="left">
					<table align="left">					
					
					<cfoutput>
					
						<cfif PostGrade.PostType neq "">
						   <cfset cl = "ffffcf">
						<cfelse>
						   <cfset cl = "ffffff">
						</cfif> 
					
						<cfif current eq 0> <tr>  </cfif>
						<cfset current = current + 1>
							<td style="padding-right:3px" bgcolor="#cl#">
								<input type="checkbox" 
									   name="postgrade_#url.posttype#_#group#" 
									   value="#PostGrade#"
									   onClick="submitPostType('#url.posttype#')"
									    <cfif PostGrade.PostType neq "">checked</cfif>>
										</td>
										<td bgcolor="#cl#" style="padding-left:1px;padding-right:4px"><font face="Calibri" size="2">#PostGrade#<cf_space spaces="14"></td>
							</td>
						<cfif current eq columns> </tr> <cfset current=0> </cfif>
					</cfoutput>
					</table>
				</td>
			</tr>
			
			<tr>
				<td height="10" colspan="2"></td>
			</tr>
		
		</cfoutput>
		
		<input type="hidden" name="groups" value="<cfoutput>#group#</cfoutput>">
		
		<cfoutput>
				
		<tr class="hide"><td  height="10" align="center" colspan="2" id="submit_#url.posttype#"></td></tr>
		
		<tr><td height="10" colspan="2"></td></tr>

</cfoutput>
																
</table>
</cfform>	