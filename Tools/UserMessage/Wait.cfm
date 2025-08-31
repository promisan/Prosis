<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="Attributes.Flush"       default="No">
<cfparam name="Attributes.text"        default="">
<cfparam name="Attributes.class"       default="top4N">
<cfparam name="Attributes.height"      default="150">
<cfparam name="Attributes.width"       default="70%">
<cfparam name="Attributes.border"      default="1">
<cfparam name="Attributes.controlid"   default="">
<cfparam name="Attributes.progress"    default="1">
<cfparam name="Attributes.total"       default="">
<cfparam name="Attributes.last"        default="0">
<cfparam name="Attributes.status"      default="#attributes.text#">
<cfparam name="Attributes.graphic"     default="busy2.gif">
<cfparam name="Attributes.DataSource"     default="AppsSystem">

<cf_waitEnd>

<cfsavecontent variable="reset">
		
		<script language="JavaScript">
		
			   	{ 
				
				try	{				
											
				se  = parent.document.getElementById("preview");				
				if (se)	{se.className = "buttonPrint";}				
				
				se  = parent.document.getElementById("email");
				if (se)	{se.className = "buttonPrint"}
				
				se  = parent.document.getElementById("buttons");
				if (se) {se.className = "regular"}
							
				se  = parent.document.getElementById("stop");
				if (se) {se.className = "hide"}
				
				se  = parent.document.getElementById("stopping");
				if (se)	{se.className = "hide"}
				
				// se  = document.getElementById("requestabort"); <!--- where is this ????? --->
				// if (se)	{se.className = "hide"}
				
				} catch(e) {}
				
				}
									
		</script> 
		
</cfsavecontent>	

<cfoutput>

<script>
	window.status = "#Attributes.status#";
</script>

<!--- ------------------------------------- --->
<!--- reporting framework behavior to catch --->
<!--- ------------------------------------- --->

<cfif Attributes.ControlId neq "" and Attributes.Last neq "1">

  <!--- retrieve the status of the report for this user as set by the button to cancel, if
  a record is found it means we have to stop it --->
       	
  <cfquery  Name="List" 
	     	DataSource="#Attributes.DataSource#"
	     	UserName="#SESSION.login#" 
		 	Password="#SESSION.dbpw#">
		 	
		 		SELECT * 
		 		FROM   System.dbo.stReportStatus
		 		WHERE  ControlId     = '#Attributes.controlId#'
		 		AND    OfficerUserId = '#SESSION.acc#'
		  
  </cfquery>		
			
			
  <cfif list.recordcount gte "1">
  
  	  <!--- user selected abort  --->
	 	 	 
	 <cfif ParameterExists(Form.SQL)> 		 
	 
	  <!--- this is to show the SQL criateria --->
		 	 
	 <cfelse>
	 	 				 
	 	<script>
		
			try {		
			toggle('reportcriteria','menu1')			
			ColdFusion.navigate('#session.root#/tools/CFReport/HTML/setAbortMessage.cfm?controlid=#url.controlid#','messagebox', function(){
				//hide message
				setTimeout(function(){ $('##messagebox table').fadeOut(1500, function(){ $('##messagebox').html('');  }); }, 3000);
			});
			} catch(e) {} 			
								
		</script>
					
		<!--- execute script to normalise the menu --->
					  
		 #reset#			 
				  
		<!--- stop the batch routine of the report and will thus not reach 
		template reportquery.cfm line 37 to execute the query --->
		  	
		<cfabort>
		   
	   </cfif>	   
	 	   
	</cfif>	   
	
</cfif>	
	   
<cfif Attributes.Last eq "1">
	    
	   <!--- reset the report --->
	  					   
		#reset#
				 	   
</cfif>  

<!--- the below code is no longer relevant and has been replace by ajax --->

<!--- NEW 10/12/2010 : We hide for report progress --->

<cfif Attributes.ControlId eq "">

    <!--- disabled 3/7/2015

	<table width="#Attributes.width#" 
		    border="0" 
			cellspacing="0" 
			cellpadding="0" 
			align="center" id="busy" name="busy">
	    
	<tr><td height="#Attributes.height#"></td></tr>
	       
	<tr>
	    <td width="80%" align="center" class="regular">
						
		<table width		="100%" 
		       border		="0" 
			   bgcolor		="white" 
			   cellspacing	="0" 
			   cellpadding	="0" 
			   bordercolor	="d4d4d4"
			   class		="formpadding">
		
		<tr><td height="25" align="center" class="#Attributes.Class#">
		<font color="737373"><b>
		
		<cfif Attributes.text eq "">
		
			<cf_tl id="Loading"><cfelse>#Attributes.text#
			
		</cfif>
		
		  <cfif attributes.total eq "">
		  &nbsp; 
		    <input type="hidden" name="progress" id="progress"> 
		 <cfelse>&nbsp;
		 [<input type="text"
	       name="progress"
		   id="progress"
	       value="0"
	       size="3"
	       maxlength="4"
	       class="regular1"
	       style="text-align: center; width: 14px;"> 
		 of 
		 <input type="text"
	       name="progress"
		   id="progress"
	       value="#Attributes.Total#"
	       size="3"
	       maxlength="4"
	       class="regular1"
	       style="text-align: center; width: 14px;">]&nbsp;
	 	 </cfif>
		 
		 <input type="hidden" name="busy" id="busy">
		
		 </td>
		 
		 <cfif Attributes.Progress eq "1">
		 
			 <tr>
				 <td height="22" align="center">
				    <img src="#SESSION.root#/Images/#Attributes.graphic#" alt="" border="0" align="absmiddle">
				 </td>
			 </tr>
		 
		 <cfelse>
		 
			  <tr>
				 <td height="50" align="center">	 
				 <input type="button" class="button10p" style="width:110px" name="Close" id="Close" value="Close" onclick="parent.window.close()">
			 	 </td>		
			 </tr> 	
		 
		 </cfif>
		 
		 <cfif Attributes.ControlId neq "">
		 
		 <tr class="hide" id="requestabort">
		      <td align="center">
		    	&nbsp;<img src="#SESSION.root#/Images/status_alert1.gif" id="request" alt="Stopping" align="absmiddle" border="0">
				User has requested the process to be stopped
			 </td>
		 </tr>
		 
		 </cfif>
		 
		 </table>	 
	   </td>
	   
	  </tr> 
	 
	</table>
	
	--->
	
<cfelse>
	
	<cfif attributes.progress neq "" and attributes.total neq "">	
		<cfset session.status = "#0.4+((attributes.progress/attributes.total)*0.55)#">	
	</cfif>	

	<cfset session.message = "#attributes.text#">

</cfif>

</cfoutput>

<cfif attributes.flush eq "Yes">
     <cfflush interval="4">		 
</cfif>  
