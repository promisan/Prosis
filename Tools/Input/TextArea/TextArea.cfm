
<cfparam name="Attributes.type"       default="CK">	
<cfparam name="Attributes.name"       default="">	
<cfparam name="Attributes.Width"      default="100%">	
<cfparam name="Attributes.Height"     default="230">
<cfparam name="Attributes.collapse"   default="false">	

<cfparam name="Attributes.resize"     default="false">	

<cfparam name="Attributes.style"      default="">	
<cfparam name="Attributes.init"       default="No">	
<cfparam name="Attributes.skin"	      default="moono-lisa">
<cfparam name="Attributes.toolbar"	  default="full">
<cfparam name="Attributes.offset"	  default="405"> <!---this is the offset of any screen --->
<cfparam name="Attributes.color"      default="">
<cfparam name="Attributes.onchange"   default="">
<cfparam name="Attributes.onkeyup"    default="">
<cfparam name="Attributes.allowedContent"    default="no">



<cfparam name="Attributes.expand"     default="yes">

<cfinvoke component = "Service.Process.System.Client"  
   method           = "getBrowser"
   browserstring    = "#CGI.HTTP_USER_AGENT#"	  
   returnvariable   = "thisbrowser"
   minIE            = "8">	    
   
<cfif thisbrowser.name eq "Explorer" and thisBrowser.release lte "9">
    <cfset attributes.toolbar = "basic">
    <cfset Attributes.type = "BTXT">
</cfif>   

<cfparam name="Attributes.inline"     default="no">

<cfif attributes.skin neq "flat" and attributes.skin neq "standard">
	<cfset attributes.skin = "standard">
</cfif>	 

	<cfoutput>

	<cfswitch expression="#Attributes.type#">
	
		<cfcase value="CK">
			<cfif thisTag.ExecutionMode is 'start'>		
					
				<input type="hidden" id="#attributes.name#_width"    name="#attributes.name#_width"     value="#attributes.width#">
				<input type="hidden" id="#attributes.name#_height"   name="#attributes.name#_height"    value="#attributes.height#">
				<input type="hidden" id="#attributes.name#_resize"   name="#attributes.name#_resize"    value="#attributes.resize#">
				<input type="hidden" id="#attributes.name#_collapse" name="#attributes.name#_collapse"  value="#attributes.collapse#">
				<input type="hidden" id="#attributes.name#_skin"     name="#attributes.name#_skin"      value="#attributes.skin#">
				<input type="hidden" id="#attributes.name#_color"    name="#attributes.name#_color"     value="#attributes.color#">
				<input type="hidden" id="#attributes.name#_toolbar"  name="#attributes.name#_toolbar"   value="#attributes.toolbar#">					
				<input type="hidden" id="#attributes.name#_expand"   name="#attributes.name#_expand"    value="#attributes.expand#">
				<input type="hidden" id="#attributes.name#_onchange" name="#attributes.name#_onchange"  value="#attributes.onchange#">
				<input type="hidden" id="#attributes.name#_pheight"  name="#attributes.name#_pheight"   value="#CLIENT.height-attributes.offset#">
				<input type="hidden" id="#attributes.name#_onkeyup"  name="#attributes.name#_onkeyup"   value="#attributes.onkeyup#">
				<input type="hidden" id="#attributes.name#_allowedContent"  name="#attributes.name#_allowedContent"   value="#attributes.allowedContent#">
				
				<cfif attributes.inline eq "yes">	
					<input type="hidden" id="#attributes.name#_inline" name="#attributes.name#_inline" value="">
					<div id="#attributes.name#" name="#attributes.name#" style="#attributes.style#" contenteditable="true">	
				<cfelse>				
					<textarea name="#attributes.name#" id="#attributes.name#" class="ckeditor" <cfif  attributes.style neq ""> style="#attributes.style#"</cfif><cfif  attributes.onchange neq ""> onChange="#attributes.onchange#"</cfif>>#thisTag.GeneratedContent#
				</cfif>											
				
			<cfelseif thisTag.ExecutionMode is 'end'>
				<cfif attributes.inline eq "yes">
					</div>
				<cfelse>
					</textarea>
				</cfif>	
								
			</cfif>		
						
			<cfif thisTag.ExecutionMode is 'end'>		
					
					<cfif attributes.init eq "Yes">
				
					<!--- set size --->	
					<script language="JavaScript">				
						
						try {																				   		
		   				<cfif find("%",attributes.height)>
							$(window).resize(function() {
			   					_calculated_height_ = textAreaFit($(window).height()-#attributes.offset*0.40#,'#attributes.height#');
			   					_calculated_width_ = '100%';
  								CKEDITOR.instances['#attributes.name#'].resize(_calculated_width_, _calculated_height_);	
							});
		   				</cfif>						   
					   
					   
					   <cfswitch expression="#attributes.toolbar#" >
					   		<cfcase value="full">
							   	<cfif Attributes.expand eq "No">
							   		var myeditor = CKEDITOR.replace('#attributes.name#', {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_config_ne.js'
									} );
								<cfelse>	
							   		var myeditor = CKEDITOR.replace('#attributes.name#', {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_config.js'
									} );
							   	</cfif>	
					   		</cfcase>
						   <cfcase value="mini">
							   <cfif Attributes.expand eq "No">
									   var myeditor = CKEDITOR.replace('#attributes.name#', {
									   customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_mini_config_ne.js'
								   } );

							   <cfelse>
									   var myeditor = CKEDITOR.replace('#attributes.name#', {
									   customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_mini_config.js'
								   } );

							   </cfif>
						   </cfcase>
					   		<cfdefaultcase>
								<cfif Attributes.expand eq "No">
									var myeditor = CKEDITOR.replace('#attributes.name#', {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_basic_config_ne.js'
									});
								<cfelse>
									var myeditor = CKEDITOR.replace('#attributes.name#', {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_basic_config.js'
									});
								</cfif>	
					   		</cfdefaultcase> 
					   			
					   </cfswitch>
					   	
					   	
					   		   
					   _calculated_height_ = textAreaFit(document.getElementById('#attributes.name#_pheight').value,document.getElementById('#attributes.name#_height').value);
					   setEditorConfiguration(myeditor,'#attributes.name#',_calculated_width_,_calculated_height_);
					   
					   } catch(e) {}
					   
					</script>
					
					</cfif>
				

			
			</cfif>
			
		</cfcase>
		<cfcase value="BTXT">
			
			<cfif thisTag.ExecutionMode is 'start'>
					<cfif attributes.style eq "">
						<cfset attributes.style = "border:1px solid silver;font-size:13px;padding:3px">
					</cfif>	
					<cfset sanitized_height = rematch("[\d]+",attributes.height)>
					<cfset vrows = sanitized_height[1]/10>		
					<textarea id="#attributes.name#" name="#attributes.name#" style="#attributes.style#;width:#Attributes.Width#;margin: 0; padding:3px; border-width: 1;" rows="#vrows#">#thisTag.GeneratedContent#
			<cfelseif thisTag.ExecutionMode is 'end'>
					</textarea>
			</cfif>		
				
				
		</cfcase>	
		
	</cfswitch>
	
	</cfoutput>
	

