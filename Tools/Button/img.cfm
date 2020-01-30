
<cfparam name="attributes.icon"      	default="edit">
<cfparam name="attributes.onclick"   	default="">
<cfparam name="attributes.id"        	default="">
<cfparam name="attributes.toggle"    	default="">
<cfparam name="attributes.safemode"  	default="">
<cfparam name="attributes.mode"      	default="">
<cfparam name="attributes.tooltip"   	default="">
<cfparam name="attributes.class"   	 	default="">
<cfparam name="attributes.buttonClass"  default="">
<cfparam name="attributes.label"     	default="">
<cfparam name="attributes.navigation"   default="No">
<cfparam name="attributes.state"     	default="">

<cfif attributes.navigation eq "Yes">
	<cfset cls = "navigation_action">	
<cfelse>
	<cfset cls = "">
</cfif>

<cfif attributes.state neq "">
		<cfset vState = "_#attributes.state#">
<cfelse>
		<cfset vState = "">
</cfif>	


<cfif attributes.icon eq "expand">
	<cfif attributes.state eq "open">
		<cfset cls_secondary="compress">
	<cfelse>
		<cfset cls_secondary="expand">
	</cfif>	
<cfelse>
	<cfset cls_secondary="sprites">
</cfif>	

<!--- valid icon value  =  edit;delete;add;open;expand;bullet;select;print;copy:log;mail  --->

<cfoutput>
	
	<cfif attributes.toggle eq "Yes">
		<cfset sFunction = "do_toggle('object',this)">
	<cfelse>
		<cfset sFunction = "">	
	</cfif>
	
	<cfset attributes.onclick  = Replace(attributes.onclick,"'",CHR(34),"ALL")>
	<cfset sFunction  = Replace(sFunction,"'",CHR(34),"ALL")>
	
		
	<cfif attributes.id eq "">
	
		<cfif client.browser eq "Explorer">
			<cfif attributes.safemode eq "">
				<a class="#cls_secondary# #attributes.mode# #cls# #attributes.buttonClass#" id="i_#attributes.icon##vState#" href='javascript:#attributes.onclick#' <cfif sFunction neq "">onClick='#sFunction#'</cfif> tabindex="9999" title="#attributes.tooltip#">
					&nbsp;&nbsp;				
					<cfif attributes.label neq "">
					<div style="position:relative;left:12px;width: 300px;  background-color: White;">				
						<div class="#attributes.class#" align="left">&nbsp;#attributes.label#</div>
					</div>	
					</cfif>	
				</a>
			<cfelse>
				<a class="#cls_secondary# #cls# #attributes.buttonClass#" id="i_#attributes.icon##vState#" onClick='javascript:#attributes.onclick#;#sFunction#;' tabindex="9999" title="#attributes.tooltip#">
					<cfif attributes.label neq "">				
						<div style="width:300px;"><div class="#attributes.class#">&nbsp;&nbsp;&nbsp;&nbsp;#attributes.label#</div></div>
					</cfif>	
					
				</a>
			</cfif>
		<cfelse>
			<div class="#cls_secondary# #cls# #attributes.buttonClass#" id="i_#attributes.icon##vState#" onClick='#attributes.onclick#;#sFunction#;' title="#attributes.tooltip#">
				<cfif attributes.label neq "">
					<div style="width:300px;"><div class="#attributes.class#">&nbsp;&nbsp;&nbsp;&nbsp;#attributes.label#</div></div>
				</cfif>					
			</div>	
		</cfif>
			
	<cfelse>
				
		<cfif client.browser eq "Explorer">
			
			<cfif attributes.safemode eq "">
				<a class="#cls_secondary# #cls# #attributes.buttonClass#" id="#attributes.id#"  name="#attributes.id##vState#" href='javascript:#attributes.onclick#' <cfif sFunction neq "">onClick='#sFunction#'</cfif> tabindex="9999" title="#attributes.tooltip#">
					&nbsp;&nbsp;
					<cfif attributes.label neq "">				
						<div style="width:300px;"><div class="#attributes.class#">&nbsp;&nbsp;&nbsp;&nbsp;#attributes.label#</div></div>
					</cfif>	
				</a>
			<cfelse>
			
				<a class="#cls_secondary# #cls# #attributes.buttonClass# i_#attributes.icon#" id="#attributes.id#"  name="#attributes.id##vState#" onClick='javascript:#attributes.onclick#; #sFunction#;' tabindex="9999" title="#attributes.tooltip#">
					<cfif attributes.label neq "">				
						<div style="width:300px;"><div class="#attributes.class#">&nbsp;&nbsp;&nbsp;&nbsp;#attributes.label#</div></div>
					</cfif>						
				</a>
			</cfif>
		<cfelse>
				
			<div class="#cls_secondary# #cls# #attributes.buttonClass# i_#attributes.icon#" id="#attributes.id#"  name="#attributes.id##vState#" onClick='#attributes.onclick#;#sFunction#;' title="#attributes.tooltip#">
				<cfif attributes.label neq "">				
					<div style="width:300px;"><div class="#attributes.class#">&nbsp;&nbsp;&nbsp;&nbsp;#attributes.label#</div></div>
				</cfif>			
			</div>	
		</cfif>
	
	</cfif>	

</cfoutput>


