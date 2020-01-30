<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_param name="SESSION.root" default="" type="String">
<cf_param name="CLIENT.LanguageId" default="ENG" type="String">
<cf_param name="CLIENT.Style" default="Portal/Logon/BlueGreen/pkdb.css" type="String">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfswitch expression="#CLIENT.LanguageId#">

<cfcase value="ESP">
	<cfset tProblem="Problema">
	<cfset tNotification="Notificación">
	<cfset tViolation="Violación">
	<cfset tAttention="Atención"> 		
	<cfset tNotBeProcessed = "Su requerimiento no puede ser procesado">
	<cfset tReturn = "Regresar">
</cfcase>
<cfdefaultcase>
	<cfset tProblem="Problem">
	<cfset tNotification="Notification">
	<cfset tViolation="Violation">
	<cfset tAttention="Attention"> 
	<cfset tNotBeProcessed = "Your Request could NOT be processed">
	<cfset tReturn = "Back">
</cfdefaultcase>
</cfswitch>

<cfparam name="Attributes.Status"     default="#tNotification#">
<cfparam name="Attributes.Message"    default="#tNotBeProcessed#">
<cfparam name="Attributes.Class"      default="LabelMedium">
<cfparam name="Attributes.return"     default="">
<cfparam name="Attributes.width"      default="97%">
<cfparam name="Attributes.height"     default="">
<cfparam name="Attributes.location"   default="">
<cfparam name="Attributes.script"     default="">
<cfparam name="Attributes.report"     default="0">
<cfparam name="Attributes.loc"        default="">
<cfparam name="Attributes.target"     default="">
<cfparam name="Attributes.header"     default="No">
<cfparam name="Attributes.align"      default="Center">
<cfparam name="Attributes.topic"      default="">
<cfparam name="Attributes.Icon"       default="Yes">
<cfparam name="Attributes.subtext"    default="Yes">
<cfparam name="Attributes.buttonText" default="#tReturn#">
<cfparam name="Attributes.layout"     default="">
<!--- reset abort status --->

<cf_param name="CLIENT.abort" default="0" type="Numeric">

<cfset client.abort = "0">

<cfif Attributes.report eq "1">

	<script language="JavaScript">
				
		   	{ 
			
			try {
			
			parent.document.getElementById('myprogressbox').className = "hide"
			parent.document.getElementById('myreportcontent').className = "regular"
			
			} catch(e) {} 
						
			try	{				
				
				se  = parent.document.getElementById("preview");
				if (se) 	{se.className = "buttonprint"}
				
				se  = parent.document.getElementById("buttons");
				if (se)		{se.className = "buttonprint"}
									
				se  = parent.document.getElementById("buttons2");
				if (se)		{se.className = "regular"}
									
				se  = parent.document.getElementById("stop");
				if (se)		{se.className = "hide"}
					
				se  = parent.document.getElementById("stopping");
				if (se)		{se.className = "hide"}
					
				se  = document.getElementById("requestabort");
				if (se)		{se.className = "hide"}
			
			} catch(e) {}				
			}
																
	</script> 

 </cfif>
 
<cfoutput>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cfif Attributes.header eq "yes">		
	<cf_screentop height="100%" label="#SESSION.welcome#" layout="webapp" banner="Gray" ValidateSession="No">		
</cfif>

<table width="100%" height="95%" align="center">

<tr><td colspan="2" height="100%" valign="center">

<cfoutput>
<table width="#Attributes.width#" height="#Attributes.height#" border="0" cellspacing="0" cellpadding="0" align="center">
</cfoutput>

