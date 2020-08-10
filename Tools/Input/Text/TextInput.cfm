
<cfparam name="Attributes.Form"        default="">
<cfparam name="Attributes.Type"        default="Text">
<cfparam name="Attributes.Mode"        default="Regularxl">
<cfparam name="Attributes.Prefix"      default="">
<cfparam name="Attributes.Label"       default="">
<cfparam name="Attributes.Tooltip"     default="">
<cfparam name="Attributes.Name"        default="">
<cfparam name="Attributes.Id"          default="#Attributes.name#">
<cfparam name="Attributes.Value"       default="">
<cfparam name="Attributes.Required"    default="0">
<cfparam name="Attributes.OnChange"    default="">
<cfparam name="Attributes.OnKeyUp"     default="">
<cfparam name="Attributes.Visible"     default="Yes">
<cfparam name="Attributes.Enabled"     default="Yes">
<cfparam name="Attributes.Size"        default="20">

<!--- added by hanno 31/5/2013 --->
<cfif attributes.size eq "">
   <cfset attributes.size = "20">
</cfif>

<cfparam name="Attributes.Mask"        default="">
<cfparam name="Attributes.autosuggest" default = "">
<cfparam name="Attributes.Pattern"     default="">
<cfparam name="Attributes.Validate"    default="">
<cfparam name="Attributes.MaxLength"   default="#Attributes.Size#">

<cf_tl class="Message" id="PleaseEnterAValue" var="1">
<cfparam name="Attributes.Message"     default="#lt_text#">
<cfparam name="Attributes.Class"       default="regularxl">
<cfparam name="Attributes.Style"       default="">


<cfset Attributes.class = "enterastab #attributes.class#">

<cfif Attributes.Required eq "1">
  <cfset req = "Yes">
 <cfelse>
  <cfset req = "No"> 
 
</cfif>

<cfif Attributes.Visible eq "1">
  <cfset vis = "Yes">
<cfelse>
  <cfset vis = "No"> 
</cfif>

<cfif Attributes.Enabled eq "1">
  <cfset ena = "Yes">
<cfelse>
  <cfset ena = "No"> 
</cfif>

<cfoutput>

