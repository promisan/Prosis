<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="url.claimtype" default="">

<cfquery name="Mission" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_ParameterMission	
	WHERE Mission IN (SELECT Mission FROM Claim)
</cfquery>

<cfloop query="Mission">

	<cfset mis = mission>

	<cfquery name="Element" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_ElementClass	
	</cfquery>
	
	<cfloop query="Element">
	
	    <!--- check if exisits --->
				
		<cfquery name="Exist" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM  Claim
			WHERE Mission    = '#Mis#'
			AND   ClaimType  = '#claimtype#'			
		</cfquery>
		
		<cfif exist.recordcount eq "0">
	
			<cfquery name="Check" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Ref_ClaimTypeTab
				WHERE Mission = '#Mis#'
				AND   Code    = '#claimtype#'
				AND   TabName = '#Description#' 
			</cfquery>
			
			<cfif check.recordcount eq "0">
			
				<cfquery name="Add" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_ClaimTypeTab
					(Mission, Code, TabName, TabOrder, TabIcon, TabTemplate,Operational)
					VALUES
					('#Mis#','#ClaimType#','#Description#',6,'Logos/CaseFile/Data.png','element',1)		
				</cfquery>
			
			</cfif>
		
		</cfif>
	
	</cfloop>

</cfloop>

<cfquery name="SearchResult" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_ClaimTypeTab	
	<cfif url.claimtype neq "">
	WHERE Code = '#url.claimtype#'
	</cfif>
	ORDER BY Mission,TabOrder
</cfquery>


<cfif url.claimtype eq "">
	
	<cf_screentop height="100%" scroll="Yes" html="No" jquery="yes">
	
</cfif>	

<!--- generate record for elements --->

<table height="100%" align="center" width="98%" cellspacing="0" cellpadding="0" class="navigation_table">

<cfif url.claimtype eq "">
		
	<cfset Page         = "0">
	<cfset add          = "1">
	<cfset Header       = "Tabs">
	<cfinclude template = "../HeaderCasefile.cfm"> 
	
</cfif>
 
<cfinclude template="TabScript.cfm">

	<tr>
	
	  <td colspan="2">
	
		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" >
		
		<tr class="labelheader linedotted" >
		   
		    <td width="30"></td>
			<td><cf_tl id ="Icon"></td>
			<td><cf_tl id ="Tab Name"></td>
			<td><cf_tl id ="Tab Label"></td>
			<td><cf_tl id ="Template"></td>
			<td><cf_tl id ="Listing Order"></td>
			<td><cf_tl id ="Operational"></td>
		    <td><cf_tl id ="Entered"></td>
		    <td align="right">
			  <cfoutput>
				<a href="javascript:recordadd('#url.claimtype#')">
					 <font color="0080FF">[<cf_tl id="add">]</font></a>
			 </cfoutput>&nbsp;
			</td>
		</tr>
		
		<cfoutput query="SearchResult" group="Mission">
		
			<tr class="linedotted">
			  <td colspan="9" class="labelmedium"><b><i>#Mission#</i></b></td>
			</tr>
		
			<cfoutput>
			   
				<tr class="cellcontent linedotted navigation_row">	
					<td></td>	
					<td><img src="#Client.VirtualDir#/images/#TabIcon#" height="18" width="18" alt="" border="0"></td>
					<td>#TabName#</td>
					<td>#TabLabel#</td>
					<td>#TabTemplate#</td>
					<td>#TabOrder#</td>
					<td>
						<cfif Operational eq 0>
							<cf_tl id="No">
						<cfelse>
							<cf_tl id="Yes">
						</cfif>
					</td>
					<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
					<td><cf_img icon="edit" onclick="recordedit('#Mission#','#Code#','#TabName#')">
					</td>
			    </tr>	 
				
			</cfoutput>
		</cfoutput>
		
		</table>
	
	</td>

</table>

<cfset AjaxOnLoad("doHighlight")>
