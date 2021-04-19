
<cfquery name="Search" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		SELECT   *
		FROM     RosterSearch A
		WHERE    A.SearchId = '#URL.ID#' 	
    </cfquery>	
	
<table width="100%" height="100%"><tr><td bgcolor="white" valign="top">	

<cfform action="Assessment/AssessmentSelectSubmit.cfm?source=#url.source#&id=#url.id#" method="post">

<table width="95%" align="center">

<cfoutput>
<tr><td height="10"></td></tr>
<tr><td height="23" class="labelmedium">#Search.Owner#</b></td></tr> 
<tr><td class="linedotted"></td></tr>
</cfoutput>

<tr><td height="4"></td></tr>

<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_AssessmentCategory C
  WHERE Code IN (SELECT AssessmentCategory 
                 FROM   Ref_Assessment 
				 WHERE Owner = '#Search.Owner#' and Operational = 1)	
</cfquery>

<cfif Master.recordcount eq "0">

<tr><td align="center" height="30"><i><font color="808080">No keywords defined</td></tr>

</cfif>

<cfloop query="Master">
      				
		<cfquery name="GroupAll" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   R1.Description AS CategoryDescription, R.*, A.SelectId AS Selected
			FROM     Ref_AssessmentCategory R1 INNER JOIN
                     Ref_Assessment R ON R1.Code = R.AssessmentCategory LEFT OUTER JOIN
                     RosterSearchLine A ON R.SkillCode = A.SelectId AND A.SearchId = '#URL.ID#' and A.SearchClass = 'Assessed#URL.Source#'
			WHERE    R.Owner = '#Search.Owner#'	
			AND      R.Operational = 1	  	
			AND      R.AssessmentCategory = '#Master.Code#'	
			ORDER BY R.AssessmentCategory, R.ListingOrder	
		</cfquery>
				
<tr><td>
					
       <table width="100%" border="0" cellspacing="0" cellpadding="0" class="regular">
	   	    		
		<cfoutput>
						
		<TR><td align="left" height="20" style="padding-left:4px" class="labelmedium">#Description#</td></TR>
			
			</cfoutput>
							
    		<TR><td width="100%" >
								
		    <cfoutput>
						
			<table width="100%" border="0" align="right" id="#Code#" cellpadding="0" class="formpadding">
			
			<tr>
    		<td style="padding-left:40px" width="30" valign="top"><img src="#SESSION.root#/Images/join.gif" alt=""></td>
			<td width="100%">
			
			<table width="98%"
			   class="formpadding"
		       align="left">
			
					</cfoutput>
				
				    <cfset row = 0>
										
					<cfoutput query="GroupAll">
															
						<cfif row eq "3">
						    <TR>						
							<cfset row = 0>																			
						</cfif>
					
					    <cfset row = row + 1>
						<td width="33%" style="border:1px dotted black;">
						<table width="100%" cellspacing="0" cellpadding="0">
							<cfif Selected eq "">
							    <TR class="regular">
							<cfelse> 
							     <TR class="highlight4">
							         
							</cfif>
							<td>&nbsp;</td>
							<td width="90%" class="labelit">#SkillDescription#</font></td>
							<TD width="10%" align="center" style="padding:5px">
							<cfif Selected eq "">
							<input type="checkbox" name="fieldid" value="#SkillCode#" onClick="hl(this,this.checked)"></TD>
							<cfelse>
							<input type="checkbox" name="fieldid" value="#Skillcode#" checked onClick="hl(this,this.checked)"></td>
						    </cfif>
						</table>
						</td>
						<cfif GroupAll.recordCount eq "1">
    						<td width="33%"></td>
						</cfif>
					
					</CFOUTPUT>
					
					<cfif row eq "2">
						<td width="33%"></td>
					</cfif>
					
					<cfif row eq "1">
						<td width="33%"></td><td width="33%"></td>
					</cfif>
												
			    </table>
				
				</td></tr>
				
				</table>
									
			</td></tr>
							
		</table>
		
	</td></tr>	
	
</cfloop>		

<tr><td class="linedotted"></td></tr>
<tr><td height="40" align="center"><INPUT class="button10g" type="submit" value="Save"></td></tr>	
	
</table>

</cfform>

</td></tr>

</table>

<cf_screenbottom layout="webapp">

