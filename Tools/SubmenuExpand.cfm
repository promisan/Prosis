<!--- Prosis template framework --->
<cfsilent>
	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes>Ajax enabled</proDes>
	<proCom>Framework</proCom>
</cfsilent>

<cfparam name="URL.Module" default="'Portal'">
<cfparam name="URL.Selection" default="">
<cfparam name="URL.Class" default="'Main'">

<cfparam name="Attributes.Heading"   default="">
<cfparam name="Attributes.Module"    default="'#URL.Module#'">
<cfparam name="Attributes.Selection" default="'#URL.Selection#'">
<cfparam name="Attributes.Class"     default="'#URL.Class#'">
<cfparam name="Attributes.bgColor"   default="fafafa">
<cfparam name="Attributes.selColor"  default="ffffcf">
<cfparam name="Attributes.align"     default="left">

<cf_licenseCheck module="#Attributes.Selection#" message="No">
<cfset License = "1">

<cfif License eq "0">

	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	  	<cfif Attributes.selection neq "'System'">
								
			<cfoutput>
			
			<tr>
			<td height="35" style="padding-left:10px">
						 			 		 
			  <font size="4" color="FF0000">License Expired</font>
			  
			</td>
			</tr>
			
			</cfoutput>		
		
		<cfelse>
		
		<tr><td align="center">
		
			  <cfoutput>
				  	 
			  <table width="100%" height="14" border="0" cellspacing="0" cellpadding="0" align="center" 
				  
				  onClick="loadform('System','Parameter/Menu.cfm','portalright','System','Settings','System','id=utility',this)"
				  onMouseOver="hl(this,true,'Settings')" 
				  onMouseOut="hl(this,false,'')" id="opt">
			     
				  <tr><td width="3"></td>
				     <td width="18">
					 
					 <img src="#SESSION.root#/Images/bullet.gif"
					     alt=""
					     border="0"
					     align="absmiddle">
					 </td>
				     <td width="90%" align="#Attributes.align#" class="regular">				 	 
					 &nbsp;<font color="FF0000"><cf_tl id="Settings"></font></td>
				  </tr>
			          
			  </table>
			  
			  </cfoutput>
				  
		 </td></tr>	  	 
		
		</cfif>
	
	</table>

<cfelse>
	
	<cfinclude template="SubmenuPrepare.cfm">
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="cee6ff" bgcolor="f7fbff" class="formpadding">
	
	<cfset row = 0>		
	
	
	<cfoutput query="searchresult">
			 	
		<cfset moduleEnabled = "1">	
	
		<cfif FunctionName eq "Listing">	
			<cf_verifyOperational checkmodule="Reporting" Warning="No">					
		</cfif>
		
		<cfset showfunction = "SHOW">
			
		<cfif functionName eq "Maintenance">
		      <cfset filter = "'Maintain','System'">
			  			  
				<cfinvoke component="Service.Access"  
		          method="selectionshow"  
				  Module="#FunctionClass#" 
				  FunctionClass="#filter#"
				  returnvariable="showfunction">
			  
		<cfelseif functionName eq "Application" or functionName eq "Applications">
		      <cfset filter = "'Application'">
			  
			  <cfinvoke component="Service.Access"  
		          method="selectionshow"  
				  Module="#FunctionClass#" 
				  FunctionClass="#filter#"
				  returnvariable="showfunction">
			  
		<cfelseif functionName eq "Inquiry">
				
		      <cfset filter = "'Inquiry','Reporting','Search'">	 
			  		
			  <cfinvoke component="Service.Access"  
		          method="selectionshow"  
				  Module="#FunctionClass#" 
				  FunctionClass="#filter#"
				  returnvariable="showfunction">
								  
		  <cfelseif functionName eq "Reports">
		
		      <!--- -------------------------- --->
			  <!--- added to check for reports --->
			  <!--- -------------------------- --->	
				
		      <cfset filter = "Reports">	 
			  		
			  <cfinvoke component="Service.Access"  
		          method="selectionshow"  
				  Module="#FunctionClass#" 
				  FunctionClass="#filter#"
				  returnvariable="showfunction">					  
				   	  
		<cfelseif functionName eq "Manuals">
		      <cfset filter = "'Manuals'">
			  <cfset showfunction = "SHOW">
			 
		<cfelseif functionName eq "System Configuration">
		      <cfset filter = "'Library','Documentation'"> 	 	
			  <cfset showfunction = "SHOW">
			  
		<cfelseif functionName eq "User Administration">  
		      
			   <cfset filter = "'User'"> 	
			  
			   <cfinvoke component="Service.Access"  
		          method="selectionshow"  
				  Module="#FunctionClass#" 
				  FunctionClass="#filter#"
				  returnvariable="showfunction">
				   
		<cfelse>
			
		      <cfset filter = "">	  
					  
		</cfif>
				
												
		<cfif showFunction eq "SHOW">
		
		  <cfset row = row+1>
		  
		  <tr><td align="center">
		  	 
			  <table bgcolor="f7fbff" width="100%" height="15" border="0" cellspacing="0" cellpadding="0" align="center"  
			  onClick="subselected('#functionclass#','#row#','#URL.Class#'); loadform('#FunctionDirectory#','#FunctionPath#','#FunctionTarget#','#SystemModule#','#FunctionName#','#SystemModule#','#FunctionCondition#',this)"
			  onMouseOver="h2(this,true,'#FunctionName#')" 
			  onMouseOut="h2(this,false,'')"
			  id="#functionclass##row#">
			 
				  <tr><td width="3"></td>
				     <td width="18">
					 <img src="#SESSION.root#/Images/bullet.gif"
					     alt=""
					     border="0"
					     align="absmiddle">
					 </td>
				     <td width="90%" align="#Attributes.align#" class="regular">				 	 
					 #FunctionName#</td>
				  </tr>
			          
			  </table>
		  
		  </td></tr>	  	  
		  
		</cfif>  
			
	</cfoutput>
		
	</TABLE>
	
</cfif>			

