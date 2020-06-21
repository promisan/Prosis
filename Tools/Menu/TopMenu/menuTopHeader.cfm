
<cfoutput>

<cf_SubmenuScript>

<cfparam name="attributes.directory" default="TopMenu">
<cfparam name="attributes.template" default="HeaderMenu1">
<cfparam name="attributes.align" default="left">
<cfparam name="Attributes.SystemModule" default="">
<cfparam name="passtru" default="">

<table cellspacing="0" cellpadding="0" >	 												 
				
<tr>
					
<td width="100%" height="20">

<cfmenu  name="topmenu" font="verdana" fontsize="14" type="horizontal" bgcolor="##ffffff" selectedfontcolor="808080">
	
	<cfloop index="itm" from="1" to="#attributes.items#" step="1">
	
	    <!--- find the details for each header --->
	
		<cfparam name="attributes.header#itm#"           default="My header">
		<cfparam name="attributes.functionClassm#itm#"   default="">
		<cfparam name="attributes.menuClass#itm#"        default="">
	
		<cfset header        = evaluate("attributes.header#itm#")>
		<cfset functionClass = evaluate("attributes.functionClass#itm#")>
		<cfset menuClass     = evaluate("attributes.menuClass#itm#")>		
				
		<cfmenuitem 
	        display="#Header#"
	        name="m#itm#">				
			  									  
			<cfquery name="SearchResult" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     #Client.LanPrefix#Ref_ModuleControl
				WHERE    SystemModule  in (#PreserveSingleQuotes(Attributes.SystemModule)#) 
				AND      FunctionClass in (#PreserveSingleQuotes(functionClass)#)
				AND      Operational = '1'
				<!--- 	AND      MainmenuItem = 1 --->
				AND      MenuClass in (#PreserveSingleQuotes(menuClass)#) 
			</cfquery>	
						
			<cfset idlist = "">
			
			<cfset s = 0>
						
			<cfloop query="SearchResult">
			
				<cfif IdMenu neq SystemFunctionId>
							      
					<cfinvoke component="Service.Access"  
			          method="function"  
					  SystemFunctionId="#SystemFunctionId#" 
					  returnvariable="access">
					  					
					 <CFIF access is "GRANTED">  				
										  
					  	<cfset s = s+1>
					  	
						<cfif idlist eq "">
						   <cfset idlist = "#SystemFunctionId#">
						<cfelse>
						   <cfset idlist = "#idlist#,#SystemFunctionId#">
						
						</cfif>		
						
						 <cfset condition = FunctionCondition>
			 		 	 <cfif passtru neq "">
						 	<cfset condition = passtru>
						 </cfif>	
						 
						 <cfif FunctionPath neq "">								
			          		 <cfset load = "javascript:loadformI('#FunctionPath#','#condition#','_self','#FunctionDirectory#','#systemFunctionId#','','','default','')">      	 	  
						 <cfelse>	 
		   				     <cfset load = "javascript:#ScriptName#('#scriptConstant#','#systemFunctionId#')">     	 	 	  	  
						 </cfif>
						 
						 <cfset fun[s] = FunctionName>
						 <cfset ref[s] = load>
						 						
					</cfif>
														
				</cfif>
					
			</cfloop>
			
			
			<cfset cnt = 0>
								 												
			<cfloop index="opt" from="1" to="#s#">							   		    
							
					<cfset cnt=cnt+1>
					
					<cftry>
					
					<cfmenuitem 
				          display="#fun[opt]#"
				          name="m#itm#_#opt#"
						  href="#ref[opt]#"
				          image="#SESSION.root#/Images/bullet.gif"/>
						  
						  <cfcatch></cfcatch>
						  
					</cftry>	  									
						  
					<cfif cnt eq "3" and opt neq s>
						<cfmenuitem divider="true"/>
						<cfset cnt = 0>
					</cfif>	  
							
			</cfloop>
											
		</cfmenuitem>
		 
	</cfloop>
	
</cfmenu>


</td></tr></table>	

</cfoutput>


