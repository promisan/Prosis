
<cfquery name="OccGroup"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   OccupationalGroup, Description, Acronym, ParentGroup
	FROM     OccGroup
	WHERE    Status = '1'	
	
	<cfif SESSION.isAdministrator eq "No">
	AND OccupationalGroup IN (  SELECT GroupParameter 
      			                FROM   Organization.dbo.OrganizationAuthorization 
				  	            WHERE  Role = 'FunctionAdmin' 
					            AND    UserAccount = '#SESSION.acc#')					
	</cfif>		
		
	ORDER BY ParentGroup,ListingOrder,OccupationalGroup, Description
</cfquery>

<cfquery name="Class"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  DISTINCT F.FunctionClass, R.FunctionClassName, R.Listingorder
	FROM    FunctionTitle F, Ref_FunctionClass R
	WHERE   F.FunctionClass = R.FunctionClass
	AND     Operational = 1	
	
	<cfif SESSION.isAdministrator eq "No">
	AND Owner IN (  SELECT ClassParameter 
	                FROM   Organization.dbo.OrganizationAuthorization 
					WHERE  Role = 'FunctionAdmin' 
					AND    UserAccount = '#SESSION.acc#')
					
	</cfif>				
	ORDER BY R.ListingOrder
</cfquery>

<cf_screentop height="100%" html="No" jquery="Yes">

<table width="96%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

<tr><td>

<cfif Class.recordcount eq "0">

<table align="center"><tr class="labellarge"><td style="padding-top:20px">You have not been granted Function administration rights</td></table>

<cfelse>

