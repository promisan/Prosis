<cfparam name="url.scope" default="Backoffice">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop label="Issued documents" 
        height="100%" jQuery="Yes" 
		scroll="yes" 
		html="No" 
		menuaccess="context"
        actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

<cfparam name="URL.Status" default="0">

<cfoutput>

<script language="JavaScript">
	
	function issuedocument(persno) {
	    ptoken.location("#session.root#/Staffing/Application/Employee/Document/DocumentEntry.cfm?ID=" + persno);
	}
	
	function edit(persno,doc) {
	    ptoken.location("#session.root#/Staffing/Application/Employee/Document/DocumentEdit.cfm?ID=" + persno + "&id1=" + doc);
	}
	
	function reloadForm(st) {
	    ptoken.location("#session.root#/Staffing/Application/Employee/Document/EmployeeDocument.cfm?ID=#URL.ID#&Status=" + st);
	}

</script>

</cfoutput>

<cf_dialogPosition>

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM Parameter
</cfquery>
   
<cfif URL.Status eq "0">
      <cfset condition = "">
<cfelseif URL.Status eq "1">
      <cfset condition = "AND (L.DateExpiration > #now()# or L.DateExpiration is NULL)">
<cfelse>	  
	  <cfset condition = "AND L.DateExpiration < #now()#">
</cfif>

<!--- Query returning search results --->

<cfquery name="Holder" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT DependentId
    FROM      PersonDocument
	WHERE     PersonNo = '#URL.ID#' 
	ORDER BY  DependentId	
</cfquery>

<cfparam name="url.webapp" default="">

<cfif url.webapp eq "">

	  <table cellpadding="0" cellspacing="0" width="99%" align="center">
		
			<tr><td height="10" style="padding-left:7px">	
				  <cfset ctr      = "0">		
			      <cfset openmode = "close"> 
				  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
		</table>

<cfelse>
		<table cellpadding="0" cellspacing="0" width="99%" align="center">
		
			<tr><td height="10">	
				  <cfset ctr      = "0">		
			      <cfset openmode = "open"> 
				  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
		</table>

</cfif>	
	
<table><tr><td height="1"></td></tr></table>	

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
  <tr><td>
	
