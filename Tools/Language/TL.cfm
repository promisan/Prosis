
<cfparam name="CLIENT.LanguageId"        default  = "ENG">
<cfparam name="SESSION.acc"              default  = "">
<cfparam name="CLIENT.Editing"           default  = "0">
<cfparam name="Attributes.edit"          default  = "#client.editing#">
<cfparam name="Attributes.LanguageCode"  default  = "#client.languageId#">
<cfparam name="url.cls"                  default  = "Label">
<cfparam name="Attributes.Class"         default  = "#url.cls#">
<cfparam name="url.clsid"                default  = "">
<cfparam name="Attributes.Id"            default  = "#url.clsid#">
<cfparam name="url.var"                  default  = "0">
<cfparam name="Attributes.var"           default  = "#url.var#">
<cfparam name="url.present"              default  = "">
<cfparam name="Attributes.present"       default  = "">

<cfoutput>
	
<cfset source = "0">

<cfif source eq "0">

	<cfif attributes.class eq "label">	
	
	    <!--- new code added 21/1/2012 to make it faster using struct --->		
		<!--- ----------- container for language translation -------- --->
		
		<cfif StructKeyExists(Application, "#Attributes.LanguageCode#") eq "NO">   
			<cfset Application[client.languageid] = structNew() />	
		</cfif>	
				
		<cfif StructKeyExists(Application[attributes.languagecode], "#Attributes.Id#") and attributes.languagecode eq client.languageId>			
			
			<cfset tLabel = Application[attributes.languagecode]["#Attributes.Id#"]>
			
		<cfelse>	
		
			<!--- --- get from database the value -- --->
			<cfset url.languageCodeDB = Attributes.LanguageCode>
			<cftry>
				<cfinclude template="TL_database.cfm">	
				<cfset tLabel = qSelect.Label>	
				<cfcatch>				
			       <cfset tLabel = "undefined">	
				</cfcatch>
			</cftry>		
			
			<!--- add entry in struct --->
			<cfset Application[attributes.languagecode]["#Attributes.Id#"] = "#tLabel#"> 
										
		</cfif>	
		
	<cfelse>		
	
		<cfinclude template="TL_database.cfm">
		<cfset tLabel = qSelect.Label>			
		
	</cfif>
					
</cfif>	

<!--- ------------------------ --->
<!--- write back to the caller --->
<!--- ------------------------ --->

<cfif Attributes.var eq "0">

	<cfif tLabel eq "">
	     <CFSET Caller.lt_text = "<font color='FF8080'>*#Attributes.Id#</font>"> 
	<cfelse>
		 <CFSET Caller.lt_text = tLabel>
	</cfif>
			
	<cfif attributes.edit eq "1">
	
	        <!--- edit mode --->			
			<cf_assignid>																		
			<cfoutput>				
				<span style="background-color:ffffaf;cursor:pointer" id="#rowguid#" onclick="javascript:tl_edit('#attributes.class#','#attributes.id#','#rowguid#');"><i>#Caller.lt_text# ^</i></span>
		    </cfoutput>	
															
	<cfelse>
	
	    <!--- regular mode --->	
		<cfif attributes.present eq "HTML">
		   <cfoutput>#EncodeForHTML(Caller.lt_text)#</cfoutput>
		<cfelse>
		   <cfoutput>#Caller.lt_text#</cfoutput>
		</cfif>
		
	
	</cfif>
	
<cfelseif Attributes.var eq "1">	
	
	<cfif tLabel eq "">
	     <CFSET Caller.lt_text = "*-#Attributes.Id#"> 
	 <cfelse>
	     <CFSET Caller.lt_text = "#tLabel#">
	 </cfif>	
	 
	<cfif attributes.edit eq "1">
		
		<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/edit.gif"
	         alt="<cfoutput>Edit:#Caller.lt_text#</cfoutput>"
			 border="0" align="absmiddle" style="cursor: pointer;"
	         onClick="tl_edit('#attributes.class#','#attributes.id#','')">
	
	</cfif>
	 
<cfelse>

	<cfif tLabel eq "">
	     <cfparam name="Caller.#Attributes.var#" default="*-#Attributes.Id#">	
	<cfelse>
	     <cfparam name="Caller.#Attributes.var#" default="#tLabel#">	  
	</cfif>	
		 	 
</cfif>	

</cfoutput>