<cfswitch expression="#Attributes.Type#">

    <cfcase value="Date">
	
	  <cf_intelliCalendarDate9
		FieldName="#Attributes.Name#" 
		Default="#Attributes.Value#"
		style="border-radius:5px"
		Class="#attributes.mode#"
		AllowBlank="#req#">	 
	
	</cfcase>

	<cfcase value="Text">
	
		<cfif Attributes.mode eq "Regular">
		
			<cfif attributes.autosuggest eq "">
				
				<cfinput type="Text"
			       name       = "#Attributes.Name#"
				   id         = "#Attributes.id#"
			       value      = "#Attributes.Value#"
				   label      = "#Attributes.Label#"
			       required   = "#req#"
			       visible    = "#vis#"
			       enabled    = "#ena#"
				   onchange   = "#attributes.onChange#"
				   mask       = "#Attributes.Mask#"
				   pattern    = "#Attributes.Pattern#"
			       size       = "#Attributes.Size#"
			       maxlength  = "#Attributes.MaxLength#"
				   message    = "#Attributes.Message#"
				   validate   = "#Attributes.Validate#"
				   class      = "#Attributes.Class#"
				   style      = "#Attributes.Style#">
				   
			<cfelse>
			
				<cfinput type="Text"
			       name                     = "#Attributes.Name#"
				   id                       = "#Attributes.id#"
			       value        			= "#Attributes.Value#"
				   label        			= "#Attributes.Label#"
			       required      			= "#req#"
			       visible       			= "#vis#"
			       enabled        			= "#ena#"
				   onchange                 = "#attributes.onChange#"
				   mask           			= "#Attributes.Mask#"
				   autosuggest              = "#Attributes.AutoSuggest#"
				   maxresultsdisplayed      = "5"
				   showautosuggestloadingicon = "No"
				   typeahead                = "Yes"
				   pattern    				= "#Attributes.Pattern#"
			       size     			    = "#Attributes.Size#"
			       maxlength 				= "#Attributes.MaxLength#"
				   message  			    = "#Attributes.Message#"
				   validate   				= "#Attributes.Validate#"
				   class      				= "#Attributes.Class#"
				   style      				= "#Attributes.Style#">
			
			</cfif>
			
			   
		<cfelse>
			<cfif req eq "No">
				<input type="Text"
		       	name      = "#Attributes.Name#"
			   	id        = "#Attributes.Id#"
		       	value     = "#Attributes.Value#"
		       	visible   = "#vis#"
		       	enabled   = "#ena#"
			   	onchange  = "#attributes.onChange#"
			   	size      = "#Attributes.Size#"
		       	maxlength = "#Attributes.MaxLength#"
			   	message   = "#Attributes.Message#"
			   	validate  = "#Attributes.Validate#"
			   	class     = "#Attributes.Class#"
			   	style     = "#Attributes.Style#">				
			<cfelse>	
				<input type="Text"
		       	name      = "#Attributes.Name#"
			   	id        = "#Attributes.Id#"
		       	value     = "#Attributes.Value#"
		       	required  = "#req#"
		       	visible   = "#vis#"
		       	enabled   = "#ena#"
			   	onchange  = "#attributes.onChange#"
			   	size      = "#Attributes.Size#"
		       	maxlength = "#Attributes.MaxLength#"
			   	message   = "#Attributes.Message#"
			   	validate  = "#Attributes.Validate#"
			   	class     = "#Attributes.Class#"
			   	style     = "#Attributes.Style#">
			</cfif>
			   
		</cfif>
		
	</cfcase>	
	
	<cfcase value="Memo">
	
		<cfif Attributes.mode eq "Regular">			
			
			<cfset vStyle = "width:100%;height:50;font-size:13px;padding:4px;border:1px solid silver">
			<cfif Attributes.Style neq "">
				<cfset vStyle = Attributes.Style>
			</cfif>
			
			<cf_textarea style="#vStyle#" name = "#Attributes.Name#" onchange  = "#attributes.onChange#"
		  	  id  = "#Attributes.id#"  message = "#Attributes.Message#" onkeyup="return ismaxlength(this)" totlength = "#Attributes.MaxLength#">#Attributes.Value#</cf_textarea>								
			   
		<cfelse>
				
			<cfset vStyle = "width:100%;height:50;font-size:13px;padding:4px;border:1px solid silver">
			<cfif Attributes.Style neq "">
				<cfset vStyle = Attributes.Style>
			</cfif>
			
			<textarea style="#vStyle#;overflow:auto"  name = "#Attributes.Name#" onchange  = "#attributes.onChange#"
		      id  = "#Attributes.id#" message = "#Attributes.Message#" onkeyup="return ismaxlength(this)" totlength = "#Attributes.MaxLength#">#Attributes.Value#</textarea>		
			  			   
		</cfif>
		
	</cfcase>	
	
	<cfcase value="Keyword">
		
		  <script language="JavaScript1.2">
		   	  		    
					  function key(code,location) {					 				 					     
 					      ColdFusion.navigate('#SESSION.root#/Tools/Input/Keyword/KeywordFind.cfm?code='+code,location)					
					  }    
								
				</script>								
			
		    <table cellspacing="0" cellpadding="0">
			<tr><td class="labelit">#attributes.Prefix#</td>
			
			<td>
			
			<table border="1" cellspacing="0" cellpadding="0">
			<tr><td>
		
				<cfinput type="text"
			       name       = "#Attributes.Name#"
			       value      = "#Attributes.Value#"
			       size       = "4"
			       maxlength  = "6"
				   required   = "#req#"
				   onchange   = "#attributes.onChange#;key(this.value,'keyfind')"
				   message    = "#Attributes.Message#"
			       class      = "regular1"
			       style      = "#Attributes.Style#; text-align: center;">
								 			   
				   </td>
				   <td>&nbsp;</td>
				   <td id="keyfind"></td>
				   <td>
				   &nbsp;
				   <img src="#SESSION.root#/Images/contract.gif" 
					  alt    = "Search for keyword" 
					  name   = "img2" 
					  onMouseOver= "document.img2.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut = "document.img2.src='#SESSION.root#/Images/contract.gif'"
					  style  = "cursor: pointer;" 
					 
					  border = "0" 
					  align  = "absmiddle" 
					  onClick="selectkey('#attributes.form#','#Attributes.Name#','#Attributes.Filter#','0')">
					  
				</td><td>&nbsp;</td></tr>
				
				<script language="JavaScript">
					key("#Attributes.Value#","keyfind")
				</script>	  
			
			</table>	
				
			</td></tr></table>			  
	
	</cfcase>
	
	<cfcase value="ZIP">
					 	   
	    <table cellspacing="0" cellpadding="0"><tr><td>#attributes.Prefix#</td>
		
		<td>
		
		<table border="0" cellspacing="0" cellpadding="0" style="height:20;border:0px solid silver">
		<tr><td>
		
			<cfinput type = "text"
		       name       = "#Attributes.Name#"
			   id         = "#Attributes.Id#"
		       value      = "#Attributes.Value#"
		       size       = "#attributes.size#"
		       maxlength  = "#attributes.maxlength#"
			   required   = "#req#"
			   message    = "#Attributes.Message#"
		       class      = "#attributes.class# enterastab"
		       style      = "#Attributes.Style#; padding-left:4px;border:0px:important!"
		       onChange   = "ptoken.navigate('#SESSION.root#/Tools/Input/ZIP/ZIPFind.cfm?code='+this.value,'zipfind_#Attributes.Id#')"
			   onKeyUp    = "#attributes.onKeyUp#">
			   			 			   
			   </td>			   
			   <td class="#attributes.class#" id="zipfind_#Attributes.Id#" style="height:25px;padding-left:1px;border:0px">
			   
			    <cfif attributes.value neq "">
				
					<cfset url.code = Attributes.Value>
					<cfinclude template="../ZIP/ZIPFind.cfm">
				
				</cfif>
			   
			   </td>
			   <td style="padding-left:2px;padding-right:4px">				   
			   			   
			   <img src="#SESSION.root#/Images/search.png" 
				  alt    = "Search" 
				  name   = "img125" 
				  onMouseOver= "document.img125.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut = "document.img125.src='#SESSION.root#/Images/search.png'"
				  style  = "cursor: pointer;" 				 
				  border = "0" 
				  height="20" width="20"
				  align  = "absmiddle" 
				  onClick="selectzip('#Attributes.id#','addresscity','country','0')">
				  
			</td></tr>			
					
			</table>	
			
			</td></tr></table>			  
	
	</cfcase>

</cfswitch>

</cfoutput>
