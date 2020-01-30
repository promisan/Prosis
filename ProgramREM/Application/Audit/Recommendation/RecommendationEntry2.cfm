<HTML><HEAD>
<TITLE>Recommendation entry</TITLE>
</head>

<body leftmargin="0" bgcolor="f9f9f9" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 




<cfparam name="URL.AuditId" default="">
<cfparam name="URL.ObservationId" default="">
<cfparam name="URL.RecommendationId" default="">
 
<cfquery name="Recommendations" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
   FROM ProgramAudit.dbo.AuditObservationRecommendation
   WHERE 	
   AuditId='#URL.AuditId#'
   and
   ObservationId='#URL.ObservationId#'
</cfquery>

<cfform action="RecommendationEntrySubmit.cfm" method="POST" enablecab="Yes" name="recommendation">


	<table width="100%" border="1" bordercolor="silver" cellspacing="0" cellpadding="0" align="left" name="trecommendation" id="trecommendation">
	    
	  <tr>
	    <td width="100%" class="def">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
			
	    <TR bgcolor="f4f4f4">
		   <td>&nbsp;</td>	
		   <td height="18">Memo</td>
		   <td>&nbsp;</td>	
		   <td>Reference</td>
		   <td>Target Date</td>
		   <td>Implementation Date</td>			   
		   <td></td>
		   <td></td>
	    </TR>	
		<tr><td height="1" colspan="8" bgcolor="e4e4e4"></td></tr>
	
		<cfoutput>
		<cfloop query="Recommendations">
											
		<cfif #URL.RecommendationId# eq #RecommendationId#>
		
		    <tr bgcolor="ECEEF2"><td height="3" colspan="8"></td></tr>
									
			<tr bgcolor="ECEEF2">
							    		
				   <td>&nbsp;</td>									   						 						  
				   <td >
				   
					<textarea name="Description" cols="30" rows="6">#Recommendations.description#</textarea>					   
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

			   <input type="hidden" name="RecommendationId" id="RecommendationId" value="#URL.RecommendationId#">							   			   
			   <input type="hidden" name="ObservationId" id="ObservationId" value="#URL.ObservationId#">
			   <input type="hidden" name="AuditId" id="AuditId" value="#URL.AuditId#">
			  			  
			   <td colspan="2" align="center"><input type="submit" value=" Update " class="button10p">&nbsp;</td>

		    </TR>	
			
			<tr bgcolor="ECEEF2"><td height="3" colspan="8"></td></tr>
					
		<cfelse>
		
 			<TR>
			   <td height="20">

				</td>	
			   <td>#Recommendations.description#</td>
			   <td>&nbsp;</td>	
			   <td>#Recommendations.Reference#</td>
			   <td>#Dateformat(Recommendations.TargetDate, CLIENT.DateFormatShow)#</td>	 
			   <td>
			      #Dateformat(Recommendations.ImplementationDate, CLIENT.DateFormatShow)#
			   </td>
				   <td width="30">
				   <A href="RecommendationEntry.cfm?AuditId=#URL.AuditId#&ObservationId=#Recommendations.ObservationId#">[edit]</a>
				   </td>
				   <td width="30">
				    <cfif Recommendations.recordcount gt "1">
				    <A href="RecommendationPurge.cfm?AuditId=#URL.AuditId#&ObservationId=#Recommendations.ObservationId#">
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
					<textarea name="Description" cols="30" rows="6"></textarea>					   
				   </td>
				    <td>&nbsp;</td>	
				   <td class="regular">
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
					<cfoutput>	
					<cf_assignId>
					<cfset KeyRecommendationId=#RowGuid#>
					
				   <input type="hidden" name="RecommendationId" id="RecommendationId" value="#KeyRecommendationId#">
				   <input type="hidden" name="ObservationId" id="ObservationId" value="#URL.ObservationId#">
   				   <input type="hidden" name="AuditId" id="AuditId" value="#URL.AuditId#">
				   </cfoutput>				   
 				   <td colspan="2" align="center">
				   <input type="submit" value=" Add " class="button10p"></td>

			    </TR>	
				<tr><td height="3"></td></tr>
					
			</cfif>	
		
				</table>
		
				</td>
				</tr>
					  			
			</table>	


</CFFORM>


	
	</BODY></HTML>
