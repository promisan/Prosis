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

<style> 
 .navy{background-color: navy;} 
</style>


<script>


function iecompattest(){
return (!window.opera && document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
} 
 
var ie5=document.all&&document.getElementById
var ns6=document.getElementById&&!document.all
var initialwidth,initialheight

function loadwindow(url,width,height,event,bx2){
if (!ie5&&!ns6)
window.open(url,"","width=width,height=height,scrollbars=1")
else{

if (!event)
{
posx = 108;
posy = bx2*10+290;

}

else
{
posx = event.clientX + 100;
posy = event.clientY + 290;
}


parent.document.getElementById("dwindow").style.display=''
parent.document.getElementById("dwindow").style.width=initialwidth=width+"px"
parent.document.getElementById("dwindow").style.height=initialheight=height+"px"
parent.document.getElementById("dwindow").style.left=posx+"px"
parent.document.getElementById("dwindow").style.top=ns6? window.pageYOffset*1+posy+"px" : iecompattest().scrollTop*1+posy+"px"
parent.document.getElementById("cframe").src=url



}
}


function more(bx,url,event,bx2)
	
	 {
	 
   		se2  = document.getElementById(bx+"Exp");
			 		 
		if (se2.className=="regular")
		 {

			 se2.className="hide"
			 
 	 		 se3  = document.getElementById(bx+"Min");
			 se3.className="regular"
			
			var table = document.getElementById("tobservations");   
			var rows = table.getElementsByTagName("tr");  
			rows[bx2].className = "navy"; 

			loadwindow(url,700,400,event,bx2);

		 }
		 
		 else
		 
		 {
 	 		 se2  = document.getElementById(bx+"Min");
			 se2.className="hide"
	
  	 		 se3  = document.getElementById(bx+"Exp");
			 se3.className="regular"

			 
		 }
			 		
 }	
 
</script>

</head>

<body leftmargin="0" bgcolor="f9f9f9" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 





<cfparam name="URL.AuditId" default="">
<cfparam name="URL.ObservationId" default="">
<cfparam name="URL.action" default="">
 
 
<cfquery name="Observations" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM         ProgramAudit.dbo.AuditObservation 
WHERE AuditId = '#URL.AuditId#'
AND RecordStatus != '9' 
ORDER BY created
</cfquery>

<cfform action="ObservationEntrySubmit.cfm" method="POST" enablecab="Yes" name="observation">


	<table width="100%" border="1" bordercolor="silver" cellspacing="0" cellpadding="0" align="left" name="tobservations" id="tobservations">
	    
	  <tr>
	    <td width="100%" class="def">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
			
	    <TR bgcolor="f4f4f4">
		   <td>&nbsp;</td>	
		   <td height="18">Description</td>
		   <td>&nbsp;</td>	
		   <td>Reference</td>
		   <td>&nbsp;</td>	
		   <td>Target Date</td>
		   <td></td>
		   <td></td>
	    </TR>	
		<tr><td height="1" colspan="8" bgcolor="e4e4e4"></td></tr>
	
		<cfoutput>
		<cfloop query="observations">
											
		<cfif #URL.ObservationId# eq #ObservationId#>
		
		    <tr bgcolor="ECEEF2"><td height="3" colspan="8"></td></tr>
									
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
				   
				   <td>&nbsp;</td>	
				   <td>
				   <input type="text" name="Reference" value="#Observations.Reference#" size="10" maxlength="10" class="regular">
				   </td>
				   
				   <td>&nbsp;</td>	
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
			
			<tr bgcolor="ECEEF2"><td height="3" colspan="8"></td></tr>
					
		<cfelse>
			
			<TR>
			   <td height="20">
			   	   <cfif #currentrow# eq "1">
				      <cfset crow=3>
				   <cfelse>
					   <cfset crow=#crow#+2>
				   </cfif>
				   <img src="#SESSION.root#/Images/zoomin.jpg" alt="Expand" 
				   id="#CurrentRow#Exp" border="0" class="regular" 
				   align="middle" style="cursor: pointer;" onClick="more('#CurrentRow#','#SESSION.root#/ProgramREM/Application/Audit/Recommendation/RecommendationEntry.cfm?AuditId=#Observations.AuditId#&ObservationId=#Observations.ObservationId#&row=#CurrentRow#',event,#crow#)">
				   <img src="#SESSION.root#/Images/zoomout.jpg" 
				    id="#CurrentRow#Min" class="hide" 
				    alt="Hide" border="0" align="middle" class="#CurrentRow#" style="cursor: pointer;" 
				   onClick="more('#CurrentRow#','#SESSION.root#/ProgramREM/Application/Audit/Recommendation/RecommendationEntry.cfm?AuditId=#Observations.AuditId#&ObservationId=#Observations.ObservationId#&row=#CurrentRow#',event,#crow#)">&nbsp;			   
			   

				</td>	
			   <td>#Observations.description#</td>
			   <td>&nbsp;</td>	
			   <td>#Observations.Reference#</td>
			   <td>&nbsp;</td>	 
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
			<cfif #action# eq #observationId#>
			<script>
				<cfoutput>
				more('#CurrentRow#','#SESSION.root#/ProgramREM/Application/Audit/Recommendation/RecommendationEntry.cfm?AuditId=#Observations.AuditId#&ObservationId=#Observations.ObservationId#&row=#CurrentRow#',null,#crow#);
				</cfoutput>
			</script>
				
 			</cfif>

		
		</cfif>
		
		<tr><td height="1" colspan="8" bgcolor="D2D2D2"></td></tr>
		
		</cfloop>
		</cfoutput>
			
			<cfif #URL.ObservationId# eq "" >
			
			    <tr><td height="3"></td></tr>
												
				<TR>
				   <td>&nbsp;</td>	
				   <td>
				   <cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="60" maxlength="200" class="regular">
				   </td>
				    <td>&nbsp;</td>	
				   <td class="regular">
				   <input type="text" name="Reference" value="" size="10" maxlength="10" class="regular">
				   </td>
				    <td>&nbsp;</td>	
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

	<cfoutput>
	<script language="JavaScript">
	
	{
	
	out  = parent.document.getElementById("observation");
	out.value = #observations.recordcount#
	frm  = parent.document.getElementById("iobservation");
	he = 60+#observations.recordcount*22#;
	frm.height = he
	
	sel = parent.document.getElementById("AuditNo")
	if (sel) {	sel.focus(); 
	           	sel.click();
			 }
		
	}
	</script>
	</cfoutput>
	
	</BODY></HTML>
