<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<HTML><HEAD>
<TITLE>Observation entry</TITLE>

</head>

<body leftmargin="0" bgcolor="ffffff" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="URL.AuditId" default="">
<cfparam name="URL.ObservationId" default="">
<cfparam name="URL.action" default="">
  
<cfquery name="Observations" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     O.*, C.Description AS darea
FROM         ProgramAudit.dbo.AuditObservation O LEFT OUTER JOIN
                      Ref_ProgramCategory C ON O.Area = C.Code
WHERE     
AuditId = '#URL.AuditId#' and (O.RecordStatus <> '9')
ORDER BY O.Created
</cfquery>

<cfquery name="getnrecommendations" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     count(1) as total
FROM         ProgramAudit.dbo.AuditObservationRecommendation
WHERE AuditId = '#URL.AuditId#'
AND RecordStatus != '9' 
</cfquery>

<cfquery name="ProgramCategory" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM         ref_ProgramCategory
</cfquery>

<cfform action="ObservationEntrySubmit.cfm" method="POST" name="observation">

	<table width="100%" border="1" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" align="left" name="tobservations" id="tobservations">
				
	  <cfoutput>

	  <cfloop query="observations">
				
	  <tr>
	    <td width="100%" class="def">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
		<TR bgcolor="f4f4f4"><TD colspan=10 ><b><font face="Verdana">Observation  #currentrow#</b><TD></TR>
		<tr><td height="1" colspan="10" bgcolor="e4e4e4"></td></tr>		
	    <TR bgcolor="f4f4f4">
		   <td></td>	
		   <td height="18">Description</td>
		   <td>Reference</td>
		   <td>Area</td>	
		   <td>Target Date</td>
		
	    </TR>	

		<cfif #URL.ObservationId# eq #ObservationId#>
								
			<tr bgcolor="ECEEF2">
							    		
				   <td>&nbsp;</td>									   						 						  
				   <td >
				   <cfinput type="Text" 
				        name="Description" 
						value="#Observations.Description#" 
						message="Please enter a description" 
						required="Yes" 
						size="60" 
						maxlength="100" 
						class="regular">
				   </td>
				   
				
				   <td>
				   <input type="text" name="Reference" id="Reference" value="#Observations.Reference#" size="10" maxlength="10" class="regular">
				   </td>
				   
				  
				   	<td class="regular">
					<select name="Area" required="Yes">
	  				  <cfloop query="ProgramCategory">
					  <option value="#code#" <cfif #Observations.area# eq #code#> SELECTED</cfif>>
						  #ProgramCategory.description#
					  </option>
					  </cfloop>
					</select>						
					
				   </td>				   
				  			   
				   <td width="25%" class="regular">
				   
					<cf_intelliCalendarDate
					FieldName="TargetDate" 
					Default="#Dateformat(Observations.TargetDate, CLIENT.DateFormatShow)#"
					AllowBlank="False">			
						
				   </td>
							   			   
			   <input type="hidden" name="ObservationId" id="ObservationId" value="#URL.ObservationId#">
			   <input type="hidden" name="AuditId" id="AuditId" value="#URL.AuditId#">
			  			  
			   <td colspan="2" align="center"><input type="submit" value=" Update " class="button10p">&nbsp;</td>

		    </TR>	
			
			<tr bgcolor="ECEEF2"><td height="3" colspan="10"></td></tr>
					
		<cfelse>
			   <tr>
			  
			   <td>#Observations.description#</td>
			   <td>#Observations.Reference#</td>
			   <td>#Observations.dArea#</td>
			   <td>
			      #Dateformat(Observations.TargetDate, CLIENT.DateFormatShow)#
			   </td>
				   <td width="30">
				   <A href="ObservationEntry.cfm?AuditId=#URL.AuditId#&ObservationId=#Observations.ObservationId#">[edit]</a>
				   </td>
				   <td width="30">
				    <cfif observations.recordcount gt "1">
				    <A href="ObservationPurge.cfm?AuditId=#URL.AuditId#&ObservationId=#Observations.ObservationId#">
					<img src="#SESSION.root#/Images/trash2.gif" alt="Remove" width="16" height="18" border="0">
					<a>
					</cfif>
				   </td>
				   
		    </TR>

			<tr><td height="1" colspan="10" bgcolor="D2D2D2"></td></tr>
		     <tr id="Recommend">
			 <td></td>
			 <td colspan="10">
				 <input type="hidden" name="observation" id="observation" value="0">	
				<cfoutput>
				   <iframe src="#SESSION.root#/ProgramREM/Application/Audit/Recommendation/RecommendationEntry.cfm?AuditId=#URL.AuditId#&ObservationId=#Observations.ObservationId#&crow=#currentrow#" name="irecommendation_#currentrow#" id="irecommendation_#currentrow#" width="100%" height="100" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" scrolling="no" frameborder="0"></iframe>
				</cfoutput>
	 
			 </td>
		  </tr>	 			
		
		</cfif>
		
		<tr><td height="1" colspan="10" bgcolor="D2D2D2"></td></tr>

		</table>
		
		</td>
		</tr>		
		</cfloop>
		</cfoutput>
	    <tr>
	    <td width="100%" class="def">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="formpadding">
	    <TR bgcolor="f4f4f4">
		   <td height="18">Description</td>
		   <td>Reference</td>
		   <td>Target Date</td>
		   <td></td>
	    </TR>	
		<tr><td height="1" colspan="10" bgcolor="e4e4e4"></td></tr>			
					
			<cfif #URL.ObservationId# eq "" >
			
			    <tr><td height="3"></td></tr>
												
				<TR>
				
				   <td>
				   <cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="60" maxlength="200" class="regular">
				   </td>
				
				   <td class="regular">
				   <input type="text" name="Reference" value="" size="10" maxlength="10" class="regular">
				   </td>
				
					<td>
					<select name="Area" required="Yes">
					  <cfoutput query="ProgramCategory">
					  <option value="#code#">#Description#
					  </option>
					  </cfoutput>
					</select>					
					</td>	
								
				   <td width="25%">
				   		  <cf_intelliCalendarDate
						FieldName="TargetDate" 
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
						AllowBlank="False">	

				   </td>
				   
					<cfoutput>	
					<cf_assignId>
					<cfset KeyObservationId=#RowGuid#>
					
				   <input type="hidden" name="ObservationId" id="ObservationId" value="#KeyObservationId#">
   				   <input type="hidden" name="AuditId" id="AuditId" value="#URL.AuditId#">
				   </cfoutput>				   
 				
				   
			    </TR>	
				<cfloop index="itm" from="1" to="4">
				
				<tr bgcolor="f4f4f4">
				<td>Recommendation <cfoutput>#itm#</cfoutput></td>
				</tr>
				
				</cfloop> 
				
				<tr><td height="1" colspan="4" bgcolor="e4e4e4"></td></tr>
				
				<tr>
				  <td colspan="4" align="right">
				  <input type="submit" value=" Save Observation" class="button10p"></td>
				</tr>
				
				<tr><td height="3"></td></tr>
					
			</cfif>	
		
				</table>
		
				</td>
				</tr>
					  			
			</table>	



</CFFORM>

	<cfoutput>
	<script language="JavaScript">
	
	{
	
	out  = parent.document.getElementById("observation");
	out.value = #observations.recordcount#
	frm  = parent.document.getElementById("iobservation");
	vnr=110+#getnrecommendations.total#*100;
	he = 60+#observations.recordcount#*22;
	he = he+vnr;

	frm.height = he
	
	sel = parent.document.getElementById("AuditNo")
	if (sel) {	sel.focus(); 
	           	sel.click();
			 }
		
	}
	</script>
	</cfoutput>
	
	</BODY></HTML>
