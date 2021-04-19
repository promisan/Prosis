
<cfquery name="ParentList" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT  *
	FROM    Ref_ExperienceParent
	WHERE   Area = '#url.area#'	
	AND     SearchEnable = '1'
	ORDER BY SearchOrder
   </cfquery>
  
<cf_divscroll style="height:100%">
 
	<cfform action="#SESSION.root#/roster/RosterGeneric/RosterSearch/Structured/Search4StructuredSubmit.cfm?ID=#URL.ID#&Area=#URL.Area#" method="post">
	
	<table width="95%" cellspacing="0" cellpadding="0" align="center">   
	
	  <tr>
	 
	  <td height="35" colspan="6" align="center">
		<button name="Prior" class="button10g" value="Submit" type="submit">Submit</button>
	  </td></tr>
	  
	  <tr><td height="3"></td></tr>
	  
	<cfoutput query="ParentList">
		  	 
		  <tr><td colspan="4" height="16" style="padding-top:5px" class="labellarge"><b>#Parent#</td>		  
		  
			  <td colspan="2" align="right" style="padding-right:4px">
			
				<cfset St = "ANY">
				
				<cfquery name="Status" 
				   datasource="AppsSelection" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT  SelectId
				   FROM    RosterSearchLine
				   WHERE   SearchId = '#URL.ID#'
				   AND     SearchClass = '#Parent#Operator'
				</cfquery>
					
				<cfif Status.recordCount eq "0">
					<cfset St = "ANY">
				</cfif>
					
					<table width="100%" align="right">
					<tr>
						<td width="8%" valign="top" align="right">
						<table align="right"><tr><td>		
						<input type="radio" name="#Parent#Status" id="#Parent#Status" class="radiol" value="ANY" <cfif St eq "ANY">checked</cfif>></td><td style="padding-left:4px" class="labelmedium"><cf_tl id="MATCHES ANY"></td>
						</td><td style="padding-left:16px">
					    <input type="radio" name="#Parent#Status" id="#Parent#Status" class="radiol" value="ALL" <cfif St eq "ALL">checked</cfif>></td><td style="padding-left:4px" class="labelmedium"><cf_tl id="MATCHES ALL"></td>
						</td></tr>
						</table>
						</td>
						
					</tr>	
					</table>
				
				</td>
		  	  
		  </tr>
		  <tr><td height="1"  colspan="6" class="linedotted"></td></tr>		     
		  <tr><td height="5"  colspan="6" valign="middle"></td></tr>   
		  <tr><td colspan="6" style="padding-left:15px">
			<cfinclude template="Search4Keyword.cfm">
		  </td></tr>
			
	</cfoutput>
	
	 <tr><td height="1" colspan="6" class="linedotted"></td></tr>
	 <tr><td height="3"></td></tr>
	 <tr>
		
		 <td height="25" colspan="6" align="center">
		  <button name="Submit" class="button10g" value="Submit" type="submit">Submit</button>
		 </td>
	 </tr>
		
	</TABLE>
	</cfform>
	
</cf_divscroll>


