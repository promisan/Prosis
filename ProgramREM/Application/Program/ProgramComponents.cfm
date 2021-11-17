
<!--- Query returning search results for components --->

<cfoutput>
<script language="JavaScript">
	function reinstate(prg) {
	window.location = "ComponentReinstate.cfm?prg="+prg+"&ProgramCode=#URL.ProgramCode#&Layout=#URL.Layout#&Period=#URL.Period#"
	}
</script>
</cfoutput>


<cfset per = replaceNoCase(url.period,'-','')>

<cfquery name="SearchResult" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   P.*, Pe.Reference, Pe.Period, Pe.OrgUnit, Pe.RecordStatus, Org.OrgUnitName
    FROM     #CLIENT.LanPrefix#Program P, 
	         ProgramPeriod Pe, 
		     Organization.dbo.Organization Org
	WHERE    Pe.PeriodParentCode  = '#ThisProgram#'
	AND      P.ProgramCode        = Pe.ProgramCode
	AND      Pe.Period            = '#URL.Period#'
	AND      Pe.OrgUnit           = Org.OrgUnit 
	ORDER BY Org.HierarchyCode,ListingOrder
</cfquery>

<table width="100%" border="0" cellspacing="0" align="center" cellpadding="0">
 
  <tr>
	<cfoutput>
    <td height="28" align="center">
	<cfif ProgramAccess eq "ALL">	
		<input type="button" value="Add" class="button10g" onClick="javascript:AddComponent('#Program.Mission#','#URL.Period#','#URL.ProgramCode#','#Program.OrgUnit#','','0','add')">
	</cfif>	
    </td>	
    </cfoutput>	
  </tr>
 
  <tr><td colspan="2">
  
	<table width="100%" width="100%" class="navigation_table formpadding">
			
	<TR class="labelmedium2 line fixrow">
	    <TD height="20" width="5%"></TD>
	    <TD width="10%"><cf_tl id="Code"></TD>		
		<TD width="15%"><cf_tl id="Implementer"></TD>
	    <TD width="30%"><cf_tl id="Name"></TD>
	    <TD width="10%"><cf_tl id="Reference"></TD>
		<TD width="10%"><cf_tl id="Class"></TD>
	    <TD width="7%"><cf_tl id="Initiated"></TD>
	    <TD width="14%"></TD>
	</TR>
			
	 <cfinvoke component="Service.AccessGlobal"
	    Method="global"
	  	Role="AdminProgram"
		ReturnVariable="ManagerAccess">	
	
	<!--- Program Components --->
	
	<cfoutput query="SearchResult">
	  <cfif RecordStatus eq "9">
		<tr bgcolor="FFBBBB" class="<cfif ManagerAccess neq 'ALL'>hide</cfif> line labelmedium2">
	  <cfelse>
		<tr class="navigation_row line labelmedium2">
	  </cfif> 
	<td align="center" width="5%" style="padding-top:2px">
	   <cf_img icon="select" navigation="Yes" onClick="EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#','Component')">
	</td>	
	<TD style="padding-left:2px">#ProgramCode#</TD>	
	<TD>#OrgUnitName#</td>
	<TD>#SearchResult.ProgramName#</TD>
	<TD>#Reference#</TD>
	<TD>#ProgramClass#</TD>
	<TD>#DateFormat(Created, CLIENT.DateFormatShow)#</TD>
	<td align="center">
		<cfif RecordStatus eq "9">
			<CFIF ManagerAccess eq "ALL">
				<a href="javascript:reinstate('#ProgramCode#')"><cf_tl id="Reinstate"></a>
			</cfif>
		</cfif>
	</TD>
	</TR>
	
	<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM Parameter
	</cfquery>
	
	 <cf_filelibraryCheck
	    	DocumentURL="#Parameter.DocumentURL#"
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#ProgramCode#"
			Filter="#Per#">
	
			<cfif (ManagerAccess eq "EDIT" or ManagerAccess eq "ALL") and Files gte "1">
			<tr>
				 <td colspan="1"></td>
				 <td colspan="7">
				 	 
				 <cf_filelibraryN
					DocumentPath="#Parameter.DocumentLibrary#"
					SubDirectory="#ProgramCode#" 
					Filter="#Per#"
					Box="#ProgramCode#"
					Insert="no"
					Remove="yes"
					Highlight="no"
					Listing="yes">
					
				</td>
				<td></td>
			</tr>
			</cfif>	
	
			<cfquery name="SubComponents" 
				datasource="AppsProgram"  
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  P.*, Pe.Reference, Pe.Period, Pe.OrgUnit, Pe.RecordStatus, Org.OrgUnitName
		   			FROM    #CLIENT.LanPrefix#Program P, ProgramPeriod Pe, Organization.dbo.Organization Org
					WHERE   Pe.PeriodParentCode = '#SearchResult.ProgramCode#'
					AND     P.ProgramCode = Pe.ProgramCode
					AND     Pe.Period     = '#SearchResult.Period#'
					AND     Pe.OrgUnit      = Org.OrgUnit 
					ORDER BY Pe.PeriodHierarchy
			</cfquery>
				
			<cfloop query="SubComponents">
			
				<cfif RecordStatus eq "9">
				<tr class="labelmedium2 linedotted" bgcolor="FFBFBF" class="<cfif ManagerAccess neq 'ALL'>hide</cfif>">
				<cfelse>
				<tr class="labelmedium2 linedotted">
				</cfif>
				  <td bgcolor="white" align="center" width="5%"></td>	
					<TD><img src="#SESSION.root#/Images/join.gif" alt="" border="0" align="absmiddle">&nbsp;&nbsp;<a href="javascript:EditProgram('#ProgramCode#','#Period#','Component')">#ProgramCode#</A></TD>					
					<TD>#OrgUnitName#</td>
					<TD><A HREF ="javascript:EditProgram('#SubComponents.ProgramCode#','#SubComponents.Period#','Component')"><font color="0080C0">#SubComponents.ProgramName#</font></A></TD>
					<TD>#Reference#</TD>
					<TD>#ProgramClass#</TD>
					<TD>#DateFormat(Created, CLIENT.DateFormatShow)#</TD>
					<td align="center">
						<cfif RecordStatus eq "9">
							<CFIF ManagerAccess eq "ALL">
								<a href="javascript:reinstate('#ProgramCode#')"><cf_tl id="Reinstate"></a>
							</cfif>
						</cfif>
					</TD>
				</tr>		
				
			</cfloop>
			
					
	</CFOUTPUT>
	
	</table>

</td></tr>

</table>