<tr><td height="100%">

	<table width="100%" bgcolor="ffffff" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td height="14"></td></TR>
	
	<cfif attributes.icon eq "Yes">
		<cfif Attributes.subtext eq "Yes">
			<tr><td height="100%" colspan="3" align="left" valign="bottom" class="labellarge" style="padding-left:7px">
			<cfif Attributes.Status eq "Problem">
				<font size="4">&nbsp;&nbsp;
				#tProblem#:</font>
			<cfelseif Attributes.Status eq "Violation">
				<font size="4" color="FF0000"><b>&nbsp;
				<cf_param name="SESSION.root" default="" type="String">
				
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/problemIcon.gif" alt="" border="0">
				#tViolation#:</font>
			<cfelse>
				<font size="4"><b>&nbsp;
				<cf_param name="SESSION.root" default="" type="String">
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/attention3.png" alt="" width="32" height="32" border="0">
				#tAttention#:</font>
			</cfif>
			<br>
			</td></tr>
			<tr><td height="6" colspan="3"></td></tr>
		</cfif>
	</cfif>
	<tr>
	  <td width="10"></td>
	  <td height="20" class="regular" align="left">
	  
	    <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr><td style="border-radius:7px;border:0px solid silver" bgcolor="ffffff">
		
		    <table width="100%"
	    	   height="35"
		       border="0"
	    	   align="center">
			   
		    	<tr>
					<td align="#Attributes.align#" class="#attributes.class#" style="padding-top:10px;padding-bottom:10px;">#Attributes.Message#</td>
				</tr>
			
	       </table>
		   
		</td></tr>	
		</table>
		
	  </td>
	  <td width="10"></td>
	</tr>
	<tr><td height="6" colspan="3"></td></tr>
	
	<cfif attributes.topic neq "">
	
	<tr><td height="30" colspan="3" align="center" valign="bottom">
		<input type="checkbox" name="hide" id="hide" value="1">
		Check here, if you don't want to see this message in the future.
	</tr>
	
	</cfif>
	
	<tr><td height="26" colspan="3" align="center" valign="bottom">
	
	<cfset vWidth = Len(Attributes.ButtonText)*10+30>
	
	<cfswitch expression="#Attributes.return#">
		
		<cfcase value="No">
			<!--- no option provided --->
		</cfcase>
		
		<cfcase value="click">
			
		   <button 
		   		class="button10g" 
		   		style="width:#vWidth#px"
		       	onClick="#preserveSingleQuotes(attributes.script)#">
				#Attributes.ButtonText#		   
			</button>   
			   
		</cfcase>
		
		<cfcase value="back">
		
		   <button class="button10g" style="width:#vWidth#px" onClick="history.back()">
			   #Attributes.ButtonText#
		  </button> 
			   
		</cfcase>
		
		<cfcase value="backgo">
		
		   <button class="button10g" style="width:#vWidth#px" type="button" onClick="history.go(-1)">
				#Attributes.ButtonText#		   
		   </button>	   
			   
		</cfcase>
		
		<cfcase value="close">
		
		   <button class="button10g" style="width:#vWidth#px" onClick="window.close()">
				#Attributes.ButtonText#	   
		   </button>
			   
		</cfcase>
		
		<cfcase value="ajax">
		
		   <button class="button10g" style="width:#vWidth#px" onClick="#ajaxLink(attributes.location)#">
				#Attributes.ButtonText#	   
		   </button>
			   
		</cfcase>
		
		<cfcase value="">
		
		   <button class="button10g" style="width:#vWidth#px" onClick="parent.window.close(); opener.history.go()">
			   #Attributes.ButtonText#
		   </button>
			   
		</cfcase>
		
		<cfdefaultcase>
		
					
			<cfif Attributes.loc neq "">
			
				<cfset goto="window.open('#attributes.return#','#Attributes.loc#')">
						   
			<cfelseif Attributes.topic neq "">
					
				<cfset goto="#attributes.return#">
				
				<!---				
				   se = document.getElementById("hide")				   
				   if (se.checked == true) {
				        window.location = "#attributes.return#&message=#Attributes.topic#&messagehide=hide"
				   } else { 
				        window.location = "#attributes.return#" 
				   }      				   
				   --->
				
			<cfelse>
				
				  <cfif Attributes.target eq "">		  
				      <cfset goto = "window.location='#attributes.return#'">	  
				  <cfelse>  	
				      <cfset goto = "parent.window.location='#attributes.return#'">			  	 
				  </cfif>
				      
			</cfif>   
				
		   <button class="button10g" style="width:#vWidth#px" onClick="javascript:#goto#">
				#Attributes.ButtonText#	   
		   </button>
			   
		</cfdefaultcase>
	
	</cfswitch>
	
	</td></tr>
	<tr><td height="10" colspan="3"></td></tr>
	
	</table>

</td></tr>

</table>

</td></tr>

<tr><td height="35" colspan="2" valign="bottom"></td></tr>

</table>

<cfif Attributes.header eq "yes">
	<cf_screenbottom layout="webapp">	
</cfif>

</cfoutput>

<script>
  try {
  Prosis.busy('no') } catch(e) {}
</script>


