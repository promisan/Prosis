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
<TITLE>Recommendation entry</TITLE>
</head>

<body leftmargin="0" bgcolor="f9f9f9" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cfparam name="URL.AuditId" default="">
<cfparam name="URL.ObservationId" default="">
<cfparam name="URL.RecommendationId" default="">
<cfparam name="URL.crow" default="">
 
<cfquery name="Recommendations" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT AR.*,S.description as dstatus
   FROM ProgramAudit.dbo.AuditObservationRecommendation AR, Program.dbo.ref_status s
   WHERE 	
   S.ClassStatus='Audit' and
   AR.status=s.status and
   AuditId='#URL.AuditId#'
   and
   ObservationId='#URL.ObservationId#'
   and RecordStatus != '9' 
</cfquery>

<cfquery name="sqlStatus"
     datasource="AppsProgram"
     username="#SESSION.login#"
     password="#SESSION.dbpw#">
	 SELECT status as code, description
     FROM Ref_status
	 WHERE ClassStatus = 'Audit'
</cfquery>



<cfform action="RecommendationEntrySubmit.cfm" method="POST" enablecab="Yes" name="recommendation">
   <cfoutput>
   <input type="hidden" name="crow" id="crow" value="#URL.crow#">							   			   
   </cfoutput>
	<table width="100%" border="1" bordercolor="silver" cellspacing="0" cellpadding="0" align="left" name="trecommendation" id="trecommendation">
	    
	  <tr>
	    <td width="100%" class="def">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
			
	    <TR bgcolor="f4f4f4">
		   <td width=3%>&nbsp;</td>	
		   <td height="18"><B>RECOMMENDATIONS</b></td>
		   <td>&nbsp;</td>	
		   <td>Reference</td>
		   <td>Target Date</td>
		   <td>Implementation Date</td>			   
   		   <td>Status</td>			   
		   <td></td>
		   <td></td>
	    </TR>	
		<tr><td height="1" colspan="8" bgcolor="e4e4e4"></td></tr>
	
		<cfoutput>
		<cfloop query="Recommendations">
											
		<cfif #URL.RecommendationId# eq #RecommendationId#>
		
		    <tr bgcolor="ECEEF2"><td height="3" colspan="8"></td></tr>
									
			<tr bgcolor="ECEEF2">
							    		
				   <td>&nbsp;#currentrow#)&nbsp;</td>									   						 						  
				   <td >
				   
					<textarea name="Description" cols="90" rows="3">#Recommendations.description#</textarea>					   
				   </td>
				   
				   <td>&nbsp;</td>	
				   <td>
				   <input type="text" name="Reference" value="#Recommendations.Reference#" size="10" maxlength="10" class="regular">
				   </td>
				   
				   <td>
					<cf_intelliCalendarDate
					FieldName="TargetDate" 
					Default="#Dateformat(Recommendations.TargetDate, CLIENT.DateFormatShow)#"
					AllowBlank="False">			
				   
				   </td>	
				   <td width="25%" class="regular">
				   
					<cf_intelliCalendarDate
					FieldName="ImplementationDate" 
					Default="#Dateformat(Recommendations.ImplementationDate, CLIENT.DateFormatShow)#"
					AllowBlank="False">			
						
				   </td>
				   
				   	<td width="25%" class="regular">

				<select name="Status" required="Yes">
  				  <cfloop query="sqlStatus">
				  <option value="#code#" <cfif #Recommendations.status# eq #code#> SELECTED</cfif>>
				  #SqlStatus.description#
				  </option>
				  </cfloop>
				</select>					   
						
				   </td>

			   <input type="hidden" name="RecommendationId" id="RecommendationId" value="#URL.RecommendationId#">							   			   
			   <input type="hidden" name="ObservationId" id="ObservationId" value="#URL.ObservationId#">
			   <input type="hidden" name="AuditId" id="AuditId" value="#URL.AuditId#">
			  			  
			   <td colspan="2" align="center"><input type="submit" value=" Update " class="button10p">&nbsp;</td>

		    </TR>	
			
			<tr bgcolor="ECEEF2"><td height="3" colspan="8"></td></tr>
					
		<cfelse>
		
 			<TR>
			   <td>#currentrow#</td>	
			   <td>#Recommendations.description#</td>
			   <td></td>	
			   <td>#Recommendations.Reference#</td>
			   <td>#Dateformat(Recommendations.TargetDate, CLIENT.DateFormatShow)#</td>	 
			   <td>#Dateformat(Recommendations.ImplementationDate, CLIENT.DateFormatShow)#</td>
			   <td width="25%">#Recommendations.dstatus#</td>
			   <td width="30">
				   <A href="RecommendationEntry.cfm?AuditId=#URL.AuditId#&ObservationId=#Recommendations.ObservationId#&RecommendationId=#Recommendations.RecommendationId#&crow=#currentrow#">[edit]</a>
			   </td>
			   <td width="30">
				    <cfif Recommendations.recordcount gt "1">
				    <A href="RecommendationPurge.cfm?AuditId=#URL.AuditId#&ObservationId=#Recommendations.ObservationId#&RecommendationId=#Recommendations.RecommendationId#&crow=#currentrow#">
					<img src="#SESSION.root#/Images/trash2.gif" alt="Remove" width="16" height="18" border="0">
					<a>
					</cfif>
			   </td>
			</TR>	

 

		
		</cfif>
		
		<tr><td height="1" colspan="8" bgcolor="D2D2D2"></td></tr>
		
		</cfloop>
		</cfoutput>
			
			<cfif #URL.RecommendationId# eq "" >
			
			    <tr><td height="3"></td></tr>
												
				<TR>
				   <td>&nbsp;</td>	
				   <td>
					<textarea name="Description" cols="90" rows="3"></textarea>					   
				   </td>
				    <td>&nbsp;</td>	
				   <td>
				   <input type="text" name="Reference" value="" size="10" maxlength="10" class="regular">
				   </td>
				    <td>
			   		  <cf_intelliCalendarDate
						FieldName="TargetDate" 
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
						AllowBlank="False">						
					</td>	
				   <td width="25%">
				   		  <cf_intelliCalendarDate
						FieldName="ImplementationDate" 
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
						AllowBlank="False">	

				   </td>
				   	<td width="25%">


				<select name="Status" required="Yes">
				  <cfoutput query="sqlStatus">
				  <option value="#code#">#Description#
				  </option>
				  </cfoutput>
				</select>					
				   </td>
				   
					<cfoutput>	
					<cf_assignId>
					<cfset KeyRecommendationId=#RowGuid#>
					
				   <input type="hidden" name="RecommendationId" id="RecommendationId" value="#KeyRecommendationId#">
				   <input type="hidden" name="ObservationId" id="ObservationId" value="#URL.ObservationId#">
   				   <input type="hidden" name="AuditId" id="AuditId" value="#URL.AuditId#">
				   </cfoutput>				   
 				   <td colspan="2" align="center">
				   <input type="submit" value="Save Recomm." class="button10p"></td>

			    </TR>	
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
	<cfoutput>
	frm  = parent.document.getElementById("irecommendation_#URL.crow#");
	</cfoutput>
	he = 90+#recommendations.recordcount*22#;

	frm.height = he
	

		
	}
	</script>
	</cfoutput>
	
	</BODY></HTML>