<!--- Search form --->

	<cf_divscroll>
	
	<table width="96%" align="center" class="formpadding">
		
		<tr><td>
		
		<CFFORM action="RecordSearchQuery.cfm?idmenu=#url.idmenu#" method="post">
		
		<table width="99%" align="center" class="formpadding formspacing">
			
			<tr class="line">
			<TD colspan="2" class="labellarge">
			<table><tr>
			   <td style="font-size:29px" class="labellarge"><cf_tl id="Functional title criteria"></td>
			   <td><cf_helpfile systemfunctionid = "#url.idmenu#"></td>
				</tr>
			</table>
			</TD>	
		    </tr>
			
			<tr><td height="6"></td></tr>
		 	
			<TR>
				<TD style="min-width:200px;padding-left:20px" class="labellarge"><cf_tl id="Search for a Title">:</TD>
				<TD><INPUT type="text" name="FunctionDescription" size="40" class="regularxl"></TD>
			</TR>
			
			
			<TR>
			<td style="padding-left:20px" class="labellarge"><cf_tl id="Function class">:</td>
			<TD>
			
			<table>
			
			  <cfset row = 1>	  
		      <cfoutput query="class">
			 
		  	  <cfif row eq 1><tr></cfif> 
			
			  <td class="labellarge" style="padding-right:5px">
			      <input class="radiol" type="checkbox" name="FunctionClass" value="'#FunctionClass#'" <cfif FunctionClass eq "Standard">checked</cfif>>
				  </td>
				  <td class="labellarge" style="width:100px;padding-left:2px;padding-right:10px">#FunctionClassName#</option>
			  </td>
			  <cfset row = row + 1>
			  <cfif row eq "5">
			    </tr>
			    <cfset row = 1>
			  </cfif>
			  
			  </cfoutput>
			  
			</table>
				
			</TD>
			</TR>
			
			<TR>
				<td style="padding-left:20px;width:200px" class="labellarge"><cf_tl id="Edition">:</td>
				<td style="width:80%">
						
				<cfquery name="Edition"
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    R.Owner, E.Description, R.SubmissionEdition, R.EditionDescription
					FROM      Ref_SubmissionEdition R INNER JOIN
				              Ref_ExerciseClass E ON R.ExerciseClass = E.ExcerciseClass
					WHERE     R.Operational = 1
					<cfif SESSION.isAdministrator eq "No">
					AND R.Owner IN (  SELECT ClassParameter 
		        			          FROM   Organization.dbo.OrganizationAuthorization 
								  	  WHERE  Role = 'FunctionAdmin' 
									  AND    UserAccount = '#SESSION.acc#')
						
					</cfif>		
					ORDER BY  R.Owner, R.EditionDescription
				</cfquery>
				
				<cfselect name="submissionedition" group="Owner" queryposition="below" query="edition" value="submissionedition" display="editiondescription" visible="Yes" enabled="Yes" class="regularxxl">				
					<option value="">Any</option>		
				</cfselect>
				
				<!---
				
				<table>
				
				  <cfset row = 1>	  
			      <cfoutput query="class">
				 
			  	  <cfif row eq 1><tr></cfif> 
				
				  <td class="labellarge" style="padding-right:5px">
				      <input class="radiol" type="checkbox" name="FunctionClass" value="'#FunctionClass#'" <cfif #FunctionClass# eq "Standard">checked</cfif>>
					  </td>
					  <td class="labellarge" style="padding-left:2px;padding-right:5px">#FunctionClass#</option>
				  </td>
				  <cfset row = row + 1>
				  <cfif row eq "10">
				    </tr>
				    <cfset row = 1>
				  </cfif>
				  
				  </cfoutput>
				  
				</table>
				
				--->
					
				</td>
			</tr>
			
			<TR>
			<td style="padding-left:20px" class="labellarge"><cf_tl id="Status">:</td>
			<TD>
			
			<table>
			
			</tr>
			
		    <tr> 
			
			  <td class="labellarge">
			      <table><tr>
				  <td style="padding-left:0px"><input class="radiol" type="checkbox" name="FunctionOperational" value="'1'" checked></td>
				  <td class="labellarge" style="padding-left:4px"><cf_tl id="Operational"></td>
				  <td style="padding-left:10px"><input class="radiol" type="checkbox" name="FunctionOperational" value="'0'"></td>
				  <td class="labellarge" style="padding-left:4px"><cf_tl id="Deactivated"></td>
				  </tr></table>
			  </td>
			 
		    </tr>
					 	  
			</table>
				
			</TD>
			</TR>
			
			<TR>
				<td style="padding-left:20px;padding-top:5px" class="labellarge"><cf_tl id="Function Network">:</td><td>
			</tr>	
		  
			<TR class="line">
						
			<TD width="99%" colspan="2" align="center" style="padding-left:20px">
			
				<table width="100%" align="center" class="navigation_table">
				  	  
				  <cfset row = 0>	
				    
			      <cfoutput query="occgroup" group="parentgroup">
				  
				      <cfif parentgroup neq "">
					  
					      <tr class="labelmedium2"><td colspan="9" style="height:28px;font-size:16px"><font color="0080C0">
						  							  
								<cfquery name="get"
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT   *
									FROM     OccGroup
									WHERE    OccupationalGroup = '#parentgroup#'	
								</cfquery>
						  
							  #get.DescriptionFull#
							  </td>
						  </tr> 
					  
					  </cfif>
					  
					  <cfset row = 0>
				  
					  <cfoutput>
					 
					  <cfset row = row + 1>
				  	  <cfif row eq 1><tr class="navigation_row fixlengthlist"></cfif> 
					
					  <td width="20" style="padding-left:5px">
					    <input type="checkbox"  class="radiol"  name="OccupationalGroup" value="'#OccupationalGroup#'">
						</td>
						<td style="height:15px;padding-left:10px">#Acronym#</td>
						<td style="height:15px;padding-left:10px">#Description#</td>
					  
					  <cfif row eq "3">
					    </tr>
					    <cfset row = 0>
					  </cfif>
					  
					  </cfoutput>
				  
				  </cfoutput>
				  
				</table>
			
			</TD>
			</TR>
				
			
			<tr><td colspan="2">
			
				<input type="submit" value="Search" class="button10g" style="width:200px">
			
			</td></tr>
			
		</TABLE>
		
		</CFFORM>
		
		</td></tr>
		
	</table>
	
	</cf_divscroll>

</cfif>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>