<table width="99%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td style="padding:10px 0 10px 30px;height:54px;" class="labelmedium">
        
       <img src="<cfoutput>#session.root#/Images/UploadDocuments.png</cfoutput>" height="60" width="60" style="float:left;padding-right: 10px;">
        <h1 style="float:left;color:#333333;font-size:28px;font-weight:200;padding-top:10px;">Upload your <strong>Documents</strong></span></h1>
        <p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">Declare and attach a copy of important document that we require (passport, laissez passer, drivers license).</p>
        <div class="emptyspace" style="height: 30px;"></div>
        
	    <table><tr><td></td>
		<td><input type="radio" class="radiol" name="Status" value="0" onClick="reloadForm('0')" <cfif URL.Status eq "0">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "0"><b></cfif><cf_tl id="All"></td>
		<td><INPUT type="radio" class="radiol" name="Status" value="1" onClick="reloadForm('1')" <cfif URL.Status eq "1">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "1"><b></cfif><cf_tl id="Current"></td>
		<td><INPUT type="radio" class="radiol" name="Status" value="2" onClick="reloadForm('2')" <cfif URL.Status eq "2">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "2"><b></cfif><cf_tl id="Expired"></td>
		</tr></table>
	</td>
	
	<cfoutput>
		
    <td align="right">
	<cf_tl id="Add" var="vAdd">
	<input type="button" value="#vAdd#" class="button10g" onClick="javascript:issuedocument('#URL.ID#')">&nbsp;
    </td>
	</cfoutput>
   </tr>
   <tr>
  <td width="100%" colspan="3">
  
	  <table border="0" class="formpadding navigation_table" cellpadding="0" cellspacing="0" width="100%">
			
		<TR class="labelmedium line">
		    <td width="24" height="20" align="center"></td>
			<TD width="15%"><cf_tl id="Type"></TD>
			<TD width="20%"><cf_tl id="DocumentNo"></TD>
			<td width="14%"><cf_tl id="Issued"></td>
		    <td width="14%"><cf_tl id="Effective"></td>
			<TD width="14%"><cf_tl id="Expiration"></TD>			
			<TD width="14%"><cf_tl id="Officer"></TD>	
		</TR>
		
	<cfset last = '1'>
	<cfset row = 0>
	
	<cfoutput query="Holder">	
		
		<cfif DependentId neq "">
				
			<cfquery name="Dependent" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
			    FROM   PersonDependent
				WHERE  PersonNo    = '#URL.ID#' 
				AND    DependentId = '#dependentid#'							
			</cfquery>		
			
			<tr><td colspan="7" class="cellcontent" valign="bottom" height="30"><font size="2">#Dependent.FirstName# #Dependent.LastName#</font></td></tr>
			<tr><td colspan="7" class="line"></td></tr>
			
		</cfif>
		
		<cfquery name="Listing" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM   PersonDocument L INNER JOIN Ref_DocumentType T ON L.DocumentType = T.DocumentType 
			WHERE  L.PersonNo = '#URL.ID#' 
			<cfif dependentid eq "">
			AND    L.DependentId is NULL 
			<cfelse>
			AND    L.DependentId = '#dependentid#' 
			</cfif>		
			#preserveSingleQuotes(condition)#		
			ORDER BY T.Listingorder, L.DocumentType, L.DateEffective DESC  
		</cfquery>
		
		<cfloop query="Listing">
		
		<cfset row = row+1> 
		
		<cfif DateExpiration lt now() and DateExpiration neq "">
		
			<tr bgcolor="FAE2DA" class="navigation_row labelmedium line">
			<td align="center" style="padding-top:3px">
			
				<cfif enableRemove eq "1">
			
					<cf_img icon="edit" navigation="yes" onClick="edit('#URL.ID#','#DocumentId#')">
					
				<cfelse>
				
					<cfinvoke component  = "Service.Access" 
				      method     = "contract"
					  personno   = "#URL.ID#"	
					  role       = "'ContractManager','PayrollOfficer'"		
					  returnvariable = "access">
				
					<cfif access eq "EDIT" or access eq "ALL">
								
						<cf_img icon="edit" navigation="yes" onClick="edit('#URL.ID#','#DocumentId#')">
					
					</cfif>
				
				</cfif>	
			
			</td>	
		
		<cfelse>
		
		<TR class="navigation_row labelmedium line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F9F9F9'))#">
		
			<td align="center" style="padding-top:3px">	
						
				<cfif enableRemove eq "1">
			
					<cf_img icon="edit" navigation="yes" onClick="edit('#URL.ID#','#DocumentId#')">
					
				<cfelse>
				
					<cfinvoke component  = "Service.Access" 
					      method     = "contract"
						  personno   = "#URL.ID#"	
						  role       = "'ContractManager','PayrollOfficer'"		
						  returnvariable = "access">
					
						<cfif access eq "EDIT" or access eq "ALL">
								
						<cf_img icon="edit" navigation="yes" onClick="edit('#URL.ID#','#DocumentId#')">
					
					    </cfif>
				
				</cfif>	
				
			</td>	
			
		</cfif>	
						
			<cfparam name="attNo" default="0">
			
			<TD><a href="javascript:edit('#URL.ID#','#DocumentId#')"><font color="6688aa">#Description#</font></a></TD>
			<TD>#DocumentReference#</TD>
			<td>#IssuedCountry#</td>
			<td>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
			<td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>			
			<td>#OfficerLastName#</td>
		
		</tr>
		
		<cfif remarks neq "">
		
		<tr>
			<td></td>
			<td></td>
			<TD colspan="5">#Remarks#</TD>
		</tr>
		
		</cfif>
	
		<cf_filelibraryCheck    	
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#PersonNo#" 
			Filter="#documenttype#_#left(DocumentId,8)#">
					
		<cfif files gte "1">
			
			<tr>
			
				<td align="center" valign="top">
				<!---
				<img src="#SESSION.root#/Images/join.gif" alt="" border="0" align="middle">
				--->
				</td>
				<td></td>
				<td colspan="4">
										  
					  <cf_filelibraryN
							DocumentPath="#Parameter.DocumentLibrary#"
							SubDirectory="#PersonNo#" 
							Filter="#documenttype#_#left(DocumentId,8)#"
							Insert="no"
							box="b#currentrow#"
							Remove="no"
							Listing="yes">
							
					
				</td>
			
			</tr>
		
		</cfif>		
				
		</cfloop>
	
	</cfoutput>
	
	</TABLE>

</td>
</tr>

</table>


</td>
</tr>

</table>
